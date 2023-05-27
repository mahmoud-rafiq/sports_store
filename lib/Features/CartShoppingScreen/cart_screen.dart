// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sports_store/Core/style/app_colors.dart';
import 'package:sports_store/Core/style/app_sizes.dart';
import 'package:sports_store/Core/widget/text_widget.dart';
import 'package:sports_store/Features/CartShoppingScreen/cart_provider.dart';

class CartShoppingScreen extends StatelessWidget {
  const CartShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.blueAccent,
        elevation: AppSizes.r0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
            size: AppSizes.r25,
          ),
        ),
        title: TextWidget(
          text: 'Shopping Cart',
          fontSize: FontSizes.sp18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      body: Consumer<CartProvider>(builder: (context, cart, _) {
        return StreamBuilder<QuerySnapshot>(
            stream: cart.addToCartCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.all(AppSizes.r16),
                  child: MasonryGridView.count(
                    itemCount: snapshot.data!.docs.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSizes.r2,
                    crossAxisSpacing: AppSizes.r2,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;

                      return Card(
                        elevation: AppSizes.r2,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: AppSizes.r150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.black12,
                                  ),
                                  child: Image.network(
                                    data['imageurl'],
                                  ),
                                ),
                                SizedBox(
                                  height: AppSizes.r110,
                                  child: Padding(
                                    padding: EdgeInsets.all(AppSizes.r4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          text: data['title'],
                                          fontSize: FontSizes.sp16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        TextWidget(
                                          text: data['brand']
                                              .toString()
                                              .toUpperCase(),
                                          fontSize: FontSizes.sp14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.grey,
                                        ),
                                        Row(
                                          children: [
                                            TextWidget(
                                              text: '\$',
                                              fontSize: FontSizes.sp18,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.blue,
                                            ),
                                            TextWidget(
                                              text: data['price'],
                                              fontSize: FontSizes.sp18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: AppSizes.r40,
                              height: AppSizes.r40,
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("AddToCart")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .collection("items")
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete()
                                      .then((value) => print("User Deleted"))
                                      .catchError((error) => print(
                                          "Failed to delete user: $error"));
                                },
                                icon: Icon(
                                  Icons.add_shopping_cart,
                                  size: AppSizes.r20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            });
      }),
    );
  }
}
