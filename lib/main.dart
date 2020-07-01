import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class Data {
  String name;
  bool keyIn;
  bool turnOn;
  String location;
  String speed;
  String oil;
  String tire;
  String inTemp;
  String engineTemp;
  Data();
  Data.fromJson(Map<String, dynamic> json) {
    this.name = json['userInfo'];
    this.keyIn = json['Key'];
    this.turnOn = json['On'];
    this.location = json['location'];
    this.speed = json['speed'];
    this.oil = json['oilVolumne'];
    this.tire = json['tirePressure'];
    this.inTemp = json['indoorTemp'];
    this.engineTemp = json['engineTemp'];
  }
}

class _MyAppState extends State<MyApp> {
  var mydata = Data();
  Timer timer;
  String userID = '';
  bool auth = false;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2),
        (Timer t) => print('ID: ' + userID + ' AU:' + auth.toString()));
  }

  Future _register() async {
    userID = textController.text;
    var url = 'http://misclicked.dynv6.net:3000/pair?id=' + userID;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        auth = json.decode(response.body)['status'] == 'success' ? true : false;
      });
    } else
      throw Exception('Failed to register');
  }

  Future _fetch() async {
    var url = 'http://misclicked.dynv6.net:3000/get?id=' + userID;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        mydata = Data.fromJson(json.decode(response.body));
      });
    } else
      throw Exception('Failed to fetch data');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomPadding: false, // 避免 bottom overflow
          appBar: AppBar(
            title: Text('老司機'),
          ),
          body: Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: 300,
                  margin: EdgeInsets.only(bottom: 50),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'userID',
                          hintText: '才不會告訴你是 1811',
                        ),
                        maxLength: 10,
                        controller: textController,
                      ),
                      RaisedButton(
                          onPressed: _register,
                          child: Text('Register'),
                          color: Colors.blue,
                          textColor: Colors.white),
                      auth
                          ? Text('已授權',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green))
                          : Text('未授權',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.red)),
                    ],
                  ),
                ),
                Text(
                  '車輛狀態',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text('用戶: ' + mydata.name.toString(),
                    style: TextStyle(fontSize: 16)),
                Text('鑰匙: ' + mydata.keyIn.toString(),
                    style: TextStyle(fontSize: 16)),
                Text('發動: ' + mydata.turnOn.toString(),
                    style: TextStyle(fontSize: 16)),
                Text('地點: ' + mydata.location.toString(),
                    style: TextStyle(fontSize: 16)),
                Text('車速: ' + mydata.speed.toString(),
                    style: TextStyle(fontSize: 16)),
                Text('油量: ' + mydata.oil.toString(),
                    style: TextStyle(fontSize: 16)),
                Text('胎壓: ' + mydata.tire.toString(),
                    style: TextStyle(fontSize: 16)),
                Text('車內溫度: ' + mydata.inTemp.toString(),
                    style: TextStyle(fontSize: 16)),
                Text('引擎溫度: ' + mydata.engineTemp.toString(),
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _fetch,
            child: Icon(Icons.sync),
          ),
        ),
      ),
    );
  }
}
