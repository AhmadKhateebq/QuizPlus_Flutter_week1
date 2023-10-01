class Expense {
  DateTime date;
  String name;
  double value;

  Expense({
    required this.date,
    required this.name,
    required this.value,
  });

  @override
  String toString() {
    return 'Expense{date: $date, name: $name, value: $value}';
  }
}
List<Expense> initialList = [
  Expense(date: DateTime.now(), name: "expense 1", value: 10),
  Expense(date: DateTime.now(), name: "expense 2", value: 20),
  Expense(date: DateTime.now(), name: "expense 3", value: 30),
  Expense(date: DateTime.now(), name: "expense 4", value: 40),
];