import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameover_app/repository/Activity_model.dart';
import 'package:gameover_app/repository/User_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AdminPassword_model.dart';

class AdminPassword_repository {

  final _db = FirebaseFirestore.instance;

  Future<AdminPassword_model> getAdminPasswordModel() async{
    final snapshot = await _db.collection("admin_password").get();

    AdminPassword_model password_model = AdminPassword_model.fromDocumentSnap(snapshot.docs.first) ;
    return password_model;
  }
}