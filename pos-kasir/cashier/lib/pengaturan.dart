import 'package:cashier/navbar.dart';
import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({Key? key}) : super(key: key);

  @override
  _PengaturanState createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  bool printerStatus = false;
  @override
  void initState() {
    super.initState();
    getDevices();
    setState(() {});
    // setState(() {
    //   printerStatus = true;
    // });
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          key: _scaffoldKey,
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
                        // _scaffoldKey.currentState.showSnackBar(SnackBar(
                        //   content: Text(
                        //     'Welcome',
                        //   ),
                        //   duration: Duration(seconds: 2),
                        // ));
                        printer.connect(selectedDevice!);
                        setState(() {
                          printerStatus = true;
                        });
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

              // ElevatedButton(
              //     onPressed: () {
              //       printer.disconnect();
              //     },
              //     child: Text('Disconnect')),
              // ElevatedButton(
              //     onPressed: () async {
              //       if ((await printer.isConnected)!) {
              //         printer.printNewLine();
              //         printer.printCustom("Skripsi Tinggal 1 Langkah", 1, 1);
              //         printer.printCustom("Sebentar lagi Wisuda", 1, 1);
              //         printer.printQRcode("Agung Wibowo", 200, 200, 1);
              //         printer.printNewLine();
              //         printer.printNewLine();
              //         printer.printNewLine();
              //         printer.printNewLine();
              //         printer.printNewLine();
              //       }
              //     },
              //     child: Text('Print')),
            ]),
          )),
    );
  }
}
