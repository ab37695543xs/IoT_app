import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import './status.dart';

main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Page());
  }
}

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  Data carStatus = Data();
  String userID = '';
  bool auth = false;
  final textController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // 定時執行
    Timer.periodic(Duration(seconds: 5), (timer) {
      print('ID:' + userID + ' AU:' + auth.toString());
    });
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (auth) _fetch();
    });
  }

  Future _register() async {
    // 顯示載入圖示
    setState(() {
      loading = true;
    });
    userID = textController.text;
    var url = 'http://misclicked01.ubddns.org:3000/pair?id=' + userID;
    print(url);
    try {
      final response = await http.get(url).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          auth =
              json.decode(response.body)['status'] == 'success' ? true : false;
          // 提示並清空車輛狀態
          if (!auth) {
            textController.text = '錯誤';
            carStatus = Data();
          }
        });
      } else
        throw Exception('Failed to register');
      // 顯示正常畫面
      setState(() {
        loading = false;
      });
    } on TimeoutException catch (_) {
      print('Timeout');
      exit(1);
    }
  }

  Future _fetch() async {
    var url = 'http://misclicked01.ubddns.org:3000/get?id=' + userID;
    print(url);
    try {
      final response = await http.get(url).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          carStatus = Data.fromJson(json.decode(response.body));
        });
      } else
        throw Exception('Failed to fetch data');
    } on TimeoutException catch (_) {
      print('Timeout');
      exit(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, // 避免 bottom overflow
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('老司機'),
      ),
      body: loading
          ? Center( // 載入圖示
              child: CircularProgressIndicator(),
            )
          : StaggeredGridView.count( // 格狀 layout
              primary: false,
              crossAxisCount: 4,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 10.0,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                Container(
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
                          ? Text('已登入',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green))
                          : Text('未登入',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.red)),
                    ],
                  ),
                ),
                Text(
                  '車輛狀態',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                Status(true, Colors.lightBlueAccent, '用戶', carStatus.name),
                Status(false, Colors.lightBlue, '鑰匙', carStatus.keyIn),
                Status(false, Colors.lightBlue, '發動', carStatus.turnOn),
                Status(true, Colors.lightBlue, '車速', carStatus.speed),
                Status(true, Colors.blue, '地點', carStatus.location),
                Status(false, Colors.blueAccent, '油量', carStatus.oil),
                Status(false, Colors.blueAccent, '胎壓', carStatus.tire),
                Status(false, Colors.blueAccent, '車內溫度', carStatus.inTemp),
                Status(false, Colors.blueAccent, '引擎溫度', carStatus.engineTemp),
              ],
              // 設定格子大小
              staggeredTiles: [
                StaggeredTile.extent(4, 200), // 註冊
                StaggeredTile.extent(2, 50), // 車輛狀態
                StaggeredTile.extent(2, 50), // 用戶
                StaggeredTile.count(1, 1), // 鑰匙
                StaggeredTile.count(1, 1), // 發動
                StaggeredTile.count(2, 1), // 車速
                StaggeredTile.count(4, 1), // 地點
                StaggeredTile.count(1, 1), // 油量
                StaggeredTile.count(1, 1), // 胎壓
                StaggeredTile.count(1, 1), // 車內溫度
                StaggeredTile.count(1, 1), // 引擎溫度
              ],
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _fetch,
      //   child: Icon(Icons.sync),
      // ),
    );
  }
}
