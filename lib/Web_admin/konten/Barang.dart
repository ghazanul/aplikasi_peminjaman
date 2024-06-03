// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, unused_import

import 'dart:html';

import 'package:aplikasi_peminjaman/databse/database_servis.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Barang extends StatefulWidget {
  const Barang({super.key});

  @override
  State<Barang> createState() => _Home_WebState();
}

class _Home_WebState extends State<Barang> {
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
  List<bool> KumpulanSekaliPakai = [];
  List<bool> KumpulanSatuanMeter = [];

  refreshData() {
    KumpulanNama.clear();
    KumpulanKode.clear();
    KumpulanUrlImage.clear();
    KumpilanId.clear();
    KumpilanTotalJumlahBarang.clear();
    KumpilanBarangBerkode.clear();
    KumpulanSekaliPakai.clear();
    KumpulanSatuanMeter.clear();
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
        KumpulanSekaliPakai.add(element["SekaliPakai"]);
        KumpulanSatuanMeter.add(element["SatuanMeter"]);
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

  EditBarangTidakBerkode(int id, int JumlahBarang) async {
    await DatabaseServie().EditBarangTidakBerkode(id, JumlahBarang);
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
                                                  if (KumpulanKode[i]) ...[
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await getBarangBerkode(
                                                            KumpilanId[i]);
                                                        showDialog(
                                                            barrierColor:
                                                                Color.fromARGB(
                                                                    141,
                                                                    7,
                                                                    7,
                                                                    7),
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return SimpleDialog(
                                                                insetPadding:
                                                                    EdgeInsets.only(
                                                                        top:
                                                                            80),
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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

                                                                        ///pop up Barang berkode
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
                                                                              width: 4,
                                                                              color: Color.fromARGB(255, 71, 71, 75))),
                                                                      height:
                                                                          469,
                                                                      width:
                                                                          579,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                30,
                                                                            horizontal:
                                                                                20),
                                                                        child:
                                                                            Column(
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
                                                                                                              width: 375,
                                                                                                              height: 251,
                                                                                                              child: Padding(
                                                                                                                padding: const EdgeInsets.symmetric(
                                                                                                                  vertical: 60,
                                                                                                                ),
                                                                                                                child: Column(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                  children: [
                                                                                                                    //icon

                                                                                                                    Text(
                                                                                                                      "Apakah yakin Ingin Menghapus \n Barang Ini?",
                                                                                                                      style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                                                      textAlign: TextAlign.center,
                                                                                                                    ),

                                                                                                                    SizedBox(
                                                                                                                      height: 35,
                                                                                                                    ),
                                                                                                                    Column(
                                                                                                                      children: [
                                                                                                                        GestureDetector(
                                                                                                                          onTap: () async {
                                                                                                                            await EditBarangTidakBerkode(KumpilanId[i], int.parse(DataBarang.text));
                                                                                                                            //untuk membalikannya seperti semula
                                                                                                                            DataBarang.text = '';
                                                                                                                            Navigator.pop(context);
                                                                                                                            refreshData();
                                                                                                                            setState(() {});
                                                                                                                          },
                                                                                                                          child: Row(
                                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                            children: [
                                                                                                                              GestureDetector(
                                                                                                                                onTap: () {
                                                                                                                                  Navigator.pop(context); //untuk kembali ke layer sebelumnya
                                                                                                                                },
                                                                                                                                child: Container(
                                                                                                                                  decoration: BoxDecoration(
                                                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                                                    color: Color.fromARGB(255, 255, 255, 255),
                                                                                                                                  ),
                                                                                                                                  height: 44,
                                                                                                                                  width: 126,
                                                                                                                                  child: Center(
                                                                                                                                    child: Text(
                                                                                                                                      "BATAL",
                                                                                                                                      style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10)),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              SizedBox(
                                                                                                                                width: 10,
                                                                                                                              ),
                                                                                                                              GestureDetector(
                                                                                                                                onTap: () async {
                                                                                                                                  Navigator.pop(context);
                                                                                                                                  Navigator.pop(context);
                                                                                                                                  await HapusbarangBerkode(KumpilanId[i], KumpilanBarangBerkode[a].toString());
                                                                                                                                  refreshData();
                                                                                                                                  setState(() {});
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
                                                                                                                                      "HAPUS",
                                                                                                                                      style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10)),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ],
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
                                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                                  color: Color.fromARGB(255, 250, 208, 7),
                                                                                                ),
                                                                                                width: 92,
                                                                                                height: 29,
                                                                                                child: Center(
                                                                                                  child: Text("HAPUS", style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10))),
                                                                                                ),
                                                                                              ),
                                                                                            )
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
                                                      //icon barang berkode
                                                      child: Container(
                                                        width: 130,
                                                        height: 135,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    100,
                                                                    71,
                                                                    71,
                                                                    75),
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
                                                                        KumpulanUrlImage[i]
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ] else ...[
                                                    //Hapus Barang Tidak berkode
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                            barrierColor:
                                                                Color.fromARGB(
                                                                    141,
                                                                    7,
                                                                    7,
                                                                    7),
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return SimpleDialog(
                                                                insetPadding:
                                                                    EdgeInsets.only(
                                                                        top:
                                                                            80),
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                                          borderRadius: BorderRadius.circular(
                                                                              25),
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              39,
                                                                              39,
                                                                              41),
                                                                          border: Border.all(
                                                                              width: 4,
                                                                              color: Color.fromARGB(255, 71, 71, 75))),
                                                                      height:
                                                                          515,
                                                                      width:
                                                                          567,
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                95,
                                                                            vertical:
                                                                                78),
                                                                        child:
                                                                            Column(
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
                                                                            KumpulanSekaliPakai[i]
                                                                                //untuk barang tidak berkode  (sekali pakai)
                                                                                ? Container(
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color.fromARGB(255, 71, 71, 75)),
                                                                                    width: 270,
                                                                                    height: 51,
                                                                                    child: Center(
                                                                                      child: KumpulanSatuanMeter[i] ? Text(" Panjang Barang Tersisa = " + (KumpilanTotalJumlahBarang[i].toString() + " M"), style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)) : Text(" Jumlah Barang Saat ini = " + (KumpilanTotalJumlahBarang[i].toString()), style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
                                                                                    ),
                                                                                  )

                                                                                ///untuk barang tidak berkode tidak sekali pakai
                                                                                : Container(
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color.fromARGB(255, 71, 71, 75)),
                                                                                    width: 251,
                                                                                    height: 51,
                                                                                    child: Center(
                                                                                      child: Text(" Jumlah Barang Saat Ini = " + (KumpilanTotalJumlahBarang[i].toString()), style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
                                                                                    ),
                                                                                  ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text("Masukkan Jumlah", style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                color: Colors.white,
                                                                              ),
                                                                              height: 63,
                                                                              width: 378,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: TextField(
                                                                                  controller: JumlahyangDiHapus,
                                                                                  decoration: InputDecoration(
                                                                                    border: InputBorder.none,
                                                                                    hintText: "Masukkan Jumlah Yang Ingin Di hapus",
                                                                                    hintStyle: TextStyle(
                                                                                      fontWeight: FontWeight.w100,
                                                                                    ),
                                                                                  ),
                                                                                  // InputDecoration(border: InputBorder.none),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 16,
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () async {
                                                                                await HapusBarangTidakBerkode(KumpilanId[i], int.parse(JumlahyangDiHapus.text));
                                                                                Navigator.pop(context);
                                                                                JumlahyangDiHapus.text = '';
                                                                                refreshData();
                                                                                setState(() {});
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  color: Color.fromARGB(255, 250, 208, 7),
                                                                                ),
                                                                                height: 52,
                                                                                width: 200,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "HAPUS",
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
                                                      //icon Barang tidak berkode
                                                      child: Container(
                                                        width: 130,
                                                        height: 135,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    100,
                                                                    71,
                                                                    71,
                                                                    75),
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
                                                                        KumpulanUrlImage[i]
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
