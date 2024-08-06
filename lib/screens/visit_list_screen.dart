import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import '../providers/visit_provider.dart';
import 'visit_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisitListScreen extends StatefulWidget {
  @override
  _VisitListScreenState createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  String _searchQuery = '';
  late VideoPlayerController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/list_unfine.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(false);
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            Future.delayed(Duration(seconds: 8), () {
              _controller.seekTo(Duration.zero);
              _controller.play();
            });
          }
        });
        _controller.play();
      });
    _fetchVisits();
  }

  Future<void> _fetchVisits() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      try {
        await Provider.of<VisitProvider>(context, listen: false).fetchVisits(token);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar visitas: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // Fondo blanco
        iconTheme: IconThemeData(
          color: Colors.black, // Color de los iconos en negro
        ),

        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visitas Registradas',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Buscar por Cédula del Director',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Buscar',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Consumer<VisitProvider>(
                builder: (ctx, visitProvider, _) {
                  final visits = visitProvider.visits.where((visit) {
                    return visit.directorId.contains(_searchQuery);
                  }).toList();

                  if (visits.isEmpty) {
                    return Stack(
                      children: [
                        if (_controller.value.isInitialized)
                          Positioned.fill(
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        Center(
                          child: Text(
                            'No hay visitas disponibles',
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: visits.length,
                    itemBuilder: (context, index) {
                      final visit = visits[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            'Centro: ${visit.centerCode}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Fecha: ${visit.date}'),
                          leading: visit.photoPath.isEmpty
                              ? Icon(Icons.location_city, color: Colors.blue)
                              : Image.file(File(visit.photoPath)),
                          trailing: Icon(Icons.arrow_forward, color: Colors.blue),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VisitDetailScreen(visit: visit),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}