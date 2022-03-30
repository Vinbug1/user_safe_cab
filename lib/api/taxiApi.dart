import 'dart:convert';
import 'dart:io';
import 'package:user_safe_cab/api/error-resp.dart';
import 'package:user_safe_cab/models/rider.dart';
import 'api-resp.dart';
import 'package:http/http.dart' as http;
import 'error-resp.dart';

String baseUrl = "http://192.168.1.8:9001/";
Future<ApiResponse> authenticateUser(String username, String password) async {
  ApiResponse _apiResponse = new ApiResponse();

  try {
    final response = await http.post(Uri.parse('$baseUrl/user/login'), body: {
      'username': username,
      'password': password,
    });

    switch (response.statusCode) {
      case 200:
        _apiResponse.Data = Rider.fromJson(json.decode(response.body));
        break;
      case 401:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
      default:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
  } on SocketException {
    _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
  }
  return _apiResponse;
}

Future<Rider> createUser(String firstName,String lastName,String phone, String email, String password) async {
  ApiResponse _apiResponse = new ApiResponse();

  try {
    final response = await http.post(Uri.parse('$baseUrl/user/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String,String>{
         'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'email': email,
          'password': password
    }),
    );

    switch (response.statusCode) {
      case 200:
        _apiResponse.Data = Rider.fromJson(json.decode(response.body));
        break;
      case 401:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
      default:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
  } on SocketException {
    _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
  }
}

 Future startRide(String userId,String location,String driverId) async{
   ApiResponse _apiResponse = new ApiResponse();
   try {
     final response = await http.post(Uri.parse('$baseUrl/user/startRide'),
         headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
         },
         body:jsonEncode(<String,String>{
           'userId': userId,
           'location': location,
           'driverId': driverId}),
     );

     switch (response.statusCode) {
       case 200:
         _apiResponse.Data = Rider.fromJson(json.decode(response.body));
         break;
       case 401:
         _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
         break;
       default:
         _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
         break;
     }
   } on SocketException {
     _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
   }
 }

 Future<ApiResponse>getDriver(String driverId) async {
   ApiResponse _apiResponse = new ApiResponse();
   try {
     final response = await http.get(Uri.parse('$baseUrl/user/$driverId'));

     switch (response.statusCode) {
       case 200:
         _apiResponse.Data = Rider.fromJson(json.decode(response.body));
         break;
       case 401:
         _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
         break;
       default:
         _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
         break;
     }
   } on SocketException {
     _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
   }
   return _apiResponse;
 }
Future endRide(String userId,String dropOffLocation,String driverId) async{
  ApiResponse _apiResponse = new ApiResponse();
  try {
    final response = await http.post(Uri.parse('$baseUrl/user/endRide'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:jsonEncode(<String,String> {
          'userId': userId,
          'dropOfLocation': dropOffLocation,
          'driverId': driverId
        }),);

    switch (response.statusCode) {
      case 200:
        _apiResponse.Data = Rider.fromJson(json.decode(response.body));
        break;
      case 401:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
      default:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
  } on SocketException {
    _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
  }
}