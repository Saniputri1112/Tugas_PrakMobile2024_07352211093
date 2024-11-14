// Enum untuk Status Mahasiswa
enum StatusMahasiswa { aktif, cuti, alumni }

// Abstract class untuk kehadiran
abstract class Kehadiran {
  void absensi();
}

// Mixin untuk menambah fitur aktivitas organisasi
mixin AktivitasOrganisasi {
  void ikutOrganisasi(String organisasi) {
    print('Ikut dalam organisasi $organisasi');
  }
}

// Kelas dasar Mahasiswa
class Mahasiswa {
  String nama;
  String _npm;
  String jurusan;
  StatusMahasiswa status;

  // Constructor dengan positional argument untuk nama, npm, dan jurusan
  Mahasiswa(this.nama, this._npm, this.jurusan, this.status);

  // Getter dan Setter untuk NPM dengan validasi panjang karakter
  String get npm => _npm;
  set npm(String value) {
    if (value.length == 8) {
      _npm = value;
    } else {
      print('NPM harus 8 karakter.');
    }
  }

  // Metode belajar
  void belajar() {
    print('$nama sedang belajar.');
  }

  // Metode menyelesaikan tugas
  void menyelesaikanTugas() {
    print('$nama telah menyelesaikan tugas.');
  }

  // Metode cek status mahasiswa
  void cekStatus() {
    print('$nama memiliki status $status');
  }
}

// Kelas turunan MahasiswaAktif dengan inheritance dari Mahasiswa dan implementasi Kehadiran serta mixin AktivitasOrganisasi
class MahasiswaAktif extends Mahasiswa
    with AktivitasOrganisasi
    implements Kehadiran {
  int semester;

  // Constructor dengan inheritance dari superclass Mahasiswa
  MahasiswaAktif(String nama, String npm, String jurusan,
      StatusMahasiswa status, this.semester)
      : super(nama, npm, jurusan, status);

  // Implementasi metode absensi dari Kehadiran
  @override
  void absensi() {
    print('$nama telah hadir di kelas.');
  }

  // Metode khusus untuk mengambil KRS
  void ambilKRS() {
    print('$nama sedang mengambil KRS untuk semester $semester');
  }
}

// Fungsi utama untuk menjalankan program
void main() {
  // Membuat objek mahasiswa
  var mahasiswa = MahasiswaAktif(
      'Budi', '12345678', 'Informatika', StatusMahasiswa.aktif, 5);

  // Memanggil berbagai metode untuk menampilkan informasi
  mahasiswa.belajar();
  mahasiswa.menyelesaikanTugas();
  mahasiswa.absensi();
  mahasiswa.ambilKRS();
  mahasiswa.ikutOrganisasi('BEM');
  mahasiswa.cekStatus();
}
