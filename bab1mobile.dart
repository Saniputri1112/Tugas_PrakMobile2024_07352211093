enum Role { Admin, Customer }

class User {
  String name;
  int age;
  late List<Product>? products;
  Role? peran;

  User(this.name, this.age, {this.products, this.peran});
}

class Product {
  String productName;
  double price;
  bool inStock;

  Product(this.productName, this.price, this.inStock);
}

class adminUser extends User {
  adminUser(String name, int age) : super(name, age, peran: Role.Admin);

  void tambahProduk(Product produk) {
    products ??= [];
    // Menggunakan Set untuk memastikan keunikan produk berdasarkan nama
    Set<String> namaProdukSet = {for (var item in products!) item.productName};
    if (!namaProdukSet.contains(produk.productName)) {
      if (produk.inStock) {
        products!.add(produk);
        print("Produk '${produk.productName}' ditambahkan.");
      } else {
        print("Produk '${produk.productName}' tidak tersedia.");
      }
    } else {
      print("Produk '${produk.productName}' sudah ada di daftar.");
    }
  }

  void hapusProduk(String productName) {
    products ??= [];
    products!.removeWhere((produk) => produk.productName == productName);
    print("Produk '$productName' dihapus.");
  }
}

class CustomerUser extends User {
  CustomerUser(String name, int age) : super(name, age, peran: Role.Customer);

  void lihatProduk() {
    products ??= [];
    if (products!.isEmpty) {
      print("Tidak ada produk yang tersedia.");
    } else {
      print("Daftar Produk:");
      for (var produk in products!) {
        print(
            "- ${produk.productName} (Rp ${produk.price}) - ${produk.inStock ? "Tersedia" : "Tidak Tersedia"}");
      }
    }
  }
}

void exceptionHandling(User user, Product produk) {
  try {
    if (!produk.inStock) {
      throw ("Produk tidak tersedia.");
    }
    if (user is adminUser) {
      user.tambahProduk(produk);
    } else {
      print("Hanya Admin yang dapat menambah produk.");
    }
  } catch (e) {
    print("Kesalahan : $e");
  }
}

Future<Product> fetchProductDetails(String productName) async {
  await Future.delayed(Duration(seconds: 1)); // Simulasi penundaan
  return Product(productName, 100.0, true); // Contoh produk yang diambil
}

void main() async {
  // Daftar produk menggunakan Map
  Map<String, Product> petaProduk = {
    "Laptop": Product("Laptop", 1500.0, true),
    "Mouse": Product("Mouse", 25.0, false),
  };

  // Pengguna Admin
  adminUser admin = adminUser("Sani", 25);
  exceptionHandling(admin, petaProduk["Laptop"]!);
  exceptionHandling(admin, petaProduk["Mouse"]!);
  exceptionHandling(admin, petaProduk["Laptop"]!); // Uji keunikan produk

  // Pengguna Customer
  CustomerUser customer = CustomerUser("Putri", 22);
  customer.products = admin.products;
  customer.lihatProduk();

  // Contoh asinkron menggunakan fetchProductDetails()
  Product produkBaru = await fetchProductDetails("Keyboard");
  admin.tambahProduk(produkBaru);
  customer.lihatProduk();
}
