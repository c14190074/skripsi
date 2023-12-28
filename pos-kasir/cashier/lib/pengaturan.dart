// ignore_for_file: unused_import

import 'package:cashier/kasir.dart';
import 'package:cashier/navbar.dart';
import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import './widget/globals.dart' as globals;

class Pengaturan extends StatefulWidget {
  const Pengaturan({Key? key}) : super(key: key);

  @override
  _PengaturanState createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  bool printerStatus = false;
  String? printerName = '';
  @override
  void initState() {
    super.initState();
    getDevices();
    cekStatusPrinter();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  void cekStatusPrinter() async {
    if ((await printer.isConnected)!) {
      setState(() {
        printerStatus = true;
        for (var device in devices) {
          if (device.name == globals.printerName) {
            selectedDevice = device;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          key: _globalKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Smart POS  | Printer"),
          ),
          drawer: Navbar(),
          body: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.shade200,
            padding: EdgeInsets.only(top: 20, right: 16, bottom: 16, left: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Pilih Printer: "),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<BluetoothDevice>(
                      value: selectedDevice,
                      hint: const Text('Select printer'),
                      items: devices
                          .map((e) => DropdownMenuItem(
                                child: Text(e.name!),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (device) {
                        setState(() {
                          selectedDevice = device;
                        });
                      }),
                  ElevatedButton(
                      onPressed: () async {
                        if (selectedDevice != null) {
                          if ((await printer.isConnected)!) {
                            setState(() {
                              printerStatus = true;
                              printerName = selectedDevice?.name.toString();
                              globals.printerName = printerName!;
                            });
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Koneksi Printer'),
                                content: const Text('Printer sudah terhubung!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            printer.connect(selectedDevice!);
                            setState(() {
                              printerStatus = true;
                              printerName = selectedDevice?.name.toString();
                              globals.printerName = printerName!;
                            });

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Kasir()));
                          }
                        } else {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Koneksi Printer'),
                              content: const Text('Silahkan pilih printer !'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text('Connect')),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Status Printer: "),
                  Text(printerStatus ? 'Connected' : 'Disconnected')
                ],
              ),
            ]),
          )),
    );
  }
}
