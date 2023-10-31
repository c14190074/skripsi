class ProdukRekomendasiModel {
  int? status;
  List<DataRekomendasi>? dataRekomendasi;

  ProdukRekomendasiModel({this.status, this.dataRekomendasi});

  ProdukRekomendasiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data_rekomendasi'] != null) {
      dataRekomendasi = <DataRekomendasi>[];
      json['data_rekomendasi'].forEach((v) {
        dataRekomendasi!.add(new DataRekomendasi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.dataRekomendasi != null) {
      data['data_rekomendasi'] =
          this.dataRekomendasi!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataRekomendasi {
  String? produkId;
  String? namaProduk;

  DataRekomendasi({this.produkId, this.namaProduk});

  DataRekomendasi.fromJson(Map<String, dynamic> json) {
    produkId = json['produk_id'];
    namaProduk = json['nama_produk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['produk_id'] = this.produkId;
    data['nama_produk'] = this.namaProduk;
    return data;
  }
}
