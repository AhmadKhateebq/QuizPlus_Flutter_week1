import 'dart:developer';
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
    log("\n",name: "");
    log("build",name: "Top level builder");
    double extent = 0.5;
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
                      endActionPane: ActionPane(
                        extentRatio: extent,
                        motion: const DrawerMotion(),
                        children: [
                          StoreConnector<List<Expense>, VoidCallback>(
                            converter: (store) {
                              return () {
                                _animatedListKey.currentState!.removeItem(
                                    index,
                                    (context, animation) =>
                                        _buildTaskItem(list[index], animation),
                                    duration:
                                        const Duration(milliseconds: 500));
                                store.dispatch(FluxAction(
                                    type: Type.remove, payload: list[index]));
                              };
                            },
                            builder: (context, value) {
                              return SlidableAction(
                                onPressed: (context) async => {
                                  value.call(),
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              );
                            },
                          ),
                          StoreConnector<List<Expense>, Store<List<Expense>>>(
                              converter: (store) {
                            return store;
                          }, builder: (context, value) {
                                log("slidable action builder Entered",name: "slidable action");
                            return SlidableAction(
                              onPressed: (context) async {
                                Expense expense = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddAndEditExpense(
                                            value: "${list[index].value}",
                                            date: list[index].date,
                                            name: list[index].name,
                                            title: "Edit Expense",
                                            buttonText: "Save Changes",
                                          )),
                                );
                                value.dispatch(FluxAction(
                                    type: Type.edit,
                                    payload: expense,
                                    meta: list[index]));
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
                  Expense? expense = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddAndEditExpense(
                              title: "Add New Expense",
                              buttonText: "Save",
                            )),
                  );
                  if (expense != null) {
                    value
                        .dispatch(FluxAction(type: Type.add, payload: expense));
                    _animatedListKey.currentState!.insertItem(list.length - 1);
                  }
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

    return SizedTransitionWidget(
      animation: animation,
      expense: expense,
    );
  }
}
class SizedTransitionWidget extends StatefulWidget {
  const SizedTransitionWidget({super.key, required this.animation, required this.expense});
  final Animation<double> animation;
  final Expense expense;
  @override
  State<SizedTransitionWidget> createState() => _SizedTransitionWidgetState();
}

class _SizedTransitionWidgetState extends State<SizedTransitionWidget> {
  @override
  void initState() {
    // TODO: implement initState
    log("${widget.expense.name} init",sequenceNumber: 0,name: "size transition");
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    log("${widget.expense.name} didChangeDependencies",sequenceNumber: 0,name: "size transition");
  }
  @override
  void didUpdateWidget(covariant SizedTransitionWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    log("${widget.expense.name} didUpdateWidget",sequenceNumber: 0,name: "size transition");
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    log("${widget.expense.name} dispose",sequenceNumber: 0,name: "size transition");
  }
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: widget.animation,
        child: Card(
            color: Colors.white,
            child: ListTile(
              title: Text(
                widget.expense.name.toString(),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                "${widget.expense.value} \$",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontFamily: 'Lobster'),
              ),
            )));
  }
}

