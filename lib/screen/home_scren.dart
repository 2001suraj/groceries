import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groceries/const/app_color.dart';
import 'package:groceries/const/app_sized.dart';
import 'package:groceries/helper/local_store.dart';
import 'package:groceries/model/product_model.dart';
import 'package:groceries/model/user_model.dart';
import 'package:groceries/provider/base_provider.dart';
import 'package:groceries/provider/product_provider.dart';
import 'package:groceries/provider/user_provider.dart';
import 'package:groceries/screen/cart_page.dart';
import 'package:groceries/screen/individual_product_screen.dart';
import 'package:groceries/screen/profile_screen.dart';
import 'package:groceries/widget/grocery_item_tile.dart';
import 'package:groceries/widget/selected_category.dart';
import 'package:groceries/widget/title_text.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String getGreeting() {
      final hour = DateTime.now().hour;

      if (hour >= 5 && hour < 12) {
        return 'Good Morning';
      } else if (hour >= 12 && hour < 17) {
        return 'Good Afternoon';
      } else {
        return 'Good Evening';
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const CartPage();
            },
          ),
        ),
        child: const Icon(
          Icons.shopping_bag,
          color: AppColor.white,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: LocalStorage().gettoken(value: "email"),
          builder: (context, snap) {
            final email = snap.data.toString();
            final userData = ref.watch(userIndividualDataProvider(email));
            return userData.when(
              data: (data) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                AppSize.normalwidth,
                                Text(
                                  data['address'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        model: UserModel(
                                          address: data['address'],
                                          email: data['email'],
                                          name: data['name'],
                                          phone: data['phone'],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSize.maxheight,

                      // good morning bro
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: [
                            titles(
                              text: getGreeting() + ",",
                            ),
                            AppSize.minwidth,
                            titles(text: data['name'], weight: FontWeight.w500),
                          ],
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Let's order fresh items for you
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          "Let's order fresh items for you",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Divider(),
                      ),

                      // recent orders -> show last 3
                      Consumer(
                        builder: (context, value, child) {
                          final productData = ref.watch(productDataProvider);

                          return productData.when(
                            data: (pdata) {
                              List<QueryDocumentSnapshot<Object?>> filterData;
                              filterData = ref.watch(selectedChipProvider).fold<List<QueryDocumentSnapshot<Object?>>>(
                                [],
                                (previousValue, element1) {
                                  return pdata.docs
                                      .where((element) => element['category'].toString().toLowerCase() == element1.toString().toLowerCase())
                                      .toList();
                                },
                              );
                              // filterData = pdata.docs.toList();
                              return Column(
                                children: [
                                  CategoryListWidget(),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      primary: false,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(12),
                                      itemCount: filterData.length,
                                      itemBuilder: (context, index) {
                                        return GroceryItemTile(
                                          itemName: pdata.docs[index]['name'],
                                          itemPrice: pdata.docs[index]['price'],
                                          imagePath: pdata.docs[index]['image'],
                                          onPressed: () {
                                            ref.invalidate(itemProvider);
                                            ref.invalidate(showMoreProvider);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return IndividualProductScreen(
                                                model: ProductModel(
                                                  category: pdata.docs[index]['category'],
                                                  name: pdata.docs[index]['name'],
                                                  image: pdata.docs[index]['image'],
                                                  description: pdata.docs[index]['description'],
                                                  photo: pdata.docs[index]['photo'],
                                                  price: pdata.docs[index]['price'],
                                                  rating: pdata.docs[index]['rating'],
                                                ),
                                              );
                                            }));
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Divider(),
                                  GridView.builder(
                                    primary: false,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(12),
                                    itemCount: pdata.docs.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1 / 1.2,
                                    ),
                                    itemBuilder: (context, index) {
                                      return GroceryItemTile(
                                        itemName: pdata.docs[index]['name'],
                                        itemPrice: pdata.docs[index]['price'],
                                        imagePath: pdata.docs[index]['image'],
                                        onPressed: () {
                                          ref.invalidate(itemProvider);
                                          ref.invalidate(showMoreProvider);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                            return IndividualProductScreen(
                                              model: ProductModel(
                                                category: pdata.docs[index]['category'],
                                                name: pdata.docs[index]['name'],
                                                image: pdata.docs[index]['image'],
                                                description: pdata.docs[index]['description'],
                                                photo: pdata.docs[index]['photo'],
                                                price: pdata.docs[index]['price'],
                                                rating: pdata.docs[index]['rating'],
                                              ),
                                            );
                                          }));
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                            error: (e, r) => Text(e.toString()),
                            loading: () => const CircularProgressIndicator(),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              error: (e, r) => Text(e.toString()),
              loading: () => const CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
