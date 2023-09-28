class Number {
  final String value;
  bool isSelected;

  Number({required this.value, this.isSelected = false});
  Map<String, dynamic> toJson() {
    return {
      'value': value, // o double.parse(value) si es decimal
      'isSelected': isSelected,
    };
  }

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Number &&
          runtimeType == other.runtimeType &&
          value == other.value;
}
