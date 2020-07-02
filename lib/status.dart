import 'package:flutter/material.dart';

class Data {
  String name = 'null';
  String keyIn = 'null';
  String turnOn = 'null';
  String location = 'null';
  String speed = 'null';
  String oil = 'null';
  String tire = 'null';
  String inTemp = 'null';
  String engineTemp = 'null';
  Data();
  Data.fromJson(Map<String, dynamic> json) {
    this.name = json['userInfo'];
    this.keyIn = json['Key'].toString();
    this.turnOn = json['On'].toString();
    this.location = json['location'];
    this.speed = json['speed'];
    this.oil = json['oilVolume'];
    this.tire = json['tirePressure'];
    this.inTemp = json['indoorTemp'];
    this.engineTemp = json['engineTemp'];
  }
}

class Status extends StatelessWidget {
  final Color color;
  final String name;
  final String data;
  final bool align;
  Status(this.align, this.color, this.name, this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.5), spreadRadius: 3, blurRadius: 5),
        ],
      ),
      child: align // 決定排版方向
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(name, style: TextStyle(fontSize: 16)),
                Text(data, style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold)),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(name, style: TextStyle(fontSize: 16)),
                Text(data, style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold)),
              ],
            ),
    );
  }
}
