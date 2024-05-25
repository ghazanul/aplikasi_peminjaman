// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aplikasi_peminjaman/Mobile_user/Konten/Home_Mobile.dart';
import 'package:aplikasi_peminjaman/Mobile_user/Konten/Peminjaman_Mobile.dart';
import 'package:aplikasi_peminjaman/Mobile_user/Konten/Pengembalian_mobile.dart';
import 'package:aplikasi_peminjaman/Web_admin/Authentication.dart';
import 'package:aplikasi_peminjaman/web_user/Konten/Home_Web.dart';
import 'package:aplikasi_peminjaman/web_user/Konten/Peminjaman_Web.dart';

import 'package:aplikasi_peminjaman/web_user/Konten/Pengembalian%20Web.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Header_user_mobile extends StatefulWidget {
  const Header_user_mobile({super.key});

  @override
  State<Header_user_mobile> createState() => _HeaderState();
}

class _HeaderState extends State<Header_user_mobile> {
  int menu = 0;
  List<Widget> page = [
    Home_mobile(),
    Peminjaman_mobile(),
    Pengembalian_Mobile(),
  ];

  bool popUpMuncul = false;

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
                    fit: BoxFit.cover),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 36),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 37,
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 37,
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
                                    fontSize: 13),
                              ),
                              Text(
                                "FAKULTAS SAINS DAN TEKNOLOGI  ",
                                style: GoogleFonts.beVietnamPro(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          popUpMuncul = true;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 37,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/menu.png"),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(
                left: 30, right: 30, top: MediaQuery.of(context).size.height*0.12 ),
            child: Column(
              children: [
                //page[menu]
                Container(
                  
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: page[menu],
                )
              ],
            ),
          ),

          //pop up menu
          popUpMuncul
              ? Container(
                  color: const Color.fromARGB(94, 0, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 39, 39, 41),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 285,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, top: 36, right: 12, bottom: 20),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 37,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/1.png"),
                                                        fit: BoxFit.cover)),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "PRODI TEKNOLOGI INFORMASI ",
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                  ),
                                                  Text(
                                                    "FAKULTAS SAINS DAN TEKNOLOGI  ",
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 10),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              popUpMuncul = false;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Container(
                                              width: 23,
                                              height: 23,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/close.png"),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        menu = 0;
                                        popUpMuncul =false ;
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        menu = 1;
                                        popUpMuncul =false ;

                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        menu = 2;
                                        popUpMuncul =false ;

                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                    height: 8,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Authentication()));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              Color.fromARGB(255, 250, 208, 7),
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Align(),
        ],
      ),
    );
  }
}
