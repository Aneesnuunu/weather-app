import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import '../controller/controller.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final HomePageController _controller = HomePageController();
  final TextEditingController _textController = TextEditingController();

  Weather? _weather;
  String? _errorMessage;
  bool _isSearching = false; // State to toggle search box visibility

  @override
  void initState() {
    super.initState();
    _fetchWeather("New York"); // Default city
  }

  Future<void> _fetchWeather(String cityName) async {
    final weather = await _controller.getWeather(cityName);
    setState(() {
      if (weather != null) {
        _weather = weather;
        _errorMessage = null;
      } else {
        _weather = null;
        _errorMessage = 'City not found. Please try again.';
      }
    });
  }

  void _searchWeather() {
    if (_textController.text.isNotEmpty) {
      _fetchWeather(_textController.text);
      setState(() {
        _isSearching = false; // Hide search box after search is done
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _textController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                  hintStyle: TextStyle(color: Colors.grey.shade300),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
                onSubmitted: (_) {
                  _searchWeather(); // Search when Enter is pressed
                },
              )
            : const Text(
                "SMART WEATHER",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        backgroundColor: Colors.redAccent,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.clear : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _textController.clear(); // Clear text when canceling search
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        Expanded(
          child: _weather != null
              ? SingleChildScrollView(
                  child: _weatherContent(),
                )
              : Center(
                  child: _errorMessage != null
                      ? Text(
                          _errorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        )
                      : const CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }

  Widget _weatherContent() {
    return Column(
      children: [
        _locationHeader(),
        _dateTimeInfo(),
        _weatherIcon(),
        _currentTemp(),
        _extraInfo(),
      ],
    );
  }

  Widget _locationHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        _weather?.areaName ?? "",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text(
            DateFormat("h:mm a").format(now),
            style: const TextStyle(fontSize: 35),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat("EEEE").format(now),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                "  ${DateFormat("d.M.y").format(now)}",
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weatherIcon() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Image.network(
            "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
            height: MediaQuery.of(context).size.height * 0.20,
          ),
          Text(
            _weather?.weatherDescription ?? "",
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _currentTemp() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
        style: const TextStyle(
            color: Colors.black, fontSize: 90, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
