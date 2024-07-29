import 'dart:io';

import 'package:flutter/material.dart';
import '../models/visit.dart';

class VisitCard extends StatelessWidget {
  final Visit visit;
  final VoidCallback onTap;

  VisitCard({required this.visit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(5, 5),
                blurRadius: 30,
                color: Color(0xff848B8D).withOpacity(0.23),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (visit.photoPath.isNotEmpty)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(File(visit.photoPath)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Centro: ${visit.centerCode}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Fecha: ${visit.date}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xffBCBCBC),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Hora: ${visit.time}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xffBCBCBC),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 12,
                  color: Color(0xffBCBCBC),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
