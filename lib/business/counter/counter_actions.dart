import 'package:async_redux/async_redux.dart';
import 'package:async_redux_todo/business/app_state.dart';

class IncrementAction extends ReduxAction<AppState> {
  final int amount;

  IncrementAction({required this.amount});

  @override
  AppState? reduce() {
    return state.copy(counter: state.counter + amount);
  }
}