import 'dart:convert';
import 'package:cashier/detail_penjualan.dart';
import 'package:intl/intl.dart';
import 'package:cashier/navbar.dart';
import 'package:cashier/widget/formatter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './widget/globals.dart' as globals;
import './model/penjualan_view_model.dart'
    show PenjualanHeader, PenjualanDetail, PenjualanViewModel;

class ListPenjualan extends StatefulWidget {
  const ListPenjualan({Key? key}) : super(key: key);

  @override
  _ListPenjualanState createState() => _ListPenjualanState();
}

class _ListPenjualanState extends State<ListPenjualan> {
  TextEditingController dateinput = TextEditingController();
  late Future<List<PenjualanHeader>> data_penjualan;

  @override
  void initState() {
    // TODO: implement initState
    dateinput.text = "";
    super.initState();

    setState(() {
      data_penjualan = _getAllDataPenjualan('1');
    });
  }

  Future<List<PenjualanHeader>> _getAllDataPenjualan(String date_filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = await prefs.getString('user_id') ?? '0';
    var response = await http.get(Uri.parse(
        globals.baseURL + 'penjualan/getall/' + user_id + '/' + date_filter));

    var json_response = json.decode(response.body);

    final result =
        json.decode(response.body)['data'].cast<Map<String, dynamic>>();

    return result
        .map<PenjualanHeader>((json) => PenjualanHeader.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Smart POS  | Daftar Penjualan"),
          ),
          drawer: Navbar(),
          body: Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.only(top: 20, right: 16, bottom: 16, left: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Text("Pilih Tanggal: "),
                      Container(
                          child: TextField(
                        controller:
                            dateinput, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "Enter Date" //label text of field
                            ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              dateinput.text = formattedDate;
                              data_penjualan = _getAllDataPenjualan(dateinput
                                  .text); //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<List<PenjualanHeader>>(
                      // future: _getAllDataPenjualan(),
                      future: data_penjualan,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          // data harga berhasil didapat
                          List<PenjualanHeader>? daftar_penjualan =
                              snapshot.data!;
                          if (daftar_penjualan.length > 0) {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: daftar_penjualan.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      color: Colors.white,
                                      margin: EdgeInsets.only(bottom: 15),
                                      padding: EdgeInsets.only(
                                          bottom: 10,
                                          left: 10,
                                          top: 10,
                                          right: 10),
                                      // decoration: BoxDecoration(

                                      //     border: Border(
                                      //         bottom:
                                      //             BorderSide(color: Colors.grey))),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPenjualan(
                                                          penjualan_id:
                                                              daftar_penjualan[
                                                                      index]
                                                                  .penjualanId
                                                                  .toString())));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  CurrencyFormat.convertToIdr(
                                                      int.parse(
                                                          daftar_penjualan[
                                                                  index]
                                                              .totalBayar
                                                              .toString()),
                                                      0),
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Text('Kasir: ' +
                                                    globals.namaKasir),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      daftar_penjualan[index]
                                                          .tglDibuat
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade600),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 3,
                                                                bottom: 3),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Color.fromARGB(
                                                              255, 58, 221, 64),
                                                        ),
                                                        child: Text(
                                                          daftar_penjualan[
                                                                  index]
                                                              .statusPembayaran
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                    // Text('Bella')
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Icon(Icons.settings)
                                          ],
                                        ),
                                      ));
                                });
                          } else {
                            return Text("Data tidak ditemukan");
                          }
                        } else {
                          return Text("loading..");
                        }
                      }),
                ],
              ),
            ),
          )),
    );
  }
}
