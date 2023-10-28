import 'package:cashier/widget/formatter.dart';

class PenjualanViewModel {
  int? status;
  List<PenjualanHeader>? penjualanHeader;
  List<PenjualanDetail>? penjualanDetail;

  PenjualanViewModel({this.status, this.penjualanHeader, this.penjualanDetail});

  PenjualanViewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['penjualan_header'] != null) {
      penjualanHeader = <PenjualanHeader>[];
      json['penjualan_header'].forEach((v) {
        penjualanHeader!.add(new PenjualanHeader.fromJson(v));
      });
    }
    if (json['penjualan_detail'] != null) {
      penjualanDetail = <PenjualanDetail>[];
      json['penjualan_detail'].forEach((v) {
        penjualanDetail!.add(new PenjualanDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.penjualanHeader != null) {
      data['penjualan_header'] =
          this.penjualanHeader!.map((v) => v.toJson()).toList();
    }
    if (this.penjualanDetail != null) {
      data['penjualan_detail'] =
          this.penjualanDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PenjualanHeader {
  String? penjualanId;
  String? totalBayar;
  String? metodePembayaran;
  String? statusPembayaran;
  String? midtransId;
  String? midtransStatus;
  String? tglDibuat;
  String? dibuatOleh;
  Null? tglDiupdate;
  String? diupdateOleh;
  String? isDeleted;
  String? nama;

  PenjualanHeader(
      {this.penjualanId,
      this.totalBayar,
      this.metodePembayaran,
      this.statusPembayaran,
      this.midtransId,
      this.midtransStatus,
      this.tglDibuat,
      this.dibuatOleh,
      this.tglDiupdate,
      this.diupdateOleh,
      this.isDeleted,
      this.nama});

  PenjualanHeader.fromJson(Map<String, dynamic> json) {
    penjualanId = json['penjualan_id'];
    totalBayar = json['total_bayar'];
    metodePembayaran = json['metode_pembayaran'];
    statusPembayaran = json['status_pembayaran'];
    midtransId = json['midtrans_id'];
    midtransStatus = json['midtrans_status'];
    tglDibuat = json['tgl_dibuat'];
    dibuatOleh = json['dibuat_oleh'];
    tglDiupdate = json['tgl_diupdate'];
    diupdateOleh = json['diupdate_oleh'];
    isDeleted = json['is_deleted'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['penjualan_id'] = this.penjualanId;
    data['total_bayar'] = this.totalBayar;
    data['metode_pembayaran'] = this.metodePembayaran;
    data['status_pembayaran'] = this.statusPembayaran;
    data['midtrans_id'] = this.midtransId;
    data['midtrans_status'] = this.midtransStatus;
    data['tgl_dibuat'] = this.tglDibuat;
    data['dibuat_oleh'] = this.dibuatOleh;
    data['tgl_diupdate'] = this.tglDiupdate;
    data['diupdate_oleh'] = this.diupdateOleh;
    data['is_deleted'] = this.isDeleted;
    data['nama'] = this.nama;
    return data;
  }
}

class PenjualanDetail {
  String? namaProduk;
  String? satuanTerkecil;
  String? penjualanDetailId;
  String? penjualanId;
  String? produkId;
  String? produkHargaId;
  String? hargaBeli;
  String? hargaJual;
  String? qty;
  String? tipeDiskon;
  String? diskon;
  String? isDeleted;
  String? satuan;
  String? netto;

  PenjualanDetail(
      {this.namaProduk,
      this.satuanTerkecil,
      this.penjualanDetailId,
      this.penjualanId,
      this.produkId,
      this.produkHargaId,
      this.hargaBeli,
      this.hargaJual,
      this.qty,
      this.tipeDiskon,
      this.diskon,
      this.isDeleted,
      this.satuan,
      this.netto});

  PenjualanDetail.fromJson(Map<String, dynamic> json) {
    namaProduk = json['nama_produk'];
    satuanTerkecil = json['satuan_terkecil'];
    penjualanDetailId = json['penjualan_detail_id'];
    penjualanId = json['penjualan_id'];
    produkId = json['produk_id'];
    produkHargaId = json['produk_harga_id'];
    hargaBeli = json['harga_beli'];
    hargaJual = json['harga_jual'];
    qty = json['qty'];
    tipeDiskon = json['tipe_diskon'];
    diskon = json['diskon'];
    isDeleted = json['is_deleted'];
    satuan = json['satuan'];
    netto = json['netto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama_produk'] = this.namaProduk;
    data['satuan_terkecil'] = this.satuanTerkecil;
    data['penjualan_detail_id'] = this.penjualanDetailId;
    data['penjualan_id'] = this.penjualanId;
    data['produk_id'] = this.produkId;
    data['produk_harga_id'] = this.produkHargaId;
    data['harga_beli'] = this.hargaBeli;
    data['harga_jual'] = this.hargaJual;
    data['qty'] = this.qty;
    data['tipe_diskon'] = this.tipeDiskon;
    data['diskon'] = this.diskon;
    data['is_deleted'] = this.isDeleted;
    data['satuan'] = this.satuan;
    data['netto'] = this.netto;
    return data;
  }

  String getLabelNama() {
    String result;
    result = this.namaProduk.toString() +
        ' (' +
        CurrencyFormat.convertToIdr(int.parse(this.netto.toString()), 0) +
        ' ' +
        this.satuanTerkecil.toString() +
        ')';
    return result;
  }

  String getLabelQty() {
    String result;
    result = this.qty.toString() +
        'x ' +
        CurrencyFormat.convertToIdr(int.parse(this.hargaJual.toString()), 0);
    return result;
  }

  String getLabelDiskon() {
    String hasil = '';
    if (int.parse(this.diskon.toString()) > 0) {
      hasil = ' Disc. ' +
          CurrencyFormat.convertToIdr(int.parse(this.diskon.toString()), 0);
      if (this.tipeDiskon.toString() == 'persen') {
        hasil = ' Disc. ' + this.diskon.toString() + '%';
      }
    }
    return hasil;
  }

  String getSubtotalLabel() {
    String hasil;
    int subtotal = 0;
    subtotal =
        int.parse(this.qty.toString()) * int.parse(this.hargaJual.toString());

    if (int.parse(this.diskon.toString()) > 0) {
      if (this.tipeDiskon.toString() == 'persen') {
        int jumlahDiskon =
            (subtotal * int.parse(this.diskon.toString()) / 100).round();
        subtotal = subtotal - jumlahDiskon;
      } else {
        subtotal = subtotal - int.parse(this.diskon.toString());
      }
    }

    hasil = CurrencyFormat.convertToIdr(subtotal, 0);
    return hasil;
  }

  int getSubtotal() {
    int subtotal = 0;
    subtotal =
        int.parse(this.qty.toString()) * int.parse(this.hargaJual.toString());

    if (int.parse(this.diskon.toString()) > 0) {
      if (this.tipeDiskon.toString() == 'persen') {
        int jumlahDiskon =
            (subtotal * int.parse(this.diskon.toString()) / 100).round();
        subtotal = subtotal - jumlahDiskon;
      } else {
        subtotal = subtotal - int.parse(this.diskon.toString());
      }
    }

    return subtotal;
  }
}
