import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({super.key});

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class DataPeminjam {
  String NamaPeminjam = "";
  String NoTelpon = "";
  String NamaBarang = "";
  String KodeBarang = "";
  String JumlahPeminjaman = "";
  String Jampeminjam = "";
  String TanggalPeminjman = "";
  int PercobaanPengembalian = 0;
  List jumlahPengembalian = [];
  List jamPengembalian = [];
  List tanggalPengembalian = [];
}

class _RiwayatState extends State<Riwayat> {
  FilePickerResult? filePilihan;
  String? urlImage;

  List<DataPeminjam> dataPeminjam = [];

  mengambilDataReportPinjman() async {
    //pengambilan data pada database report satu persatu sesuai dengan class pada datapeminjam
    await FirebaseFirestore.instance
        .collection("Report")
        .get()
        .then((value) => value.docs.forEach((element) {
              DataPeminjam DataSementar = new DataPeminjam();
              DataSementar.NamaPeminjam = element["NamaPeminjam"];
              DataSementar.NoTelpon = element["NoTelpon"];
              DataSementar.NamaBarang = element["NamaBarang"];
              DataSementar.KodeBarang = element["KodeBarang"];
              DataSementar.JumlahPeminjaman = element["JumlahPeminjaman"];
              DataSementar.Jampeminjam = element["jamPeminjaman"];
              DataSementar.TanggalPeminjman = element["tanggalPeminjaman"];
              DataSementar.PercobaanPengembalian =
                  element["PercobaanPengembalian"];
              //kalao pengembalian user tidak ada maka (-) isinya
              if (int.parse(element["PercobaanPengembalian"].toString()) == 0) {
                DataSementar.jumlahPengembalian.add("-");
                DataSementar.jamPengembalian.add("-");
                DataSementar.tanggalPengembalian.add("-");
              } else {
                //ketika telah berisi
                print(int.parse(element["PercobaanPengembalian"].toString()));
                for (int i = 0;
                    i < int.parse(element["PercobaanPengembalian"].toString());
                    i++) {
                  DataSementar.jumlahPengembalian
                      .add(element["jumlahPengembalian"][i]);

                  DataSementar.jamPengembalian
                      .add(element["jamPengembalian"][i]);

                  DataSementar.tanggalPengembalian
                      .add(element["tanggalPengembalian"][i]);
                }
              }

              dataPeminjam.add(DataSementar);
            }));
  }

  bool isUpload = false;
  Uint8List? imageBytes;
  Image? imageUploaded;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: mengambilDataReportPinjman(),
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///SizedBox(height: MediaQuery.of(context).size.height*0.1 ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(163, 39, 39, 41),
                      border: Border.all(
                          width: 4, color: Color.fromARGB(255, 71, 71, 75))),
                  height: 700,
                  width: 1750,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 130,
                                child: Text("Nama \nPeminjam",
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                width: 130,
                                child: Text("No \nTelpon",
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                width: 130,
                                child: Text("Nama \nBarang",
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                width: 130,
                                child: Text("Jumlah \nPeminjaman",
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                width: 130,
                                child: Text("Kode \nBarang",
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                width: 130,
                                child: Text("Jam \nPeminjaman",
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                width: 130,
                                child: Text("Tanggal \nPeminjaman",
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                width: 130,
                                child: Text("Jumlah \nPengambalian",
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                width: 130,
                                child: Text("Jam \nPengambalian",
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                width: 130,
                                child: Text("Tanggal \nPengambalian",
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //isi
                          Container(
                            height: 565,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (int i = 0; i < dataPeminjam.length; i++)
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              color: Colors.amber,
                                              width: 130,
                                              height: 70,
                                              child: Center(
                                                child: Text(
                                                    dataPeminjam[i]
                                                        .NamaPeminjam,
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                            Container(
                                              width: 130,
                                              height: 70,
                                              child: Center(
                                                child: Text(
                                                    dataPeminjam[i].NoTelpon,
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                            Container(
                                              color: Colors.amber,
                                              width: 130,
                                              height: 70,
                                              child: Center(
                                                child: Text(
                                                    dataPeminjam[i].NamaBarang,
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                            Container(
                                              width: 130,
                                              height: 70,
                                              child: Center(
                                                child: Text(
                                                    dataPeminjam[i]
                                                        .JumlahPeminjaman,
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                            Container(
                                              width: 130,
                                              height: 70,
                                              child: Center(
                                                child: Text(
                                                    dataPeminjam[i].KodeBarang,
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                            Container(
                                              width: 130,
                                              child: Center(
                                                child: Text(
                                                    dataPeminjam[i].Jampeminjam,
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                            Container(
                                              width: 130,
                                              color: Colors.amber,
                                              child: Center(
                                                child: Text(
                                                    dataPeminjam[i]
                                                        .TanggalPeminjman,
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                            Container(
                                              width: 460,
                                              color: Colors.brown,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  for (int j = 0;
                                                      j <
                                                          dataPeminjam[i]
                                                              .jamPengembalian
                                                              .length;
                                                      j++)
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  width: 130,
                                                                  child: Text(
                                                                      dataPeminjam[i]
                                                                              .jumlahPengembalian[
                                                                          j],
                                                                      style: GoogleFonts
                                                                          .beVietnamPro(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  width: 130,
                                                                  child: Text(
                                                                      dataPeminjam[i]
                                                                              .jamPengembalian[
                                                                          j],
                                                                      style: GoogleFonts
                                                                          .beVietnamPro(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  width: 130,
                                                                  child: Text(
                                                                      dataPeminjam[i]
                                                                              .tanggalPengembalian[
                                                                          j],
                                                                      style: GoogleFonts
                                                                          .beVietnamPro(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 1620,
                                          height: 4,
                                          color: const Color.fromARGB(
                                              255, 71, 71, 75),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //       width: 130,
                          //       height: 70,
                          //       child: Center(
                          //         child: Text("Ghazanul",
                          //             style: GoogleFonts.beVietnamPro(
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: 15,
                          //               color: Colors.white,
                          //             ),
                          //             textAlign: TextAlign.center),
                          //       ),
                          //     ),
                          //     Container(
                          //       width: 130,
                          //       color: Colors.red,
                          //       child: Text("081234567890",
                          //           style: GoogleFonts.beVietnamPro(
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 15,
                          //             color: Colors.white,
                          //           ),
                          //           textAlign: TextAlign.center),
                          //     ),
                          //     Container(
                          //       width: 130,
                          //       height: 70,
                          //       color: Colors.amber,
                          //       child: Center(
                          //         child: Text("RJ45",
                          //             style: GoogleFonts.beVietnamPro(
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: 15,
                          //               color: Colors.white,
                          //             ),
                          //             textAlign: TextAlign.center),
                          //       ),
                          //     ),
                          //     Container(
                          //       width: 130,
                          //       child: Text("70",
                          //           style: GoogleFonts.beVietnamPro(
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 15,
                          //             color: Colors.white,
                          //           ),
                          //           textAlign: TextAlign.center),
                          //     ),
                          //     Container(
                          //       width: 130,
                          //       child: Text("-",
                          //           style: GoogleFonts.beVietnamPro(
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 15,
                          //             color: Colors.white,
                          //           ),
                          //           textAlign: TextAlign.center),
                          //     ),
                          //     Container(
                          //       width: 130,
                          //       child: Text("08.00",
                          //           style: GoogleFonts.beVietnamPro(
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 15,
                          //             color: Colors.white,
                          //           ),
                          //           textAlign: TextAlign.center),
                          //     ),
                          //     Container(
                          //       width: 130,
                          //       height: 70,
                          //       color: Colors.amber,
                          //       child: Center(
                          //         child: Text("02 - 03 - 2024",
                          //             style: GoogleFonts.beVietnamPro(
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: 15,
                          //               color: Colors.white,
                          //             ),
                          //             textAlign: TextAlign.center),
                          //       ),
                          //     ),
                          //     Container(
                          //       width: 460,
                          //       color: Colors.brown,
                          //       child: Column(
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Column(
                          //                 children: [
                          //                   Container(
                          //                     color: Colors.blueAccent,
                          //                     width: 130,
                          //                     child: Text("20",
                          //                         style:
                          //                             GoogleFonts.beVietnamPro(
                          //                           fontWeight: FontWeight.bold,
                          //                           fontSize: 15,
                          //                           color: Colors.white,
                          //                         ),
                          //                         textAlign: TextAlign.center),
                          //                   ),
                          //                 ],
                          //               ),
                          //               Column(
                          //                 children: [
                          //                   Container(
                          //                     color: Colors.blueAccent,
                          //                     width: 130,
                          //                     child: Text("12.00",
                          //                         style:
                          //                             GoogleFonts.beVietnamPro(
                          //                           fontWeight: FontWeight.bold,
                          //                           fontSize: 15,
                          //                           color: Colors.white,
                          //                         ),
                          //                         textAlign: TextAlign.center),
                          //                   ),
                          //                 ],
                          //               ),
                          //               Column(
                          //                 children: [
                          //                   Container(
                          //                     color: Colors.blueAccent,
                          //                     width: 130,
                          //                     child: Text("02 - 03 - 2024",
                          //                         style:
                          //                             GoogleFonts.beVietnamPro(
                          //                           fontWeight: FontWeight.bold,
                          //                           fontSize: 15,
                          //                           color: Colors.white,
                          //                         ),
                          //                         textAlign: TextAlign.center),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //           SizedBox(
                          //             height: 15,
                          //           ),
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Column(
                          //                 children: [
                          //                   Container(
                          //                     color: Colors.blueAccent,
                          //                     width: 130,
                          //                     child: Text("20",
                          //                         style:
                          //                             GoogleFonts.beVietnamPro(
                          //                           fontWeight: FontWeight.bold,
                          //                           fontSize: 15,
                          //                           color: Colors.white,
                          //                         ),
                          //                         textAlign: TextAlign.center),
                          //                   ),
                          //                 ],
                          //               ),
                          //               Column(
                          //                 children: [
                          //                   Container(
                          //                     color: Colors.blueAccent,
                          //                     width: 130,
                          //                     child: Text("12.00",
                          //                         style:
                          //                             GoogleFonts.beVietnamPro(
                          //                           fontWeight: FontWeight.bold,
                          //                           fontSize: 15,
                          //                           color: Colors.white,
                          //                         ),
                          //                         textAlign: TextAlign.center),
                          //                   ),
                          //                 ],
                          //               ),
                          //               Column(
                          //                 children: [
                          //                   Container(
                          //                     color: Colors.blueAccent,
                          //                     width: 130,
                          //                     child: Text("02 - 03 - 2024",
                          //                         style:
                          //                             GoogleFonts.beVietnamPro(
                          //                           fontWeight: FontWeight.bold,
                          //                           fontSize: 15,
                          //                           color: Colors.white,
                          //                         ),
                          //                         textAlign: TextAlign.center),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: 1620,
                          //   height: 4,
                          //   color: const Color.fromARGB(255, 71, 71, 75),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 11,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 71, 71, 75)),
                    width: 215,
                    height: 61,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/xls.png",
                            height: 44,
                            width: 44,
                          ),
                          Text(
                            "Download Data",
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
