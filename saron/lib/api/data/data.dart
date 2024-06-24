// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:saron/api/get_all_utilization/get_all_utilization.dart';
// import 'package:saron/api/url/url.dart';
// import 'package:saron/api/utilization_model/utilization_model.dart';
// import 'package:saron/main.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// abstract class ApiCalls {
//   Future<int> userLogin(String email, String password);
//   Future<int> userSignup(String username, String email, String password);
//   Future<int> forgetPassword(String email);
//   Future<int> resetPassword(String email, String token, String password);
//   Future<int> deleteAccount(String password);

//   Future<List<UtilizationModel>> getAllUtilizationData();
//   Future<List<UtilizationModel>> history(String startDate, String endDate);
//   Future<double> unitConsumed(String startDate, String endDate);
// }

// class UtilizationDB extends ApiCalls {
//   final Dio dio = Dio();
//   final Url url = Url();
//   late SharedPreferences _sharedPref;
//   late String _token;
//   bool _initialized = false;

//   UtilizationDB() {
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     _sharedPref = await SharedPreferences.getInstance();
//     _token = _sharedPref.getString(TOKEN) ?? '';
//     dio.options = BaseOptions(
//       baseUrl: url.baseUrl,
//       responseType: ResponseType.plain,
//       headers: {
//         "authorization": _token,
//       },
//     );
//     _initialized = true;
//   }

//   @override
//   Future<List<UtilizationModel>> getAllUtilizationData() async {
//     if (!_initialized) {
//       await _initialize();
//     }
//     try {
//       final result = await dio.get(url.getAllUtilizationData);

//       if (result.data != null) {
//         final resultAsJson = jsonDecode(result.data);

//         final getUtilization = GetAllUtilization.fromJson(resultAsJson);
//         return getUtilization.utilization;
//       } else {
//         return [];
//       }
//     } catch (e) {
//       return [];
//     }
//   }

//   @override
//   Future<List<UtilizationModel>> history(
//       String startDate, String endDate) async {
//     if (!_initialized) {
//       await _initialize();
//     }
//     try {
//       final result = await dio.get(
//           url.fetchUtilization + '?startDate=${startDate}&endDate=${endDate}');

//       if (result.data != null) {
//         final resultAsJson = jsonDecode(result.data);

//         final getUtilization = GetAllUtilization.fromJson(resultAsJson);
//         print(resultAsJson);
//         return getUtilization.utilization;
//       } else {
//         return [];
//       }
//     } catch (e) {
//       return [];
//     }
//   }

//   @override
//   Future<double> unitConsumed(String startDate, String endDate) async {
//     if (!_initialized) {
//       await _initialize();
//     }
//     try {
//       final result = await dio.get(
//           url.fetchUnitConsumed + '?startDate=${startDate}&endDate=${endDate}');

//       Map<String, dynamic> jsonData = jsonDecode(result.data);
//       double totalUnitConsumed = jsonData['totalUnitConsumed'].toDouble();

//       return totalUnitConsumed;
//     } catch (e) {
//       return -1;
//     }
//   }

//   @override
//   Future<int> userLogin(String email, String password) async {
//     if (!_initialized) {
//       await _initialize();
//     }
//     try {
//       final response = await dio.post(
//         url.login,
//         data: {
//           'email': email,
//           'password': password,
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.data);
//         final token = responseData['token'];
//         final username = responseData['username'];
//         final email = responseData['email'];
//         final _sharedPref = await SharedPreferences.getInstance();
//         await _sharedPref.setString(TOKEN, token);
//         await _sharedPref.setString(USERNAME, username);
//         await _sharedPref.setString(EMAIL, email);

//         return response.statusCode ?? -1;
//       } else {
//         return response.statusCode ?? -1;
//       }
//     } catch (e) {
//       if (e is DioException && e.response != null) {
//         return e.response!.statusCode ?? -1;
//       } else {
//         return -1;
//       }
//     }
//   }

//   @override
//   Future<int> userSignup(String username, String email, String password) async {
//     if (!_initialized) {
//       await _initialize();
//     }
//     try {
//       final response = await dio.post(
//         url.signup,
//         data: {
//           'username': username,
//           'email': email,
//           'password': password,
//         },
//       );

//       return response.statusCode ?? -1;
//     } catch (e) {
//       if (e is DioException && e.response != null) {
//         return e.response!.statusCode ?? -1;
//       } else {
//         return -1;
//       }
//     }
//   }

//   @override
//   Future<int> forgetPassword(String email) async {
//     if (!_initialized) {
//       await _initialize();
//     }
//     try {
//       final response = await dio.post(
//         url.forgetPassword,
//         data: {
//           'email': email,
//         },
//       );

//       return response.statusCode ?? -1;
//     } catch (e) {
//       if (e is DioException && e.response != null) {
//         return e.response!.statusCode ?? -1;
//       } else {
//         return -1;
//       }
//     }
//   }

//   @override
//   Future<int> resetPassword(String email, String token, String password) async {
//     if (!_initialized) {
//       await _initialize();
//     }
//     try {
//       final response = await dio.post(
//         url.resetPassword,
//         data: {'email': email, 'token': token, 'password': password},
//       );

//       return response.statusCode ?? -1;
//     } catch (e) {
//       if (e is DioException && e.response != null) {
//         return e.response!.statusCode ?? -1;
//       } else {
//         return -1;
//       }
//     }
//   }

//   @override
//   Future<int> deleteAccount(String password) async {
//     if (!_initialized) {
//       await _initialize();
//     }
//     try {
//       _sharedPref = await SharedPreferences.getInstance();
//       final _email = _sharedPref.getString(EMAIL) ?? '';
//       final response = await dio.delete(
//         url.deleteAccount,
//         data: {'email': _email, 'password': password},
//       );

//       return response.statusCode ?? -1;
//     } catch (e) {
//       if (e is DioException && e.response != null) {
//         return e.response!.statusCode ?? -1;
//       } else {
//         return -1;
//       }
//     }
//   }
// }
