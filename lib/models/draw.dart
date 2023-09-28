// draw.dart
import 'package:lotoplay/models/number.dart';

class Draw {
  final String name;
  final List<Number> numbers;
  bool isSelected;
  bool isActive;
  Draw(
      {required this.name,
      required this.numbers,
      this.isSelected = false,
      this.isActive = true});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'numbers': numbers.map((number) => number.toJson()).toList(),
      'isSelected': isSelected,
    };
  }

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Draw && runtimeType == other.runtimeType && name == other.name;
}
