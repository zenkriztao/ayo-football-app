import 'package:ayo_football_app/core/api/ApiResponse.dart';
import 'package:ayo_football_app/features/match/data/models/MatchModel.dart';

abstract class MatchRepository {
  Future<ApiResponse<List<MatchModel>>> getMatches({
    int page = 1,
    int limit = 10,
    String? status,
    String? teamId,
  });
  Future<ApiResponse<MatchModel>> getMatchById(String id);
  Future<ApiResponse<MatchModel>> createMatch(Map<String, dynamic> data);
  Future<ApiResponse<MatchModel>> updateMatch(String id, Map<String, dynamic> data);
  Future<ApiResponse<void>> deleteMatch(String id);
  Future<ApiResponse<MatchModel>> recordResult(String id, Map<String, dynamic> data);
}
