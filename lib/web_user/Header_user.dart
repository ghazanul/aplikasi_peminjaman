// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aplikasi_peminjaman/Web_admin/Authentication.dart';
import 'package:aplikasi_peminjaman/web_user/Konten/Home_Web.dart';
import 'package:aplikasi_peminjaman/web_user/Konten/Peminjaman_Web.dart';

import 'package:aplikasi_peminjaman/web_user/Konten/Pengembalian%20Web.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Header_user extends StatefulWidget {
  const Header_user({super.key});

  @override
  State<Header_user> createState() => _HeaderState();
}

class _HeaderState extends State<Header_user> {
  int menu = 0;
  List<Widget> page = [
    Home_Web(),
    Peminjaman_Web(),
    Pengembalian_web(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background1.png"),
                    fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 122, vertical: 30),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/1.png"),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "PRODI TEKNOLOGI INFORMASI ",
                                style: GoogleFonts.beVietnamPro(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Text(
                                "FAKULTAS SAINS DAN TEKNOLOGI  ",
                                style: GoogleFonts.beVietnamPro(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                menu = 0;
                              });
                            },
                            child: Container(
                              height: 75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(15),
                                      color: menu == 0
                                          ? Colors.white
                                          : Color.fromARGB(
                                              0, 255, 255, 255),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Home",
                                    style: GoogleFonts.beVietnamPro(
                                        color: menu == 0
                                            ? Colors.white
                                            : Color.fromARGB(
                                                255, 126, 126, 127),
                                        fontWeight: menu == 0
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 20,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(15),
                                      color: menu == 0
                                          ? Colors.white
                                          : Color.fromARGB(
                                              0, 255, 255, 255),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                menu = 1;
                              });
                            },
                            child: Container(
                              height: 75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(15),
                                      color: menu == 1
                                          ? Colors.white
                                          : Color.fromARGB(
                                              0, 255, 255, 255),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Peminjaman",
                                    style: GoogleFonts.beVietnamPro(
                                        color: menu == 1
                                            ? Colors.white
                                            : Color.fromARGB(
                                                255, 126, 126, 127),
                                        fontWeight: menu == 1
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 20,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(15),
                                      color: menu == 1
                                          ? Colors.white
                                          : Color.fromARGB(
                                              0, 255, 255, 255),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                menu = 2;
                              });
                            },
                            child: Container(
                              height: 75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(15),
                                      color: menu == 2
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              0, 255, 255, 255),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Pengembalian",
                                    style: GoogleFonts.beVietnamPro(
                                        color: menu == 2
                                            ? Colors.white
                                            : Color.fromARGB(
                                                255, 126, 126, 127),
                                        fontWeight: menu == 2
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 20,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(15),
                                      color: menu == 2
                                          ? Colors.white
                                          : Color.fromARGB(
                                              0, 255, 255, 255),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                          width: 100,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Authentication()));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 250, 208, 7),
                              ),
                              width: 95,
                              height: 30,
                              child: Center(
                                child: Text(
                                  "Admin",
                                  style: GoogleFonts.beVietnamPro(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )),
                        ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 100, right: 100, top: 150, bottom: 50),
            child: Column(
              children: [
                //page[menu]
                Container(
                  height: MediaQuery.of(context).size.height * 0.78,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: page[menu],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
