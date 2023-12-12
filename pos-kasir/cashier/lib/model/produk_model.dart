class ProdukModel {
  int? status;
  List<Data>? data;

  ProdukModel({this.status, this.data});

  ProdukModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? produkId;
  String? supplierId;
  String? kategoriId;
  String? namaProduk;
  String? satuanTerkecil;
  String? netto;
  String? stokMin;
  String? totalStok;
  String? tglDibuat;
  String? dibuatOleh;
  String? tglDiupdate;
  String? diupdateOleh;
  String? isDeleted;

  Data(
      {this.produkId,
      this.supplierId,
      this.kategoriId,
      this.namaProduk,
      this.satuanTerkecil,
      this.netto,
      this.stokMin,
      this.totalStok,
      this.tglDibuat,
      this.dibuatOleh,
      this.tglDiupdate,
      this.diupdateOleh,
      this.isDeleted});

  Data.fromJson(Map<String, dynamic> json) {
    produkId = json['produk_id'];
    supplierId = json['supplier_id'];
    kategoriId = json['kategori_id'];
    namaProduk = json['nama_produk'];
    satuanTerkecil = json['satuan_terkecil'];
    netto = json['netto'];
    stokMin = json['stok_min'];
    totalStok = json['total_stok'];
    tglDibuat = json['tgl_dibuat'];
    dibuatOleh = json['dibuat_oleh'];
    tglDiupdate = json['tgl_diupdate'];
    diupdateOleh = json['diupdate_oleh'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['produk_id'] = this.produkId;
    data['supplier_id'] = this.supplierId;
    data['kategori_id'] = this.kategoriId;
    data['nama_produk'] = this.namaProduk;
    data['satuan_terkecil'] = this.satuanTerkecil;
    data['netto'] = this.netto;
    data['stok_min'] = this.stokMin;
    data['total_stok'] = this.totalStok;
    data['tgl_dibuat'] = this.tglDibuat;
    data['dibuat_oleh'] = this.dibuatOleh;
    data['tgl_diupdate'] = this.tglDiupdate;
    data['diupdate_oleh'] = this.diupdateOleh;
    data['is_deleted'] = this.isDeleted;
    return data;
  }
}
