import 'package:ayo_football_app/core/api/ApiResponse.dart';
import 'package:ayo_football_app/features/team/data/models/TeamModel.dart';

abstract class TeamRepository {
  Future<ApiResponse<List<TeamModel>>> getTeams({
    int page = 1,
    int limit = 10,
    String? search,
  });
  Future<ApiResponse<TeamModel>> getTeamById(String id, {bool withPlayers = false});
  Future<ApiResponse<TeamModel>> createTeam(Map<String, dynamic> data);
  Future<ApiResponse<TeamModel>> updateTeam(String id, Map<String, dynamic> data);
  Future<ApiResponse<void>> deleteTeam(String id);
}
