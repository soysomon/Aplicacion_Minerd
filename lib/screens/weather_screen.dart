import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api.dart'; // Asegúrate de que esta ruta sea correcta
import '../screens/weathermodel.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  ApiResponse? response;
  bool inProgress = false;
  String message =
      "Busque la ubicación para obtener datos meteorológicos y active la ubicación del dispositivo móvil y vuelva a loguearse en caso de que no le aparezca una ubicación por default, pero sigue funcionando el buscador en caso de no activar la ubicación del movil...";

  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      if (position != null) {
        _getCurrentLocationWeather(position);
      }
    }).catchError((error) {
      setState(() {
        message = error.toString();
      });
    });
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación están denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Los permisos de ubicación están permanentemente denegados.');
    }

    // Obtiene la posición actual usando el método adecuado para tu versión
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _getCurrentLocationWeather(Position position) async {
    setState(() {
      inProgress = true;
    });
    try {
      response = await WeatherApi()
          .getCurrentWeather("${position.latitude},${position.longitude}");
      message = "";
    } catch (e) {
      setState(() {
        message = "No se pudo obtener el clima";
        response = null;
      });
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('El clima de la zona'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchWidget(),
              const SizedBox(height: 20),
              if (inProgress)
                CircularProgressIndicator()
              else
                Expanded(
                  child: SingleChildScrollView(child: _buildWeatherWidget()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return SearchBar(
      hintText: "Busca cualquier ubicación",
      onSubmitted: (value) {
        _getWeatherData(value);
      },
    );
  }

  Widget _buildWeatherWidget() {
    if (response == null) {
      return Text(message);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.location_on,
                size: 50,
                color: Colors.red,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        response?.location?.name ?? "",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        response?.location?.country ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (response?.current?.tempC.toString() ?? "") + " °C",
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                (response?.current?.condition?.text.toString() ?? ""),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: Image.network(
                "https:${response?.current?.condition?.icon}"
                    .replaceAll("64x64", "128x128"),
                scale: 0.7,
              ),
            ),
          ),
          Card(
            elevation: 4,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Humedad",
                        response?.current?.humidity?.toString() ?? ""),
                    _dataAndTitleWidget("Velocidad del viento",
                        "${response?.current?.windKph?.toString() ?? ""} km/h")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget(
                        "UV", response?.current?.uv?.toString() ?? ""),
                    _dataAndTitleWidget("Precipitación",
                        "${response?.current?.precipMm?.toString() ?? ""} mm")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Hora local",
                        response?.location?.localtime?.split(" ").last ?? ""),
                    _dataAndTitleWidget("Fecha local",
                        response?.location?.localtime?.split(" ").first ?? ""),
                  ],
                )
              ],
            ),
          )
        ],
      );
    }
  }

  Widget _dataAndTitleWidget(String title, String data) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Text(
            data,
            style: const TextStyle(
              fontSize: 27,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _getWeatherData(String location) async {
    setState(() {
      inProgress = true;
    });

    try {
      response = await WeatherApi().getCurrentWeather(location);
    } catch (e) {
      setState(() {
        message = "No se pudo obtener el clima";
        response = null;
      });
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
