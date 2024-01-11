import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groceries/const/app_color.dart';
import 'package:groceries/const/app_sized.dart';
import 'package:groceries/helper/local_store.dart';
import 'package:groceries/model/product_model.dart';
import 'package:groceries/provider/base_provider.dart';
import 'package:groceries/provider/product_provider.dart';
import 'package:groceries/screen/cart_page.dart';
import 'package:groceries/screen/home_scren.dart';
import 'package:groceries/service/product_add_service.dart';
import 'package:groceries/widget/dot_indicator.dart';
import 'package:groceries/widget/title_text.dart';
import 'package:lottie/lottie.dart';

class IndividualProductScreen extends ConsumerWidget {
  const IndividualProductScreen({super.key, required this.model});
  final ProductModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMore = ref.watch(showMoreProvider);

    double parsedDouble = double.parse((model.rating ?? '3.4').replaceAll(',', '.'));
    int intValue = parsedDouble.toInt();
    final items = ref.watch(itemProvider);

    final wordCount = RegExp(r'\b\w+\b').allMatches(model.description ?? 'NA').length;
    final displayedText = ref.read(showMoreProvider) ? (model.description ?? 'NA') : (model.description ?? 'NA').split(' ').take(30).join(' ');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              model.photo?.length == 0
                  ? Stack(
                      children: [
                        CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * 0.4,
                          fit: BoxFit.cover,
                          imageUrl: model.image ?? 'na',
                          placeholder: (context, url) => SizedBox(
                            height: 200,
                            width: 300,
                            child: Lottie.asset('assets/animation/placeholder.json', fit: BoxFit.cover),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColor.white,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios_new_outlined),
                            ),
                          ),
                        ),
                      ],
                    )
                  : custompageView(context, ref, model.photo ?? []),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Row(
                          children: List.generate(
                              5,
                              (index) => const Icon(
                                    Icons.star_border,
                                    color: AppColor.primaryColor,
                                  )),
                        ),
                        Row(
                          children: List.generate(
                              intValue,
                              (index) => const Icon(
                                    Icons.star,
                                    color: AppColor.primaryColor,
                                  )),
                        ),
                      ],
                    ),
                    titles(
                      text: model.name ?? 'NA',
                      size: 30,
                      weight: FontWeight.w600,
                    ),
                    titles(
                      text: '\$ ${model.price}',
                      size: 30,
                      weight: FontWeight.w600,
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (items > 0) {
                              ref.read(itemProvider.notifier).state = items - 1;
                            }
                          },
                          iconSize: 40,
                          icon: const Icon(
                            Icons.remove_circle_outline_outlined,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        titles(
                          text: items.toString(),
                          size: 30,
                          weight: FontWeight.w600,
                        ),
                        IconButton(
                          onPressed: () {
                            ref.read(itemProvider.notifier).state = items + 1;
                            log('${ref.read(itemProvider) * int.parse(model.price ?? 'na')}');
                          },
                          iconSize: 40,
                          icon: const Icon(
                            Icons.add_circle_outline_rounded,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    titles(
                      text: ' Product Description',
                      size: 20,
                      weight: FontWeight.w500,
                    ),
                    Text(
                      displayedText,
                      style: const TextStyle(color: AppColor.greyColor, fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    if (wordCount > 50)
                      TextButton(
                        onPressed: () {
                          log(ref.read(showMoreProvider).toString());
                          ref.read(showMoreProvider.notifier).state = !showMore;
                        },
                        child: titles(text: showMore ? 'Show Less' : 'Read More', color: AppColor.primaryColor),
                      ),
                  ],
                ),
              ),
              titles(
                text: ' Related  Product ',
                size: 20,
                weight: FontWeight.w500,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final productData = ref.watch(productDataProvider);

                  return productData.when(
                      data: (data) {
                        final filterData = data.docs
                            .where((element) => element['category'].toString().toLowerCase() == model.category.toString().toLowerCase())
                            .toList();
                        return SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: ListView.builder(
                              itemCount: filterData.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ref.invalidate(itemProvider);
                                    ref.invalidate(showMoreProvider);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return IndividualProductScreen(
                                        model: ProductModel(
                                          category: filterData[index]['category'],
                                          name: filterData[index]['name'],
                                          image: filterData[index]['image'],
                                          description: filterData[index]['description'],
                                          photo: filterData[index]['photo'],
                                          price: filterData[index]['price'],
                                          rating: filterData[index]['rating'],
                                        ),
                                      );
                                    }));
                                  },
                                  child: Container(
                                    width: 200,
                                    margin: EdgeInsets.all(7),
                                    padding: EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColor.bgColor,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CachedNetworkImage(
                                            height: 100,
                                            width: 200,
                                            fit: BoxFit.cover,
                                            imageUrl: filterData[index]['image'],
                                            placeholder: (context, url) => SizedBox(
                                              child: Lottie.asset('assets/animation/placeholder.json', fit: BoxFit.cover),
                                            ),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              titles(
                                                text: filterData[index]['name'],
                                                size: 20,
                                                weight: FontWeight.w500,
                                              ),
                                              titles(
                                                text: '\$${filterData[index]['price']}',
                                                size: 20,
                                                weight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      },
                      error: (e, r) => Text(
                            e.toString(),
                          ),
                      loading: () => CircularProgressIndicator());
                },
              ),
              AppSize.largeheight,
            ],
          ),
        ),
      ),
      floatingActionButton: FutureBuilder(
          future: LocalStorage().gettoken(value: 'email'),
          builder: (context, snap) {
            return MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: AppColor.primaryColor,
              onPressed: () async {
                final product = ProductModel(
                    name: model.name,
                    price: model.price,
                    category: model.category,
                    image: model.image,
                    photo: model.photo,
                    description: model.description,
                    rating: model.rating);
                await ProductAddService().addOrder(
                    userId: snap.data.toString(),
                    items: product,
                    totalAmount: '${ref.read(itemProvider) * int.parse(model.price ?? 'na')}',
                    itemLength: ref.read(itemProvider).toString());
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartPage()));
              },
              child: titles(text: "Add to Cart", color: AppColor.white),
            );
          }),
    );
  }

  Stack custompageView(BuildContext context, WidgetRef ref, List<dynamic> images) {
    final pageindex = ref.watch(imageIndexProvider);
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          color: Colors.red,
          child: PageView.builder(
              itemCount: images.length,
              onPageChanged: (value) {
                ref.read(imageIndexProvider.notifier).state = value;
              },
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  height: 100,
                  fit: BoxFit.cover,
                  imageUrl: images[index],
                  placeholder: (context, url) => SizedBox(
                    height: 200,
                    width: 300,
                    child: Lottie.asset('assets/animation/placeholder.json', fit: BoxFit.cover),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              }),
        ),
        Positioned(
          bottom: 10,
          left: 150,
          child: Row(
            children: [
              ...List.generate(
                  images.length,
                  (index) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Dotindicator(
                          isActive: index == pageindex,
                        ),
                      ))
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppColor.white,
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
            ),
          ),
        ),
      ],
    );
  }
}
