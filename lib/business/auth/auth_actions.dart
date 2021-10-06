// AuthenticateAction
import 'package:async_redux/async_redux.dart';
import 'package:async_redux_todo/business/app_state.dart';
import 'package:async_redux_todo/business/todo/todo_actions.dart';
import 'package:async_redux_todo/dao/api/api_client.dart';
import 'package:async_redux_todo/dao/entity/user.dart';

final _apiClient = ApiClient();

class AuthenticateAction extends ReduxAction<AppState> {
  final String username;
  final String password;
  AuthenticateAction({
    required this.username,
    required this.password,
  });

  @override
  Future<AppState?> reduce() async {
    String token = '';
    List<User> users = <User>[];
    final userData = await _apiClient.makeUserToken(username, password);
    token = userData['token'] ?? '';
    if (token == '') return null;
    users = await _apiClient.getUserByEmail(userData['email'] ?? '', token) ?? <User>[];
    final userId = users.length == 1 ? users[0].id : 0;
    final newstate = state.copy(
        appStatus: state.appStatus.copy(
      userToken: token,
      userId: userId,
      isAuthInProgress: false,
    ));
    return newstate;
  }

  @override
  void after() {
    if (state.appStatus.userToken != '') {
      dispatch(InitialGetTodoListAction());
    }
  }
}
