import 'dart:convert';
import 'dart:ffi';

import 'package:cashier/pembayaran_midtrans.dart';
import 'package:cashier/widget/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:http/http.dart' as http;
import './widget/globals.dart' as globals;
import './model/produk_model.dart' show Data, ProdukModel;
import './model/produk_rekomendasi_model.dart'
    show DataRekomendasi, ProdukRekomendasiModel;
import './model/produk_harga_model.dart'
    show DataHarga, DataDiskon, ProdukHargaModel;
import './model/penjualan_detail.dart' show ItemPenjualan;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class FormPenjualan extends StatefulWidget {
  const FormPenjualan({Key? key}) : super(key: key);

  @override
  _FormPenjualanState createState() => _FormPenjualanState();
}

class _FormPenjualanState extends State<FormPenjualan> {
  ProdukModel? produkModel;
  List<ItemPenjualan> list_belanja = <ItemPenjualan>[];
  List<TextEditingController> _qty_controllers = [];
  List<ItemPenjualan> list_qty_produk = <ItemPenjualan>[];
  List<DataRekomendasi> list_rekomendasi = <DataRekomendasi>[];
  final TextEditingController inputNoTelp = new TextEditingController();
  final TextEditingController inputJumlahBayar = new TextEditingController();
  late Future<List<DataHarga>> data_produk_harga;

  int total_belanja = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllDataProduk();

    // setState(() {
    //   data_produk_harga = _getProdukHarga('0');
    // });
  }

  void _getAllDataProduk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? '0';
    var response = await http
        .get(Uri.parse(globals.baseURL + 'produk/getall/' + user_token));

    setState(() {
      produkModel = ProdukModel.fromJson(json.decode(response.body));
    });
  }

  void resetDiskon() {
    for (var i = 0; i < list_belanja.length; i++) {
      list_belanja[i].resetDiskon();
    }
  }

  void hitungTotalBelanja() async {
    resetDiskon();
    Map dataToSave = {
      "dataBelanja": json.encode(list_belanja.toList()),
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? '0';

    var jsonResponse = null;
    var api_url = globals.baseURL + 'penjualan/hitungdiskon/' + user_token;
    var response = await http.post(Uri.parse(api_url), body: dataToSave);
    jsonResponse = json.decode(response.body);
    // print(jsonResponse);

    int hasil = 0;
    if (jsonResponse['status'] == 200 && jsonResponse['data'].length > 0) {
      for (var i = 0; i < list_belanja.length; i++) {
        for (var j = 0; j < jsonResponse['data'].length; j++) {
          if (list_belanja[i].produkId.toString() ==
              jsonResponse['data'][j]['produk_id']) {
            list_belanja[i].diskon = jsonResponse['data'][j]['nominal'];
            list_belanja[i].tipe_diskon =
                jsonResponse['data'][j]['tipe_nominal'];
          }
        }

        int subtotal = list_belanja[i].hitungSubtotal();
        hasil += subtotal;
      }
    } else {
      hasil = 0;
      for (var i = 0; i < list_belanja.length; i++) {
        hasil += int.parse(list_belanja[i].qty.toString()) *
            int.parse(list_belanja[i].hargaJual.toString());
      }
    }

    setState(() {
      total_belanja = 0;
      total_belanja = hasil;
    });
  }

  void getRekomendasi() async {
    list_rekomendasi.clear();
    Map dataToSave = {
      "dataBelanja": json.encode(list_belanja.toList()),
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? '0';

    var jsonResponse = null;
    var api_url = globals.baseURL + 'penjualan/getsuggestion/' + user_token;
    var response = await http.post(Uri.parse(api_url), body: dataToSave);
    jsonResponse = json.decode(response.body);
    // print(jsonResponse);
    if (jsonResponse['status'] == 200) {
      for (var i = 0; i < jsonResponse['data_rekomendasi'].length; i++) {
        // print(jsonResponse['data_rekomendasi'][i]['nama_produk']);
        final itemRekomendasi = new DataRekomendasi();
        itemRekomendasi.produkId =
            jsonResponse['data_rekomendasi'][i]['produk_id'];
        itemRekomendasi.namaProduk =
            jsonResponse['data_rekomendasi'][i]['nama_produk'];
        itemRekomendasi.satuanTerkecil =
            jsonResponse['data_rekomendasi'][i]['satuan_terkecil'];

        setState(() {
          list_rekomendasi.add(itemRekomendasi);
        });
      }
    }
  }

  Future<void> _showInputNoTelp(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No Telp Pelanggan'),
            content: TextField(
              onChanged: (value) {},
              controller: inputNoTelp,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(hintText: "Contoh. 081321348877"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Batal');
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Ok');
                  submitOrderan('midtrans', inputNoTelp.text, '0');
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  Future<void> _showInputJumlahBayar(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Pembayaran Tunai'),
            content: TextField(
              onChanged: (value) {},
              controller: inputJumlahBayar,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(hintText: "Jumlah Bayar"),
            ),
            actions: <Widget>[
              TextButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey.shade600, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () async {
                  Navigator.pop(context, 'Batal');
                },
                child: const Text('Batal'),
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  Navigator.pop(context, 'Uang Pas');

                  submitOrderan('tunai', '', total_belanja.toString());
                },
                child: const Text('Uang Pas'),
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  Navigator.pop(context, 'Bayar');

                  submitOrderan('tunai', '', inputJumlahBayar.text);
                },
                child: const Text('Bayar'),
              ),
            ],
          );
        });
  }

  void submitOrderan(String metode_pembayaran, String no_telp_pelanggan,
      String jumlah_bayar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = await prefs.getString('user_id') ?? '0';
    String user_token = await prefs.getString('user_token') ?? '0';
    Map dataToSave = {
      "user_id": user_id,
      "dataBelanja": json.encode(list_belanja.toList()),
      "metode_pembayaran": metode_pembayaran,
      "no_telp_pelanggan": no_telp_pelanggan
    };

    var jsonResponse = null;
    var api_url = globals.baseURL + 'penjualan/simpanpenjualan/' + user_token;
    var response = await http.post(Uri.parse(api_url), body: dataToSave);
    jsonResponse = json.decode(response.body);
    print(jsonResponse);
    if (jsonResponse['status'] == 200) {
      cetakNota(jumlah_bayar, jsonResponse['tgl_transaksi']);
      if (metode_pembayaran == 'midtrans') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                MidtransPayment(midtrans_url: jsonResponse['midtrans_url'])));
      }
    } else {
      String pesanError = jsonResponse['msg'];
      final SnackBarMsg = SnackBar(
        content: Text(pesanError),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBarMsg);
    }
  }

  void cetakNota(String jumlah_bayar, String tgl_transaksi) async {
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
      for (var i = 0; i < list_belanja.length; i++) {
        String diskon_label = list_belanja[i].getLabelDiskon();
        String qty_label = list_belanja[i].getQtyLabel();
        int subtotal = list_belanja[i].hitungSubtotal();

        String _satuan_terkecil = list_belanja[i].satuanTerkecil.toString();
        String _netto = CurrencyFormat.convertToIdr(
            int.parse(list_belanja[i].netto.toString()), 0);
        String netto_label = _netto + ' ' + _satuan_terkecil;
        String nama_produk_label =
            list_belanja[i].namaProduk.toString() + ' ' + netto_label;

        printer.printCustom(nama_produk_label, 1, 0);
        printer.printCustom(qty_label, 1, 0);

        if (diskon_label == '') {
          printer.printCustom(CurrencyFormat.convertToIdr(subtotal, 0), 1, 2);
        } else {
          printer.printCustom(diskon_label, 1, 0);
          printer.printCustom(CurrencyFormat.convertToIdr(subtotal, 0), 1, 2);
        }
      }
      if (int.parse(jumlah_bayar) <= total_belanja) {
        jumlah_bayar = total_belanja.toString();
      }

      int uang_kembali = int.parse(jumlah_bayar.toString()) -
          int.parse(total_belanja.toString());

      String total_label =
          'Total ' + CurrencyFormat.convertToIdr(total_belanja, 0);
      String jumlah_bayar_label =
          'Bayar ' + CurrencyFormat.convertToIdr(int.parse(jumlah_bayar), 0);
      String uang_kembali_label =
          'Kembali ' + CurrencyFormat.convertToIdr(uang_kembali, 0);

      printer.printNewLine();
      printer.printCustom(total_label, 1, 2);
      printer.printCustom(jumlah_bayar_label, 1, 2);
      printer.printCustom(uang_kembali_label, 1, 2);
      printer.printNewLine();
      printer.printNewLine();
      printer.printCustom("TERIMA KASIH", 1, 1);
      printer.printCustom("SELAMAT BELANJA KEMBALI", 1, 1);

      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      setState(() {
        list_belanja.clear();
        hitungTotalBelanja();
        list_rekomendasi.clear();
        inputJumlahBayar.text = '';
      });
    }
  }

  Future<List<DataHarga>> _getProdukHarga(String produk_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? '0';

    var response = await http.get(Uri.parse(
        globals.baseURL + 'produk/getprice/' + produk_id + '/' + user_token));

    var json_response = await json.decode(response.body);
    final result = json_response['data'].cast<Map<String, dynamic>>();

    return result.map<DataHarga>((json) => DataHarga.fromJson(json)).toList();
  }

  Future<List<DataDiskon>> _getProdukDiskon(String produk_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_token = await prefs.getString('user_token') ?? '0';
    var response = await http.get(Uri.parse(globals.baseURL +
        'produk/getnewestdiskon/' +
        produk_id +
        '/' +
        user_token));

    var json_response = json.decode(response.body);

    final result =
        json.decode(response.body)['data_diskon'].cast<Map<String, dynamic>>();

    return result.map<DataDiskon>((json) => DataDiskon.fromJson(json)).toList();
  }

  Future<void> _showMyDialog(String nama_produk, String produk_id,
      String produk_harga_id, String qty, String satuan_terkecil) async {
    list_qty_produk.clear();
    _qty_controllers.clear();
    int indexInputQty = 0;
    return showDialog<void>(
        context: context,
        // barrierDismissible: false, // user must tap button!
        builder: (context) => AlertDialog(
              title: Text(nama_produk),
              content: Container(
                width: MediaQuery.of(context).size.width - 50,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FutureBuilder<List<DataHarga>>(
                          future: _getProdukHarga(produk_id),
                          // future: data_produk_harga,
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              // data harga berhasil didapat
                              List<DataHarga>? daftar_harga = snapshot.data!;
                              if (daftar_harga.length > 0) {
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: daftar_harga.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      bool displayItem = false;

                                      if (daftar_harga[index]
                                              .produkId
                                              .toString() ==
                                          produk_id) {
                                        displayItem = true;
                                        TextEditingController _qty_controller =
                                            TextEditingController();

                                        final produk_info = new ItemPenjualan();
                                        produk_info.produkId =
                                            daftar_harga[index].produkId;
                                        produk_info.produkHargaId =
                                            daftar_harga[index].produkHargaId;
                                        produk_info.namaProduk = nama_produk;
                                        produk_info.satuanTerkecil =
                                            satuan_terkecil;
                                        produk_info.netto =
                                            daftar_harga[index].netto;
                                        produk_info.hargaJual =
                                            daftar_harga[index].hargaJual;
                                        produk_info.satuan =
                                            daftar_harga[index].satuan;
                                        produk_info.qty = "0";
                                        produk_info.isNew = "1";
                                        produk_info.diskon = "0";
                                        produk_info.tipe_diskon = 'nominal';

                                        if (produk_harga_id ==
                                            produk_info.produkHargaId) {
                                          produk_info.qty = qty;
                                          produk_info.isNew = "0";
                                        }

                                        list_qty_produk.add(produk_info);

                                        _qty_controllers.add(_qty_controller);
                                        _qty_controllers[
                                                _qty_controllers.length - 1]
                                            .text = "0";

                                        if (produk_harga_id ==
                                            produk_info.produkHargaId) {
                                          _qty_controllers[
                                                  _qty_controllers.length - 1]
                                              .text = qty;
                                        }
                                      } else {
                                        displayItem = false;
                                      }

                                      if (!displayItem) {
                                        return Container();
                                      } else {
                                        indexInputQty += 1;
                                        int indexInputQtyPrev =
                                            _qty_controllers.length - 1;

                                        return Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            padding: EdgeInsets.only(bottom: 5),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(CurrencyFormat
                                                        .convertToIdr(
                                                            int.parse(
                                                                daftar_harga[
                                                                        index]
                                                                    .hargaJual
                                                                    .toString()),
                                                            0)),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(daftar_harga[index]
                                                            .satuan
                                                            .toString() +
                                                        ' (' +
                                                        CurrencyFormat.convertToIdr(
                                                            int.parse(
                                                                daftar_harga[
                                                                        index]
                                                                    .netto
                                                                    .toString()),
                                                            0) +
                                                        ' ' +
                                                        satuan_terkecil +
                                                        ')'),
                                                  ],
                                                ),
                                                Text("x"),
                                                Container(
                                                  width: 75.0,
                                                  foregroundDecoration:
                                                      BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: TextFormField(
                                                          textAlign:
                                                              TextAlign.center,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                          ),
                                                          controller:
                                                              _qty_controllers[
                                                                  indexInputQtyPrev],
                                                          keyboardType:
                                                              TextInputType
                                                                  .numberWithOptions(
                                                            decimal: false,
                                                            signed: true,
                                                          ),
                                                          inputFormatters: <
                                                              TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 60.0,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border(
                                                                  bottom:
                                                                      BorderSide(
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                              ),
                                                              child: InkWell(
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_drop_up,
                                                                  size: 28.0,
                                                                ),
                                                                onTap: () {
                                                                  int currentValue =
                                                                      int.parse(
                                                                          _qty_controllers[indexInputQtyPrev]
                                                                              .text);
                                                                  setState(() {
                                                                    currentValue++;
                                                                    _qty_controllers[indexInputQtyPrev]
                                                                            .text =
                                                                        (currentValue)
                                                                            .toString();
                                                                    list_qty_produk[indexInputQtyPrev]
                                                                            .qty =
                                                                        currentValue
                                                                            .toString(); // incrementing value
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            InkWell(
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                size: 28.0,
                                                              ),
                                                              onTap: () {
                                                                int currentValue =
                                                                    int.parse(_qty_controllers[
                                                                            indexInputQtyPrev]
                                                                        .text);
                                                                setState(() {
                                                                  currentValue--;
                                                                  _qty_controllers[
                                                                          indexInputQtyPrev]
                                                                      .text = (currentValue >
                                                                              0
                                                                          ? currentValue
                                                                          : 0)
                                                                      .toString();
                                                                  list_qty_produk[
                                                                              indexInputQtyPrev]
                                                                          .qty =
                                                                      currentValue
                                                                          .toString(); // decrementing value
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ));
                                      }
                                    });
                              } else {
                                return Text("Data tidak ditemukan");
                              }
                            } else {
                              return Text("loading..");
                            }
                          }),
                      FutureBuilder<List<DataDiskon>>(
                          future: _getProdukDiskon(produk_id),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              List<DataDiskon>? daftar_diskon = snapshot.data!;
                              if (daftar_diskon.length > 0) {
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: daftar_diskon.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        child: Text(daftar_diskon[index]
                                            .listDiskon
                                            .toString()),
                                      );
                                    });
                              } else {
                                return Text("");
                              }
                            } else {
                              return Text("");
                            }
                          }),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () => Navigator.pop(context, 'Tutup'),
                  child: const Text('Tutup'),
                ),
                ElevatedButton(
                  child: const Text('Tambahkan'),
                  onPressed: () {
                    for (var i = 0; i < list_qty_produk.length; i++) {
                      if (int.parse(list_qty_produk[i].qty.toString()) > 0) {
                        final indexTarget = list_belanja.indexWhere((element) =>
                            element.produkHargaId ==
                            list_qty_produk[i].produkHargaId);
                        if (indexTarget > -1) {
                          // untuk update qty
                          int newQty = int.parse(
                                  list_belanja[indexTarget].qty.toString()) +
                              int.parse(list_qty_produk[i].qty.toString());

                          if (list_qty_produk[i].isNew == "0") {
                            newQty =
                                int.parse(list_qty_produk[i].qty.toString());
                          }
                          list_belanja[indexTarget].qty = newQty.toString();
                        } else {
                          // untuk add produ
                          list_belanja.add(list_qty_produk[i]);
                        }
                      }
                    }

                    list_qty_produk.clear();
                    _qty_controllers.clear();
                    hitungTotalBelanja();
                    getRekomendasi();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  } // end of _showMyDialog

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double newheight = height - padding.top - padding.bottom - 350;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 10, right: 16, bottom: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border(bottom: BorderSide(color: Colors.grey))),
            //   padding: EdgeInsets.only(top: 5, bottom: 15),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [Text('FormPenjualan: Stephanie'), Text('07 Oct 2023 12:27')],
            //   ),
            // ),
            Container(
              child: Autocomplete<Data>(
                optionsBuilder: (TextEditingValue value) {
                  if (value.text.isEmpty) {
                    return List.empty();
                  }
                  return produkModel!.data!
                      .where((element) => element.namaProduk!
                          .toLowerCase()
                          .contains(value.text.toLowerCase()))
                      .toList();
                },
                fieldViewBuilder: (BuildContext context,
                        TextEditingController controller,
                        FocusNode node,
                        Function onSubmit) =>
                    TextField(
                  controller: controller,
                  focusNode: node,
                  decoration: InputDecoration(hintText: 'Cari barang..'),
                ),
                optionsViewBuilder: (BuildContext context, Function onSelect,
                    Iterable<Data> dataList) {
                  return Material(
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 15),
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          Data d = dataList.elementAt(index);

                          return InkWell(
                              onTap: () => onSelect(d),
                              child: Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(d.namaProduk!)));
                        }),
                  );
                },
                onSelected: (value) => setState(() {
                  _showMyDialog(
                      value.namaProduk.toString().toUpperCase(),
                      value.produkId.toString(),
                      "0",
                      "0",
                      value.satuanTerkecil.toString());
                }),
                displayStringForOption: (Data d) => '',
              ),
            ),
            Container(
              // color: Colors.grey,
              width: MediaQuery.of(context).size.width,
              height: newheight,
              padding: EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: list_belanja.length,
                    itemBuilder: (BuildContext context, int index) {
                      String _produkId =
                          list_belanja[index].produkId.toString();
                      String _namaProduk =
                          list_belanja[index].namaProduk.toString();
                      String _produkHargaId =
                          list_belanja[index].produkHargaId.toString();
                      String _qty = list_belanja[index].qty.toString();
                      String _satuan_terkecil =
                          list_belanja[index].satuanTerkecil.toString();

                      String _netto = CurrencyFormat.convertToIdr(
                          int.parse(list_belanja[index].netto.toString()), 0);
                      int subtotal = list_belanja[index].hitungSubtotal();
                      String diskon_label =
                          list_belanja[index].getLabelDiskon();
                      String qty_label = list_belanja[index].getQtyLabel();

                      // slidable item
                      return Slidable(
                        // Specify a key if the Slidable is dismissible.
                        key: const ValueKey(0),

                        // The start action pane is the one at the left or the top side.
                        startActionPane: ActionPane(
                          extentRatio: 0.2,
                          // A motion is a widget used to control how the pane animates.
                          motion: const ScrollMotion(),

                          // A pane can dismiss the Slidable.
                          // dismissible: DismissiblePane(onDismissed: () {}),

                          // All actions are defined in the children parameter.
                          children: [
                            // A SlidableAction can have an icon and/or a label.
                            SlidableAction(
                              onPressed: (context) {
                                setState(() {
                                  list_belanja.removeWhere((element) =>
                                      element.produkHargaId == _produkHargaId);
                                  hitungTotalBelanja();
                                  getRekomendasi();
                                });
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),

                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          extentRatio: 0.2,
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              // An action can be bigger than the others.
                              flex: 2,
                              onPressed: (context) {
                                _showMyDialog(_namaProduk, _produkId,
                                    _produkHargaId, _qty, _satuan_terkecil);
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),

                        // The child of the Slidable is what the user sees when the
                        // component is not dragged.
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            // decoration: BoxDecoration(
                            // border: Border(
                            //     bottom: BorderSide(color: Colors.black26))),
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list_belanja[index]
                                              .namaProduk
                                              .toString() +
                                          ' (' +
                                          _netto +
                                          ' ' +
                                          _satuan_terkecil +
                                          ')',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(qty_label),
                                        Text(
                                          diskon_label,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Text(
                                  CurrencyFormat.convertToIdr(subtotal, 0),
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            )),
                      );
                      // end of slidable item
                    }),
              ),
            ),
            Container(
              // color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total Belanja: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    CurrencyFormat.convertToIdr(total_belanja, 0),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Produk yang mungkin dibeli: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 30,
                    child: ListView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        // shrinkWrap: true,
                        itemCount: list_rekomendasi.length,
                        itemBuilder: (BuildContext context, int index) {
                          int bg_item_rek = 700 - (index * 100);
                          return InkWell(
                            onTap: () {
                              _showMyDialog(
                                  list_rekomendasi[index].namaProduk.toString(),
                                  list_rekomendasi[index].produkId.toString(),
                                  "0",
                                  "0",
                                  list_rekomendasi[index]
                                      .satuanTerkecil
                                      .toString());
                            },
                            child: Container(
                              width: 130,
                              color: Colors.purple[bg_item_rek],
                              child: Center(
                                  child: Text(
                                list_rekomendasi[index].namaProduk.toString(),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              )),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (list_belanja.length > 0) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Konfirmasi'),
                        content: const Text(
                            'Apakah anda yakin untuk memproses orderan ini?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Tidak'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context, 'Ya');

                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    // title: const Text('Konfirmasi'),
                                    content: Container(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      const Text('Pilih metode pembayaran: '),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context, 'Tunai');
                                                _showInputJumlahBayar(context);
                                              },
                                              child: const Text('Tunai'),
                                              style: ElevatedButton.styleFrom(
                                                primary:
                                                    Colors.red, // background
                                                onPrimary:
                                                    Colors.white, // foreground
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: TextButton(
                                              onPressed: () async {
                                                Navigator.pop(
                                                    context, 'Midtrans');
                                                _showInputNoTelp(context);
                                              },
                                              child: const Text('Midtrans'),
                                              style: ElevatedButton.styleFrom(
                                                primary:
                                                    Colors.blue, // background
                                                onPrimary:
                                                    Colors.white, // foreground
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              );
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    const SnackBarMsg = SnackBar(
                      content: Text('Silahkan pilih produk terlebih dahulu!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBarMsg);
                  }
                },
                child: const Text('Bayar'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
