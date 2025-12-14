import 'package:ayo_football_app/core/api/ApiClient.dart';
import 'package:ayo_football_app/core/api/ApiResponse.dart';
import 'package:ayo_football_app/core/constants/AppConstants.dart';
import 'package:ayo_football_app/features/report/domain/repositories/ReportRepository.dart';
import 'package:ayo_football_app/features/report/data/models/ReportModel.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ApiClient _apiClient;

  ReportRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<List<MatchReportModel>>> getMatchReports({
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    return await _apiClient.getList<MatchReportModel>(
      ApiEndpoints.matchReports,
      queryParameters: queryParams,
      fromJson: (json) => MatchReportModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<MatchReportModel>> getMatchReportById(String id) async {
    return await _apiClient.get<MatchReportModel>(
      ApiEndpoints.matchReportById(id),
      fromJson: (json) => MatchReportModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<List<TopScorerModel>>> getTopScorers({
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
    };

    return await _apiClient.getList<TopScorerModel>(
      ApiEndpoints.topScorers,
      queryParameters: queryParams,
      fromJson: (json) => TopScorerModel.fromJson(json),
    );
  }
}
