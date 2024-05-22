// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types


import 'package:aplikasi_peminjaman/Web_admin/konten/Barang.dart';
import 'package:aplikasi_peminjaman/web_user/Konten/Komponen/Barang_User.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home_Web extends StatefulWidget {
  const Home_Web({super.key});

  @override
  State<Home_Web> createState() => _Home_WebState();
}

class _Home_WebState extends State<Home_Web> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
          ),
          Text(
            "SELAMAT DATANG DI",
            style: GoogleFonts.beVietnamPro(
                fontSize: 70, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "PEMINJAMAN TI",
                style: GoogleFonts.beVietnamPro(
                    fontSize: 70,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Scroll",
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w200),
                  ),
                  Text("Ke",
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w200)),
                  Text("Bawah",
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w200))
                ],
              )
            ],
          ),
          SizedBox(
            height: 430,
          ),
          Barang_User()
        ],
      ),
    );
  }
}
