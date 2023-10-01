import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:redux/redux.dart';
import 'package:test_3/expenses_app/add_expense_page.dart';
import 'package:test_3/expenses_app/expense_data.dart';
import 'package:test_3/expenses_app/expense_main.dart';

class ExpenseListView extends StatelessWidget {
  ExpenseListView({super.key});

  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double extent = 0.25;
    return StoreConnector<List<Expense>, List<Expense>>(
      converter: (store) => store.state,
      builder: (context, list) {
        return Column(
          children: [
            Expanded(
              child: AnimatedList(
                key: _animatedListKey,
                initialItemCount: list.length,
                itemBuilder: (context, index, animation) {
                  return Slidable(
                      startActionPane: ActionPane(
                        extentRatio: extent,
                        motion: const DrawerMotion(),
                        children: [
                          StoreConnector<List<Expense>, VoidCallback>(
                            converter: (store) {
                              return () => store.dispatch(FluxAction(
                                  type: Type.remove, payload: list[index]));
                            },
                            builder: (context, value) {
                              return SlidableAction(
                                onPressed: (context) async => {
                                  _animatedListKey.currentState!.removeItem(
                                      index,
                                      (context, animation) => _buildTaskItem(
                                          list[index], animation)),
                                  // await Future.delayed(const Duration(seconds: 1)),
                                  // list.removeAt(index),
                                  value.call(),
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              );
                            },
                          ),
                        ],
                      ),

                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        extentRatio: extent,
                        motion: const StretchMotion(),
                        children: [
                          StoreConnector<List<Expense>, Store<List<Expense>>>(
                              converter: (store) {
                            return store;
                          }, builder: (context, value) {
                            return SlidableAction(
                              onPressed: (context) async {
                                FluxAction action = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddAndEditExpense(
                                            index: index,
                                          )),
                                );
                                value.dispatch(action);
                              },
                              backgroundColor: const Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            );
                          }),
                        ],
                      ),
                      child: _buildTaskItem(list[index], animation));
                },
              ),
            ),
            StoreConnector<List<Expense>, Store<List<Expense>>>(
                converter: (store) {
              return store;
            }, builder: (context, value) {
              return ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueGrey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.black26)))),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddAndEditExpense()),
                  ).then((action) => value.dispatch(action));
                  _animatedListKey.currentState!.insertItem(list.length - 1);
                },
                child: const Icon(Icons.add),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildTaskItem(Expense expense, Animation<double> animation) {
    return SizeTransition(
        sizeFactor: animation,
        child: Card(
            color: Colors.white,
            child: ListTile(
              title: Text(
                expense.name.toString(),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                "${expense.value} \$",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontFamily: 'Lobster'),
              ),
            )));
  }
}
