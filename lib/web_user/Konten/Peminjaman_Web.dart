// ignore_for_file: prefer_const_constructors, camel_case_types, use_build_context_synchronously, avoid_unnecessary_containers, avoid_print, sized_box_for_whitespace, curly_braces_in_flow_control_structures

import 'package:aplikasi_peminjaman/databse/database_servis.dart';

import 'package:aplikasi_peminjaman/web_user/Konten/Pengembalian%20Web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Peminjaman_Web extends StatefulWidget {
  const Peminjaman_Web({super.key});

  @override
  State<Peminjaman_Web> createState() => _Peminjaman_WebState();
}

List<String> KumpulanNama = [];
List<bool> KumpulanKode = [];
List<String> KumpulanUrlImage = [];
List<int> KumpilanId = [];
List<int> KumpulanBarangTerpakai = [];

List<int> KumpilanTotalJumlahBarang = [];
List<String> KumpilanBarangBerkode = [];
List<bool> KumpulanStatusBerkode = [];
List<String> BarangYangDipinjam = [];
List<String> KodeAtauJumlahYangDipinjam = [];
List<bool> BarangBerkode = [];
List<int> idBarangYangDiPinjam = [];
List<bool> KumpulanSekaliPakaiDiPinjam = [];
List<bool> KumpulanSekaliPakai = [];
List<bool> KumpulanSatuanMeter = [];
List<bool> KumpulanSatuanMeterYangDipinjam = [];

bool loading = false;

HapusDataPeminjmanBarang(int index) {
  BarangYangDipinjam.removeAt(index);
  KodeAtauJumlahYangDipinjam.removeAt(index);
  BarangBerkode.removeAt(index);
}

refreshData() {
  KumpulanNama.clear();
  KumpulanKode.clear();
  KumpulanUrlImage.clear();
  KumpilanId.clear();
  KumpilanTotalJumlahBarang.clear();
  KumpilanBarangBerkode.clear();
  KumpulanBarangTerpakai.clear();
  KumpulanSekaliPakai.clear();
  KumpulanSatuanMeter.clear();
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

class _Peminjaman_WebState extends State<Peminjaman_Web> {
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
        KumpulanBarangTerpakai.add(element['JumlahTerpakai']);
        KumpulanSekaliPakai.add(element["SekaliPakai"]);
        KumpulanSatuanMeter.add(element["SatuanMeter"]);
      });
    });
  }

  //mengambbil data dari text filt
  TextEditingController NamaPeminjamController = new TextEditingController();
  TextEditingController NoTelponController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextEditingController JumlahyangDipinjamController =
        new TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///SizedBox(height: MediaQuery.of(context).size.height*0.1 ),
        Center(
          child: loading
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
                          width: 4, color: Color.fromARGB(255, 71, 71, 75))),
                  height: 617,
                  width: 622,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 110,
                      horizontal: 122,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            height: 305,
                            child: ListView(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Nama Peminjam",
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
                                      controller: NamaPeminjamController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
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
                                      controller: NoTelponController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),

                                //MENGECEK JUMLAH BARANG
                                (BarangYangDipinjam.length != 0)
                                    ?
                                    //MUNCUL KETIKA BARANG TELAH DI PINJMAN
                                    Column(
                                        children: [
                                          for (int x = 0;
                                              x < BarangYangDipinjam.length;
                                              x++)
                                            BarangBerkode[x]
                                                ?
                                                //ketika barang berkode (TIDAK MEMILIKI JUMLAH)
                                                Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
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
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
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
                                                              width: 328,
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
                                                                        BarangYangDipinjam[x] +
                                                                            " - " +
                                                                            KodeAtauJumlahYangDipinjam[x],
                                                                        style: GoogleFonts.beVietnamPro(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
                                                          GestureDetector(
                                                            onTap: () {
                                                              HapusDataPeminjmanBarang(
                                                                  x);
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              height: 25,
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/minus.png",
                                                                width: 31,
                                                                height: 5,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                :
                                                //ketika barang tidak berkode (MEMILIKI JUMLAH)
                                                Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
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
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
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
                                                              width: 223,
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
                                                                        BarangYangDipinjam[
                                                                            x],
                                                                        style: GoogleFonts.beVietnamPro(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
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
                                                              width: 88,
                                                              child: Center(
                                                                child: Text(
                                                                  KodeAtauJumlahYangDipinjam[
                                                                      x],
                                                                  style: GoogleFonts.beVietnamPro(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              )),
                                                          GestureDetector(
                                                            onTap: () {
                                                              HapusDataPeminjmanBarang(
                                                                  x);
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              height: 25,
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/minus.png",
                                                                width: 31,
                                                                height: 5,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),

                                          //pop up more tambah barang
                                          SizedBox(
                                            height: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  barrierColor: Color.fromARGB(
                                                      141, 7, 7, 7),
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SimpleDialog(
                                                        insetPadding:
                                                            EdgeInsets.only(
                                                                top: 80),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        0),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                0, 39, 39, 41),
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
                                                                  height: 735,
                                                                  width: 1450,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            20),
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          //baris 1
                                                                          for (int j = 0;
                                                                              j < KumpulanNama.length;
                                                                              j += 10)
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
                                                                                                                              child: Text(" Jumlah Barang Saat Ini = " + (KumpilanTotalJumlahBarang[i] - KumpulanBarangTerpakai[i]).toString(), style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
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
                                                                                                                                              if (!KumpulanStatusBerkode[a]) {
                                                                                                                                                BarangYangDipinjam.add(KumpulanNama[i]);
                                                                                                                                                KumpulanSatuanMeterYangDipinjam.add(KumpulanSatuanMeter[i]);
                                                                                                                                                BarangBerkode.add(KumpulanKode[i]);
                                                                                                                                                if (KumpulanKode[i]) {
                                                                                                                                                  KodeAtauJumlahYangDipinjam.add(KumpilanBarangBerkode[a].toString());
                                                                                                                                                } else {
                                                                                                                                                  KodeAtauJumlahYangDipinjam.add(KumpilanTotalJumlahBarang[i].toString());
                                                                                                                                                }
                                                                                                                                                idBarangYangDiPinjam.add(KumpilanId[i]);
                                                                                                                                                KumpulanSekaliPakaiDiPinjam.add(KumpulanSekaliPakai[i]);

                                                                                                                                                print("Berhasillll dengan id " + KumpilanId[i].toString());

                                                                                                                                                Navigator.pop(context);
                                                                                                                                                Navigator.pop(context);
                                                                                                                                                setState(() {});
                                                                                                                                              }
                                                                                                                                            },
                                                                                                                                            child: Container(
                                                                                                                                              decoration: BoxDecoration(
                                                                                                                                                borderRadius: BorderRadius.circular(5),
                                                                                                                                                color: KumpulanStatusBerkode[a] ? Color.fromARGB(255, 71, 71, 75) : Color.fromARGB(255, 250, 208, 7),
                                                                                                                                              ),
                                                                                                                                              width: 100,
                                                                                                                                              height: 35,
                                                                                                                                              child: Center(
                                                                                                                                                child: Text("PINJAM", style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10))),
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
                                                                                                      color: Colors.amber,
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
                                                                                                                  child: Container(
                                                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Color.fromARGB(255, 39, 39, 41), border: Border.all(width: 4, color: Color.fromARGB(255, 71, 71, 75))),
                                                                                                                    height: 515,
                                                                                                                    width: 567,
                                                                                                                    child: Padding(
                                                                                                                      padding: EdgeInsets.symmetric(horizontal: 95, vertical: 78),
                                                                                                                      child: Container(
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
                                                                                                                            KumpulanSekaliPakai[i]
                                                                                                                                //untuk barang sekali pakai
                                                                                                                                ? Container(
                                                                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color.fromARGB(255, 71, 71, 75)),
                                                                                                                                    width: 270,
                                                                                                                                    height: 51,
                                                                                                                                    child: Center(
                                                                                                                                      child: KumpulanSatuanMeter[i] ? Text(" Panjang Barang Tersisa = " + (KumpilanTotalJumlahBarang[i].toString() + " M"), style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)) : Text(" Jumlah Barang Saat ini = " + (KumpilanTotalJumlahBarang[i].toString()), style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
                                                                                                                                    ),
                                                                                                                                  )

                                                                                                                                ///untuk barang tidak sekali pakai
                                                                                                                                : Container(
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
                                                                                                                                Text("Jumlah Yang Dipinjam", style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
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
                                                                                                                                  controller: JumlahyangDipinjamController,
                                                                                                                                  decoration: InputDecoration(
                                                                                                                                    border: InputBorder.none,
                                                                                                                                    hintText: " Masukkan Jumlah Yang Dipinjaman",
                                                                                                                                    hintStyle: TextStyle(
                                                                                                                                      fontWeight: FontWeight.w100,
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            SizedBox(
                                                                                                                              height: 16,
                                                                                                                            ),
                                                                                                                            GestureDetector(
                                                                                                                              onTap: () async {
                                                                                                                                if (!KumpulanKode[i] && int.parse(JumlahyangDipinjamController.text) > (KumpilanTotalJumlahBarang[i] - KumpulanBarangTerpakai[i])) {
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
                                                                                                                                                        "Pinjaman Gagal Jumlah Sudah \n Melempaui Ketersediaan Barang",
                                                                                                                                                        style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                                                                                        textAlign: TextAlign.center,
                                                                                                                                                      ),
                                                                                                                                                    ],
                                                                                                                                                  ),
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            )
                                                                                                                                          ],
                                                                                                                                        );
                                                                                                                                      });
                                                                                                                                } else {
                                                                                                                                  BarangYangDipinjam.add(KumpulanNama[i]);
                                                                                                                                  KumpulanSatuanMeterYangDipinjam.add(KumpulanSatuanMeter[i]);
                                                                                                                                  BarangBerkode.add(KumpulanKode[i]);
                                                                                                                                  KodeAtauJumlahYangDipinjam.add(JumlahyangDipinjamController.text);
                                                                                                                                  idBarangYangDiPinjam.add(KumpilanId[i]);
                                                                                                                                  KumpulanSekaliPakaiDiPinjam.add(KumpulanSekaliPakai[i]);

                                                                                                                                  print("Berhasillll");

                                                                                                                                  Navigator.pop(context);
                                                                                                                                  Navigator.pop(context);
                                                                                                                                  setState(() {});
                                                                                                                                }
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
                                                                                                                                    "PINJAM",
                                                                                                                                    style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10)),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ],
                                                                                                                        ),
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
                                                                                                      color: Colors.amber,
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
                                            child: Image.asset(
                                              "assets/images/more.png",
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Barang",
                                                style: GoogleFonts.beVietnamPro(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          // pop up ketuk tekan untuk pilih
                                          GestureDetector(
                                            onTap: () async {
                                              await getBarang();
                                              showDialog(
                                                  barrierColor: Color.fromARGB(
                                                      141, 7, 7, 7),
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SimpleDialog(
                                                        insetPadding:
                                                            EdgeInsets.only(
                                                                top: 80),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        0),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                0, 39, 39, 41),
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
                                                                  height: 735,
                                                                  width: 1450,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            20),
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          //baris 1
                                                                          for (int j = 0;
                                                                              j < KumpulanNama.length;
                                                                              j += 10)
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
                                                                                                                              child: Text(" Jumlah Barang Saat Ini = " + (KumpilanTotalJumlahBarang[i] - KumpulanBarangTerpakai[i]).toString(), style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
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
                                                                                                                                              if (!KumpulanStatusBerkode[a]) {
                                                                                                                                                BarangYangDipinjam.add(KumpulanNama[i]);
                                                                                                                                                KumpulanSatuanMeterYangDipinjam.add(KumpulanSatuanMeter[i]);
                                                                                                                                                BarangBerkode.add(KumpulanKode[i]);
                                                                                                                                                if (KumpulanKode[i]) {
                                                                                                                                                  KodeAtauJumlahYangDipinjam.add(KumpilanBarangBerkode[a].toString());
                                                                                                                                                } else {
                                                                                                                                                  KodeAtauJumlahYangDipinjam.add(KumpilanTotalJumlahBarang[i].toString());
                                                                                                                                                }
                                                                                                                                                idBarangYangDiPinjam.add(KumpilanId[i]);
                                                                                                                                                KumpulanSekaliPakaiDiPinjam.add(KumpulanSekaliPakai[i]);

                                                                                                                                                print("Berhasillll dengan id " + KumpilanId[i].toString());

                                                                                                                                                Navigator.pop(context);
                                                                                                                                                Navigator.pop(context);
                                                                                                                                                setState(() {});
                                                                                                                                              }
                                                                                                                                            },
                                                                                                                                            child: Container(
                                                                                                                                              decoration: BoxDecoration(
                                                                                                                                                borderRadius: BorderRadius.circular(5),
                                                                                                                                                color: KumpulanStatusBerkode[a] ? Color.fromARGB(255, 71, 71, 75) : Color.fromARGB(255, 250, 208, 7),
                                                                                                                                              ),
                                                                                                                                              width: 100,
                                                                                                                                              height: 35,
                                                                                                                                              child: Center(
                                                                                                                                                child: Text("PINJAM", style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10))),
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
                                                                                                      color: Colors.amber,
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
                                                                                                                      padding: EdgeInsets.symmetric(horizontal: 95, vertical: 78),
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
                                                                                                                          KumpulanSekaliPakai[i]
                                                                                                                              //untuk barang sekali pakai
                                                                                                                              ? Container(
                                                                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color.fromARGB(255, 71, 71, 75)),
                                                                                                                                  width: 270,
                                                                                                                                  height: 51,
                                                                                                                                  child: Center(
                                                                                                                                    child: KumpulanSatuanMeter[i] ? Text(" Panjang Barang Tersisa = " + (KumpilanTotalJumlahBarang[i].toString() + " M"), style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)) : Text(" Jumlah Barang Saat ini = " + (KumpilanTotalJumlahBarang[i].toString()), style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
                                                                                                                                  ),
                                                                                                                                )

                                                                                                                              ///untuk barang tidak sekali pakai
                                                                                                                              : Container(
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
                                                                                                                              Text("Jumlah Yang Dipinjam", style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
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
                                                                                                                                controller: JumlahyangDipinjamController,
                                                                                                                                decoration: InputDecoration(
                                                                                                                                  border: InputBorder.none,
                                                                                                                                  hintText: " Masukkan Jumlah Yang Dipinjaman",
                                                                                                                                  hintStyle: TextStyle(
                                                                                                                                    fontWeight: FontWeight.w100,
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          SizedBox(
                                                                                                                            height: 16,
                                                                                                                          ),
                                                                                                                          GestureDetector(
                                                                                                                            onTap: () async {
                                                                                                                              if (!KumpulanKode[i] && int.parse(JumlahyangDipinjamController.text) > (KumpilanTotalJumlahBarang[i] - KumpulanBarangTerpakai[i])) {
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
                                                                                                                                                      "Pinjaman Gagal Jumlah Sudah \n Melempaui Ketersediaan Barang",
                                                                                                                                                      style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                                                                                      textAlign: TextAlign.center,
                                                                                                                                                    ),
                                                                                                                                                  ],
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                          )
                                                                                                                                        ],
                                                                                                                                      );
                                                                                                                                    });
                                                                                                                              } else {
                                                                                                                                BarangYangDipinjam.add(KumpulanNama[i]);
                                                                                                                                KumpulanSatuanMeterYangDipinjam.add(KumpulanSatuanMeter[i]);
                                                                                                                                BarangBerkode.add(KumpulanKode[i]);
                                                                                                                                KodeAtauJumlahYangDipinjam.add(JumlahyangDipinjamController.text);
                                                                                                                                idBarangYangDiPinjam.add(KumpilanId[i]);
                                                                                                                                KumpulanSekaliPakaiDiPinjam.add(KumpulanSekaliPakai[i]);

                                                                                                                                print("Berhasillll");

                                                                                                                                Navigator.pop(context);
                                                                                                                                Navigator.pop(context);
                                                                                                                                setState(() {});
                                                                                                                              }
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
                                                                                                                                  "PINJAM",
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
                                                                                                      color: Colors.amber,
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
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                              ),
                                              height: 63,
                                              width: 378,
                                              child: Center(
                                                child: Text(
                                                  "Tekan Untuk Pilih",
                                                  style:
                                                      GoogleFonts.beVietnamPro(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w300,
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
                          GestureDetector(
                            onTap: () {
                              //untuk membuat upload data hanya bisa ketika semua from di isi
                              if (NamaPeminjamController.text != "" &&
                                  NoTelponController.text != "" &&
                                  BarangYangDipinjam.length != 0)
                                showDialog(
                                    barrierColor: Color.fromARGB(141, 7, 7, 7),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                        insetPadding: EdgeInsets.only(top: 80),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        backgroundColor:
                                            Color.fromARGB(0, 39, 39, 41),
                                        children: [
                                          Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Color.fromARGB(
                                                      255, 39, 39, 41),
                                                  border: Border.all(
                                                      width: 4,
                                                      color: Color.fromARGB(
                                                          255, 71, 71, 75))),
                                              width: 430,
                                              height: 325,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 60,
                                                        horizontal: 73),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    //Data Peminjam
                                                    Text(
                                                      "Peminjaman TI",
                                                      style: GoogleFonts
                                                          .beVietnamPro(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),

                                                    SizedBox(
                                                      height: 20,
                                                    ),

                                                    Container(
                                                      width: 260,
                                                      height: 75,
                                                      child: ListView(
                                                        children: [
                                                          Container(
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 85,
                                                                      child:
                                                                          Text(
                                                                        "Nama  ",
                                                                        style: GoogleFonts.beVietnamPro(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white),
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ": " +
                                                                          NamaPeminjamController
                                                                              .text,
                                                                      style: GoogleFonts.beVietnamPro(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 85,
                                                                      child:
                                                                          Text(
                                                                        "No Telpon",
                                                                        style: GoogleFonts.beVietnamPro(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white),
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ": " +
                                                                          NoTelponController
                                                                              .text,
                                                                      style: GoogleFonts.beVietnamPro(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                    ),
                                                                  ],
                                                                ),
                                                                for (int i = 0;
                                                                    i <
                                                                        BarangYangDipinjam
                                                                            .length;
                                                                    i++)
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            85,
                                                                        child:
                                                                            Text(
                                                                          "Barang",
                                                                          style: GoogleFonts.beVietnamPro(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white),
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        ": ",
                                                                        style: GoogleFonts.beVietnamPro(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white),
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            165,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                BarangYangDipinjam[i] + " - " + KodeAtauJumlahYangDipinjam[i],
                                                                                style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                textAlign: TextAlign.start,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
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
                                                      height: 20,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                            ),
                                                            height: 40,
                                                            width: 135,
                                                            child: Center(
                                                              child: Text(
                                                                "BATAL",
                                                                style: GoogleFonts.beVietnamPro(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: const Color
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
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            for (int y = 0;
                                                                y <
                                                                    BarangYangDipinjam
                                                                        .length;
                                                                y++) {
                                                              if (BarangBerkode[
                                                                  y]) {
                                                                //peminjaman barang berkode
                                                                await DatabaseServie().PinjambarangBerkode(
                                                                    idBarangYangDiPinjam[
                                                                        y],
                                                                    KodeAtauJumlahYangDipinjam[
                                                                            y]
                                                                        .toString());
                                                                print(
                                                                    "peminjaman berhasil");
                                                              } else {
                                                                //peminjaman barang tidak berkode
                                                                await DatabaseServie().PinjambarangTidakBerkode(
                                                                    idBarangYangDiPinjam[
                                                                        y],
                                                                    int.parse(
                                                                        KodeAtauJumlahYangDipinjam[
                                                                            y]));
                                                                print(
                                                                    "peminjaman berhasil");
                                                              }
                                                            }

                                                            String
                                                                NamapeminjamYangDigunkan =
                                                                NamaPeminjamController
                                                                    .text
                                                                    .toLowerCase();
                                                            print(
                                                                NamapeminjamYangDigunkan);
                                                            //Memasukkan data ke database user
                                                            await DatabaseServie().DataPeminjam(
                                                                NamapeminjamYangDigunkan,
                                                                NoTelponController
                                                                    .text,
                                                                BarangYangDipinjam,
                                                                KodeAtauJumlahYangDipinjam,
                                                                KumpulanSekaliPakaiDiPinjam,
                                                                BarangBerkode);
                                                            //memasukan data ke database report
                                                            await DatabaseServie().ReportPinjam(
                                                                NamaPeminjamController
                                                                    .text,
                                                                NoTelponController
                                                                    .text,
                                                                BarangYangDipinjam,
                                                                KodeAtauJumlahYangDipinjam,
                                                                BarangBerkode,
                                                                KumpulanSatuanMeterYangDipinjam);
                                                            //ngeriset data
                                                            NamaPeminjamController
                                                                .text = "";
                                                            NoTelponController
                                                                .text = "";
                                                            KumpulanSatuanMeterYangDipinjam
                                                                .clear();
                                                            BarangYangDipinjam
                                                                .clear();
                                                            BarangBerkode
                                                                .clear();
                                                            KodeAtauJumlahYangDipinjam
                                                                .clear();
                                                            idBarangYangDiPinjam
                                                                .clear();

                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      250,
                                                                      208,
                                                                      7),
                                                            ),
                                                            height: 40,
                                                            width: 135,
                                                            child: Center(
                                                              child: Text(
                                                                "PINJAM",
                                                                style: GoogleFonts.beVietnamPro(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: const Color
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
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 250, 208, 7),
                              ),
                              height: 62,
                              width: 202,
                              child: Center(
                                child: Text(
                                  "PINJAM",
                                  style: GoogleFonts.beVietnamPro(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 7, 7, 10)),
                                ),
                              ),
                            ),
                          )
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
