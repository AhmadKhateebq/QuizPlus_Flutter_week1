import 'package:redux/redux.dart';

enum Operation { SET, EMPTY }

class FluxAction {
  Operation action;
  String? payload;

  FluxAction({required this.action, this.payload});
}

Store<String> store = Store<String>(
  reducer,
  initialState: '',
);

String reducer(String state, dynamic action) {
  switch((action as FluxAction).action){
    case (Operation.EMPTY) :
      return "";
    case Operation.SET:
      return state = action.payload!;
  }
}
