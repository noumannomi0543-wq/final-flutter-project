import 'package:dio/dio.dart';
import 'package:flutter_final_project/networks/network_client.dart';
import 'package:flutter_final_project/utils/constants.dart';

class ApiServices {
  NetworkClient networkClient;
  ApiServices(this.networkClient);

  Future<Response> register(Map<String, dynamic> params) async {
    return await networkClient.post(Constants.signUpEndpoint, params);
  }

  Future<Response> login(Map<String, dynamic> params) async {
    return await networkClient.post(Constants.loginEndpoint, params);
  }

  Future<Response> forgotPassword(Map<String, dynamic> params) async {
    return await networkClient.post(Constants.forgotPasswordEndpoint, params);
  }

  Future<Response> verifyForgotPasswordOtp(Map<String, dynamic> params) async {
    return await networkClient.post(Constants.verifyOtpEndpoint, params);
  }

  Future<Response> resetPassword(Map<String, dynamic> params) async {
    return await networkClient.post(Constants.resetPasswordEndpoint, params);
  }

  Future<Response> propertyTypes() async {
    return await networkClient.get(Constants.propertyTypesEndpoint);
  }

  Future<Response> propertySuggestions({required String query}) async {
    return await networkClient.get(
      Constants.propertySuggestionsEndpoint,
      params: {"q": query},
    );
  }

  Future<Response> propertyAmenities() async {
    return await networkClient.get(Constants.propertyAmenitiesEndpoint);
  }

  Future<Response> searchProperties(Map<String, dynamic> params) async {
    return await networkClient.get(
      Constants.searchPropertiesEndpoint,
      params: params,
    );
  }

  Future<Response> recommendedProperties({int size = 20}) async {
    return await networkClient.get(
      Constants.recommendedPropertiesEndpoint,
      params: {"size": size},
    );
  }

  Future<Response> featuredProperties({int size = 20}) async {
    return await networkClient.get(
      Constants.featuredPropertiesEndpoint,
      params: {"size": size},
    );
  }

  Future<Response> newDevelopments({int size = 20}) async {
    return await networkClient.get(
      Constants.newDevelopmentsEndpoint,
      params: {"size": size},
    );
  }

  Future<Response> propertyById(int id) async {
    return await networkClient.get("${Constants.searchPropertiesEndpoint}/$id");
  }

  Future<Response> news({int size = 20}) async {
    return await networkClient.get(
      Constants.newsEndpoint,
      params: {"size": size},
    );
  }

  Future<Response> notifications({int size = 30}) async {
    return await networkClient.get(
      Constants.notificationsEndpoint,
      params: {"size": size},
    );
  }

  Future<Response> markAllNotificationsRead() async {
    return await networkClient.post(Constants.notificationsEndpoint, {
      "read": true,
    });
  }

  Future<Response> markNotificationRead(int id) async {
    return await networkClient.post("${Constants.notificationsEndpoint}/$id", {
      "read": true,
    });
  }

  Future<Response> addCard(Map<String, dynamic> params) async {
    return await networkClient.post(Constants.addCardEndpoint, params);
  }

  Future<Response> refreshToken(Map<String, dynamic> params) async {
    return await networkClient.post(Constants.refreshTokenEndpoint, params);
  }
}
