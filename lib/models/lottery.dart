// lottery.dart
import 'package:lotoplay/models/draw.dart';

class Lottery {
  final String name;
  final List<Draw> draws;
  bool isSelected;

  Lottery({required this.name, required this.draws, this.isSelected = false});

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lottery &&
          runtimeType == other.runtimeType &&
          name == other.name;
}
