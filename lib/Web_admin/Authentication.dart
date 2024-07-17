// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'dart:ui';

import 'package:aplikasi_peminjaman/Web_admin/Header_admin.dart';
import 'package:aplikasi_peminjaman/Web_admin/konten/Barang.dart';
import 'package:aplikasi_peminjaman/Web_admin/konten/Riwayat.dart';
import 'package:aplikasi_peminjaman/Web_admin/konten/tambah_barang.dart';
import 'package:aplikasi_peminjaman/databse/Authentication_servis.dart';
import 'package:aplikasi_peminjaman/web_user/Konten/Home_Web.dart';

import 'package:aplikasi_peminjaman/web_user/Konten/Pengembalian%20Web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _HeaderState();
}

class _HeaderState extends State<Authentication> {
  //mengambbil data dari text filt
  TextEditingController emailController = new TextEditingController();
  TextEditingController PasswordController = new TextEditingController();
  bool _isLoading = false;
  String email = "";
  String password = "";
  AuthService authService = AuthService();
  String PesanloginKetikaGagal = "";

  bool loginGagal = false;

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
          loginGagal
              ? Center(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromARGB(255, 39, 39, 41),
                        border: Border.all(
                            width: 4, color: Color.fromARGB(255, 71, 71, 75))),
                    width: 375,
                    height: 251,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 44),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //icon
                
                          Text(
                            "Login Gagal !",
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 26,
                          ),
                          Text(
                            PesanloginKetikaGagal,
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 26,
                          ),
                
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                loginGagal = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 250, 208, 7),
                              ),
                              height: 44,
                              width: 126,
                              child: Center(
                                child: Text(
                                  "KEMBALI",
                                  style: GoogleFonts.beVietnamPro(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 7, 7, 10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              )
              : Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromARGB(163, 39, 39, 41),
                        border: Border.all(
                            width: 4, color: Color.fromARGB(255, 71, 71, 75))),
                    height: 496,
                    width: 622,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 98,
                        horizontal: 122,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //icon

                          Row(
                            children: [
                              Text(
                                "Email",
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            height: 63,
                            width: 378,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: " Masukkan Email",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Password",
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            height: 63,
                            width: 378,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                obscureText: true,
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                controller: PasswordController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: " Masukkan Password",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 38,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  height: 62,
                                  width: 161,
                                  child: Center(
                                    child: Text(
                                      "BATAL",
                                      style: GoogleFonts.beVietnamPro(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 7, 7, 10)),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //mengisi email dan password data
                                  login();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 250, 208, 7),
                                  ),
                                  width: 161,
                                  height: 62,
                                  child: Center(
                                    child: Text("LOGIN",
                                        style: GoogleFonts.beVietnamPro(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 7, 7, 10))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  login() async {
    if (emailController.text != "" && PasswordController.text != "") {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Header_admin()));
        } else {
          setState(() {
            PesanloginKetikaGagal = value.toString();
            loginGagal = true;
            _isLoading = false;
          });
          print(PesanloginKetikaGagal);
          if (PesanloginKetikaGagal == "The email address is badly formatted." ) {
            PesanloginKetikaGagal = "Format Email Salah" ;
          } else  if (PesanloginKetikaGagal == "The supplied auth credential is incorrect, malformed or has expired.") {

            PesanloginKetikaGagal = "Email Atau Sandi salah";
          }
        }
      });
    }
  }
}
