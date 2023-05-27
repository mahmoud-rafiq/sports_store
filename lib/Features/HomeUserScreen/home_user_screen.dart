// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_store/Core/widget/showd_loading.dart';
import 'package:sports_store/Core/widget/text_widget.dart';
import 'package:sports_store/Features/AuthLogin/SignInScreen/signin_screen.dart';
import 'package:sports_store/Features/CartShoppingScreen/cart_screen.dart';
import 'package:sports_store/Features/HomeUserScreen/home_user_provider.dart';
import 'package:sports_store/Features/OrdersScreen/orders_screen.dart';
import 'package:sports_store/Core/style/app_colors.dart';
import 'package:sports_store/Core/style/app_sizes.dart';
import 'package:sports_store/Core/widget/list_tile_widget.dart';
import 'package:sports_store/Features/ProductDetailsScreen/product_details__screen.dart';
import 'package:sports_store/Features/ProfileScreen/profile_screen.dart';

class HomeUserScreen extends StatelessWidget {
  const HomeUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeUserProvider>(
      builder: (context, homeUser, _) {
        return WillPopScope(
          onWillPop: () => homeUser.onWillPop(),
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.blueAccent,
              elevation: AppSizes.r0,
              centerTitle: true,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: AppColors.white,
                    size: AppSizes.r28,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: TextWidget(
                fontSize: FontSizes.sp18,
                text: 'Home',
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartShoppingScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: AppColors.white,
                    size: AppSizes.r25,
                  ),
                ),
                SizedBox(
                  width: AppSizes.r8,
                )
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: AppColors.black12,
                    ),
                    child: Column(children: [
                      CircleAvatar(
                        radius: AppSizes.r40,
                        backgroundColor: AppColors.grey,
                        child: Icon(
                          Icons.person,
                          color: AppColors.black,
                          size: AppSizes.r28,
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.r16,
                      ),
                      Expanded(
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: FontSizes.sp16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                  ),
                  ListTileWidget(
                    text: 'Orders',
                    iconLeading: Icons.shopping_bag,
                    iconTrailing: Icons.arrow_forward_ios,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrdersScreen(),
                        ),
                      );
                    },
                  ),
                  ListTileWidget(
                    text: 'Profile',
                    iconLeading: Icons.person,
                    iconTrailing: Icons.arrow_forward_ios,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  ListTileWidget(
                    text: 'Shopping Cart',
                    iconLeading: Icons.shopping_cart,
                    iconTrailing: Icons.arrow_forward_ios,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartShoppingScreen(),
                        ),
                      );
                    },
                  ),
                  ListTileWidget(
                    text: 'Edit Profile',
                    iconLeading: Icons.edit,
                    iconTrailing: Icons.arrow_forward_ios,
                    onTap: () async {
                      homeUser.getEditProfileScreen(context);
                    },
                  ),
                  SizedBox(
                    height: AppSizes.r28,
                  ),
                  Divider(
                    thickness: AppSizes.r1,
                    height: AppSizes.r0,
                  ),
                  ListTileWidget(
                    text: 'Log Out',
                    iconLeading: Icons.logout,
                    iconTrailing: Icons.power_settings_new,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut().then((value) =>
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                              (route) => false));
                    },
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(AppSizes.r16),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        homeUser.getsearch(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search here...',
                        contentPadding: EdgeInsets.all(AppSizes.r8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.r40),
                          borderSide: BorderSide(color: AppColors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.r40),
                          borderSide: BorderSide(color: AppColors.blue),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.r40),
                          borderSide: BorderSide(color: AppColors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.r40),
                          borderSide: BorderSide(color: AppColors.blue),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: AppSizes.r25,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.r20),
                    SizedBox(
                      height: AppSizes.r600,
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: homeUser.productCollection.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.hasData) {
                              final docs = snapshot.data!.docs;
                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  listOfSearch = docs.where((e) {
                                if (homeUser.search1.isNotEmpty) {
                                  return ((e.data()['title']) as String)
                                      .toLowerCase()
                                      .startsWith(
                                          homeUser.search1.toLowerCase());
                                }
                                return true;
                              }).toList();
                              return ListView.builder(
                                itemCount: listOfSearch.length,
                                itemBuilder: (context, index) {
                                  final data = listOfSearch[index].data();
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsScreen(snapshot
                                                  .data!.docs[index].id),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(bottom: AppSizes.r4),
                                      child: SizedBox(
                                        height: AppSizes.r150,
                                        child: Card(
                                          elevation: AppSizes.r2,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: AppColors.black12,
                                              width: AppSizes.r1,
                                            ),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: AppSizes.r150,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppSizes.r4),
                                                      color: AppColors.black12,
                                                    ),
                                                    child: Image.network(
                                                      data['imageurl'][0],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          AppSizes.r10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          TextWidget(
                                                            text: data['title'],
                                                            fontSize:
                                                                FontSizes.sp16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          TextWidget(
                                                            text: data['brand']
                                                                .toString()
                                                                .toUpperCase(),
                                                            fontSize:
                                                                FontSizes.sp14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                AppColors.grey,
                                                          ),
                                                          Row(
                                                            children: [
                                                              TextWidget(
                                                                text: '\$',
                                                                fontSize:
                                                                    FontSizes
                                                                        .sp18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: AppColors
                                                                    .blue,
                                                              ),
                                                              TextWidget(
                                                                text: data[
                                                                    'price'],
                                                                fontSize:
                                                                    FontSizes
                                                                        .sp18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection("AddToCart")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.email)
                                                      .collection("items")
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data == null) {
                                                      return const Text("");
                                                    }
                                                    return Container(
                                                      width: AppSizes.r40,
                                                      height: AppSizes.r40,
                                                      decoration: BoxDecoration(
                                                        color: snapshot.data!
                                                                    .data() ==
                                                                null
                                                            ? AppColors.grey300
                                                            : AppColors.red,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          snapshot.data!
                                                                      .data() ==
                                                                  null
                                                              ? await homeUser
                                                                  .addToCart(
                                                                  snapshot
                                                                      .data!.id,
                                                                  data['title'],
                                                                  data['price'],
                                                                  data['brand'],
                                                                  data['imageurl']
                                                                      [0],
                                                                )
                                                              : showAddToCart(
                                                                  context);
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .add_shopping_cart,
                                                          size: AppSizes.r20,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
