import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:test_3/expenses_app/expense_data.dart';

import 'list_view_page.dart';

enum Type { add, remove, edit }

class FluxAction {
  Type type;
  Expense? payload;
  Expense? meta;
  FluxAction({required this.type, this.payload, this.meta});

  @override
  String toString() {
    return 'FluxAction{type: $type, payload: $payload, meta: $meta}';
  }
}

List<Expense> counterReducer(List<Expense> state, dynamic action) {
  log("${action.type}");
  if (action.type == Type.add) {
    return List.of(state)..add(action.payload);
  }
  if (action.type == Type.remove) {
    return List.of(state)..remove(action.payload);
  }
  if (action.type == Type.edit) {
    int index = state.indexOf(action.payload);
    return List.of(state)..[index] = action.meta;
  }
  return state;
}

main() {
  final store = Store<List<Expense>>(counterReducer, initialState: initialList);
  runApp(StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor:Colors.blueGrey,
            title: const Text("Expenses App",style:  TextStyle(
                fontSize: 24,
                fontFamily: 'Lobster'
            ),),
          ),
          body: ExpenseListView(),
        ),
      )));
}
