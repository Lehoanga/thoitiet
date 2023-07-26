import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class Todo {
  String city;
  String weather;
  String icon;
  double temperature;
  double tempMax;
  double tempMin;

  Todo(this.city, this.weather, this.temperature, this.tempMax, this.tempMin, this.icon);
}

class _WeatherAppState extends State<WeatherApp> {
  final String apiKey = 'be5f7ac5e6e09779dd7d8baca677fee5';
  final cityController = TextEditingController();
  String city = '';
  String weather = '';
  String icon = '';
  double temperature = 0.0;
  double tempMin = 0.0;
  double tempMax = 0.0;

  void fetchWeatherData() async {
    final cityName = cityController.text;
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        city = jsonData['name'];
        weather = jsonData['weather'][0]['description'];
        temperature = jsonData['main']['temp'] - 273.15;
        tempMin = jsonData['main']['temp_min'] - 273.15;
        tempMax = jsonData['main']['temp_max'] - 273.15;
        icon = jsonData['weather'][0]['icon'];
        /// Convert temperature from Kelvin to Celsius
      });
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(
            city: city,
            weather: weather,
            temperature: temperature,
            tempMin: tempMin,
            tempMax: tempMax,
            icon: icon,
          ),
        ),
      );
    } else {
      setState(() {
        city = 'City not found';
        weather = '';
        temperature = 0.0;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thời tiết'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'Nhập khu vực mong muốn',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchWeatherData,
              child: Text('Tìm kiếm'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final String city;
  final String weather;
  final double temperature;
  final double tempMax;
  final double tempMin;
  final String icon;

  SecondScreen({required this.city, required this.weather, required this.temperature, required this.tempMax, required this.tempMin, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thời tiết"),
      ),
      backgroundColor: Colors.green,
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Align the city text to the center
            children: [
              SizedBox(height: 50),
              Text(
                '$city',
                style: GoogleFonts.montserrat(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Image.network( // Use Image.network to load the weather icon from the URL
                "https://openweathermap.org/img/wn/$icon@2x.png",
                width: 100,
                height: 100,
              ),
              Text(
                'Thời tiết: $weather',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Expanded( // Use Expanded to align the temperature information to the left
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'max: ${tempMax.toStringAsFixed(1)} °C',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Nhiệt độ: ${temperature.toStringAsFixed(1)} °C',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'min: ${tempMin.toStringAsFixed(1)} °C',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Quay lại!'),
              ),
              SizedBox(height: 14),
            ],
          ),
        ),
      ),

    );
  }
}

