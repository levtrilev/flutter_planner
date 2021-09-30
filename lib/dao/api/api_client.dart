import 'dart:convert';
import 'dart:io';

import 'package:async_redux_todo/dao/entity/todo_item.dart';

/*
// Возможные ошибки при соединении:
//
// 1. Нет сети
// 2. Нет ответа - таймаут соединения
// 3. Сервер недоступен
// 4. Сервер не может обработать запрос
// 5. Сервер ответил не то, что мы ожидали
// 6. Сервер ответил ожидаемой ошибкой
*/

enum ApiClientExceptionType { network, auth, apiKey, other, token }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;
  // final String errorMessage;

  ApiClientException(this.type);
}

class ApiClient {
  final _client = HttpClient();
  static const _host = 'http://api.themoviedb.org/3';
  // static const _hostMin = 'http://192.168.1.71:80';
  static const _hostMin = 'http://95.165.6.202:80';
  // static const _hostMinLan = 'http://192.168.1.71:80';
  // static const _hostMinWan = 'http://192.168.1.71:80';
  // static const _hostMinLocalhost = 'http://10.0.2.2:5000';
  static const _imageUrl = 'http://tmdb.org/t/p/w500';
  static const _apiKey = '0a2a46b5593a0978cc8e87ba34037430';

  static imageUrl(String path) {
    return _imageUrl + path;
  }

  Future<List<TodoItem>?> minimalApiGet() async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final jsonMapList = json.map((e) => e as Map<String, dynamic>);
      final responce = jsonMapList.map((e) => TodoItem.fromJson(e)).toList();
      return responce;
    };
    final result = await _get(_hostMin, '/api/todoitems', parser);
    return result;
    // // _client.connectionTimeout = Duration.zero;
    // final url = Uri.parse('$_host/authentication/token/new?api_key=$_apiKey');
    // //final urlMin = Uri.parse('http://10.0.2.2:5000/todoitems');
  }

  Future<List<TodoItem>>? searchTodoItemsGet(String query) async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final responce = (json as List<dynamic>)
          .map((e) => TodoItem.fromJson(e as Map<String, dynamic>))
          .toList();
      return responce;
    };
    //await _checkAddress();
    final result = await _get(_hostMin, '/api/todoitems/title/$query', parser);

    return result;
  }

  Future<List<TodoItem>>? todoItemsGet() async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final responce = (json as List<dynamic>)
          .map((e) => TodoItem.fromJson(e as Map<String, dynamic>))
          .toList();
      return responce;
    };
    //await _checkAddress();
    final result = await _get(_hostMin, '/api/todoitems', parser);

    return result;
  }

  Future<TodoItem>? todoItemGet(int id) async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final responce = TodoItem.fromJson(json as Map<String, dynamic>);
      return responce;
    };

    final result = _get(_hostMin, '/api/todoitems/${id.toString()}', parser);
    return result;
  }

  Future<bool>? todoItemDelete(int id) async {
    return await _delete(_hostMin, '/api/todoitems/${id.toString()}');
  }

  Future<String> auth({
    required String username,
    required String password,
  }) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
      username: username,
      password: password,
      requestToken: token,
    );
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Future<bool> _delete<bool>(
    String host,
    String path,
  ) async {
    final url = _makeUri(
      host,
      path,
    );
    bool deleted = false as bool;
    try {
      final request = await _client.deleteUrl(url);
      await request.close().then((responce) {
        responce.statusCode == 204
            ? deleted = true as bool
            : deleted = false as bool;
      });
      return deleted;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<T> _get<T>(
    String host,
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]) async {
    final url = _makeUri(host, path, parameters);
    try {
      final request = await _client.getUrl(url);
      final responce = await request.close();
      final dynamic json = (await responce.jsonDecode());
      _validateResponce(responce, json);
      final result = parser(json);
      return result;
      // final token = json['request_token'] as String;
      // return token;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      //rethrow;
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<bool> _put(
    String host,
    String path,
    Map<String, dynamic>? bodyParameters, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    try {
      final url = _makeUri(host, path, urlParameters);
      final request = await _client.putUrl(url);
      request.headers.contentType = ContentType.json;
      var tmpVarJson = jsonEncode(bodyParameters);
      request.write(tmpVarJson);
      final responce = await request.close();
      if (responce.statusCode == 204) return true;
      return false;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      //rethrow;
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<T> _post<T>(
    String host,
    String path,
    Map<String, dynamic>? bodyParameters,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    try {
      // final parameters = <String, dynamic>{
      //   'username': username,
      //   'password': password,
      //   'request_token': requestToken
      // };
      final url = _makeUri(host, path, urlParameters);
      // final url = Uri.parse(
      //     '$_host/authentication/token/validate_with_login?api_key=$_apiKey');

      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));
      final responce = await request.close();
      final dynamic json = (await responce.jsonDecode());

      _validateResponce(responce, json);
      final result = parser(json);
      return result;
      // final token = json['request_token'] as String;
      // return token;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      //rethrow;
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<String> _makeToken() async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    };

    final result = _get(_host, '/authentication/token/new', parser,
        <String, dynamic>{'api_key': _apiKey});
    return result;
    // // _client.connectionTimeout = Duration.zero;
    // final url = Uri.parse('$_host/authentication/token/new?api_key=$_apiKey');
    // //final urlMin = Uri.parse('http://10.0.2.2:5000/todoitems');
  }

  Future<int> createTodoItem({
    required TodoItem todoItemToCreate,
  }) async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final createdId = jsonMap['id'] as int;
      return createdId;
    };
    final bodyParameters = <String, dynamic>{
      'id': 0,
      'title': todoItemToCreate.title,
      'isCompleted': todoItemToCreate.isCompleted,
      'openDate': todoItemToCreate.openDate.toIso8601String(),
      'closeDate': todoItemToCreate.closeDate.toIso8601String(),
    };
    final result = _post(
      _hostMin,
      '/api/todoitems',
      bodyParameters,
      parser,
    );
    return result;
  }

  Future<int> updateTodoItem({
    required TodoItem todoItemToUpdate,
  }) async {
    final bodyParameters = <String, dynamic>{
      'id': todoItemToUpdate.id,
      'title': todoItemToUpdate.title,
      'isCompleted': todoItemToUpdate.isCompleted,
      'openDate': todoItemToUpdate.openDate.toIso8601String(),
      'closeDate': todoItemToUpdate.closeDate.toIso8601String(),
      'priority': todoItemToUpdate.priority,
    };
    final success = await _put(
      _hostMin,
      '/api/todoitems/${todoItemToUpdate.id.toString()}',
      bodyParameters,
    );
    return success ? todoItemToUpdate.id : 0;
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    };
    final bodyParameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken
    };
    final result = _post(
      _host,
      '/authentication/token/validate_with_login',
      bodyParameters,
      parser,
      <String, dynamic>{'api_key': _apiKey},
    );
    return result;
  }

  Future<String> _makeSession({
    required String requestToken,
  }) async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;
      return sessionId;
    };
    final bodyParameters = <String, dynamic>{'request_token': requestToken};
    final result = _post(
      _host,
      '/authentication/session/new',
      bodyParameters,
      parser,
      <String, dynamic>{'api_key': _apiKey},
    );
    return result;
  }

  Uri _makeUri(String host, String path, [Map<String, dynamic>? parameters]) {
    // _client.connectionTimeout = Duration.zero;
    final uri = Uri.parse('$host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
    //final url = Uri.parse('$_host/authentication/token/new?api_key=$_apiKey');
    //final urlMin = Uri.parse('http://10.0.2.2:5000/todoitems');
  }

  void _validateResponce(HttpClientResponse responce, dynamic json) {
    if (responce.statusCode == 401) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        // 30 - неверный логин-пароль 7 - невнрный ApiKey 33 - неверный токен
        throw ApiClientException(ApiClientExceptionType.auth);
      } else if (code == 7) {
        throw ApiClientException(ApiClientExceptionType.apiKey);
      } else if (code == 33) {
        throw ApiClientException(ApiClientExceptionType.token);
      } else {
        throw ApiClientException(ApiClientExceptionType.other);
      }
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder).toList().then((value) {
      final stringJson = value.join();
      return stringJson;
    }).then<dynamic>((v) => json.decode(v));
  }
}
