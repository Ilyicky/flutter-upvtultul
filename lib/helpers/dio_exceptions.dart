import 'dart:io';
import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        if (dioError.response != null) {
          message = _handleError(
            dioError.response!.statusCode!,
            dioError.response!.data,
          );
        } else {
          message = "Received invalid response from server";
        }
        break;
      case DioExceptionType.connectionError:
        message = "Connection to API server failed due to internet connection";
        break;
      case DioExceptionType.badCertificate:
        message = "SSL certificate verification failed";
        break;
      case DioExceptionType.unknown:
        message = _handleUnknownError(dioError);
        break;
    }
  }

  late String message;

  String _handleError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return error is Map && error.containsKey("message") 
            ? error["message"] 
            : 'Resource not found';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      default:
        return 'Oops something went wrong (Status $statusCode)';
    }
  }

  String _handleUnknownError(DioException error) {
    if (error.error is SocketException) {
      return "No internet connection";
    } else if (error.error is FormatException) {
      return "Invalid data format from server";
    }
    return "Unknown error occurred";
  }

  @override
  String toString() => message;
}