import 'package:async_redux_todo/business/todo/todo_state.dart';

class AppState {
  final int counter;
  final int otherCounter;
  final String message;
  final TodoState todoState;

  AppState({
    required this.counter,
    required this.otherCounter,
    required this.message,
    required this.todoState,
  });

  AppState copy({
    int? counter,
    int? otherCounter,
    String? message,
    TodoState? todoState,
  }) {
    return AppState(
      counter: counter ?? this.counter,
      otherCounter: otherCounter ?? this.otherCounter,
      message: message ?? this.message,
      todoState: todoState ?? this.todoState,
    );
  }

  static AppState initialState() => AppState(
        counter: 2,
        otherCounter: 3,
        message: 'other is bigger!',
        todoState: TodoState.initialState(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          counter == other.counter &&
          otherCounter == other.otherCounter &&
          message == other.message &&
          todoState == other.todoState;

  @override
  int get hashCode =>
      counter.hashCode ^ otherCounter.hashCode ^ message.hashCode ^ todoState.hashCode;
}
