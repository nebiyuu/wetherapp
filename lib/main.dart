import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
          print('Data fetched successfully: $data');
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
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
            String date = data['daily']['time'][index];
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
                                'Temperature: $temp  °C\n  date : $date',
                              ),
                            ),
                          ),
                        ),
                      ),
              )
            ]);
          }),
    ));
  }
}
