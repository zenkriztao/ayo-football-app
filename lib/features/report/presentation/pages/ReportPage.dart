import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/core/widgets/coming_soon_sheet.dart';
import 'package:ayo_football_app/features/report/presentation/pages/MatchReportsPage.dart';
import 'package:ayo_football_app/features/report/presentation/pages/TopScorersPage.dart';

/// AYO-style Report Page
class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: Text(
          'Reports',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Statistics'),
          const SizedBox(height: 12),
          _buildReportCard(
            context,
            'Match Reports',
            'View detailed reports of completed matches',
            Icons.sports_soccer,
            AppTheme.primaryColor,
            isAvailable: true,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MatchReportsPage(),
                ),
              );
            },
          ),
          _buildReportCard(
            context,
            'Top Scorers',
            'View top goal scorers leaderboard',
            Icons.emoji_events,
            Colors.amber,
            isAvailable: true,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TopScorersPage(),
                ),
              );
            },
          ),
          _buildReportCard(
            context,
            'Team Statistics',
            'View team performance statistics',
            Icons.bar_chart,
            Colors.blue,
            isAvailable: false,
            () => _showComingSoon(
              context,
              title: 'Team Statistics',
              description: 'Analisis performa tim lengkap termasuk win rate, goals scored, clean sheets, dan trend performa.',
              icon: Icons.bar_chart,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Leaderboards'),
          const SizedBox(height: 12),
          _buildReportCard(
            context,
            'League Table',
            'View current league standings',
            Icons.leaderboard,
            Colors.green,
            isAvailable: false,
            () => _showComingSoon(
              context,
              title: 'League Table',
              description: 'Klasemen liga terkini dengan detail poin, goal difference, dan form terakhir setiap tim.',
              icon: Icons.leaderboard,
            ),
          ),
          _buildReportCard(
            context,
            'Player Rankings',
            'View player performance rankings',
            Icons.stars,
            Colors.purple,
            isAvailable: false,
            () => _showComingSoon(
              context,
              title: 'Player Rankings',
              description: 'Ranking pemain berdasarkan performa dengan metrik seperti rating, kontribusi gol, dan statistik defensif.',
              icon: Icons.stars,
              illustrationPath: 'assets/images/player_kick.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isAvailable = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          if (!isAvailable) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Soon',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppTheme.textTertiary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(
    BuildContext context, {
    required String title,
    String? description,
    IconData? icon,
    String? illustrationPath,
  }) {
    ComingSoonSheet.show(
      context,
      title: title,
      description: description,
      icon: icon,
      illustrationPath: illustrationPath,
    );
  }
}
