class Number {
  final String value;
  bool isSelected;

  Number({required this.value, this.isSelected = false});

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Number &&
          runtimeType == other.runtimeType &&
          value == other.value;
}
