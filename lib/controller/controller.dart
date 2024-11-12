import '../model/model.dart';
import 'package:weather/weather.dart';

class HomePageController {
  final WeatherModel _weatherModel = WeatherModel();

  Future<Weather?> getWeather(String cityName) async {
    return await _weatherModel.fetchWeather(cityName);
  }
}
