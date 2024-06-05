// ignore_for_file: prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures

import 'dart:html';
import 'dart:io';
import 'dart:js_interop_unsafe';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseServie {
  //Data Base admin
  //refrence for out collection

  final CollectionReference barangCollection =
      FirebaseFirestore.instance.collection("Barang");

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("User");

  final CollectionReference ReportCollection =
      FirebaseFirestore.instance.collection("Report");

  final CollectionReference ReportPengambalianCollection =
      FirebaseFirestore.instance.collection("ReportPengembalian");

  //getting user data

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await barangCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //ngambil data barang
  getBarang() async {
    return await barangCollection.get();
  }

//menghiting jumlah barang
  Future<int> countBarang() async {
    int Jumlah;
    int x = 0;
    return await barangCollection.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        x++;
      });
      Jumlah = x;

      return Jumlah;
    });
  }

  //tambah Barang
  addBarang(String NamaBarang, String Gambar, bool Berkode, bool? SekaliPakai,
      bool SatuanMeter) async {
    int id = 0;
    await barangCollection.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        if (int.parse(element['Id'].toString()) >= id) {
          id = int.parse(element['Id'].toString()) +
              1; //+ 1 untuk memisahkan tiap data yang masuk
        }
      });
    });
    if (Berkode) {
      await barangCollection.doc(id.toString()).set({
        "Nama": NamaBarang,
        "Gambar": Gambar,
        "JumlahTotalBarang": 0,
        "JumlahTerpakai": 0,
        "Berkode": Berkode,
        "Id": id,
        "SekaliPakai": false,
        "SatuanMeter": false
      });
    } else
      (await barangCollection.doc(id.toString()).set({
        "Nama": NamaBarang,
        "Gambar": Gambar,
        "JumlahTotalBarang": 0,
        "JumlahTerpakai": 0,
        "Berkode": Berkode,
        "Id": id,
        "SekaliPakai": SekaliPakai,
        "SatuanMeter": SatuanMeter
      }));
  }

  //edit Barang Berkode
  EditBarangBerkode(
    int id,
    String KodeBarang,
  ) async {
    int JumlahBarang = 0;
    DocumentReference DataBarang = await barangCollection.doc(id.toString());

    await barangCollection
        .doc(id.toString())
        .collection('BarangBarang')
        .doc(KodeBarang.toString())
        .set({
      "Kode": KodeBarang,
      "Status": false,
    });
    await barangCollection
        .doc(id.toString())
        .collection('BarangBarang')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        JumlahBarang++;
      });
    });
    DataBarang.update({"JumlahTotalBarang": JumlahBarang});
  }

  //edit Barang Tidak Berkode
  EditBarangTidakBerkode(
    int id,
    int JumlahBarang,
  ) async {
    DocumentReference DataBarang = await barangCollection.doc(id.toString());
    DocumentSnapshot snapshot = await DataBarang.get();
    await DataBarang.update({
      "JumlahTotalBarang":
          JumlahBarang + int.parse(snapshot['JumlahTotalBarang'].toString())
    });
  }

  //cek Barang Berkode Atau Tidak
  Future<bool> CekBarangBerkodeAtauTidak(int id) async {
    DocumentReference DataBarang = await barangCollection.doc(id.toString());
    DocumentSnapshot snapshot = await DataBarang.get();
    return snapshot['Berkode'];
  }

  //hapus Barang semua atau hapus kategori
  HapusBarang(int id) async {
    await barangCollection
        .doc(id.toString())
        .collection('BarangBarang')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        barangCollection
            .doc(id.toString())
            .collection("BarangBarang")
            .doc(element.id)
            .delete();
      });
    });
    await barangCollection.doc(id.toString()).delete();
  }

  //hapus Barang satu persatu atau  hanya hapus berkode
  HapusSatuan(int id, String KodeBarang) async {
    await barangCollection
        .doc(id.toString())
        .collection('BarangBarang')
        .doc(KodeBarang)
        .delete();
    print("Penghapusan Berhsil");
    DocumentReference DataBarang = await barangCollection.doc(id.toString());
    DocumentSnapshot snapshot = await DataBarang.get();
    await DataBarang.update(
        {"JumlahTotalBarang": snapshot['JumlahTotalBarang'] - 1});
  }

  //edit barang
  EditBarang(String NamaBarang, String Gambar, bool Berkode, int id,
      bool SatuanMeter, bool sekaliPakai) async {
    await barangCollection.doc(id.toString()).update({
      "Nama": NamaBarang,
      "Gambar": Gambar,
      "JumlahTotalBarang": 0,
      "JumlahTerpakai": 0,
      "Berkode": Berkode,
      "SatuanMeter": SatuanMeter,
      "SekaliPakai": sekaliPakai,
    });
    print("edit berhasil");
  }

  //========================================DataBase Mahasiswa
  //pinjam Barang tidak berkode
  PinjambarangTidakBerkode(int id, int JumlahBarangDiPinjam) async {
    DocumentReference DataBarang = await barangCollection.doc(id.toString());
    DocumentSnapshot snapshot = await DataBarang.get();
    if (!snapshot["SekaliPakai"]) {
      if (int.parse(snapshot['JumlahTotalBarang'].toString()) -
              int.parse(snapshot['JumlahTerpakai'].toString()) <
          JumlahBarangDiPinjam) {
        print("Pinjaman Jumlah Sudah Melempaui Ketersediyaan Barang");
      } else {
        int JumlahTerpakaiSekarang =
            int.parse(snapshot["JumlahTerpakai"].toString()) +
                JumlahBarangDiPinjam;
        await DataBarang.update({"JumlahTerpakai": JumlahTerpakaiSekarang});
      }
    } else {
      if (int.parse(snapshot['JumlahTotalBarang'].toString()) <
          JumlahBarangDiPinjam) {
        print("Pengambilan  Gagal Jumlah Sudah Melempaui Ketersediyaan Barang");
      } else {
        int JumlahTotalBarangSekarang =
            int.parse(snapshot["JumlahTotalBarang"].toString()) -
                JumlahBarangDiPinjam;
        await DataBarang.update(
            {"JumlahTotalBarang": JumlahTotalBarangSekarang});
        int JumlahTerpakaiSekarang =
            int.parse(snapshot["JumlahTerpakai"].toString()) +
                JumlahBarangDiPinjam;
        await DataBarang.update({"JumlahTerpakai": JumlahTerpakaiSekarang});
      }
    }
  }

  //pinjam Barang berkode
  PinjambarangBerkode(int id, String KodeBarang) async {
    DocumentReference DataBarang = await barangCollection
        .doc(id.toString())
        .collection("BarangBarang")
        .doc(KodeBarang.toString());
    DocumentReference DataBarangsnapshot =
        await barangCollection.doc(id.toString());
    DocumentSnapshot snapshot = await DataBarangsnapshot.get();
    int JumlahTerpakaiSekarang =
        int.parse(snapshot["JumlahTerpakai"].toString()) + 1;
    await DataBarangsnapshot.update({"JumlahTerpakai": JumlahTerpakaiSekarang});
    await DataBarang.update({"Status": true});
  }

  //kembalikan barang Berkode
  KembalikanBarangBerkode(int id, int KodeBarang) async {
    DocumentReference DataBarang = await barangCollection
        .doc(id.toString())
        .collection("BarangBarang")
        .doc(KodeBarang.toString());

    DataBarang.update({'Status': false});
    DocumentSnapshot snapshot = await barangCollection.doc(id.toString()).get();
    int JumlahTerpakaiSekarang =
        int.parse(snapshot["JumlahTerpakai"].toString()) - 1;
    await barangCollection
        .doc(id.toString())
        .update({"JumlahTerpakai": JumlahTerpakaiSekarang});
  }

  //Kembalikan Barang Tidak Berkode
  KembalikanBarangTidakBerkode(int id, int JumlahBarangDiKemablikan) async {
    DocumentSnapshot snapshot = await barangCollection.doc(id.toString()).get();
    int JumlahTerpakaiSekarang =
        int.parse(snapshot["JumlahTerpakai"].toString()) -
            JumlahBarangDiKemablikan;
    await barangCollection
        .doc(id.toString())
        .update({"JumlahTerpakai": JumlahTerpakaiSekarang});
  }

  //Menghitung Sisa Barang
  Future<int> HitungSisaBarang(int id) async {
    DocumentReference DataBarang = await barangCollection.doc(id.toString());
    DocumentSnapshot snapshot = await DataBarang.get();

    return int.parse(snapshot['JumlahTotalBarang'].toString()) -
        int.parse(snapshot['JumlahTerpakai'].toString());
  }

  //penampungan data dari peminjam
  DataPeminjam(String NamaPeminjam, String NoTelponPeminjam, List Barang,
      List jumlahBarang, List sekaliPakai, List Berkode) async {
    bool isPeminjamSama = false;
    int id = 0;
    int panjangBarangYangSedangDipinjamUser = 0;
    bool ketemu = false;
    int jumlahbarang = 0;
    String idBarangYangDiUpdate = "";

    //mengambil nilai id user
    await userCollection.get().then((value) => value.docs.forEach((element) {
          if (NamaPeminjam == element["Nama"] &&
              NoTelponPeminjam == element["NoTelpon"]) {
            isPeminjamSama = true;
            id = int.parse(element.id);
          }
        }));

    if (!isPeminjamSama) {
      //mengecek id untuk melakukan build user dengan id lanjutan
      print("generate ID");
      await userCollection.get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((element) {
          if (int.parse(element['Id'].toString()) >= id) {
            id = int.parse(element['Id'].toString()) + 1;
          }
        });
      });
    }

    await userCollection
        .doc(id.toString())
        .collection("BarangBarang")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        if (int.parse(element.id.toString()) >=
            panjangBarangYangSedangDipinjamUser) {
          panjangBarangYangSedangDipinjamUser =
              int.parse(element.id.toString()) + 1;
        }
      });
    });

    // melakukan perulangan untuk proses pemasukan data ke database user
    // mengecek apakah barang nya sekali pakai atau tidak (karena jika dia sekali pakai maka dia tidak akan di create di database user)
    //menambah data ke user baru

    for (int i = 0; i < Barang.length; i++) {
      if (!sekaliPakai[i]) {
        await userCollection.doc(id.toString()).set({
          "Id": id,
          "Nama": NamaPeminjam,
          "NoTelpon": NoTelponPeminjam,
        });

        //mengambil jumlahataukodebarang dari database (keperluan peminjaman barang tidak berkode dengan nama sama)
        if (!sekaliPakai[i]) {
          await userCollection
              .doc(id.toString())
              .collection("BarangBarang")
              .get()
              .then((value) => value.docs.forEach((element) {
                    if (Barang[i] == element["NamaBarang"] && !Berkode[i]) {
                      jumlahbarang = int.parse(
                              element["JumlahatauKodeBarang"].toString()) +
                          int.parse(jumlahBarang[i].toString());
                    }
                  }));
        }

        //melakukan pengecekan normal
        if (!sekaliPakai[i]) {
          if (Berkode[i]) {
            print("upload barang brkode");
            await userCollection
                .doc(id.toString())
                .collection('BarangBarang')
                .doc(panjangBarangYangSedangDipinjamUser.toString())
                .set({
              "NamaBarang": Barang[i],
              "JumlahatauKodeBarang": jumlahBarang[i],
              "Berkode": Berkode[i]
            });
            panjangBarangYangSedangDipinjamUser++;
          } else {
            //cek apakah ada nama yang sama
            print("upload barang tidak brkode");

            await userCollection
                .doc(id.toString())
                .collection("BarangBarang")
                .get()
                .then((value) => value.docs.forEach((element) async {
                      if (element["NamaBarang"] == Barang[i] && !ketemu) {
                        idBarangYangDiUpdate = element.id;

                        ketemu = true;
                      }
                    }));
            //kalo tidak ada maka buat baru
            if (!ketemu) {
              await userCollection
                  .doc(id.toString())
                  .collection('BarangBarang')
                  .doc(panjangBarangYangSedangDipinjamUser.toString())
                  .set({
                "NamaBarang": Barang[i],
                "JumlahatauKodeBarang": jumlahBarang[i],
                "Berkode": Berkode[i]
              });
              panjangBarangYangSedangDipinjamUser++;
              //kalo ada maka update
            } else {
              await userCollection
                  .doc(id.toString())
                  .collection('BarangBarang')
                  .doc((idBarangYangDiUpdate).toString())
                  .update({
                "JumlahatauKodeBarang": jumlahbarang,
              });
            }
          }
        }
      }
      ketemu = false;
    }
  }

  //mengambil data peminjam
  getDataPeminjam() async {
    return await userCollection.get();
  }

  ///=======================================DATABASE REPORT PEMINJMAN DAN PENGEMBALIAN BARANG MAHASISWAA==================

  ///laporan peminjman
  ReportPinjam(String Namapeminjam, String NoTelpon, List NamaBarang,
      List KodeAtauJumlahBarang, List Berkode, List BerM) async {
    DateTime now = new DateTime.now();
    String jamSekarang = "";
    String menitSekarang = "";
    String date = now.day.toString() +
        "-" +
        now.month.toString() +
        "-" +
        (now.year.toString());

    int id = 0;
    bool isPeminjamSama = false;
    int percobaanPeminjaman = 1;

    for (int i = 0; i < NamaBarang.length; i++) {
      //sama id untuk sama nama dan no telepon
      if (!Berkode[i]) {
        await ReportCollection.get().then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            print("object");
            if (Namapeminjam == element["NamaPeminjam"] &&
                NoTelpon == element["NoTelpon"] &&
                NamaBarang[i] == element["NamaBarang"]) {
              id = int.parse(element.id);
              isPeminjamSama = true;
              percobaanPeminjaman = element["percobaanPeminjaman"] + 1;
              print("percobaan peminjaman : " + percobaanPeminjaman.toString());
            }
          });
        });
      }
      //build id untuk setiap field
      if (!isPeminjamSama) {
        await ReportCollection.get().then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            if (int.parse(element.id.toString()) >= id) {
              id = int.parse(element.id.toString()) + 1;
            }
          });
        });
      }

      //membaca jam dan menit sekarang
      if (int.parse(now.hour.toString()) < 10) {
        jamSekarang = "0" + now.hour.toString();
      } else {
        jamSekarang = now.hour.toString();
      }
      if (int.parse(now.minute.toString()) < 10) {
        menitSekarang = "0" + now.minute.toString();
      } else {
        menitSekarang = now.minute.toString();
      }

      print("jam : " + jamSekarang);
      print("menit : " + menitSekarang);

      //proses pembuatan data report

      if (Berkode[i]) {
        //barang berkode
        await ReportCollection.doc(id.toString()).set({
          "id": id,
          "NamaPeminjam": Namapeminjam,
          "NoTelpon": NoTelpon,
          "NamaBarang": NamaBarang[i],
          "JumlahPeminjaman": [1.toString() + " " + 1.toString()],
          "KodeBarang": [KodeAtauJumlahBarang[i] + " " + 1.toString()],
          "jamPeminjaman": [
            jamSekarang + ":" + menitSekarang + " " + 1.toString()
          ],
          "tanggalPeminjaman": [date.toString() + " " + 1.toString()],
          "jumlahPengembalian": [],
          "jamPengembalian": [],
          "tanggalPengembalian": [],
          "barangBerkode": true,
          "percobaanPeminjaman": percobaanPeminjaman,
          "PercobaanPengembalian": 0,
          "berM": BerM[i]
        });
      } else {
        //barang tidak berkode
        if (isPeminjamSama) {
          await ReportCollection.doc(id.toString()).update({
            "percobaanPeminjaman": percobaanPeminjaman,
            "JumlahPeminjaman": FieldValue.arrayUnion([
              KodeAtauJumlahBarang[i] + " " + percobaanPeminjaman.toString()
            ]),
            "KodeBarang": FieldValue.arrayUnion(
                ["-" + " " + percobaanPeminjaman.toString()]),
            "jamPeminjaman": FieldValue.arrayUnion([
              jamSekarang +
                  ":" +
                  menitSekarang +
                  " " +
                  percobaanPeminjaman.toString()
            ]),
            "tanggalPeminjaman": FieldValue.arrayUnion(
                [date.toString() + " " + percobaanPeminjaman.toString()]),
          });
        } else {
          await ReportCollection.doc(id.toString()).set({
            "id": id,
            "NamaPeminjam": Namapeminjam,
            "NoTelpon": NoTelpon,
            "NamaBarang": NamaBarang[i],
            "JumlahPeminjaman": [KodeAtauJumlahBarang[i] + " " + 1.toString()],
            "KodeBarang": ["-" + " " + 1.toString()],
            "jamPeminjaman": [
              jamSekarang + ":" + menitSekarang + " " + 1.toString()
            ],
            "tanggalPeminjaman": [date.toString() + " " + 1.toString()],
            "jumlahPengembalian": [],
            "jamPengembalian": [],
            "tanggalPengembalian": [],
            "barangBerkode": false,
            "percobaanPeminjaman": percobaanPeminjaman,
            "PercobaanPengembalian": 0,
            "berM": BerM[i]
          });
        }
      }
      isPeminjamSama = false;
    }
  }

  //laporan pengembalian
  ReportPengembalian(String namaPeminjam, String namaBarang,
      String jumlahYangDiKembalikan) async {
    print("NAMA PEMINJAM : " + namaPeminjam);
    print("NAMA BARANG : " + namaBarang);
    DateTime now = new DateTime.now();
    String jamSekarang = "";
    String menitSekarang = "";
    String date = now.day.toString() +
        "-" +
        now.month.toString() +
        "-" +
        (now.year.toString());
    int idYangDipilih = 0;
    int PercobaanPengembalian = 0;
    bool isBerkode = false;
    bool isKetemu = false;

    //membaca jam dan menit sekarang
    if (int.parse(now.hour.toString()) < 10) {
      jamSekarang = "0" + now.hour.toString();
    } else {
      jamSekarang = now.hour.toString();
    }
    if (int.parse(now.minute.toString()) < 10) {
      menitSekarang = "0" + now.minute.toString();
    } else {
      menitSekarang = now.minute.toString();
    }

    //mencari id barang yang terdapat di report untuk di olah datanya
    await ReportCollection.get().then((value) => value.docs.forEach((element) {
          print("x : " + element["barangBerkode"].toString());
          if (!element["barangBerkode"]) {
            print("xy");
            if (namaBarang == element["NamaBarang"] &&
                namaPeminjam.toLowerCase() ==
                    element["NamaPeminjam"].toString().toLowerCase()) {
              idYangDipilih = int.parse(element.id);
              isBerkode = element["barangBerkode"];
              PercobaanPengembalian = element["PercobaanPengembalian"];
              print("id yang dipilih REPORT (tidak berkode) : " +
                  idYangDipilih.toString());
              isKetemu = true;
            }
          } else {
            print("bnnnnb : " +
                (jumlahYangDiKembalikan.toString() +
                            " " +
                            element["PercobaanPengembalian"].toString() ==
                        element["KodeBarang"])
                    .toString());
            print(jumlahYangDiKembalikan.toString() +
                " " +
                element["percobaanPeminjaman"].toString() +
                " == " +
                element["KodeBarang"][0]);
            if (namaBarang == element["NamaBarang"] &&
                namaPeminjam.toLowerCase() ==
                    element["NamaPeminjam"].toString().toLowerCase() &&
                jumlahYangDiKembalikan.toString() +
                        " " +
                        element["percobaanPeminjaman"].toString() ==
                    element["KodeBarang"][0]) {
              idYangDipilih = int.parse(element.id);
              isBerkode = element["barangBerkode"];
              PercobaanPengembalian = element["PercobaanPengembalian"];
              print("id yang dipilih REPORT (berkode) : " +
                  idYangDipilih.toString());
              isKetemu = true;
            }
          }
        }));
    //proses pembuatan data report
    print(isBerkode);
    //untuk barang berkode
    if (isKetemu) {
      if (isBerkode) {
        PercobaanPengembalian++;
        await ReportCollection.doc(idYangDipilih.toString()).update({
          "PercobaanPengembalian": PercobaanPengembalian,
          "jumlahPengembalian": 1.toString(),
          "jamPengembalian": FieldValue.arrayUnion([
            jamSekarang +
                ":" +
                menitSekarang +
                " " +
                PercobaanPengembalian.toString()
          ]),
          "tanggalPengembalian": FieldValue.arrayUnion(
              [date.toString() + " " + PercobaanPengembalian.toString()]),
        });
        print("bacek");
      } else {
        //untuk barang tidak berkode
        PercobaanPengembalian++;
        await ReportCollection.doc(idYangDipilih.toString()).update({
          "PercobaanPengembalian": PercobaanPengembalian,
          "jumlahPengembalian": FieldValue.arrayUnion([
            jumlahYangDiKembalikan.toString() +
                " " +
                PercobaanPengembalian.toString()
          ]),
          "jamPengembalian": FieldValue.arrayUnion([
            jamSekarang +
                ":" +
                menitSekarang +
                " " +
                PercobaanPengembalian.toString()
          ]),
          "tanggalPengembalian": FieldValue.arrayUnion(
              [date.toString() + " " + PercobaanPengembalian.toString()]),
        });
        print("kiruk");
      }
    }

    ///hilangin nomor pada arry di ujing firebase
    ///tambah M atau meter di barang yang sesuai pada tampilan riwayat
    ///buat format jam lebih bagus (00.01) jangan (0:1) jam 12 mlm tes
    ///cari tau download data di firebase
    ///cari tau download data di firebase
    ///cari tau download data di firebase
    ///buat supaya ketika di upload icon gambar barang uang, gambar sebelumnnya ke replace
    ///bug ketika upload gambar di tambah kategori admin dengan nama yang sama maka gambar sebelumnnya akan ke ubah dengan gambar baru
    ///
    ///
    /// bug ketika update tidak ada masuk data ke kumpulanNamafile di database
    /// k
  }

  //============================================================================================================

  ///buat pop up edit setelah pilih barang di kategori
  ///edit gambar, buat supaya ketika  edit gambar, gambar sebelumnya otomatis ke hapus
  ///edit nama
  /// buat kurangin jumlah barang tidak berkode, kondisinya jika barang tersebut rusak
  ///buat supaya bisa hapus semua kategori
  ///buat hapus barang berkode bisa berfungsi pada menu barang admin
  ///
  ///====================================================================================

  ///===================PENTING====================
  ///buat peningkat peforma kode buatlah  paling bagian terakhir ketika projek telah selesai
  ///kalo dia pinjman barang yang sama di waktu yang berbeda akan di lakukan update cuma di tambahin jumlah barang yang di pinjmam nama barang tidak di di ubah ataupun di tambah (berlaku hanya untuk barang tidak berkode)
  ///kalo misalnya user meminjam barang tidak berkode dalam waktu yang berbeda maka s eharusnya di buat dalam satu database field ()
  ///peminjman barang tidak berkode di nama yang sama masuh belum bisa  tergabung di field yang sama
  ///buat bisa terdeteksi sama aja dari nama huruf gedek maupun kecil
  ///buat notifikasi bukan pop up pada aksi yang  gagal maupun berhasil
  ///

  ///===================================================================
  ///
  ///
  ///buat kembalikan barang tidak berkode
  ///
  ///buat pop up ketika barang yang di kembalikan melebihi barang yang di pinjam hasilnya adalah jumlah barang yang di kembalikan melebihi barang yang di pinjam
  ///
  ///buat database pengembalian barang tidak berkode, berjalan dengan semestinya
  ///buat supaya bisa mengurangin jumlah terpakai pada barang tidak berkode  di database
  ///
  ///
  ///=========================================sudah berhasil cuma perlu tambhkan pop upnya saja=============="Pengambalian Gagal Jumlah yang Dikembalikan \n Melempaui Jumlah Yang di Pinjam"
  ///membuat pengembalian gagal ketika barang yang di kembalikan lebih besar dari jumlah yang di pinjam oleh user
  ///=============================================================
  ///bug ketika mengembalikan  barang yang kurang dari peminyaman awal, maka pengurangan barang itu sebesar barang yang di kembalikan namun user di database juga hilang contoh kasus( pinjam 20, kembalikan 10, barang yang di kembalikan hanya 10, namun user hilang, seharusnya user tidak hilnag dan masih ada barang yang tersisa 10 lagi)
}
