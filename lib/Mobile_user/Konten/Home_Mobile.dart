// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:aplikasi_peminjaman/Mobile_user/Konten/Komponen/Barang_User_mobile.dart';
import 'package:aplikasi_peminjaman/Web_admin/konten/Barang.dart';
import 'package:aplikasi_peminjaman/web_user/Konten/Komponen/Barang_User.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home_mobile extends StatefulWidget {
  const Home_mobile({super.key});

  @override
  State<Home_mobile> createState() => _Home_MobileState();
}

class _Home_MobileState extends State<Home_mobile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selamat Datang Di",
            style: GoogleFonts.beVietnamPro(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            "Peminjaman TI",
            style: GoogleFonts.beVietnamPro(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          //jarak anatara titel dan komponen
          SizedBox(
            height: 25,
          ),
          Barang_User_Mobile()
        ],
      ),
    );
  }
}
