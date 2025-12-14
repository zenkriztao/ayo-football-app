import 'package:ayo_football_app/core/api/ApiClient.dart';
import 'package:ayo_football_app/core/api/ApiResponse.dart';
import 'package:ayo_football_app/core/constants/AppConstants.dart';
import 'package:ayo_football_app/features/team/domain/repositories/TeamRepository.dart';
import 'package:ayo_football_app/features/team/data/models/TeamModel.dart';

class TeamRepositoryImpl implements TeamRepository {
  final ApiClient _apiClient;

  TeamRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<List<TeamModel>>> getTeams({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    return await _apiClient.getList<TeamModel>(
      ApiEndpoints.teams,
      queryParameters: queryParams,
      fromJson: (json) => TeamModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<TeamModel>> getTeamById(String id, {bool withPlayers = false}) async {
    final queryParams = <String, dynamic>{};
    if (withPlayers) {
      queryParams['with_players'] = 'true';
    }

    return await _apiClient.get<TeamModel>(
      ApiEndpoints.teamById(id),
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (json) => TeamModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<TeamModel>> createTeam(Map<String, dynamic> data) async {
    return await _apiClient.post<TeamModel>(
      ApiEndpoints.teams,
      data: data,
      fromJson: (json) => TeamModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<TeamModel>> updateTeam(String id, Map<String, dynamic> data) async {
    return await _apiClient.put<TeamModel>(
      ApiEndpoints.teamById(id),
      data: data,
      fromJson: (json) => TeamModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<void>> deleteTeam(String id) async {
    return await _apiClient.delete<void>(ApiEndpoints.teamById(id));
  }
}
