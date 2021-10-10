import 'package:async_redux_todo/dao/session_data_provider.dart';

class AppModel {
  final _sessionDataProvider = SessionDataProvider();
  var _isAuth = false;
  String _token = '';
  int _userId = 0;
  bool get isAuth => _isAuth;
  String get token => _token;
  int get userId => _userId;

  Future<void> checkAuth() async {
    final token = await _sessionDataProvider.getToken();
    _isAuth = token != null;
    _token = token ?? '';
  }

  Future<void> getUserId() async {
    final userId = await _sessionDataProvider.getUserId();
    _userId = userId ?? 0;
  }
}
