// ignore_for_file: unused_import

import 'package:aplikasi_peminjaman/Mobile_user/Header_user_mobile.dart';
import 'package:aplikasi_peminjaman/Web_admin/Authentication.dart';
import 'package:aplikasi_peminjaman/Web_admin/Header_admin.dart';
import 'package:aplikasi_peminjaman/databse/PengecekDeviceUser.dart';
import 'package:aplikasi_peminjaman/web_user/Header_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...
 
void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CekDevieUser(),
      
    );
  }
}
