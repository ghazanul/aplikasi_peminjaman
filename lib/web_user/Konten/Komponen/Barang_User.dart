// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, unused_import

import 'dart:html';

import 'package:aplikasi_peminjaman/databse/database_servis.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Barang_User extends StatefulWidget {
  const Barang_User({super.key});

  @override
  State<Barang_User> createState() => _Home_WebState();
}

class _Home_WebState extends State<Barang_User> {
  addBarang(String NamaBarang, String Gambar, bool Berkode, bool SekaliPakai,
      bool SatuanMeter) async {
    DatabaseServie()
        .addBarang(NamaBarang, Gambar, Berkode, SekaliPakai, SatuanMeter);
  }

  EditBarangBerkode(int id, String KodeBarang) async {
    DatabaseServie().EditBarangBerkode(id, KodeBarang);
  }

  CekBarangBerkodeAtauTidak(int id) async {
    DatabaseServie().CekBarangBerkodeAtauTidak(id);
  }

  HapusBarang(int id) async {
    DatabaseServie().HapusBarang(id);
  }

  HitungSisaBarang(int id) async {
    print(await DatabaseServie().HitungSisaBarang(id));
  }

  PinjamBarangTidakBerkode(int id, JumlahBarangDiPinjam) async {
    DatabaseServie().PinjambarangTidakBerkode(id, JumlahBarangDiPinjam);
  }

  PinjamBarangBerkode(int id, KodeBarang) async {
    DatabaseServie().PinjambarangBerkode(id, KodeBarang);
  }

  KembalikanBarangBerkode(int id, int KodeBarang) async {
    DatabaseServie().KembalikanBarangBerkode(id, KodeBarang);
  }

  KembalikanBarangTidakBerkode(int id, int JumlahBarangDiKemablikan) async {
    DatabaseServie().KembalikanBarangTidakBerkode(id, JumlahBarangDiKemablikan);
  }

  List<String> KumpulanNama = [];
  List<bool> KumpulanKode = [];
  List<String> KumpulanUrlImage = [];
  List<int> KumpilanId = [];
  List<int> KumpilanTotalJumlahBarang = [];
  List<String> KumpilanBarangBerkode = [];
  List<bool> KumpulanStatusBerkode = [];

  refreshData() {
    KumpulanNama.clear();
    KumpulanKode.clear();
    KumpulanUrlImage.clear();
    KumpilanId.clear();
    KumpilanTotalJumlahBarang.clear();
    KumpilanBarangBerkode.clear();
  }

  refreshDataBarangBerkode() {
    KumpilanBarangBerkode.clear();
    KumpulanStatusBerkode.clear();
  }

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
        KumpulanNama.add(element['Nama']);

        KumpulanKode.add(element['Berkode']);
        KumpulanUrlImage.add(element['Gambar']);
        KumpilanId.add(int.parse(element.id.toString()));
        KumpilanTotalJumlahBarang.add(
            int.parse(element['JumlahTotalBarang'].toString()));
      });
    });
    
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

  

  @override
  Widget build(BuildContext context) {
    //mengambbil data dari text filt
    TextEditingController Namabarang = new TextEditingController();
    TextEditingController DataBarang = new TextEditingController();
    TextEditingController JumlahyangDiHapus = new TextEditingController();

    return FutureBuilder(
        future: getBarang(),
        builder: (context, snapshot) {
          print(KumpulanNama.length);
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromARGB(163, 39, 39, 41),
                        border: Border.all(
                            width: 4, color: Color.fromARGB(255, 71, 71, 75))),
                    height: 735,
                    width: 1450,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //baris 1
                            for (int j = 0; j < KumpulanNama.length; j += 10)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (int i = j;
                                        i < j + 10 && i < KumpulanNama.length;
                                        i++)
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Column(
                                                children: [
                                                 
                                                    //icon barang
                                                    Container(
                                                      width: 130,
                                                      height: 135,
                                                      decoration: BoxDecoration(
                                                          color: Color.fromARGB(100, 71, 71, 75),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                          image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      KumpulanUrlImage[
                                                                              i]
                                                                          .toString()),
                                                                  fit: BoxFit
                                                                      .contain),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            height: 70,
                                                            width: 90,
                                                          ),
                                                          Text(
                                                            KumpulanNama[i],
                                                            style: GoogleFonts
                                                                .beVietnamPro(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  
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
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
              ],
            );
          }
        });
  }
}
