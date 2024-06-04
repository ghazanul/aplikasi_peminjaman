// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_import, camel_case_types

import 'dart:js_interop';

import 'package:aplikasi_peminjaman/databse/database_servis.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Pengembalian_web extends StatefulWidget {
  const Pengembalian_web({super.key});

  @override
  State<Pengembalian_web> createState() => _Pengembalian_webState();
}

List<String> KumpulanNama = [];
List<bool> KumpulanKode = [];
List<String> KumpulanUrlImage = [];
List<int> KumpilanId = [];
List<int> KumpilanTotalJumlahBarang = [];
List<String> KumpilanBarangBerkode = [];
List<bool> KumpulanStatusBerkode = [];
List<String> BarangYangDikembalikan = [];
List<String> BarangYangRusak = [];

List<String> KodeAtauJumlahYangDikembalikan = [];
List<bool> BarangBerkode = [];
List<String> KumpulanIdUser = [];
List<String> KumpulanNamaUser = [];
List<String> KumpulanNoTlponUser = [];
List<String> KumpulanDocPeminjamUser = [];

List<int> KumpulanBarangTerpakai = [];

String NamaPeminjamSekarang = "";
String NoTelponPeminjamSekarang = "";

String kodeAtauJumlahBarangYangDikembalikan = "";

String DocPeminjamSekarang = "";
String idBarangYangDikembalikan = "";
String docBarangYangDipinjamSekarang = "";
int BanyakBarangDipinjamUser = 0;

bool isBarangBerkodeYangAkanDikembalikan =
    false; // untuk mengecek apakah brang yang akaan dikembalikan adalah barang berkode atau tidak

bool loading = false;
bool loading2 = false;
bool peminjamanGagalKarenaJumlahYangDiKembalikanKebanyakan = false;
bool munculPopUpPengembalianKebanyakan = false;

HapusDataKembalikanBarang() {
  BarangYangDikembalikan.clear();
  KodeAtauJumlahYangDikembalikan.clear();
  BarangBerkode.clear();
  BanyakBarangDipinjamUser = 0;
  refreshData();
}

refreshData() {
  KumpulanNama.clear();
  KumpulanKode.clear();
  KumpulanUrlImage.clear();
  KumpilanId.clear();
  KumpilanTotalJumlahBarang.clear();
  KumpilanBarangBerkode.clear();
  KumpulanIdUser.clear();
  KumpulanNamaUser.clear();
  KumpulanNoTlponUser.clear();
  KumpulanDocPeminjamUser.clear();
  KumpulanBarangTerpakai.clear();
}

refreshDataBarangBerkode() {
  KumpilanBarangBerkode.clear();
  KumpulanStatusBerkode.clear();
}

getBarangBerkode(int id) async {
  refreshDataBarangBerkode();
  print("Id Yang di pilih adalah :" + id.toString());

  await FirebaseFirestore.instance
      .collection("Barang")
      .doc(id.toString())
      .collection("BarangBarang")
      .get()
      .then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((element) {
      KumpilanBarangBerkode.add(element["Kode"].toString());
      KumpulanStatusBerkode.add(element["Status"]);
    });
  });
}

HapusbarangBerkode(int id, String KodeBarang) async {
  await DatabaseServie().HapusSatuan(id, KodeBarang);
}

loadingPanel(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      });
}

HapusBarangTidakBerkode(int id, int JumlahBarangYangDiHapus) async {
  DocumentSnapshot data = await FirebaseFirestore.instance
      .collection('Barang')
      .doc(id.toString())
      .get();
  if (int.parse(data['JumlahTotalBarang'].toString()) >=
      JumlahBarangYangDiHapus) {
    await FirebaseFirestore.instance
        .collection("Barang")
        .doc(id.toString())
        .update({
      'JumlahTotalBarang': int.parse(data['JumlahTotalBarang'].toString()) -
          JumlahBarangYangDiHapus
    });
  } else {
    print("Penghapusan Data Tidak Sesuai");
  }
}

EditBarangTidakBerkode(int id, int JumlahBarang) async {
  await DatabaseServie().EditBarangTidakBerkode(id, JumlahBarang);
}

class _Pengembalian_webState extends State<Pengembalian_web> {
  getBarang() async {
    refreshData();
    setState(() {});
    await FirebaseFirestore.instance
        .collection("Barang")
        .orderBy(
            //supaya tersusun dengen berurutan
            "Id",
            descending: false)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        if (!(element["SekaliPakai"])) {
          KumpulanNama.add(element['Nama']);

          KumpulanKode.add(element['Berkode']);
          KumpulanUrlImage.add(element['Gambar']);
          KumpilanId.add(int.parse(element.id.toString()));
          KumpilanTotalJumlahBarang.add(
              int.parse(element['JumlahTotalBarang'].toString()));
          KumpulanBarangTerpakai.add(element['JumlahTerpakai']);
        }
      });
    });
  }

  loadingPanel(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        });
  }

  //mengambbil data dari text filt
  TextEditingController NamaPeminjamController = new TextEditingController();
  TextEditingController NoTelponController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextEditingController JumlahYangDikembalikanController =
        new TextEditingController();
    TextEditingController JumlahYangRusakController =
        new TextEditingController();
    TextEditingController NamaPeminjamController = new TextEditingController();
    TextEditingController NoTelponController = new TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///SizedBox(height: MediaQuery.of(context).size.height*0.1 ),
        Center(
          child: munculPopUpPengembalianKebanyakan
              ?
              //pop up pengembalian berlebihan
              Container(
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
                          "Pengambalian Gagal !",
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
                          "Jumlah Yang Dikembalikan \n Melempaui Jumlah Yang di Pinjam",
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
                              munculPopUpPengembalianKebanyakan = false;
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
                )
              : loading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            )),
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color.fromARGB(163, 39, 39, 41),
                          border: Border.all(
                              width: 4,
                              color: Color.fromARGB(255, 71, 71, 75))),
                      height: 617,
                      width: 622,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 90,
                          horizontal: 122,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                height: 400,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //MENGECEK JUMLAH BARANG
                                    (BarangYangDikembalikan.length != 0)
                                        ?
                                        //KONDISI KETIKA BARANG TELAH ADA/SEDANG DIKEMBALIKAN
                                        Column(
                                            children: [
                                              for (int x = 0;
                                                  x <
                                                      BarangYangDikembalikan
                                                          .length;
                                                  x++)
                                                BarangBerkode[x]
                                                    ?
                                                    //ketika barang berkode (TIDAK MEMILIKI JUMLAH)
                                                    Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Barang",
                                                                style: GoogleFonts
                                                                    .beVietnamPro(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              height: 63,
                                                              width: 378,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      BarangYangDikembalikan[
                                                                          x],
                                                                      style: GoogleFonts.beVietnamPro(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Kode Barang",
                                                                style: GoogleFonts
                                                                    .beVietnamPro(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              height: 63,
                                                              width: 378,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      KodeAtauJumlahYangDikembalikan[
                                                                          x],
                                                                      style: GoogleFonts.beVietnamPro(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                        ],
                                                      )
                                                    :
                                                    //ketika barang tidak berkode (MEMILIKI JUMLAH)
                                                    Container(
                                                        height: 305,
                                                        child: ListView(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Nama Peminjam",
                                                                  style: GoogleFonts.beVietnamPro(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              height: 63,
                                                              width: 378,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      NamaPeminjamController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        " Masukkan Nama Seperti saat Meminjam",
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w100,
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
                                                                  "No Telpon",
                                                                  style: GoogleFonts.beVietnamPro(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              height: 63,
                                                              width: 378,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      NoTelponController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Masukkan No Telpon Seperti saat Meminjam",
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w100,
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
                                                                  "Barang",
                                                                  style: GoogleFonts.beVietnamPro(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                height: 62,
                                                                width: 378,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          BarangYangDikembalikan[
                                                                              x],
                                                                          style: GoogleFonts.beVietnamPro(
                                                                              fontSize: 15,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Jumlah Yang DiKembalikan",
                                                                  style: GoogleFonts.beVietnamPro(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                height: 62,
                                                                width: 378,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        KodeAtauJumlahYangDikembalikan[
                                                                            x],
                                                                        style: GoogleFonts.beVietnamPro(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      HapusDataKembalikanBarang();
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                      ),
                                                      height: 62,
                                                      width: 161,
                                                      child: Center(
                                                        child: Text(
                                                          "BATAL",
                                                          style: GoogleFonts
                                                              .beVietnamPro(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          7,
                                                                          7,
                                                                          10)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      //untuk loading panel
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return SimpleDialog(
                                                              insetPadding:
                                                                  EdgeInsets.only(
                                                                      top: 80),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          0),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100)),
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          0,
                                                                          39,
                                                                          39,
                                                                          41),
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                                  ],
                                                                )
                                                              ],
                                                            );
                                                          });

                                                      //untuk mengambil semua data peminjam
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("User")
                                                          .get()
                                                          .then((QuerySnapshot
                                                              snapshot) {
                                                        snapshot.docs
                                                            .forEach((element) {
                                                          KumpulanIdUser.add(
                                                              element.id);
                                                          KumpulanNamaUser.add(
                                                              element["Nama"]);
                                                          KumpulanNoTlponUser
                                                              .add(element[
                                                                  "NoTelpon"]);
                                                          KumpulanDocPeminjamUser
                                                              .add(element.id);
                                                        });
                                                      });

                                                      //melkakukan pengeceken siapa yang meminjam barang
                                                      if (isBarangBerkodeYangAkanDikembalikan) {
                                                        for (int i = 0;
                                                            i <
                                                                KumpulanIdUser
                                                                    .length;
                                                            i++) {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "User")
                                                              .doc(
                                                                  KumpulanIdUser[
                                                                      i])
                                                              .collection(
                                                                  "BarangBarang")
                                                              .get()
                                                              .then(
                                                                  (QuerySnapshot
                                                                      snapshot) {
                                                            snapshot.docs
                                                                .forEach(
                                                                    (element) {
                                                              // print("a : " +
                                                              //   kodeAtauJumlahBarangYangDikembalikan + "  b : " + element["JumlahatauKodeBarang"]);

                                                              if (kodeAtauJumlahBarangYangDikembalikan ==
                                                                  element[
                                                                      "JumlahatauKodeBarang"]) {
                                                        print("lkajsdflkjaselfjase;fjas l;fekj : " + kodeAtauJumlahBarangYangDikembalikan);
                                                                NamaPeminjamSekarang =
                                                                    KumpulanNamaUser[
                                                                        i];
                                                                NoTelponPeminjamSekarang =
                                                                    KumpulanNoTlponUser[
                                                                        i];
                                                                //mengambil id user yang sedang mau mengembalikan
                                                                DocPeminjamSekarang =
                                                                    KumpulanDocPeminjamUser[
                                                                        i];
                                                              }
                                                            });
                                                          });
                                                        }
                                                      } else {
                                                        ////kembalikan barang tidak berkode
                                                        NamaPeminjamSekarang =
                                                            "Tidak Terdeteksi";
                                                        NoTelponPeminjamSekarang =
                                                            "Tidak Terdeteksi";
                                                        DocPeminjamSekarang =
                                                            "NULL";
                                                        int i = 0;
                                                        String
                                                            NamaPeminjamControllerHurufKecil =
                                                            NamaPeminjamController
                                                                .text
                                                                .toLowerCase(); ////supaya kebaca huruf kecil
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection("User")
                                                            .get()
                                                            .then((QuerySnapshot
                                                                snapshot) {
                                                          snapshot.docs.forEach(
                                                              (element) {
                                                            if (NamaPeminjamControllerHurufKecil ==
                                                                    element[
                                                                        "Nama"] &&
                                                                NoTelponController
                                                                        .text ==
                                                                    element[
                                                                        "NoTelpon"]) {
                                                              NamaPeminjamSekarang =
                                                                  element[
                                                                      "Nama"];

                                                              NoTelponPeminjamSekarang =
                                                                  element[
                                                                      "NoTelpon"];
                                                              //mengambil id user yang sedang mau mengembalikan
                                                              DocPeminjamSekarang =
                                                                  KumpulanDocPeminjamUser[
                                                                      i];
                                                            }

                                                            i++;
                                                          });
                                                        });
                                                      }
                                                      print("doc peminjam sekarang : " +
                                                          DocPeminjamSekarang);

                                                      //mengambil data id dari barang yang ada di database user
                                                      int i = 0;
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("User")
                                                          .doc(
                                                              DocPeminjamSekarang)
                                                          .collection(
                                                              "BarangBarang")
                                                          .get()
                                                          .then((QuerySnapshot
                                                              snapshot) {
                                                        snapshot.docs
                                                            .forEach((element) {
                                                          //perlu manambahkan field kode di di database user pada barang untuk bisa mengecek apakah barang itu berkode atau tidak
                                                          if (BarangBerkode[
                                                              i]) {
                                                            if (element[
                                                                    "JumlahatauKodeBarang"] ==
                                                                KodeAtauJumlahYangDikembalikan[
                                                                    0]) {
                                                              idBarangYangDikembalikan =
                                                                  element.id;
                                                            }
                                                          } else {
                                                            if (element[
                                                                    "NamaBarang"] ==
                                                                BarangYangDikembalikan[
                                                                    0]) {
                                                              idBarangYangDikembalikan =
                                                                  element.id;
                                                            }
                                                          }
                                                        });
                                                      });

                                                      //menghitung jumlah barang yang dipinjam user
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("User")
                                                          .doc(
                                                              DocPeminjamSekarang)
                                                          .collection(
                                                              "BarangBarang")
                                                          .get()
                                                          .then((value) =>
                                                              value.docs.forEach(
                                                                  (element) {
                                                                BanyakBarangDipinjamUser++;
                                                              }));

                                                      setState(() {});
                                                      Navigator.pop(context);

                                                      showDialog(
                                                          barrierColor:
                                                              Color.fromARGB(
                                                                  141, 7, 7, 7),
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return SimpleDialog(
                                                              insetPadding:
                                                                  EdgeInsets.only(
                                                                      top: 80),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          0),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100)),
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          0,
                                                                          39,
                                                                          39,
                                                                          41),
                                                              children: [
                                                                Center(
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                25),
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            39,
                                                                            39,
                                                                            41),
                                                                        border: Border.all(
                                                                            width:
                                                                                4,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                71,
                                                                                71,
                                                                                75))),
                                                                    width: 430,
                                                                    height: 325,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              60,
                                                                          horizontal:
                                                                              73),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          //Data Peminjam

                                                                          Text(
                                                                            "Pengembalian TI",
                                                                            style: GoogleFonts.beVietnamPro(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.white),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),

                                                                          SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),

                                                                          Container(
                                                                            height:
                                                                                95,
                                                                            width:
                                                                                260,
                                                                            child:
                                                                                ListView(
                                                                              children: [
                                                                                Container(
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            width: 110,
                                                                                            child: Text(
                                                                                              "Nama  ",
                                                                                              style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            ": " + NamaPeminjamSekarang,
                                                                                            style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            width: 110,
                                                                                            child: Text(
                                                                                              "No Telpon",
                                                                                              style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            ": " + NoTelponPeminjamSekarang,
                                                                                            style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            width: 110,
                                                                                            child: Text(
                                                                                              "Barang",
                                                                                              style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            ": ",
                                                                                            style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                          ),
                                                                                          Container(
                                                                                            width: 140,
                                                                                            child: SingleChildScrollView(
                                                                                              scrollDirection: Axis.horizontal,
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  Text(
                                                                                                    BarangYangDikembalikan[0].toString(),
                                                                                                    style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                                    textAlign: TextAlign.start,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            width: 110,
                                                                                            child: Text(
                                                                                              isBarangBerkodeYangAkanDikembalikan ? "Kode" : "Jumlah",
                                                                                              style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            ": ${kodeAtauJumlahBarangYangDikembalikan}",
                                                                                            style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),

                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      color: Color.fromARGB(255, 255, 255, 255),
                                                                                    ),
                                                                                    height: 40,
                                                                                    width: 135,
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        "BATAL",
                                                                                        style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10)),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              //kembalikan barang
                                                                              NamaPeminjamSekarang == "Tidak Terdeteksi"
                                                                                  ? GestureDetector(
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          color: Color.fromARGB(255, 255, 255, 255),
                                                                                        ),
                                                                                        height: 40,
                                                                                        width: 135,
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            "KEMBALIKAN",
                                                                                            style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10)),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  : GestureDetector(
                                                                                      onTap: () async {
                                                                                        setState(() {
                                                                                          loading = true;
                                                                                          Navigator.pop(context);
                                                                                        });

                                                                                        //mengurangi data jumlah yang terpakai pada database barang
                                                                                        if (isBarangBerkodeYangAkanDikembalikan) {
                                                                                          //proses mengatur jumlah terpakai agar berkurang untyuk barang berkode
                                                                                          int nilaiJumlahTerpakaiSekarang = 0;
                                                                                          await FirebaseFirestore.instance.collection("Barang").doc(docBarangYangDipinjamSekarang).get().then((value) => nilaiJumlahTerpakaiSekarang = value["JumlahTerpakai"]);
                                                                                          await FirebaseFirestore.instance.collection("Barang").doc(docBarangYangDipinjamSekarang).update({
                                                                                            "JumlahTerpakai": nilaiJumlahTerpakaiSekarang - 1
                                                                                          });
                                                                                          print("Mengurangi barang terpakai berhasil");
                                                                                        } else {
                                                                                          //proses mengatur jumlah terpakai agar berkurang untyuk barang tidak berkode
                                                                                          int nilaiJumlahTerpakaiSekarang = 0;
                                                                                          int jumlahPinjamanUser = 0;
                                                                                          await FirebaseFirestore.instance.collection("Barang").doc(docBarangYangDipinjamSekarang).get().then((value) => nilaiJumlahTerpakaiSekarang = value["JumlahTerpakai"]);
                                                                                          await FirebaseFirestore.instance.collection("User").doc(DocPeminjamSekarang).collection("BarangBarang").doc(idBarangYangDikembalikan).get().then((value) => jumlahPinjamanUser = int.parse(value["JumlahatauKodeBarang"].toString()));
                                                                                          print(jumlahPinjamanUser.toString() + " - " + kodeAtauJumlahBarangYangDikembalikan.toString() + "");
                                                                                          print("fffff :" + idBarangYangDikembalikan);
                                                                                          if (jumlahPinjamanUser >= int.parse(kodeAtauJumlahBarangYangDikembalikan.toString())) {
                                                                                            //mengurangi jumlah terpakai di database BARANG
                                                                                            await FirebaseFirestore.instance.collection("Barang").doc(docBarangYangDipinjamSekarang).update({
                                                                                              "JumlahTerpakai": nilaiJumlahTerpakaiSekarang - int.parse(kodeAtauJumlahBarangYangDikembalikan.toString())
                                                                                            });

                                                                                            //mengurangi jumlahataukodebarang di database USER
                                                                                            await FirebaseFirestore.instance.collection("User").doc(DocPeminjamSekarang).collection("BarangBarang").doc(idBarangYangDikembalikan).update({
                                                                                              "JumlahatauKodeBarang": jumlahPinjamanUser - int.parse(kodeAtauJumlahBarangYangDikembalikan.toString())
                                                                                            });
                                                                                            peminjamanGagalKarenaJumlahYangDiKembalikanKebanyakan = true; // KODE TIDAK EFISIEN
                                                                                            print("Mengurangi barang terpakai berhasil");

                                                                                            //menghapus field barang di BarangBarang ketika kodeataujumlahpinjaman == 0
                                                                                            await FirebaseFirestore.instance.collection("User").doc(DocPeminjamSekarang).collection("BarangBarang").doc(idBarangYangDikembalikan).get().then((value) => jumlahPinjamanUser = int.parse(value["JumlahatauKodeBarang"].toString()));

                                                                                            if (jumlahPinjamanUser == 0) {
                                                                                              peminjamanGagalKarenaJumlahYangDiKembalikanKebanyakan = false;
                                                                                            }
                                                                                          } else {
                                                                                            //snackbar barang yang dikembalikan berlebih dari yang dipinjam

                                                                                            peminjamanGagalKarenaJumlahYangDiKembalikanKebanyakan = true;
                                                                                            munculPopUpPengembalianKebanyakan = true;
                                                                                            print("Pengembalian Gagal Dek");
                                                                                            print("doc peminjam : " + DocPeminjamSekarang);
                                                                                            print("id barang peminjam : " + idBarangYangDikembalikan);
                                                                                          }
                                                                                        }

                                                                                        print(peminjamanGagalKarenaJumlahYangDiKembalikanKebanyakan);

                                                                                        if (peminjamanGagalKarenaJumlahYangDiKembalikanKebanyakan == false) {
                                                                                          //penghapusan data di database user
                                                                                          await FirebaseFirestore.instance.collection("User").doc(DocPeminjamSekarang).collection("BarangBarang").doc(idBarangYangDikembalikan).delete();
                                                                                          print("hapus data barang berhasil");

                                                                                          //penghapussan data peminjam ketika barang sudah tidak tersisa
                                                                                          if (BanyakBarangDipinjamUser == 1) {
                                                                                            await FirebaseFirestore.instance.collection("User").doc(DocPeminjamSekarang).delete();
                                                                                            print("hapus data user berhasil");
                                                                                          }

                                                                                          //mengubah data barang berkode menjadi False( non aktif)
                                                                                          if (isBarangBerkodeYangAkanDikembalikan) {
                                                                                            await FirebaseFirestore.instance.collection("Barang").doc(docBarangYangDipinjamSekarang).collection("BarangBarang").doc(KodeAtauJumlahYangDikembalikan[0].toString()).update({
                                                                                              "Status": false
                                                                                            });
                                                                                            print("Mengubah status barang berhasil");
                                                                                          }
                                                                                        }

                                                                                        if (!munculPopUpPengembalianKebanyakan) {
                                                                                          //REPORT
                                                                                          print("JUmlah barang yang di kembalikan : " + KodeAtauJumlahYangDikembalikan[0].toString());
                                                                                          if (isBarangBerkodeYangAkanDikembalikan) {
                                                                                            await DatabaseServie().ReportPengembalian(NamaPeminjamSekarang, BarangYangDikembalikan[0], KodeAtauJumlahYangDikembalikan[0].toString());
                                                                                          } else {
                                                                                            await DatabaseServie().ReportPengembalian(NamaPeminjamSekarang, BarangYangDikembalikan[0], KodeAtauJumlahYangDikembalikan[0].toString());
                                                                                          }
                                                                                          print("Report berhasil didata");
                                                                                        }

                                                                                        //kembalikan menjadi normal
                                                                                        HapusDataKembalikanBarang();
                                                                                        setState(() {
                                                                                          loading = false;
                                                                                          peminjamanGagalKarenaJumlahYangDiKembalikanKebanyakan = false;
                                                                                        });
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          color: Color.fromARGB(255, 250, 208, 7),
                                                                                        ),
                                                                                        height: 40,
                                                                                        width: 135,
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            "KEMBALIKAN",
                                                                                            style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10)),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Color.fromARGB(
                                                            255, 250, 208, 7),
                                                      ),
                                                      height: 62,
                                                      width: 161,
                                                      child: Center(
                                                        child: Text(
                                                          "KEMBALIKAN",
                                                          style: GoogleFonts
                                                              .beVietnamPro(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          7,
                                                                          7,
                                                                          10)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        :
                                        //KONDISI KETIKA BELUM ADA BARANG YANG DIKEMBALIKAN
                                        Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Pilih Barang",
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),

                                              // BUTTON PILIH BARANG
                                              GestureDetector(
                                                onTap: () async {
                                                  await getBarang();
                                                  showDialog(
                                                      barrierColor:
                                                          Color.fromARGB(
                                                              141, 7, 7, 7),
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return SimpleDialog(
                                                            insetPadding:
                                                                EdgeInsets.only(
                                                                    top: 80),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    0,
                                                                    39,
                                                                    39,
                                                                    41),
                                                            children: [
                                                              //===================================================================================================Pop up Milih Item yang dipinjam
                                                              SingleChildScrollView(
                                                                  child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              25),
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              39,
                                                                              39,
                                                                              41),
                                                                          border: Border.all(
                                                                              width:
                                                                                  4,
                                                                              color: Color.fromARGB(255, 71, 71,
                                                                                  75))),
                                                                      height:
                                                                          735,
                                                                      width:
                                                                          1450,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            20),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              //baris 1
                                                                              for (int j = 0; j < KumpulanNama.length; j += 10)
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(bottom: 10),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      for (int i = j; i < j + 10 && i < KumpulanNama.length; i++)
                                                                                        Container(
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Container(
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    if (KumpulanKode[i]) ...[
                                                                                                      GestureDetector(
                                                                                                        onTap: () async {
                                                                                                          await getBarangBerkode(KumpilanId[i]);
                                                                                                          showDialog(
                                                                                                              barrierColor: Color.fromARGB(141, 7, 7, 7),
                                                                                                              context: context,
                                                                                                              builder: (BuildContext context) {
                                                                                                                return SimpleDialog(
                                                                                                                  insetPadding: EdgeInsets.only(top: 80),
                                                                                                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                                                                                                  backgroundColor: Color.fromARGB(0, 39, 39, 41),
                                                                                                                  children: [
                                                                                                                    Center(
                                                                                                                      child:

                                                                                                                          ///pop up Barang berkode
                                                                                                                          Container(
                                                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Color.fromARGB(255, 39, 39, 41), border: Border.all(width: 4, color: Color.fromARGB(255, 71, 71, 75))),
                                                                                                                        height: 469,
                                                                                                                        width: 579,
                                                                                                                        child: Padding(
                                                                                                                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                                                                                          child: Column(
                                                                                                                            children: [
                                                                                                                              Container(
                                                                                                                                decoration: BoxDecoration(
                                                                                                                                  image: DecorationImage(image: NetworkImage(KumpulanUrlImage[i].toString()), fit: BoxFit.contain),
                                                                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                                                                ),
                                                                                                                                height: 59,
                                                                                                                                width: 80,
                                                                                                                              ),
                                                                                                                              SizedBox(
                                                                                                                                height: 5,
                                                                                                                              ),
                                                                                                                              Text(
                                                                                                                                KumpulanNama[i],
                                                                                                                                style: GoogleFonts.beVietnamPro(
                                                                                                                                  fontWeight: FontWeight.bold,
                                                                                                                                  fontSize: 15,
                                                                                                                                  color: Colors.white,
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              SizedBox(
                                                                                                                                height: 10,
                                                                                                                              ),
                                                                                                                              Container(
                                                                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color.fromARGB(255, 71, 71, 75)),
                                                                                                                                width: 251,
                                                                                                                                height: 51,
                                                                                                                                child: Center(
                                                                                                                                  child: Text(" Jumlah Barang Saat Ini = " + KumpilanTotalJumlahBarang[i].toString(), style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              SizedBox(
                                                                                                                                height: 20,
                                                                                                                              ),
                                                                                                                              Container(
                                                                                                                                height: 230,
                                                                                                                                child: ListView(
                                                                                                                                  children: [
                                                                                                                                    for (int a = 0; a < KumpilanBarangBerkode.length; a++)
                                                                                                                                      Column(
                                                                                                                                        children: [
                                                                                                                                          Row(
                                                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                            children: [
                                                                                                                                              Container(
                                                                                                                                                width: 200,
                                                                                                                                                child: Row(
                                                                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                                  children: [
                                                                                                                                                    Text(
                                                                                                                                                      KumpilanBarangBerkode[a],
                                                                                                                                                      style: GoogleFonts.beVietnamPro(
                                                                                                                                                        fontWeight: FontWeight.bold,
                                                                                                                                                        fontSize: 15,
                                                                                                                                                        color: Colors.white,
                                                                                                                                                      ),
                                                                                                                                                    ),
                                                                                                                                                    Container(
                                                                                                                                                      width: 100,
                                                                                                                                                      child: Text(KumpulanStatusBerkode[a] ? "Aktif" : "Non Aktif",
                                                                                                                                                          style: GoogleFonts.beVietnamPro(
                                                                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                                                            fontSize: 15,
                                                                                                                                                            color: Colors.white,
                                                                                                                                                          ),
                                                                                                                                                          textAlign: TextAlign.center),
                                                                                                                                                    ),
                                                                                                                                                  ],
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                              GestureDetector(  
                                                                                                                                                onTap: () async {
                                                                                                                                                  print("tertekan");
                                                                                                                                                  if (KumpulanStatusBerkode[a]) {
                                                                                                                                                    print("kumpulkalafljasjdflkas ejflksjf lkshejfaslkfj");
                                                                                                                                                    BarangYangDikembalikan.add(KumpulanNama[i]);
                                                                                                                                                    BarangBerkode.add(KumpulanKode[i]);
                                                                                                                                                    KodeAtauJumlahYangDikembalikan.add(KumpilanBarangBerkode[a].toString());
                                                                                                                                                    BarangYangRusak.add(0.toString());
                                                                                                                                                    isBarangBerkodeYangAkanDikembalikan = KumpulanKode[i];

                                                                                                                                                    docBarangYangDipinjamSekarang = KumpilanId[i].toString();
                                                                                                                                                    //function untuk membaca nama barang berkode yang dipilih (akan dikembalikan oleh user)
                                                                                                                                                    int looping = 0;
                                                                                                                                                    await FirebaseFirestore.instance.collection("Barang").doc( KumpilanId[i].toString()).collection("BarangBarang").get().then((QuerySnapshot value) {
                                                                                                                                                      value.docs.forEach((element) {
                                                                                                                                                        if (looping == a) {
                                                                                                                                                          kodeAtauJumlahBarangYangDikembalikan = element["Kode"];
                                                                                                                                                        }

                                                                                                                                                        looping++;
                                                                                                                                                      });
                                                                                                                                                    });

                                                                                                                                                    print("isi kode : " + kodeAtauJumlahBarangYangDikembalikan);

                                                                                                                                                    Navigator.pop(context);
                                                                                                                                                    Navigator.pop(context);
                                                                                                                                                    setState(() {});
                                                                                                                                                  }
                                                                                                                                                },
                                                                                                                                                child: Container(
                                                                                                                                                  decoration: BoxDecoration(
                                                                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                                                                    color: KumpulanStatusBerkode[a] ? Color.fromARGB(255, 250, 208, 7) : Color.fromARGB(255, 71, 71, 75),
                                                                                                                                                  ),
                                                                                                                                                  width: 145,
                                                                                                                                                  height: 35,
                                                                                                                                                  child: Center(
                                                                                                                                                    child: Text("KEMBALIKAN", style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10))),
                                                                                                                                                  ),
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            ],
                                                                                                                                          ),
                                                                                                                                          SizedBox(
                                                                                                                                            height: 10,
                                                                                                                                          ),
                                                                                                                                          Container(
                                                                                                                                            width: 525,
                                                                                                                                            height: 4,
                                                                                                                                            color: const Color.fromARGB(255, 71, 71, 75),
                                                                                                                                          ),
                                                                                                                                          SizedBox(
                                                                                                                                            height: 20,
                                                                                                                                          ),
                                                                                                                                        ],
                                                                                                                                      ),
                                                                                                                                  ],
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    )
                                                                                                                  ],
                                                                                                                );
                                                                                                              });
                                                                                                        },
                                                                                                        child:

                                                                                                            //icon barang berkode
                                                                                                            Container(
                                                                                                          width: 130,
                                                                                                          height: 135,
                                                                                                          decoration: BoxDecoration(color: Color.fromARGB(100, 71, 71, 75), borderRadius: BorderRadius.circular(20)),
                                                                                                          child: Column(
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              Container(
                                                                                                                decoration: BoxDecoration(
                                                                                                                  image: DecorationImage(image: NetworkImage(KumpulanUrlImage[i].toString()), fit: BoxFit.contain),
                                                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                                                ),
                                                                                                                height: 70,
                                                                                                                width: 90,
                                                                                                              ),
                                                                                                              Text(
                                                                                                                KumpulanNama[i],
                                                                                                                style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
                                                                                                                textAlign: TextAlign.center,
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      )
                                                                                                    ] else ...[
                                                                                                      //pinjam Barang Tidak berkode 
                                                                                                      GestureDetector(
                                                                                                        onTap: () {
                                                                                                          showDialog(
                                                                                                              barrierColor: Color.fromARGB(141, 7, 7, 7),
                                                                                                              context: context,
                                                                                                              builder: (BuildContext context) {
                                                                                                                return SimpleDialog(
                                                                                                                  insetPadding: EdgeInsets.only(top: 80),
                                                                                                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                                                                                                  backgroundColor: Color.fromARGB(0, 39, 39, 41),
                                                                                                                  children: [
                                                                                                                    Center(
                                                                                                                      child: Container(
                                                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Color.fromARGB(255, 39, 39, 41), border: Border.all(width: 4, color: Color.fromARGB(255, 71, 71, 75))),
                                                                                                                        height: 515,
                                                                                                                        width: 567,
                                                                                                                        child: Padding(
                                                                                                                          padding: EdgeInsets.symmetric(horizontal: 94, vertical: 87),
                                                                                                                          child: Column(
                                                                                                                            children: [
                                                                                                                              Container(
                                                                                                                                decoration: BoxDecoration(
                                                                                                                                  image: DecorationImage(image: NetworkImage(KumpulanUrlImage[i].toString()), fit: BoxFit.contain),
                                                                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                                                                ),
                                                                                                                                height: 59,
                                                                                                                                width: 80,
                                                                                                                              ),
                                                                                                                              SizedBox(
                                                                                                                                height: 5,
                                                                                                                              ),
                                                                                                                              Text(
                                                                                                                                KumpulanNama[i],
                                                                                                                                style: GoogleFonts.beVietnamPro(
                                                                                                                                  fontWeight: FontWeight.bold,
                                                                                                                                  fontSize: 15,
                                                                                                                                  color: Colors.white,
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              SizedBox(
                                                                                                                                height: 10,
                                                                                                                              ),
                                                                                                                              Container(
                                                                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color.fromARGB(255, 71, 71, 75)),
                                                                                                                                width: 251,
                                                                                                                                height: 51,
                                                                                                                                child: Center(
                                                                                                                                  child: Text(" Jumlah Barang Saat Ini = " + (KumpilanTotalJumlahBarang[i] - KumpulanBarangTerpakai[i]).toString(), style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              SizedBox(
                                                                                                                                height: 10,
                                                                                                                              ),
                                                                                                                              Row(
                                                                                                                                children: [
                                                                                                                                  Text("Jumlah Yang Dikembalikan", style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
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
                                                                                                                                    controller: JumlahYangDikembalikanController,
                                                                                                                                    decoration: InputDecoration(
                                                                                                                                      border: InputBorder.none,
                                                                                                                                      hintText: " Masukkan Jumlah Yang Dikembalikan",
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
                                                                                                                              SizedBox(
                                                                                                                                height: 16,
                                                                                                                              ),
                                                                                                                              GestureDetector(
                                                                                                                                onTap: () async {
                                                                                                                                  BarangYangDikembalikan.add(KumpulanNama[i]);
                                                                                                                                  BarangBerkode.add(KumpulanKode[i]);
                                                                                                                                  KodeAtauJumlahYangDikembalikan.add(JumlahYangDikembalikanController.text);
                                                                                                                                  isBarangBerkodeYangAkanDikembalikan = KumpulanKode[i];
                                                                                                                                  kodeAtauJumlahBarangYangDikembalikan = JumlahYangDikembalikanController.text;

                                                                                                                                  docBarangYangDipinjamSekarang = KumpilanId[i].toString();
                                                                                                                                  Navigator.pop(context);
                                                                                                                                  Navigator.pop(context);
                                                                                                                                  setState(() {});
                                                                                                                                },
                                                                                                                                child: Container(
                                                                                                                                  decoration: BoxDecoration(
                                                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                                                    color: Color.fromARGB(255, 250, 208, 7),
                                                                                                                                  ),
                                                                                                                                  height: 60,
                                                                                                                                  width: 200,
                                                                                                                                  child: Center(
                                                                                                                                    child: Text(
                                                                                                                                      "KEMBALIKAN",
                                                                                                                                      style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10)),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    )
                                                                                                                  ],
                                                                                                                );
                                                                                                              });
                                                                                                        },
                                                                                                        child:
                                                                                                            //icon barang tidak berkode
                                                                                                            Container(
                                                                                                          width: 130,
                                                                                                          height: 135,
                                                                                                          decoration: BoxDecoration(color: Color.fromARGB(100, 71, 71, 75), borderRadius: BorderRadius.circular(20)),
                                                                                                          child: Column(
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              Container(
                                                                                                                decoration: BoxDecoration(
                                                                                                                  image: DecorationImage(image: NetworkImage(KumpulanUrlImage[i].toString()), fit: BoxFit.contain),
                                                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                                                ),
                                                                                                                height: 70,
                                                                                                                width: 90,
                                                                                                              ),
                                                                                                              Text(
                                                                                                                KumpulanNama[i],
                                                                                                                style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
                                                                                                                textAlign: TextAlign.center,
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      )
                                                                                                    ]
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 10,
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                ],
                                                              ))
                                                            ]);
                                                      });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                  ),
                                                  height: 63,
                                                  width: 378,
                                                  child: Center(
                                                    child: Text(
                                                      "Tekan Untuk Pilih",
                                                      style: GoogleFonts
                                                          .beVietnamPro(
                                                        fontSize: 15,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
        )
      ],
    );
  }
}
