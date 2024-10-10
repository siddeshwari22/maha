import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderModel with ChangeNotifier {
  final String orderId, productId, userName, price, userId, imageUrl, quantity;
  final Timestamp orderDate;

  OrderModel({
    required this.orderId,
    required this.quantity,
    required this.userId,
    required this.price,
    required this.productId,
    required this.imageUrl,
    required this.orderDate,
    required this.userName,
  });
}
