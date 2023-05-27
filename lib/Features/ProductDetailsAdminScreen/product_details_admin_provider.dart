import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailsAdminProvider extends ChangeNotifier {
  final productCollection = FirebaseFirestore.instance.collection('Product');
}
