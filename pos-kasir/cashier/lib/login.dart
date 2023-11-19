import 'dart:io';
import 'dart:convert';
import 'package:cashier/kasir.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './widget/globals.dart' as globals;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController noTelpController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool _obscureText1 = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLogin();
  }

  void _togglevisibility() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  isLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString("user_id");
    var nama = prefs.getString("nama");
    var no_telp = prefs.getString("no_telp");
    print(user_id);
    if (user_id != null) {
      globals.namaKasir = nama.toString();
      globals.noTelp = no_telp.toString();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Kasir()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      Container(
                          child: Text(
                        'SMART POS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: TextField(
                    controller: noTelpController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      hintText: 'No Telp',
                      suffixIcon: Icon(Icons.phone),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: TextField(
                    obscureText: _obscureText1,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _togglevisibility();
                        },
                        child: Icon(
                          _obscureText1
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        elevation: 10,
                        clipBehavior: Clip.antiAlias,
                        child: MaterialButton(
                          minWidth: 200,
                          height: 50,
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: Color(0xff132137),
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            Map data = {
                              'no_telp': noTelpController.text,
                              'password': passwordController.text
                            };

                            var jsonResponse = null;
                            var api_url = globals.baseURL + 'user/login';
                            var response =
                                await http.post(Uri.parse(api_url), body: data);
                            jsonResponse = json.decode(response.body);
                            print(jsonResponse);
                            if (jsonResponse['status'] == 200) {
                              globals.namaKasir = jsonResponse['data']['nama'];
                              globals.noTelp = jsonResponse['data']['no_telp'];
                              prefs.setString(
                                  "user_token", jsonResponse['user_token']);
                              prefs.setString(
                                  "user_id", jsonResponse['data']['user_id']);
                              prefs.setString(
                                  "no_telp", jsonResponse['data']['no_telp']);
                              prefs.setString(
                                  "nama", jsonResponse['data']['nama']);
                              prefs.setString(
                                  "jabatan", jsonResponse['data']['jabatan']);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Kasir()));
                            } else {
                              if (jsonResponse['status'] == 403) {
                                const SnackBarMsg = SnackBar(
                                  content: Text('User sedang digunakan!'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBarMsg);
                              } else {
                                const SnackBarMsg = SnackBar(
                                  content:
                                      Text('Informasi login tidak sesuai!'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBarMsg);
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
