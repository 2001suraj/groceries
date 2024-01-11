import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groceries/model/product_model.dart';
import 'package:groceries/provider/product_provider.dart';
import 'package:groceries/screen/add_product_screen.dart';
import 'package:groceries/screen/home_scren.dart';
import 'package:groceries/service/product_add_service.dart';
import 'package:groceries/widget/title_text.dart';
import 'package:lottie/lottie.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderData = ref.watch(cartDataProvider);
    double totalAmountSum = 0.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductScreen()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Let's order fresh items for you
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "My Cart",
              style: GoogleFonts.notoSerif(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          orderData.when(
              data: (data) {
                // list view of cart
                return Expanded(
                  // width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: data.docs.length + 1,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        if (index < data.docs.length) {
                          final items = ProductModel.fromJson(data.docs[index]['items']);
                          final totalAmount = double.parse(data.docs[index]['totalAmount']);
                          totalAmountSum += totalAmount;
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        height: 100,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        imageUrl: items.image ?? 'Na',
                                        placeholder: (context, url) => SizedBox(
                                          child: Lottie.asset('assets/animation/placeholder.json', fit: BoxFit.cover),
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        titles(text: items.name ?? 'Na', size: 20, weight: FontWeight.w500),
                                        titles(text: '\$ ${data.docs[index]['totalAmount']}', size: 13, weight: FontWeight.w300),
                                        titles(text: '${data.docs[index]['itemLength']} items', size: 13, weight: FontWeight.w300),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      ProductAddService().deleteOrder(data.docs[index].id);
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(36.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.green,
                                  ),
                                  padding: const EdgeInsets.all(24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total Price',
                                            style: TextStyle(color: Colors.green[200]),
                                          ),

                                          const SizedBox(height: 8),
                                          // total price
                                          Text(
                                            '$totalAmountSum',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // pay now
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.green.shade200),
                                          borderRadius: BorderRadius.circular(28),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: const Row(
                                          children: [
                                            Text(
                                              'Pay Now',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                      },
                    ),
                  ),
                );
              },
              error: (e, r) => Text(e.toString()),
              loading: () => const CircularProgressIndicator()),

          // total amount + pay now
        ],
      ),
    );
  }
}
