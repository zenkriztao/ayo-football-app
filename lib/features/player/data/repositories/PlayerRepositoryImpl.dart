import 'package:ayo_football_app/core/api/ApiClient.dart';
import 'package:ayo_football_app/core/api/ApiResponse.dart';
import 'package:ayo_football_app/core/constants/AppConstants.dart';
import 'package:ayo_football_app/features/player/domain/repositories/PlayerRepository.dart';
import 'package:ayo_football_app/features/player/data/models/PlayerModel.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final ApiClient _apiClient;

  PlayerRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<List<PlayerModel>>> getPlayers({
    int page = 1,
    int limit = 10,
    String? search,
    String? teamId,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (teamId != null && teamId.isNotEmpty) {
      queryParams['team_id'] = teamId;
    }

    return await _apiClient.getList<PlayerModel>(
      ApiEndpoints.players,
      queryParameters: queryParams,
      fromJson: (json) => PlayerModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<PlayerModel>> getPlayerById(String id) async {
    return await _apiClient.get<PlayerModel>(
      ApiEndpoints.playerById(id),
      fromJson: (json) => PlayerModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<PlayerModel>> createPlayer(Map<String, dynamic> data) async {
    return await _apiClient.post<PlayerModel>(
      ApiEndpoints.players,
      data: data,
      fromJson: (json) => PlayerModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<PlayerModel>> updatePlayer(String id, Map<String, dynamic> data) async {
    return await _apiClient.put<PlayerModel>(
      ApiEndpoints.playerById(id),
      data: data,
      fromJson: (json) => PlayerModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<void>> deletePlayer(String id) async {
    return await _apiClient.delete<void>(ApiEndpoints.playerById(id));
  }
}
