import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/visit_provider.dart';
import 'visit_detail_screen.dart';

class VisitListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Visitas'),
      ),
      body: FutureBuilder(
        future: Provider.of<VisitProvider>(context, listen: false).fetchVisits(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer<VisitProvider>(
              builder: (ctx, visitProvider, _) {
                return ListView.builder(
                  itemCount: visitProvider.visits.length,
                  itemBuilder: (ctx, index) {
                    final visit = visitProvider.visits[index];
                    return ListTile(
                      title: Text('Centro: ${visit.centerCode}'),
                      subtitle: Text('Fecha: ${visit.date}'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VisitDetailScreen(visit: visit),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
