import 'dart:ffi';
import 'package:cashier/widget/formatter.dart';

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
  String? diskon;
  String? tipe_diskon;
  String? total_stok;

  ItemPenjualan(
      {this.produkHargaId,
      this.produkId,
      this.namaProduk,
      this.satuanTerkecil,
      this.netto,
      this.hargaJual,
      this.satuan,
      this.qty,
      this.isNew,
      this.diskon,
      this.tipe_diskon,
      this.total_stok});

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
    diskon = json['diskon'];
    tipe_diskon = json['tipe_diskon'];
    total_stok = json['total_stok'];
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
    data['diskon'] = this.diskon;
    data['tipe_diskon'] = this.tipe_diskon;
    data['total_stok'] = this.total_stok;

    return data;
  }

  int hitungSubtotal() {
    int hasil = 0;
    hasil =
        int.parse(this.qty.toString()) * int.parse(this.hargaJual.toString());

    if (int.parse(this.diskon.toString()) > 0) {
      if (this.tipe_diskon.toString() == 'persen') {
        int jumlahDiskon =
            (hasil * int.parse(this.diskon.toString()) / 100).round();
        hasil = hasil - jumlahDiskon;
      } else {
        hasil = hasil - int.parse(this.diskon.toString());
      }
    }
    return hasil;
  }

  String getLabelDiskon() {
    String hasil = '';
    if (int.parse(this.diskon.toString()) > 0) {
      hasil = ' Disc. ' +
          CurrencyFormat.convertToIdr(int.parse(this.diskon.toString()), 0);
      if (this.tipe_diskon.toString() == 'persen') {
        hasil = ' Disc. ' + this.diskon.toString() + '%';
      }
    }
    return hasil;
  }

  String getQtyLabel() {
    String hasil = '';

    hasil = this.qty.toString() +
        'x ' +
        CurrencyFormat.convertToIdr(int.parse(this.hargaJual.toString()), 0) +
        ' (' +
        this.satuan.toString() +
        ')';

    if (this.satuan.toString() == this.satuanTerkecil.toString()) {
      hasil = this.qty.toString() +
          'x ' +
          CurrencyFormat.convertToIdr(int.parse(this.hargaJual.toString()), 0);
    }
    return hasil;
  }

  String getNetto() {
    String result = '';
    double _netto = 0;
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

    result = CurrencyFormat.convertToIdr(int.parse(this.netto.toString()), 0) +
        ' ' +
        this.satuanTerkecil.toString();

    if (int.parse(this.netto.toString()) >= 1000) {
      _netto = int.parse(this.netto.toString()) / 1000;
      result = _netto.toString().replaceAll(regex, '') + ' KG';
    }
    return result;
  }

  void resetDiskon() {
    this.diskon = '0';
    this.tipe_diskon = 'nominal';
  }
}
