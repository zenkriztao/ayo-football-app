import 'package:ayo_football_app/features/auth/data/models/UserModel.dart';
import 'package:ayo_football_app/core/api/ApiResponse.dart';

abstract class AuthRepository {
  Future<ApiResponse<AuthResponseModel>> login(String email, String password);
  Future<ApiResponse<UserModel>> register(String name, String email, String password);
  Future<ApiResponse<UserModel>> getProfile();
}
