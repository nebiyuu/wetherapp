// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> data = {};

  Future<void> fetcherr() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=9.025&longitude=38.7469&daily=temperature_2m_max&wind_speed_unit=ms&timezone=Europe%2FMoscow'));

      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
          print('Data fetched successfully: ');
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: ');
    }
  }

  @override
  void initState() {
    super.initState();
    fetcherr();
  }

  String getDayOfWeek(String dateString) {
    List<String> dateParts = dateString.split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    DateTime dateTime = DateTime(year, month, day);

    List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[dateTime.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: const AssetImage("assets/sky.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.blue.withOpacity(0.0), BlendMode.darken)),
      ),
      child: ListView.builder(
          itemCount: data['daily']['temperature_2m_max'].length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) {
            double temp = data['daily']['temperature_2m_max'][index];
            String datt = data['daily']['time'][index];

            return Stack(children: [
              Center(
                child: data.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: 300,
                        child: ListTile(
                          title: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(179, 255, 255, 255)
                                    .withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20)),
                            height: 300,
                            child: Center(
                                child: Text(
                                    ' ${getDayOfWeek(datt)} \n   Temperature: $temp  °C  ')),
                          ),
                        ),
                      ),
              )
            ]);
          }),
    ));
  }
}
