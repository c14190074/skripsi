class ProdukDiskonModel {
  int? status;
  List<DataDiskon>? data;

  ProdukDiskonModel({this.status, this.data});

  ProdukDiskonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DataDiskon>[];
      json['data'].forEach((v) {
        data!.add(new DataDiskon.fromJson(v));
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

class DataDiskon {
  String? produkId;
  String? namaProduk;
  String? produkDiskonId;
  String? tipeDiskon;
  String? nominal;
  String? tipeNominal;
  String? startDiskon;
  String? endDiskon;
  String? produkBundled;
  String? tglDibuat;
  String? dibuatOleh;
  String? tglDiupdate;
  String? diupdateOleh;
  String? isDeleted;

  DataDiskon(
      {this.produkId,
      this.namaProduk,
      this.produkDiskonId,
      this.tipeDiskon,
      this.nominal,
      this.tipeNominal,
      this.startDiskon,
      this.endDiskon,
      this.produkBundled,
      this.tglDibuat,
      this.dibuatOleh,
      this.tglDiupdate,
      this.diupdateOleh,
      this.isDeleted});

  DataDiskon.fromJson(Map<String, dynamic> json) {
    produkId = json['produk_id'];
    namaProduk = json['nama_produk'];
    produkDiskonId = json['produk_diskon_id'];
    tipeDiskon = json['tipe_diskon'];
    nominal = json['nominal'];
    tipeNominal = json['tipe_nominal'];
    startDiskon = json['start_diskon'];
    endDiskon = json['end_diskon'];
    produkBundled = json['produk_bundled'];
    tglDibuat = json['tgl_dibuat'];
    dibuatOleh = json['dibuat_oleh'];
    tglDiupdate = json['tgl_diupdate'];
    diupdateOleh = json['diupdate_oleh'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['produk_id'] = this.produkId;
    data['nama_produk'] = this.namaProduk;
    data['produk_diskon_id'] = this.produkDiskonId;
    data['tipe_diskon'] = this.tipeDiskon;
    data['nominal'] = this.nominal;
    data['tipe_nominal'] = this.tipeNominal;
    data['start_diskon'] = this.startDiskon;
    data['end_diskon'] = this.endDiskon;
    data['produk_bundled'] = this.produkBundled;
    data['tgl_dibuat'] = this.tglDibuat;
    data['dibuat_oleh'] = this.dibuatOleh;
    data['tgl_diupdate'] = this.tglDiupdate;
    data['diupdate_oleh'] = this.diupdateOleh;
    data['is_deleted'] = this.isDeleted;
    return data;
  }
}
