// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  return runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> data = {};

  Future<void> fetcherr() async {
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=9.025&longitude=38.7469&current=temperature_2m,rain&timezone=Europe%2FMoscow'));

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetcherr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/sky.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.blue.withOpacity(0.3), BlendMode.darken)),
      ),
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, index) {
            return Stack(children: [
              Center(
                child: ListTile(
                    title: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(179, 194, 193, 193),
                        borderRadius: BorderRadius.circular(20)),
                    height: 125,
                    child: Center(
                      child: Text(
                        'Temperature: ${data['current']['temperature_2m']} °C',
                      ),
                    ),
                  ),
                )),
              )
            ]);
          }),
    ));
  }
}
