// purchase.dart
import 'package:lotoplay/models/draw.dart';
import 'package:lotoplay/models/lottery.dart';
import 'package:lotoplay/models/number.dart';

class Purchase {
  final Lottery lottery;
  final Draw draw;
  final Number number;
  final double amount;

  Purchase({
    required this.lottery,
    required this.draw,
    required this.number,
    required this.amount,
  });
}
