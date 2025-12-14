import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/core/api/ApiClient.dart';
import 'package:ayo_football_app/features/report/data/repositories/ReportRepositoryImpl.dart';
import 'package:ayo_football_app/features/report/data/models/ReportModel.dart';

class MatchReportDetailPage extends StatefulWidget {
  final String matchId;

  const MatchReportDetailPage({super.key, required this.matchId});

  @override
  State<MatchReportDetailPage> createState() => _MatchReportDetailPageState();
}

class _MatchReportDetailPageState extends State<MatchReportDetailPage> {
  late final ReportRepositoryImpl _repository;
  MatchReportModel? _report;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = ReportRepositoryImpl(ApiClient());
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _repository.getMatchReportById(widget.matchId);
      if (response.success && response.data != null) {
        setState(() {
          _report = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load report: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Match Report',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_report == null) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadReport,
      color: AppTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildMatchHeader(),
            const SizedBox(height: 16),
            _buildMatchStats(),
            const SizedBox(height: 16),
            _buildGoalsList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              _error ?? 'An error occurred',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_soccer_outlined,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Report Not Found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHeader() {
    final report = _report!;
    return Container(
      color: AppTheme.primaryColor,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          // Date
          Text(
            report.match.matchDate,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          // Teams and score
          Row(
            children: [
              // Home team
              Expanded(
                child: Column(
                  children: [
                    _buildTeamLogo(report.homeTeam.logo, isWhite: true),
                    const SizedBox(height: 8),
                    Text(
                      report.homeTeam.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Home',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              // Score
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      report.scoreDisplay,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      'Full Time',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Away team
              Expanded(
                child: Column(
                  children: [
                    _buildTeamLogo(report.awayTeam.logo, isWhite: true),
                    const SizedBox(height: 8),
                    Text(
                      report.awayTeam.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Away',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Result badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              report.matchResultDisplay,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchStats() {
    final report = _report!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Statistics',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Total Wins',
            report.homeTeamTotalWins.toString(),
            report.awayTeamTotalWins.toString(),
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            'Goals This Match',
            report.homeScore.toString(),
            report.awayScore.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String homeValue, String awayValue) {
    return Row(
      children: [
        Text(
          homeValue,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          awayValue,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsList() {
    final report = _report!;
    if (report.goals.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Center(
          child: Text(
            'No goals in this match',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sports_soccer,
                size: 20,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Goals',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...report.goals.map((goal) => _buildGoalItem(goal)),
        ],
      ),
    );
  }

  Widget _buildGoalItem(goal) {
    final report = _report!;
    final isHomeTeamGoal = goal.teamId == report.homeTeam.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (isHomeTeamGoal) ...[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    goal.playerName ?? 'Unknown',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (goal.isOwnGoal) ...[
                    const SizedBox(width: 4),
                    Text(
                      '(OG)',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            const Expanded(child: SizedBox()),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${goal.minute}'",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          if (!isHomeTeamGoal) ...[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (goal.isOwnGoal) ...[
                    Text(
                      '(OG)',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    goal.playerName ?? 'Unknown',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Expanded(child: SizedBox()),
          ],
        ],
      ),
    );
  }

  Widget _buildTeamLogo(String? logo, {bool isWhite = false}) {
    if (logo != null && logo.isNotEmpty) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: isWhite ? Colors.white30 : AppTheme.cardBorder,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            logo,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholderLogo(isWhite: isWhite),
          ),
        ),
      );
    }
    return _buildPlaceholderLogo(isWhite: isWhite);
  }

  Widget _buildPlaceholderLogo({bool isWhite = false}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isWhite
            ? Colors.white.withValues(alpha: 0.2)
            : AppTheme.primaryColor.withValues(alpha: 0.1),
        border: Border.all(
          color: isWhite ? Colors.white30 : AppTheme.cardBorder,
        ),
      ),
      child: Icon(
        Icons.shield,
        size: 28,
        color: isWhite ? Colors.white : AppTheme.primaryColor,
      ),
    );
  }
}
