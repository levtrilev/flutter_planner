import 'dart:async';

import 'package:async_redux/async_redux.dart';

import 'package:async_redux_todo/business/app_state.dart';
//import 'package:async_redux_todo/business/auth/auth_actions.dart';
import 'package:async_redux_todo/dao/api/api_client.dart';
import 'package:async_redux_todo/dao/entity/todo_item.dart';
import 'package:async_redux_todo/main_navigation.dart';

final _apiClient = ApiClient();
var _isLoadingInProgress = false;
//var _stateIsInitializingNow = true;
var _searchQuery = '';
Timer? searchDebounce;
List<TodoItem>? searchResultTodoItems;

class SearchTodoListAction extends ReduxAction<AppState> {
  final String searchQuery;
  SearchTodoListAction({
    required this.searchQuery,
  });
  @override
  Future<AppState?> reduce() async {
    if (searchQuery == '') {
      List<TodoItem> todoItems = await getTodoItems(state.appStatus.userToken, state.appStatus.userId,);
      return state.copy(todoState: state.todoState.copy(todoItems: todoItems));
    }
    // ignore: avoid_print
    print(searchQuery);
    await searchTodoItems(
      searchQuery,
      state.appStatus.userToken,
      state.appStatus.userId,
    );
    return state.copy(
        todoState: state.todoState.copy(todoItems: searchResultTodoItems));
  }
}

// class SetNewTodoListAction extends ReduxAction<AppState> {
//   final List<TodoItem>? items;

//   SetNewTodoListAction({required this.items});

//   @override
//   AppState? reduce() {
//     return state.copy(todoState: state.todoState.copy(todoItems: items));
//   }
// }

class CreateNewAndOpenTodoDetailsAction extends ReduxAction<AppState> {
  @override
  AppState? reduce() {
    TodoItem todoItem = TodoItem(
      id: 0,
      priority: 50,
      title: '',
      userId: 1,
      isCompleted: false,
      openDate: DateTime.now(),
      closeDate: DateTime.now(),
    );

    return state.copy(todoState: state.todoState.copy(todoItem: todoItem));
  }

  @override
  void after() =>
      dispatch(NavigateAction.pushNamed(MainNavigationRouteNames.todoDetails));
}

class DeleteTodoDetailsAction extends ReduxAction<AppState> {
  final int todoIdToDelete;
  DeleteTodoDetailsAction({
    required this.todoIdToDelete,
  });

  @override
  Future<AppState?> reduce() async {
    bool isDeleted = await _apiClient.todoItemDelete(todoIdToDelete) ?? false;

    if (!isDeleted) return null;

    // List<TodoItem> todoItems = await getTodoItems();
    List<TodoItem> todoItems = state.todoState.todoItems;
    final deletedElementIndex = todoItems.indexOf(
        todoItems.firstWhere((todoItem) => todoItem.id == todoIdToDelete));
    todoItems.removeAt(deletedElementIndex);

    final newstate =
        state.copy(todoState: state.todoState.copy(todoItems: todoItems));
    return newstate;
  }

  // @override
  // void before() =>
  //     dispatch(NavigateAction.pushNamed(MainNavigationRouteNames.deleteTodoDialog));

  @override
  void after() =>
      dispatch(NavigateAction.pushNamed(MainNavigationRouteNames.mainScreen));
}

class SaveTodoDetailsAction extends ReduxAction<AppState> {
  TodoItem changedTodoItem;
  SaveTodoDetailsAction({
    required this.changedTodoItem,
  });

  @override
  Future<AppState?> reduce() async {
    List<TodoItem> todoItems = state.todoState.todoItems;
    int changedTodoItemId = 0;
    if (changedTodoItem.id == 0) {
      //changedTodoItem.userId = state.appStatus.userId;
      changedTodoItemId = await _apiClient.createTodoItem(
        todoItemToCreate: changedTodoItem,
        token: state.appStatus.userToken,
      );
    } else {
      changedTodoItemId = await _apiClient.updateTodoItem(
        todoItemToUpdate: changedTodoItem,
        token: state.appStatus.userToken,
      );
    }

    if (changedTodoItemId == 0) return null;

    if (changedTodoItem.id == 0) {
      todoItems.add(changedTodoItem.copy(id: changedTodoItemId));
    } else {
      final changedElementIndex = todoItems.indexOf(
          todoItems.firstWhere((todoItem) => todoItem.id == changedTodoItemId));
      todoItems[changedElementIndex] = changedTodoItem;
    }

    final newstate =
        state.copy(todoState: state.todoState.copy(todoItems: todoItems));
    return newstate;
  }

  @override
  void after() =>
      dispatch(NavigateAction.pushNamed(MainNavigationRouteNames.mainScreen));
}

class CloseDatePickedAction extends ReduxAction<AppState> {
  final DateTime datePicked;
  CloseDatePickedAction({
    required this.datePicked,
  });

  @override
  AppState? reduce() {
    return state.copy(
        todoState: state.todoState.copy(
            todoItem: state.todoState.todoItem.copy(closeDate: datePicked)));
  }
}

class OpenDatePickedAction extends ReduxAction<AppState> {
  final DateTime datePicked;
  OpenDatePickedAction({
    required this.datePicked,
  });

  @override
  AppState? reduce() {
    return state.copy(
        todoState: state.todoState.copy(
            todoItem: state.todoState.todoItem.copy(openDate: datePicked)));
  }
}

class IsCompletedSwitchedAction extends ReduxAction<AppState> {
  final bool isCompletedNewvalue;
  IsCompletedSwitchedAction({required this.isCompletedNewvalue});

  @override
  AppState? reduce() {
    if (isCompletedNewvalue != state.todoState.todoItem.isCompleted) {
      return state.copy(
          todoState: state.todoState.copy(
              todoItem: state.todoState.todoItem
                  .copy(isCompleted: isCompletedNewvalue)));
    }
    return null;
  }
}

class OpenTodoDetailsAction extends ReduxAction<AppState> {
  int todoId;
  OpenTodoDetailsAction({
    required this.todoId,
  });

  @override
  Future<AppState?> reduce() async {
    TodoItem todoItem = await getTodoDetails(todoId, state.appStatus.userToken);
    //state.todoState.copy(todoItems: todoItems);
    return state.copy(todoState: state.todoState.copy(todoItem: todoItem));
  }

  @override
  void after() =>
      dispatch(NavigateAction.pushNamed(MainNavigationRouteNames.todoDetails));
}

class GetTodoListAction extends ReduxAction<AppState> {
  GetTodoListAction();

  @override
  Future<AppState?> reduce() async {
    List<TodoItem> todoItems = await getTodoItems(
      state.appStatus.userToken,
      state.appStatus.userId,
    );
    //state.todoState.copy(todoItems: todoItems);
    return state.copy(todoState: state.todoState.copy(todoItems: todoItems));
  }
}

class InitialGetTodoListAction extends ReduxAction<AppState> {
  InitialGetTodoListAction();

  @override
  Future<AppState?> reduce() async {
    // if (state.todoState.todoItems.isEmpty && _stateIsInitializingNow) {
    if (state.todoState.todoItems.isEmpty &&
        state.appStatus.appStateIsInitializing) {
      List<TodoItem> todoItems = await getTodoItems(
        state.appStatus.userToken,
        state.appStatus.userId,
      );
      //_stateIsInitializingNow = false;
      return state.copy(todoState: state.todoState.copy(todoItems: todoItems));
    }
    return null;
  }

  @override
  void after() => dispatch(SetAppStateIsInitializingAction());
}

class SetAppStateIsInitializingAction extends ReduxAction<AppState> {
  @override
  AppState? reduce() {
    return state.copy(
        appStatus: state.appStatus.copy(appStateIsInitializing: false));
  }

  @override
  void after() =>
      dispatch(NavigateAction.pushNamed(MainNavigationRouteNames.mainScreen));
}

Future<List<TodoItem>?> searchTodoItems(
    String query, String token, int userId) async {
  final searchQuery = query.isNotEmpty ? query : null;
  if (searchQuery == null) return null;
  if (_searchQuery == searchQuery) return null;
  _searchQuery = searchQuery;

  // searchDebounce?.cancel();
  // searchDebounce = Timer(const Duration(seconds: 2), () async {
  if (_isLoadingInProgress) return null;
  _isLoadingInProgress = true;

  try {
    searchResultTodoItems = await _apiClient.searchTodoItemsGet(
      searchQuery,
      token,
      userId,
    );
  } catch (e) {
    _isLoadingInProgress = false;
  } finally {
    _isLoadingInProgress = false;
  }
  //});
}

Future<List<TodoItem>> getTodoItems(String token, int userId) async {
  if (_isLoadingInProgress) return <TodoItem>[];
  _isLoadingInProgress = true;

  try {
    final todos = await _apiClient.todoItemsGet(token, userId);
    if (todos == null) return <TodoItem>[];
    _isLoadingInProgress = false;
    return todos;
  } catch (e) {
    _isLoadingInProgress = false;
    return <TodoItem>[];
  }
}

Future<TodoItem> getTodoDetails(int todoId, String token) async {
  // if (todoId == 0) {
  //   // todoId == 0 means to create a new todo
  final newTodo = TodoItem(
    id: 0,
    priority: 0,
    title: 'Не найдено todo id = $todoId',
    isCompleted: false,
    userId: 1,
    openDate: DateTime.now(),
    closeDate: DateTime.parse('2021-01-01'),
  );
  //     _todoItem = newTodo;
  //   return Future.delayed(const Duration(milliseconds: 20), () => newTodo);
  // }
  // if (_isLoadingInProgress) return;
  // _isLoadingInProgress = true;

  try {
    final todo = await _apiClient.todoItemGet(todoId, token);
    _isLoadingInProgress = false;
    if (todo == null) {
      return newTodo;
    }
    return todo;
  } catch (e) {
    _isLoadingInProgress = false;
    // ignore: avoid_print
    print(e);
    return newTodo;
  }
}
