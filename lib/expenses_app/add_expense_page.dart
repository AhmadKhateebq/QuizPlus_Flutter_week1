import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/services.dart';


import 'expense_data.dart';
import 'expense_main.dart';

class AddAndEditExpense extends StatefulWidget {
  final int? index;

  const AddAndEditExpense({super.key, this.index});

  @override
  State<AddAndEditExpense> createState() => _AddAndEditExpenseState();
}

class _AddAndEditExpenseState extends State<AddAndEditExpense> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  DateTime selectedDate = DateTime.now(); // Add this line

  // Function to show date picker
  VoidCallback _selectDate(BuildContext context) {
    return () async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null && pickedDate != selectedDate) {
        selectedDate = pickedDate;
        dateController.text =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      }
    };
  }

  @override
  void initState() {
    super.initState();
    dateController.text =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.index != null ? 'Edit Expense' : 'Add Expense',
          style: const TextStyle(fontFamily: 'Lobster'),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: StoreConnector<List<Expense>, Expense>(
        converter: (store) => ((widget.index != null)
            ? store.state[widget.index!]
            : Expense(date: DateTime.now(), name: '', value: 0)),
        builder: (context, expense) {
          dateController.text =
              "${expense.date.day}/${expense.date.month}/${expense.date.year}";
          nameController.text = expense.name;
          valueController.text = expense.value.toString();
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Add padding to the content
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: createTextField("Date", dateController),
                      ),
                      StoreConnector<List<Expense>, VoidCallback>(
                        converter: (store) {
                          return _selectDate(context);
                        },
                        builder: (context, value) {
                          return IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                             value.call();
                            },
                          );
                        },
                      ),

                    ],
                  ),
                  createTextField("Name", nameController),
                  createTextField("Amount", valueController),
                  const SizedBox(height: 20),
                  StoreConnector<List<Expense>, VoidCallback>(
                    converter: (store) {
                      return () {
                        if (widget.index == null) {

                          return Navigator.pop(context,FluxAction(
                              type: Type.add,
                              payload: Expense(
                                  date: selectedDate,
                                  name: nameController.text,
                                  value: double.parse(valueController.text))));
                        } else {
                          Navigator.pop(context,FluxAction(
                              type: Type.edit,
                              payload: expense,
                              meta: Expense(
                                  date: selectedDate,
                                  name: nameController.text,
                                  value: double.parse(valueController.text))));
                        }
                      };
                    },
                    builder: (context, value) {
                      return ElevatedButton(
                        onPressed: value,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blueGrey),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Colors.black26)))),
                        child: Text(
                            widget.index != null ? 'Save Changes' : 'Save'),
                      );
                    },
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Column createTextField(String name, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'Lobster',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8), // Add spacing between label and input field
        TextField(
          controller: controller,
          inputFormatters: name == 'Amount'? <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ] : null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(), // Add border to input field
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
