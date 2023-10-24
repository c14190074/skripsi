class ProdukHargaModel {
  int? status;
  List<DataHarga>? data;
  List<DataDiskon>? dataDiskon;

  ProdukHargaModel({this.status, this.data, this.dataDiskon});

  ProdukHargaModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DataHarga>[];
      json['data'].forEach((v) {
        data!.add(new DataHarga.fromJson(v));
      });
    }
    if (json['data_diskon'] != null) {
      dataDiskon = <DataDiskon>[];
      json['data_diskon'].forEach((v) {
        dataDiskon!.add(new DataDiskon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.dataDiskon != null) {
      data['data_diskon'] = this.dataDiskon!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataHarga {
  String? produkHargaId;
  String? produkId;
  String? satuan;
  String? netto;
  String? hargaBeli;
  String? hargaJual;
  String? tglDibuat;
  String? dibuatOleh;
  Null? tglDiupdate;
  String? diupdateOleh;
  String? isDeleted;
  String? namaProduk;
  String? satuanTerkecil;

  DataHarga(
      {this.produkHargaId,
      this.produkId,
      this.satuan,
      this.netto,
      this.hargaBeli,
      this.hargaJual,
      this.tglDibuat,
      this.dibuatOleh,
      this.tglDiupdate,
      this.diupdateOleh,
      this.isDeleted,
      this.namaProduk,
      this.satuanTerkecil});

  DataHarga.fromJson(Map<String, dynamic> json) {
    produkHargaId = json['produk_harga_id'];
    produkId = json['produk_id'];
    satuan = json['satuan'];
    netto = json['netto'];
    hargaBeli = json['harga_beli'];
    hargaJual = json['harga_jual'];
    tglDibuat = json['tgl_dibuat'];
    dibuatOleh = json['dibuat_oleh'];
    tglDiupdate = json['tgl_diupdate'];
    diupdateOleh = json['diupdate_oleh'];
    isDeleted = json['is_deleted'];
    namaProduk = json['nama_produk'];
    satuanTerkecil = json['satuan_terkecil'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['produk_harga_id'] = this.produkHargaId;
    data['produk_id'] = this.produkId;
    data['satuan'] = this.satuan;
    data['netto'] = this.netto;
    data['harga_beli'] = this.hargaBeli;
    data['harga_jual'] = this.hargaJual;
    data['tgl_dibuat'] = this.tglDibuat;
    data['dibuat_oleh'] = this.dibuatOleh;
    data['tgl_diupdate'] = this.tglDiupdate;
    data['diupdate_oleh'] = this.diupdateOleh;
    data['is_deleted'] = this.isDeleted;
    data['nama_produk'] = this.namaProduk;
    data['satuan_terkecil'] = this.satuanTerkecil;
    return data;
  }
}

class DataDiskon {
  String? listDiskon;

  DataDiskon({this.listDiskon});

  DataDiskon.fromJson(Map<String, dynamic> json) {
    listDiskon = json['list_diskon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list_diskon'] = this.listDiskon;
    return data;
  }
}
