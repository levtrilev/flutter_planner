import 'package:async_redux_todo/business/todo/todo_state.dart';
import 'package:async_redux_todo/dao/entity/app_status.dart';

class AppState {
  final int counter;
  final int otherCounter;
  final String message;
  final TodoState todoState;
  final AppStatus appStatus;

  AppState({
    required this.counter,
    required this.otherCounter,
    required this.message,
    required this.todoState,
    required this.appStatus,
  });

  AppState copy({
    int? counter,
    int? otherCounter,
    String? message,
    TodoState? todoState,
    AppStatus? appStatus,
  }) {
    return AppState(
      counter: counter ?? this.counter,
      otherCounter: otherCounter ?? this.otherCounter,
      message: message ?? this.message,
      todoState: todoState ?? this.todoState,
      appStatus: appStatus ?? this.appStatus,
    );
  }

  static AppState initialState(String token, int userId) {
return AppState(
        counter: 2,
        otherCounter: 3,
        message: 'other is bigger!',
        todoState: TodoState.initialState(),
        appStatus: AppStatus.initialState(token, userId),
      );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          counter == other.counter &&
          otherCounter == other.otherCounter &&
          message == other.message &&
          appStatus == other.appStatus &&
          todoState == other.todoState;

  @override
  int get hashCode =>
      counter.hashCode ^
      otherCounter.hashCode ^
      message.hashCode ^
      appStatus.hashCode ^
      todoState.hashCode;
}
