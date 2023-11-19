import 'dart:ffi';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cashier/navbar.dart';
import 'package:cashier/widget/formatter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './widget/globals.dart' as globals;
import 'package:http/http.dart' as http;
import './model/penjualan_view_model.dart'
    show PenjualanHeader, PenjualanDetail, PenjualanViewModel;

class DetailPenjualan extends StatefulWidget {
  final String penjualan_id;

  const DetailPenjualan({Key? key, required this.penjualan_id})
      : super(key: key);

  @override
  _DetailPenjualanState createState() => _DetailPenjualanState();
}

class _DetailPenjualanState extends State<DetailPenjualan> {
  late Future<List<PenjualanDetail>> data_detail_penjualan;
  String tgl_transaksi = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      data_detail_penjualan = _getPenjualanDetail(widget.penjualan_id);
    });
  }

  Future<List<PenjualanHeader>> _getPenjualanHeader(
      String _penjualan_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? '0';
    var response = await http.get(Uri.parse(globals.baseURL +
        'penjualan/getheader/' +
        _penjualan_id +
        '/' +
        user_token));

    var json_response = json.decode(response.body);

    final result = json
        .decode(response.body)['penjualan_header']
        .cast<Map<String, dynamic>>();

    return result
        .map<PenjualanHeader>((json) => PenjualanHeader.fromJson(json))
        .toList();
  }

  Future<List<PenjualanDetail>> _getPenjualanDetail(
      String _penjualan_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? '0';
    var response = await http.get(Uri.parse(globals.baseURL +
        'penjualan/getdetail/' +
        _penjualan_id +
        '/' +
        user_token));

    var json_response = json.decode(response.body);
    tgl_transaksi = json_response['tgl_transaksi'];

    final result = json
        .decode(response.body)['penjualan_detail']
        .cast<Map<String, dynamic>>();

    return result
        .map<PenjualanDetail>((json) => PenjualanDetail.fromJson(json))
        .toList();
  }

  void cetakNota(int _total_belanja) async {
    final list_belanja = await data_detail_penjualan;

    BlueThermalPrinter printer = BlueThermalPrinter.instance;

    if ((await printer.isConnected)!) {
      printer.printNewLine();
      printer.printCustom('TOKO XYZ', 1, 1);
      printer.printCustom('JL. BASUKI RAHMAT 70, TUBAN', 1, 1);
      printer.printNewLine();
      printer.printCustom('KASIR: ' + globals.namaKasir, 1, 0);
      printer.printCustom('WAKTU: ' + tgl_transaksi, 1, 0);
      // printer.printNewLine();
      printer.printCustom('-----------------------------', 1, 1);
      printer.printNewLine();

      list_belanja.forEach((item) {
        String diskon_label = item.getLabelDiskon();
        String qty_label = item.getLabelQty();
        int subtotal = item.getSubtotal();

        String _satuan_terkecil = item.satuanTerkecil.toString();
        String _netto =
            CurrencyFormat.convertToIdr(int.parse(item.netto.toString()), 0);
        String netto_label = _netto + ' ' + _satuan_terkecil;
        String nama_produk_label =
            item.namaProduk.toString() + ' ' + netto_label;

        printer.printCustom(nama_produk_label, 1, 0);
        printer.printCustom(qty_label, 1, 0);

        if (diskon_label == '') {
          printer.printCustom(CurrencyFormat.convertToIdr(subtotal, 0), 1, 2);
        } else {
          printer.printCustom(diskon_label, 1, 0);
          printer.printCustom(CurrencyFormat.convertToIdr(subtotal, 0), 1, 2);
        }
      });

      String total_label =
          'Total ' + CurrencyFormat.convertToIdr(_total_belanja, 0);

      printer.printNewLine();
      printer.printCustom(total_label, 1, 2);
      printer.printNewLine();
      printer.printNewLine();
      printer.printCustom("TERIMA KASIH", 1, 1);
      printer.printCustom("SELAMAT BELANJA KEMBALI", 1, 1);

      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
    }
  }

  @override
  Widget build(BuildContext context) {
    int total_belanja = 0;
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Smart POS  | Detail Penjualan"),
          ),
          drawer: Navbar(),
          body: Container(
            // color: Colors.grey.shade200,
            padding: EdgeInsets.only(top: 20, right: 16, bottom: 16, left: 16),
            child: SingleChildScrollView(
              child: FutureBuilder<List<PenjualanHeader>>(
                  future: _getPenjualanHeader(widget.penjualan_id),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      // data harga berhasil didapat
                      List<PenjualanHeader>? header_penjualan = snapshot.data!;
                      if (header_penjualan.length > 0) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: header_penjualan.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              total_belanja = int.parse(header_penjualan[index]
                                  .totalBayar
                                  .toString());
                              return Container(
                                  child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Kasir: '),
                                              Text(header_penjualan[index]
                                                  .nama
                                                  .toString())
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text('Waktu: '),
                                              Text(header_penjualan[index]
                                                  .tglDibuat
                                                  .toString())
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text('Status Pembayaran: '),
                                              Text(
                                                header_penjualan[index]
                                                    .statusPembayaran
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: TextButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red, // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            ),
                                            onPressed: () {
                                              cetakNota(total_belanja);
                                            },
                                            child: Text('CETAK')),
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: FutureBuilder<List<PenjualanDetail>>(
                                        future: _getPenjualanDetail(
                                            widget.penjualan_id),
                                        builder:
                                            (BuildContext context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<PenjualanDetail>?
                                                detail_penjualan =
                                                snapshot.data!;
                                            if (detail_penjualan.length > 0) {
                                              return ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      detail_penjualan.length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                detail_penjualan[
                                                                        index]
                                                                    .getLabelNama(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(detail_penjualan[
                                                                          index]
                                                                      .getLabelQty()),
                                                                  Text(
                                                                    detail_penjualan[
                                                                            index]
                                                                        .getLabelDiskon(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          Text(
                                                            detail_penjualan[
                                                                    index]
                                                                .getSubtotalLabel(),
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            } else {
                                              return Text(
                                                  "Data tidak ditemukan");
                                            }
                                          } else {
                                            return Text("loading..");
                                          }
                                        }),
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Total Belanja: ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          CurrencyFormat.convertToIdr(
                                              total_belanja, 0),
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ));
                            });
                      } else {
                        return Text("Data tidak ditemukan");
                      }
                    } else {
                      return Text("loading..");
                    }
                  }),
            ),
          )),
    );
  }
}
