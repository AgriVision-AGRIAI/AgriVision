import 'package:flutter/cupertino.dart';

class CropSymptoms {
  final String title;
  final String description;
  const CropSymptoms({required this.title, required this.description});
}

final List<IconData> symptomIcons = [
  CupertinoIcons.circle_grid_hex,
  CupertinoIcons.cloud_rain,
  CupertinoIcons.drop_triangle,
  CupertinoIcons.sun_max,
  CupertinoIcons.flame,
  CupertinoIcons.wind,
  CupertinoIcons.eye,
  CupertinoIcons.bolt_horizontal_circle,
  CupertinoIcons.ant,
];