class ProdukDigital {
  String namaProduk;
  double harga;
  String kategori;

  ProdukDigital(this.namaProduk, this.harga, this.kategori) {
    // Validasi harga sesuai kategori
    if (kategori == "NetworkAutomation" && harga < 200000) {
      harga = 200000; // Pastikan harga minimal 200.000
    } else if (kategori == "DataManagement" && harga >= 200000) {
      harga = 199999; // Pastikan harga di bawah 200.000
    }
  }

  void terapkanDiskon(int jumlahTerjual) {
    if (kategori == "NetworkAutomation" && jumlahTerjual > 50) {
      double hargaDiskon = harga * 0.85; // Diskon 15%
      if (hargaDiskon < 200000) {
        hargaDiskon = 200000; // Harga akhir tidak boleh di bawah 200.000
      }
      harga = hargaDiskon;
    }
  }
}

abstract class Karyawan with Kinerja {
  String nama;
  String idKaryawan;
  int? umur;
  String? peran;
  bool aktif;

  Karyawan(this.nama, this.idKaryawan,
      {this.umur, this.peran, this.aktif = true});

  void bekerja(); // Metode abstrak untuk diimplementasikan oleh subclass

  void infoKaryawan() {
    print(
        "Nama: $nama, ID: $idKaryawan, Umur: ${umur ?? "Tidak diketahui"}, Peran: ${peran ?? "Tidak ditentukan"}");
  }

  void resign() {
    aktif = false;
    print(
        "Karyawan $nama (ID: $idKaryawan) telah resign dan statusnya menjadi non-aktif.");
  }
}

class Perusahaan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];
  final int maxKaryawanAktif = 20;

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length < maxKaryawanAktif) {
      if (karyawan.aktif) {
        karyawanAktif.add(karyawan);
        print(
            "Karyawan ${karyawan.nama} (ID: ${karyawan.idKaryawan}) ditambahkan ke daftar karyawan aktif.");
      } else {
        print(
            "Karyawan ${karyawan.nama} adalah non-aktif dan tidak bisa ditambahkan ke daftar aktif.");
      }
    } else {
      print(
          "Tidak dapat menambahkan karyawan ${karyawan.nama}. Batas maksimal karyawan aktif tercapai.");
    }
  }

  void karyawanResign(Karyawan karyawan) {
    if (karyawanAktif.contains(karyawan)) {
      karyawan.resign();
      karyawanAktif.remove(karyawan);
      karyawanNonAktif.add(karyawan);
    } else {
      print(
          "Karyawan ${karyawan.nama} tidak ditemukan dalam daftar karyawan aktif.");
    }
  }

  void infoKaryawan() {
    print("Jumlah Karyawan Aktif: ${karyawanAktif.length}");
    print("Jumlah Karyawan Non-Aktif: ${karyawanNonAktif.length}");
    print("\nDaftar Karyawan Aktif:");
    for (var k in karyawanAktif) {
      print("- ${k.nama} (ID: ${k.idKaryawan})");
    }

    print("\nDaftar Karyawan Non-Aktif:");
    for (var k in karyawanNonAktif) {
      print("- ${k.nama} (ID: ${k.idKaryawan})");
    }
  }
}

class KaryawanTetap extends Karyawan {
  KaryawanTetap(String nama, String idKaryawan, {int? umur, String? peran})
      : super(nama, idKaryawan, umur: umur, peran: peran);

  @override
  void bekerja() {
    print(
        "Karyawan tetap $nama (ID: $idKaryawan) bekerja selama hari kerja reguler.");
  }
}

class KaryawanKontrak extends Karyawan {
  String proyek;
  String periode;

  KaryawanKontrak(String nama, String idKaryawan, this.proyek, this.periode,
      {int? umur, String? peran})
      : super(nama, idKaryawan, umur: umur, peran: peran);

  @override
  void bekerja() {
    print(
        "Karyawan kontrak $nama (ID: $idKaryawan) bekerja pada proyek '$proyek' selama periode $periode.");
  }
}

class Manager extends Karyawan {
  Manager(String nama, String idKaryawan, {int? umur})
      : super(nama, idKaryawan, umur: umur, peran: "Manager");

  @override
  void bekerja() {
    print(
        "Manager $nama (ID: $idKaryawan) bertanggung jawab atas manajemen tim.");
  }
}

mixin Kinerja {
  int produktivitas = 75;

  void tingkatkanProduktivitas(int hari) {
    if (hari % 30 == 0) {
      produktivitas += 5;
      print(
          "Produktivitas meningkat sebesar 5 poin. Produktivitas saat ini: $produktivitas%");
    }
  }

  void cekProduktivitasManager() {
    if (this is Manager && produktivitas < 85) {
      produktivitas = 85;
      print(
          "Produktivitas Manager disesuaikan ke minimum 85. Produktivitas saat ini: $produktivitas%");
    }
  }
}

enum FaseProyek {
  Perencanaan,
  Pengembangan,
  Evaluasi,
}

class Proyek {
  FaseProyek fase = FaseProyek.Perencanaan;
  int karyawanAktif;
  int hariBerjalan;

  Proyek({required this.karyawanAktif, required this.hariBerjalan});

  void cekTransisiFase() {
    switch (fase) {
      case FaseProyek.Perencanaan:
        if (karyawanAktif >= 5) {
          fase = FaseProyek.Pengembangan;
          print("Proyek beralih ke fase Pengembangan.");
        } else {
          print(
              "Belum bisa beralih ke fase Pengembangan. Minimal 5 karyawan aktif diperlukan.");
        }
        break;

      case FaseProyek.Pengembangan:
        if (hariBerjalan > 45) {
          fase = FaseProyek.Evaluasi;
          print("Proyek beralih ke fase Evaluasi.");
        } else {
          print(
              "Belum bisa beralih ke fase Evaluasi. Proyek harus berjalan lebih dari 45 hari.");
        }
        break;

      case FaseProyek.Evaluasi:
        print(
            "Proyek sudah berada di fase Evaluasi. Tidak ada fase berikutnya.");
        break;
    }
  }

  void infoProyek() {
    print("Fase Proyek Saat Ini: $fase");
    print("Jumlah Karyawan Aktif: $karyawanAktif");
    print("Hari Berjalan: $hariBerjalan");
  }
}

void main() {
  // Membuat produk digital
  var produk1 =
      ProdukDigital("Sistem Manajemen Data", 150000, "DataManagement");
  var produk2 = ProdukDigital("NetworkAutomation", 250000, "NetworkAutomation");

  // Menerapkan diskon pada produk jika memenuhi syarat
  produk1.terapkanDiskon(
      35); // Tidak akan ada perubahan karena kategori bukan NetworkAutomation
  produk2.terapkanDiskon(60); // Diskon 15% akan diterapkan

  // Informasi produk setelah diskon
  print(
      "Nama Produk: ${produk1.namaProduk}, Harga setelah diskon: ${produk1.harga}");
  print(
      "Nama Produk: ${produk2.namaProduk}, Harga setelah diskon: ${produk2.harga}");

  // Membuat instance perusahaan
  var perusahaan = Perusahaan();

  // Menambahkan karyawan tetap
  var karyawan1 = KaryawanTetap("Budi", "KT001", umur: 30, peran: "Developer");
  var karyawan2 =
      KaryawanTetap("Siti", "KT002", umur: 28, peran: "Network Engineer");

  // Menambahkan karyawan kontrak
  var karyawan3 = KaryawanKontrak("Andi", "KC001", "Proyek A", "6 bulan",
      umur: 25, peran: "UI/UX Designer");

  // Menambahkan manager
  var manager1 = Manager("Lina", "M001", umur: 35);

  // Menambahkan karyawan ke dalam perusahaan
  perusahaan.tambahKaryawan(karyawan1);
  perusahaan.tambahKaryawan(karyawan2);
  perusahaan.tambahKaryawan(karyawan3);
  perusahaan.tambahKaryawan(manager1);

  // Melihat informasi karyawan di perusahaan
  perusahaan.infoKaryawan();

  // Manager bekerja dan cek produktivitas
  manager1.bekerja();
  manager1
      .cekProduktivitasManager(); // Menyesuaikan produktivitas minimum untuk Manager

  // Proyek perusahaan
  var proyek1 =
      Proyek(karyawanAktif: perusahaan.karyawanAktif.length, hariBerjalan: 10);

  // Informasi proyek sebelum transisi fase
  proyek1.infoProyek();
  proyek1
      .cekTransisiFase(); // Mencoba beralih fase proyek jika syarat terpenuhi

  // Menambah jumlah hari dan mengecek transisi fase
  proyek1.hariBerjalan = 50;
  proyek1.cekTransisiFase();

  // Karyawan resign dan memperbarui daftar karyawan
  perusahaan.karyawanResign(karyawan2);
  perusahaan.infoKaryawan();

  // Update dan cek info proyek setelah ada karyawan yang resign
  proyek1.karyawanAktif = perusahaan.karyawanAktif.length;
  proyek1.infoProyek();
}
