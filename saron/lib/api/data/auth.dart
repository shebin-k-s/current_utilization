import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:saron/api/url/url.dart';
import 'package:saron/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthApiCalls {
  Future<int> userLogin(String email, String password);
  Future<int> userSignup(String username, String email, String password);
  Future<int> forgetPassword(String email);
  Future<int> resetPassword(String email, String token, String password);
  Future<int> deleteAccount(String password);
}

class AuthDB extends AuthApiCalls {
  final dio = Dio();
  final url = Url();

  AuthDB() {
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
    );
  }

  @override
  Future<int> userLogin(String email, String password) async {
    try {
      final response = await dio.post(
        url.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.data);
        final token = responseData['token'];
        final username = responseData['username'];
        final email = responseData['email'];
        print(email);
        final _sharedPref = await SharedPreferences.getInstance();
        await _sharedPref.setString(TOKEN, token);
        await _sharedPref.setString(USERNAME, username);
        await _sharedPref.setString(EMAIL, email);

        return response.statusCode ?? -1;
      } else {
        return response.statusCode ?? -1;
      }
    } catch (e) {
      print(e);
      if (e is DioException && e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    }
  }

  @override
  Future<int> userSignup(String username, String email, String password) async {
    try {
      final response = await dio.post(
        url.signup,
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      return response.statusCode ?? -1;
    } catch (e) {
      if (e is DioException && e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    }
  }

  @override
  Future<int> forgetPassword(String email) async {
    try {
      final response = await dio.post(
        url.forgetPassword,
        data: {
          'email': email,
        },
      );

      return response.statusCode ?? -1;
    } catch (e) {
      if (e is DioException && e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    }
  }

  @override
  Future<int> resetPassword(String email, String token, String password) async {
    try {
      final response = await dio.post(
        url.resetPassword,
        data: {'email': email, 'token': token, 'password': password},
      );

      return response.statusCode ?? -1;
    } catch (e) {
      if (e is DioException && e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    }
  }

  @override
  Future<int> deleteAccount(String password) async {
    try {
      final _sharedPref = await SharedPreferences.getInstance();
      final _email = _sharedPref.getString(EMAIL) ?? '';
      final response = await dio.delete(
        url.deleteAccount,
        data: {'email': _email, 'password': password},
      );

      return response.statusCode ?? -1;
    } catch (e) {
      if (e is DioException && e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    }
  }
}
