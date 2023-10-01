import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/services.dart';

import 'expense_data.dart';

class AddAndEditExpense extends StatefulWidget {
  final String? title;
  final String? name;
  final String? value;
  final DateTime? date;
  final String? buttonText;

  const AddAndEditExpense({
    super.key,
    this.title,
    this.name,
    this.value,
    this.date,
    this.buttonText,
  });

  @override
  State<AddAndEditExpense> createState() => _AddAndEditExpenseState();
}

class _AddAndEditExpenseState extends State<AddAndEditExpense> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  DateTime selectedDate = DateTime.now();

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
    valueController.text = widget.value != null? widget.value! : "";
    nameController.text = widget.name != null? widget.name! : "";
    widget.date != null ? selectedDate = widget.date!: selectedDate;
    dateController.text =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title!,
            style: const TextStyle(fontFamily: 'Lobster'),
          ),
          backgroundColor: Colors.blueGrey,
        ),
        body: Center(
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
                      child: createTextField("Date", dateController,context),
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
                createTextField("Name", nameController,context),
                createTextField("Amount", valueController,context),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context,
                        Expense(
                            date: selectedDate,
                            name: nameController.text,
                            value: double.parse(valueController.text)));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueGrey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.black26)))),
                  child: Text(
                      widget.buttonText != null ? widget.buttonText! : "save"),
                ),
              ],
            ),
          ),
        ));
  }
  Column createTextField(String name, TextEditingController controller,BuildContext context) {
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
          onTap: name == "Date"? showDate:(){},
          readOnly: name == 'Date'?true:false,
          controller: controller,
          inputFormatters: name == 'Amount'
              ? <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ]
              : null,
          keyboardType: name == 'Amount' ?  TextInputType.number : TextInputType.text,
          decoration: const InputDecoration(
            border: OutlineInputBorder(), // Add border to input field
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  showDate(){
    BottomPicker.date(
        title:  "Set your Birthday",
        initialDateTime: selectedDate,
        titleStyle:  const TextStyle(
            fontWeight:  FontWeight.bold,
            fontSize:  15,
            color:  Colors.blue
        ),
        onChange: (index) {
        },
        onSubmit: (index) {
          selectedDate = index;
          dateController.text =
          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
        },
        // bottomPickerTheme:  BOTTOM_PICKER_THEME.plumPlate
    ).show(context);

  }

}

