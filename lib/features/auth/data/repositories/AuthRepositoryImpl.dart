import 'package:ayo_football_app/core/api/ApiClient.dart';
import 'package:ayo_football_app/core/api/ApiResponse.dart';
import 'package:ayo_football_app/core/constants/AppConstants.dart';
import 'package:ayo_football_app/features/auth/domain/repositories/AuthRepository.dart';
import 'package:ayo_football_app/features/auth/data/models/UserModel.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<AuthResponseModel>> login(String email, String password) async {
    return await _apiClient.post<AuthResponseModel>(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
      fromJson: (json) => AuthResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<UserModel>> register(String name, String email, String password) async {
    return await _apiClient.post<UserModel>(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<UserModel>> getProfile() async {
    return await _apiClient.get<UserModel>(
      ApiEndpoints.profile,
      fromJson: (json) => UserModel.fromJson(json),
    );
  }
}
