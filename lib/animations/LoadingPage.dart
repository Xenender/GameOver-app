
import 'package:flutter/material.dart';
import 'package:gameover_app/repository/Storage_service.dart';
import 'dart:io';

import 'package:gameover_app/repository/User_repository.dart';

import '../repository/User_model.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),


    );
  }
}