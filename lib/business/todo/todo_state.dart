import 'package:async_redux_todo/dao/entity/todo_item.dart';

class TodoState {
  final TodoItem todoItem;
  final List<TodoItem> todoItems;
  final int todoItemId;

  TodoState({
    required this.todoItem,
    required this.todoItems,
    required this.todoItemId,
  });

  TodoState copy({
    TodoItem? todoItem,
    List<TodoItem>? todoItems,
    int? todoItemId,
  }) {
    return TodoState(
      todoItem: todoItem ?? this.todoItem,
      todoItems: todoItems ?? this.todoItems,
      todoItemId: todoItemId ?? this.todoItemId,
    );
  }

  static TodoState initialState() => TodoState(
        todoItem: TodoItem(
            id: 0,
            title: 'title',
            isCompleted: false,
            userId: 1,
            openDate: DateTime.now(),
            closeDate: DateTime.now()),
        todoItems: <TodoItem>[],
        todoItemId: 0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoState &&
          runtimeType == other.runtimeType &&
          todoItem == other.todoItem &&
          todoItems == other.todoItems &&
          todoItemId == other.todoItemId;

  @override
  int get hashCode =>
      todoItem.hashCode ^ todoItems.hashCode ^ todoItemId.hashCode;
}
