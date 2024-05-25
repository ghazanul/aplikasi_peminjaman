import 'package:aplikasi_peminjaman/Mobile_user/Header_user_mobile.dart';
import 'package:aplikasi_peminjaman/web_user/Header_user.dart';
import 'package:flutter/material.dart';

class CekDevieUser extends StatefulWidget {
  const CekDevieUser({super.key});

  @override
  State<CekDevieUser> createState() => _CekDevieUserState();
}

class _CekDevieUserState extends State<CekDevieUser> {
  @override
  Widget build(BuildContext context) {
    double lebar = MediaQuery.of(context).size.width;

    return Scaffold(body: lebar <= 430 ? Header_user_mobile() : Header_user());
  }
}
