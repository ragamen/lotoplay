class NewPurchase {
  String lottery;
  String draw;
  String number;
  String amount;

  NewPurchase({
    required this.lottery,
    required this.draw,
    required this.number,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'lottery': lottery,
      'draw': draw,
      'numbers': number,
      'amount': amount,
    };
  }
}
