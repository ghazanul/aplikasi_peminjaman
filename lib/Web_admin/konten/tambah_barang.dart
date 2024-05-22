import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:aplikasi_peminjaman/databse/database_servis.dart';
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

class tambah_barang extends StatefulWidget {
  const tambah_barang({super.key});

  @override
  State<tambah_barang> createState() => _tambah_barangState();
}

class _tambah_barangState extends State<tambah_barang> {
  FilePickerResult? filePilihan;
  String? urlImage;
  String? EditurlImage;
  UploadTask? uploadTask;
  Reference? ref;

  UploadGambar() async {
    try {
      ref = FirebaseStorage.instance
          .ref()
          .child('gambar')
          .child('/' + filePilihan!.files.first.name);

      final metadata = SettableMetadata(contentType: 'image/jpeg');

      uploadTask = ref!.putData(filePilihan!.files.first.bytes!, metadata);

      await uploadTask!.whenComplete(() => null);

      setState(() {});
    } catch (e) {
      print(e);
    }
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

  addBarang(String NamaBarang, String Gambar, bool Berkode, bool SekaliPakai,
      bool SatuanMeter) async {
    await DatabaseServie()
        .addBarang(NamaBarang, Gambar, Berkode, SekaliPakai, SatuanMeter);
    setState(() {});
  }

  EditBarangBerkode(int id, String KodeBarang) async {
    await DatabaseServie().EditBarangBerkode(id, KodeBarang);
  }

  EditBarangTidakBerkode(int id, int JumlahBarang) async {
    await DatabaseServie().EditBarangTidakBerkode(id, JumlahBarang);
  }

  EditBarang(int id, int? JumlahBarang, String? KodeBarang) async {
    DocumentReference DataBarang = await FirebaseFirestore.instance
        .collection("Barang")
        .doc(id.toString());
    DocumentSnapshot snapshot = await DataBarang.get();
    if (snapshot['Berkode']) {
      EditBarangBerkode(id, KodeBarang!);
    } else {
      EditBarangTidakBerkode(id, JumlahBarang!);
    }
  }

  List<String> KumpulanNama = [];
  List<bool> KumpulanKode = [];
  List<String> KumpulanUrlImage = [];
  List<int> KumpilanId = [];
  List<int> KumpilanTotalJumlahBarang = [];
  List<int> KumpulanBarangTerpakai = [];

  List<bool> KumpulanSekaliPakai = [];
  List<bool> KumpulanSatuanMeter = [];

  refreshData() {
    KumpulanNama.clear();
    KumpulanKode.clear();
    KumpulanUrlImage.clear();
    KumpilanId.clear();
    KumpilanTotalJumlahBarang.clear();
    KumpulanBarangTerpakai.clear();
    KumpulanSekaliPakai.clear();
    KumpulanSatuanMeter.clear();
  }

  getBarang() async {
    setState(() {});
    print("getbarang");
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

  getEditBarang(int id) async {
    refreshData();
    setState(() {});
    await FirebaseFirestore.instance
        .collection("Barang")
        .doc(id.toString())
        .get()
        .then((value) {
      EditisUpload = value["Berkode"];
      EditurlImage = value["Gambar"];
      EditNamaBarang.text = value["Nama"];
      SatuanMeter = value["SatuanMeter"];
      EditSekaliPakai = value["SekaliPakai"];
      if (value["Berkode"]) {
        _EditdropdownValue = "Barang Berkode";
      } else {
        if (value["SekaliPakai"]) {
          _EditdropdownValue = "Barang Tidak Berkode (Sekali Pakai)";
        } else {
          _EditdropdownValue = "Barang Tidak Berkode";
        }
      }
    });
  }

  UbahBarang(String NamaBarang, String Gambar, bool Berkode, int id,
      bool SatuanMeter, bool sekaliPakai) async {
    DatabaseServie()
        .EditBarang(NamaBarang, Gambar, Berkode, id, SatuanMeter, sekaliPakai);
    setState(() {});
  }

  bool isUpload = false;
  Uint8List? imageBytes;
  Image? imageUploaded;
  String _dropdownValue = "Tipe ";

  bool SatuanMeter = false;

  bool EditisUpload = false;
  Uint8List? EditimageBytes;
  Image? EditimageUploaded;
  String _EditdropdownValue = "Tipe ";
  bool EditSatuanMeter = false;
  bool EditSekaliPakai = false;

  TextEditingController EditNamaBarang = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //mengambbil data dari text filt
    TextEditingController Namabarang = new TextEditingController();
    TextEditingController DataBarang = new TextEditingController();

    return FutureBuilder(
        future: getBarang(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                    height: 617,
                    width: 622,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 70),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "KATEGORI BARANG",
                                style: GoogleFonts.beVietnamPro(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 27,
                          ),

                          /// DAFTAR BARANG
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 81,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 332,
                              child: ListView(
                                //buat menampilkan daftar kategori barang
                                shrinkWrap: true,
                                children: [
                                  for (int i = 0; i < KumpulanNama.length; i++)
                                    Column(
                                      children: [
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
                                                        EdgeInsets.symmetric(
                                                            vertical: 0,
                                                            horizontal: 0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            0, 39, 39, 41),
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      39,
                                                                      39,
                                                                      41),
                                                              border: Border.all(
                                                                  width: 4,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          71,
                                                                          71,
                                                                          75))),
                                                          height: 469,
                                                          width: 579,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(25),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
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
                                                                                                "Apakah yakin Ingin Menghapus \nKategori Barang Ini?",
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
                                                                                                      await EditBarangTidakBerkode(KumpilanId[i], int.parse(DataBarang.text)); //edit jumlah barang
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
                                                                                                            await DatabaseServie().HapusBarang(KumpilanId[i]);
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
                                                                        //edit barang
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Image.asset(
                                                                              "assets/images/delete.png",
                                                                              height: 35,
                                                                              width: 35,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Text(
                                                                              "hapus",
                                                                              style: GoogleFonts.beVietnamPro(
                                                                                fontWeight: FontWeight.normal,
                                                                                fontSize: 10,
                                                                                color: Colors.white,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          await getEditBarang(
                                                                              KumpilanId[i]);
                                                                          showDialog(
                                                                              barrierColor: Color.fromARGB(141, 7, 7, 7),
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return StatefulBuilder(builder: (context, setState) {
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
                                                                                            padding: EdgeInsets.symmetric(horizontal: 95, vertical: 29),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Row(
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      "Nama Barang Baru",
                                                                                                      style: GoogleFonts.beVietnamPro(
                                                                                                        fontSize: 15,
                                                                                                        color: Colors.white,
                                                                                                      ),
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
                                                                                                      controller: EditNamaBarang,
                                                                                                      decoration: InputDecoration(border: InputBorder.none),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 10,
                                                                                                ),
                                                                                                //UPLOAD GAMBAR
                                                                                                GestureDetector(
                                                                                                  onTap: () async {
                                                                                                    FilePickerResult? x = await FilePicker.platform.pickFiles();
                                                                                                    if (x != null) {
                                                                                                      setState(() async {
                                                                                                        filePilihan = x;
                                                                                                        //upload to database
                                                                                                        loadingPanel(context);
                                                                                                        await UploadGambar();
                                                                                                        Navigator.pop(context);
                                                                                                        EditurlImage = await ref!.getDownloadURL();
                                                                                                        EditisUpload = true;
                                                                                                        setState(() {});
                                                                                                      });
                                                                                                    }
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                      color: Colors.white,
                                                                                                    ),
                                                                                                    width: 378,
                                                                                                    height: 95,
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "Pilih Gambar Baru",
                                                                                                            style: GoogleFonts.beVietnamPro(
                                                                                                              fontWeight: FontWeight.normal,
                                                                                                              fontSize: 15,
                                                                                                              color: Colors.grey,
                                                                                                            ),
                                                                                                          ),
                                                                                                          EditisUpload
                                                                                                              ? Container(
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    image: DecorationImage(image: NetworkImage(EditurlImage!.toString()), fit: BoxFit.contain),
                                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                                    color: Colors.grey,
                                                                                                                  ),
                                                                                                                  width: 104,
                                                                                                                  height: 71,
                                                                                                                )
                                                                                                              : Container(
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                                    color: Colors.grey,
                                                                                                                  ),
                                                                                                                  width: 104,
                                                                                                                  height: 71,
                                                                                                                )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 10,
                                                                                                ),
                                                                                                //tipee
                                                                                                Container(
                                                                                                  decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                    color: Colors.white,
                                                                                                  ),
                                                                                                  height: 63,
                                                                                                  width: 378,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.only(right: 23, left: 15),
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          height: 5,
                                                                                                        ),
                                                                                                        DropdownButton<String>(
                                                                                                          underline: SizedBox(),
                                                                                                          isExpanded: true,
                                                                                                          hint: Text(
                                                                                                            _EditdropdownValue,
                                                                                                            style: GoogleFonts.beVietnamPro(
                                                                                                              fontWeight: FontWeight.normal,
                                                                                                              fontSize: 15,
                                                                                                              color: const Color.fromARGB(255, 7, 7, 10),
                                                                                                            ),
                                                                                                          ),
                                                                                                          items: <String>[
                                                                                                            'Barang Berkode',
                                                                                                            'Barang Tidak Berkode',
                                                                                                            'Barang Tidak Berkode (Sekali Pakai)',
                                                                                                          ].map((String value) {
                                                                                                            return DropdownMenuItem<String>(
                                                                                                                value: value,
                                                                                                                child: Text(
                                                                                                                  value,
                                                                                                                  style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.normal, fontSize: 15, color: const Color.fromARGB(255, 7, 7, 10)),
                                                                                                                ));
                                                                                                          }).toList(),
                                                                                                          onChanged: (value) {
                                                                                                            setState(() {
                                                                                                              _EditdropdownValue = value.toString();
                                                                                                            });
                                                                                                          },
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 10,
                                                                                                ),
                                                                                                GestureDetector(
                                                                                                  onTap: () {
                                                                                                    if (!SatuanMeter) {
                                                                                                      SatuanMeter = true;
                                                                                                    } else {
                                                                                                      SatuanMeter = false;
                                                                                                    }
                                                                                                    setState(
                                                                                                      () {},
                                                                                                    );
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                      color: SatuanMeter ? Colors.white : Colors.white10,
                                                                                                    ),
                                                                                                    height: 63,
                                                                                                    width: 378,
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.only(left: 15, right: 25),
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "Satuan Meter",
                                                                                                            style: GoogleFonts.beVietnamPro(
                                                                                                              fontWeight: FontWeight.normal,
                                                                                                              fontSize: 15,
                                                                                                              color: SatuanMeter ? Colors.black : Colors.grey,
                                                                                                            ),
                                                                                                          ),
                                                                                                          Container(
                                                                                                            decoration: BoxDecoration(shape: BoxShape.circle, color: SatuanMeter ? Color.fromARGB(255, 250, 208, 7) : Colors.grey),
                                                                                                            width: 20,
                                                                                                            height: 20,
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 16,
                                                                                                ),

                                                                                                Text(
                                                                                                  "*HANYA UBAH BAGIAN YANG INGIN DIUBAH",
                                                                                                  style: GoogleFonts.beVietnamPro(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 16,
                                                                                                ),
                                                                                                GestureDetector(
                                                                                                  onTap: () async {
                                                                                                    bool berkode = false;
                                                                                                    if (_EditdropdownValue == "Barang Berkode") {
                                                                                                      berkode = true;
                                                                                                      EditSekaliPakai = false;
                                                                                                    } else if (_EditdropdownValue == "Barang Tidak Berkode") {
                                                                                                      berkode = false;
                                                                                                      EditSekaliPakai = false;
                                                                                                    } else {
                                                                                                      berkode = false;
                                                                                                      EditSekaliPakai = true;
                                                                                                    }
                                                                                                    //proses penambahan
                                                                                                    await UbahBarang(EditNamaBarang.text.toString(), EditurlImage!, berkode, KumpilanId[i], SatuanMeter, EditSekaliPakai);
                                                                                                    //untuk tutup pop up
                                                                                                    Navigator.pop(context);
                                                                                                    Navigator.pop(context);
                                                                                                    //untuk mengambalikan data jadi normal
                                                                                                    isUpload = false;
                                                                                                    _EditdropdownValue = 'Tipe';
                                                                                                    EditNamaBarang.text = '';
                                                                                                    EditurlImage = '';
                                                                                                    EditSatuanMeter = false;
                                                                                                    //untuk mengriset semua seperti semua

                                                                                                    refreshData();

                                                                                                    setState(
                                                                                                      () {},
                                                                                                    );
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
                                                                                                        "UBAH",
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
                                                                              });
                                                                        },
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Image.asset(
                                                                              "assets/images/edit.png",
                                                                              height: 35,
                                                                              width: 35,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Text(
                                                                              "Edit",
                                                                              style: GoogleFonts.beVietnamPro(
                                                                                fontWeight: FontWeight.normal,
                                                                                fontSize: 10,
                                                                                color: Colors.white,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ]),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          70),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      //icon
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(KumpulanUrlImage[i].toString()),
                                                                              fit: BoxFit.contain),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        height:
                                                                            59,
                                                                        width:
                                                                            80,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            KumpulanNama[i],
                                                                            style:
                                                                                GoogleFonts.beVietnamPro(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(
                                                                                10),
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                71,
                                                                                71,
                                                                                75)),
                                                                        width:
                                                                            270,
                                                                        height:
                                                                            51,
                                                                        child:
                                                                            Center(
                                                                          child:!KumpulanKode[i] && KumpulanSatuanMeter[i]? Text(
                                                                              " Panjang Barang Tersisa = " + KumpilanTotalJumlahBarang[i].toString() + " M",  
                                                                              style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)) : Text(
                                                                              " Jumlah Barang Saat Ini = " + KumpilanTotalJumlahBarang[i].toString(),  
                                                                              style: GoogleFonts.beVietnamPro(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal)),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      KumpulanKode[
                                                                              i]
                                                                          ? Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Kode Barang",
                                                                                      style: GoogleFonts.beVietnamPro(
                                                                                        fontSize: 15,
                                                                                        color: Colors.white,
                                                                                      ),
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
                                                                                        controller: DataBarang,
                                                                                        decoration: InputDecoration(border: InputBorder.none),
                                                                                      ),
                                                                                    )),
                                                                                SizedBox(
                                                                                  height: 16,
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () async {
                                                                                    await EditBarangBerkode(KumpilanId[i], DataBarang.text);
                                                                                    //untuk membalikannya seperti semula
                                                                                    DataBarang.text = '';
                                                                                    SatuanMeter = false;
                                                                                    Navigator.pop(context);
                                                                                    refreshData();
                                                                                    setState(() {});
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
                                                                                        "TAMBAH",
                                                                                        style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10)),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          : Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Jumlah Barang",
                                                                                      style: GoogleFonts.beVietnamPro(
                                                                                        fontSize: 15,
                                                                                        color: Colors.white,
                                                                                      ),
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
                                                                                        controller: DataBarang,
                                                                                        decoration: InputDecoration(border: InputBorder.none),
                                                                                      ),
                                                                                    )),
                                                                                SizedBox(
                                                                                  height: 16,
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () async {
                                                                                    await EditBarangTidakBerkode(KumpilanId[i], int.parse(DataBarang.text));
                                                                                    //untuk membalikannya seperti semula
                                                                                    DataBarang.text = '';
                                                                                    Navigator.pop(context);
                                                                                    refreshData();
                                                                                    setState(() {});
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
                                                                                        "TAMBAH",
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
                                                  BorderRadius.circular(5),
                                              color: Color.fromARGB(
                                                  255, 71, 71, 75),
                                            ),
                                            height: 51,
                                            width: 460,
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    KumpulanNama[i],
                                                    style: GoogleFonts
                                                        .beVietnamPro(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Image.asset(
                                                    "assets/images/arrow_kanan.png",
                                                    height: 29,
                                                    width: 29,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    )
                                ],
                              ),
                            ),
                          ),

                          /// tAMABAH KATEGORI BARANG
                          SizedBox(height: 27),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  barrierColor: Color.fromARGB(141, 7, 7, 7),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
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
                                              height: 515,
                                              width: 567,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 95,
                                                    vertical: 40),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Nama Barang",
                                                          style: GoogleFonts
                                                              .beVietnamPro(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white,
                                                      ),
                                                      height: 63,
                                                      width: 378,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          controller:
                                                              Namabarang,
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    //UPLOAD GAMBAR
                                                    GestureDetector(
                                                      onTap: () async {
                                                        FilePickerResult? x =
                                                            await FilePicker
                                                                .platform
                                                                .pickFiles();
                                                        if (x != null) {
                                                          setState(() async {
                                                            filePilihan = x;
                                                            //upload to database
                                                            loadingPanel(
                                                                context);
                                                            await UploadGambar();
                                                            Navigator.pop(
                                                                context);
                                                            urlImage = await ref!
                                                                .getDownloadURL();
                                                            isUpload = true;
                                                            setState(() {});
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.white,
                                                        ),
                                                        width: 378,
                                                        height: 95,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Pilih Gambar",
                                                                style: GoogleFonts
                                                                    .beVietnamPro(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              isUpload
                                                                  ? Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image:
                                                                                NetworkImage(urlImage!.toString()),
                                                                            fit: BoxFit.contain),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      width:
                                                                          104,
                                                                      height:
                                                                          71,
                                                                    )
                                                                  : Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      width:
                                                                          104,
                                                                      height:
                                                                          71,
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white,
                                                      ),
                                                      height: 63,
                                                      width: 378,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 23,
                                                                left: 15),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            DropdownButton<
                                                                String>(
                                                              underline:
                                                                  SizedBox(),
                                                              isExpanded: true,
                                                              hint: Text(
                                                                _dropdownValue,
                                                                style: GoogleFonts
                                                                    .beVietnamPro(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 15,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      7,
                                                                      7,
                                                                      10),
                                                                ),
                                                              ),
                                                              items: <String>[
                                                                'Barang Berkode',
                                                                'Barang Tidak Berkode',
                                                                'Barang Tidak Berkode (Sekali Pakai)'
                                                              ].map((String
                                                                  value) {
                                                                return DropdownMenuItem<
                                                                        String>(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                      value,
                                                                      style: GoogleFonts.beVietnamPro(
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          fontSize:
                                                                              15,
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              7,
                                                                              7,
                                                                              10)),
                                                                    ));
                                                              }).toList(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  _dropdownValue =
                                                                      value
                                                                          .toString();
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (!SatuanMeter) {
                                                          SatuanMeter = true;
                                                        } else {
                                                          SatuanMeter = false;
                                                        }
                                                        setState(
                                                          () {},
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: SatuanMeter
                                                              ? Colors.white
                                                              : Colors.white10,
                                                        ),
                                                        height: 63,
                                                        width: 378,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 15,
                                                                  right: 25),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Satuan Meter",
                                                                style: GoogleFonts
                                                                    .beVietnamPro(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 15,
                                                                  color: SatuanMeter
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .grey,
                                                                ),
                                                              ),
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: SatuanMeter
                                                                        ? Color.fromARGB(
                                                                            255,
                                                                            250,
                                                                            208,
                                                                            7)
                                                                        : Colors
                                                                            .grey),
                                                                width: 20,
                                                                height: 20,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 16,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        //proses penambahan
                                                        if (_dropdownValue !=
                                                                'Tipe' &&
                                                            Namabarang.text !=
                                                                '' &&
                                                            urlImage != '') {
                                                          addBarang(
                                                              Namabarang.text
                                                                  .toString(),
                                                              urlImage!,
                                                              _dropdownValue ==
                                                                      'Barang Berkode'
                                                                  ? true
                                                                  : false,
                                                              _dropdownValue ==
                                                                      'Barang Tidak Berkode (Sekali Pakai)'
                                                                  ? true
                                                                  : false,
                                                              SatuanMeter);
                                                          //untuk tutup pop up
                                                          Navigator.pop(
                                                              context);
                                                          //untuk mengambalikan data jadi normal
                                                          isUpload = false;
                                                          _dropdownValue =
                                                              'Tipe';
                                                          Namabarang.text = '';
                                                          urlImage = '';
                                                          //untuk mengriset semua seperti semua
                                                          refreshData();
                                                        } else {
                                                          showDialog(
                                                              barrierColor:
                                                                  Color
                                                                      .fromARGB(
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
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 80),
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
                                                                      Color.fromARGB(
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
                                                                            border:
                                                                                Border.all(width: 4, color: Color.fromARGB(255, 71, 71, 75))),
                                                                        width:
                                                                            375,
                                                                        height:
                                                                            251,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                60,
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              //icon

                                                                              Text(
                                                                                "Penambahan Gagal \nIsi Semua Terlebih Dahulu!",
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
                                                                                              color: Color.fromARGB(255, 250, 208, 7),
                                                                                            ),
                                                                                            height: 44,
                                                                                            width: 126,
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                "KEMBALI",
                                                                                                style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 7, 7, 10)),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 10,
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
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Color.fromARGB(
                                                              255, 250, 208, 7),
                                                        ),
                                                        height: 62,
                                                        width: 202,
                                                        child: Center(
                                                          child: Text(
                                                            "TAMBAH",
                                                            style: GoogleFonts
                                                                .beVietnamPro(
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
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 250, 208, 7),
                              ),
                              height: 51,
                              width: 212,
                              child: Center(
                                child: Text(
                                  "TAMBAH KATEGORI",
                                  style: GoogleFonts.beVietnamPro(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 7, 7, 10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
