class PenjualanModel {
  int? status;
  List<HeaderPenjualan>? data;

  PenjualanModel({this.status, this.data});

  PenjualanModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <HeaderPenjualan>[];
      json['data'].forEach((v) {
        data!.add(new HeaderPenjualan.fromJson(v));
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

class HeaderPenjualan {
  String? penjualanId;
  String? totalBayar;
  String? metodePembayaran;
  String? statusPembayaran;
  String? midtransId;
  String? midtransStatus;
  String? tglDibuat;
  String? dibuatOleh;
  String? tglDiupdate;
  String? diupdateOleh;
  String? isDeleted;

  HeaderPenjualan(
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
      this.isDeleted});

  HeaderPenjualan.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
