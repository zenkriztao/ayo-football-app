import 'package:ayo_football_app/core/api/ApiClient.dart';
import 'package:ayo_football_app/core/api/ApiResponse.dart';
import 'package:ayo_football_app/core/constants/AppConstants.dart';
import 'package:ayo_football_app/features/match/domain/repositories/MatchRepository.dart';
import 'package:ayo_football_app/features/match/data/models/MatchModel.dart';

class MatchRepositoryImpl implements MatchRepository {
  final ApiClient _apiClient;

  MatchRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<List<MatchModel>>> getMatches({
    int page = 1,
    int limit = 10,
    String? status,
    String? teamId,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (status != null) queryParams['status'] = status;
    if (teamId != null) queryParams['team_id'] = teamId;

    return await _apiClient.getList<MatchModel>(
      ApiEndpoints.matches,
      queryParameters: queryParams,
      fromJson: (json) => MatchModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<MatchModel>> getMatchById(String id) async {
    return await _apiClient.get<MatchModel>(
      ApiEndpoints.matchById(id),
      fromJson: (json) => MatchModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<MatchModel>> createMatch(Map<String, dynamic> data) async {
    return await _apiClient.post<MatchModel>(
      ApiEndpoints.matches,
      data: data,
      fromJson: (json) => MatchModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<MatchModel>> updateMatch(String id, Map<String, dynamic> data) async {
    return await _apiClient.put<MatchModel>(
      ApiEndpoints.matchById(id),
      data: data,
      fromJson: (json) => MatchModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<void>> deleteMatch(String id) async {
    return await _apiClient.delete<void>(ApiEndpoints.matchById(id));
  }

  @override
  Future<ApiResponse<MatchModel>> recordResult(String id, Map<String, dynamic> data) async {
    return await _apiClient.post<MatchModel>(
      ApiEndpoints.matchResult(id),
      data: data,
      fromJson: (json) => MatchModel.fromJson(json),
    );
  }
}
