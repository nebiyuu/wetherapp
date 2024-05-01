// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyWetherApp extends StatefulWidget {
  const MyWetherApp({Key? key}) : super(key: key);

  @override
  State<MyWetherApp> createState() => _MyWetherAppState();
}

class _MyWetherAppState extends State<MyWetherApp> {
  Map<String, dynamic> mydata = {};
  double x = 9.025;
  double y = 38.7469;
  void fetcherr() async {
    try {
      final ress = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$x&longitude=$y&current=temperature_2m,is_day,rain&timezone=Europe%2FMoscow'));
      if (ress.statusCode == 200) {
        setState(() {
          mydata = jsonDecode(ress.body);
        });
      } else {
        throw Exception("error");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetcherr();
  }

  Image imageselector() {
    final wether = mydata['current']['temperature_2m'];
    if (wether >= 20) {
      return Image.asset('assets/sun.png');
    } else {
      return Image.asset('assets/sun.png');
    }
  }

  bool backgroundselector() {
    final day_night = mydata['current']['is_day'];
    if (day_night == 1) {
      ThemeData.dark();
      return true;
    } else {
      ThemeData.dark();
      return false;
    }
  }

  String greetings() {
    final day_night = mydata['current']['is_day'];
    if (day_night == 1) {
      return "Good Night";
    } else {
      return "Good morning";
    }
  }

  @override
  Widget build(BuildContext context) {
    final wether = mydata['current']['temperature_2m'];
    final raim = mydata['current']['rain'];
    final now = DateTime.now();
    final formattedTime = DateFormat('h:mm a').format(DateTime.now());
    final dayOfWeek = DateFormat('EEEE').format(now);

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Center(
              child: mydata.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Addis Abeba',
                                style: TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                              Text(
                                ' $dayOfWeek    $formattedTime',
                                style: const TextStyle(fontSize: 30),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 300,
                                child: imageselector(),
                              ),
                              const SizedBox(height: 100),
                              Text(
                                ' $wether °C ',
                                style: const TextStyle(fontSize: 30),
                              ),
                              Text(
                                greetings(),
                                style: const TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 70.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.grey, // Icon color
                                    ),
                                    Text("rain \n $raim mm"),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.sunny,
                                      color: Colors.grey, // Icon color
                                    ),
                                    Text("sunset \n $raim mm"),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.thermostat,
                                      color: Colors.grey, // Icon color
                                    ),
                                    Text("temparure \n $wether c"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            )));
  }
}
