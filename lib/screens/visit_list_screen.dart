import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import '../providers/visit_provider.dart';
import 'visit_detail_screen.dart';

class VisitListScreen extends StatefulWidget {
  @override
  _VisitListScreenState createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  String _searchQuery = '';
  late VideoPlayerController _controller;

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
        title: Text('Lista de Visitas'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar por Cédula del Director',
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
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<VisitProvider>(context, listen: false).fetchVisits(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Consumer<VisitProvider>(
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
                            Center(child: Text('', style: TextStyle(fontSize: 24, color: Colors.black))),
                          ],
                        );
                      }

                      return ListView(
                        children: [
                          if (visits.isNotEmpty)
                            CarouselSlider.builder(
                              itemCount: visits.length,
                              itemBuilder: (context, index, realIndex) {
                                final visit = visits[index];
                                if (visit.photoPath.isEmpty) {
                                  return Container();
                                } else {
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Image.file(File(visit.photoPath)),
                                  );
                                }
                              },
                              options: CarouselOptions(
                                height: 200,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 0.8,
                              ),
                            ),
                          ...visits.map((visit) {
                            return ListTile(
                              title: Text('Centro: ${visit.centerCode}'),
                              subtitle: Text('Fecha: ${visit.date}'),
                              leading: visit.photoPath.isEmpty
                                  ? null
                                  : Image.file(File(visit.photoPath)),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => VisitDetailScreen(visit: visit),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
