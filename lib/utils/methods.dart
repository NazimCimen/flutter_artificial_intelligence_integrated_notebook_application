import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_demo_app/utils/colors.dart';

String convertDate(Timestamp date) {
  DateTime dateTime = date.toDate();

  return dateTime.day.toString() +
      '/' +
      dateTime.month.toString() +
      '/' +
      dateTime.year.toString();
}
