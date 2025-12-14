import 'package:ayo_football_app/core/api/ApiResponse.dart';
import 'package:ayo_football_app/features/report/data/models/ReportModel.dart';

abstract class ReportRepository {
  /// Get all match reports with pagination
  Future<ApiResponse<List<MatchReportModel>>> getMatchReports({
    int page = 1,
    int limit = 10,
  });

  /// Get a specific match report by ID
  Future<ApiResponse<MatchReportModel>> getMatchReportById(String id);

  /// Get top scorers leaderboard
  Future<ApiResponse<List<TopScorerModel>>> getTopScorers({
    int limit = 10,
  });
}
