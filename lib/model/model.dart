import 'package:weather/weather.dart';
import '../consts.dart';

class WeatherModel {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Future<Weather?> fetchWeather(String cityName) async {
    try {
      return await _wf.currentWeatherByCityName(cityName);
    } catch (_) {
      return null;
    }
  }
}
