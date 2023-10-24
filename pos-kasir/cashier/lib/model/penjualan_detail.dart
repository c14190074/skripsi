import 'dart:ffi';

class ItemPenjualan {
  String? produkHargaId;
  String? produkId;
  String? namaProduk;
  String? satuanTerkecil;
  String? netto;
  String? hargaJual;
  String? satuan;
  String? qty;
  String? isNew;

  ItemPenjualan(
      {this.produkHargaId,
      this.produkId,
      this.namaProduk,
      this.satuanTerkecil,
      this.netto,
      this.hargaJual,
      this.satuan,
      this.qty,
      this.isNew});

  ItemPenjualan.fromJson(Map<String, dynamic> json) {
    produkHargaId = json['produk_harga_id'];
    produkId = json['produk_id'];
    namaProduk = json['nama_produk'];
    satuanTerkecil = json['satuan_terkecil'];
    netto = json['netto'];
    hargaJual = json['harga_jual'];
    satuan = json['satuan'];
    qty = json['qty'];
    isNew = json['isNew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['produk_harga_id'] = this.produkHargaId;
    data['produk_id'] = this.produkId;
    data['nama_produk'] = this.namaProduk;
    data['satuan_terkecil'] = this.satuanTerkecil;
    data['netto'] = this.netto;
    data['harga_jual'] = this.hargaJual;
    data['satuan'] = this.satuan;
    data['qty'] = this.qty;
    data['isNew'] = this.isNew;

    return data;
  }
}
