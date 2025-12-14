import 'package:ayo_football_app/core/api/ApiResponse.dart';
import 'package:ayo_football_app/features/player/data/models/PlayerModel.dart';

abstract class PlayerRepository {
  Future<ApiResponse<List<PlayerModel>>> getPlayers({
    int page = 1,
    int limit = 10,
    String? search,
    String? teamId,
  });
  Future<ApiResponse<PlayerModel>> getPlayerById(String id);
  Future<ApiResponse<PlayerModel>> createPlayer(Map<String, dynamic> data);
  Future<ApiResponse<PlayerModel>> updatePlayer(String id, Map<String, dynamic> data);
  Future<ApiResponse<void>> deletePlayer(String id);
}
