import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/core/widgets/Widgets.dart';
import 'package:ayo_football_app/features/auth/presentation/providers/AuthProvider.dart';
import 'package:ayo_football_app/features/match/data/models/MatchModel.dart';
import 'package:ayo_football_app/features/match/presentation/providers/MatchProvider.dart';
import 'package:ayo_football_app/features/match/presentation/providers/MatchState.dart';

class MatchDetailPage extends ConsumerStatefulWidget {
  final String matchId;

  const MatchDetailPage({super.key, required this.matchId});

  @override
  ConsumerState<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends ConsumerState<MatchDetailPage> {
  bool _isLoadingDetail = true;

  @override
  void initState() {
    super.initState();
    _loadMatchDetail();
  }

  Future<void> _loadMatchDetail() async {
    setState(() => _isLoadingDetail = true);
    await ref.read(matchProvider.notifier).getMatchById(widget.matchId);
    if (mounted) setState(() => _isLoadingDetail = false);
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchProvider);
    final isAdmin = ref.watch(isAdminProvider);

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
          'Detail Pertandingan',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: isAdmin
            ? [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) => _handleMenuAction(value, matchState),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit Match'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('Hapus', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            : null,
      ),
      body: _buildBody(matchState, isAdmin),
    );
  }

  void _handleMenuAction(String action, MatchState state) {
    switch (action) {
      case 'edit':
        context.push('/matches/${widget.matchId}/edit');
        break;
      case 'delete':
        _showDeleteDialog();
        break;
    }
  }

  Widget _buildBody(MatchState state, bool isAdmin) {
    if (_isLoadingDetail) {
      return const LoadingWidget();
    }

    final match = state.selectedMatch;
    if (match == null) {
      return const EmptyStateWidget(message: 'Match tidak ditemukan');
    }

    return RefreshIndicator(
      onRefresh: _loadMatchDetail,
      color: AppTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildMatchHeader(match),
            const SizedBox(height: 16),
            if (isAdmin) _buildAdminActions(match),
            if (match.goals != null && match.goals!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildGoalsSection(match),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHeader(MatchModel match) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Date and time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Text(
                  '${match.matchDate} • ${match.matchTime}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Teams and score
          Row(
            children: [
              // Home team
              Expanded(
                child: Column(
                  children: [
                    _buildTeamLogo(match.homeTeam?.logo),
                    const SizedBox(height: 12),
                    Text(
                      match.homeTeam?.name ?? 'Home',
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
                        fontSize: 11,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              // Score
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      match.scoreDisplay,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      _getStatusText(match.status),
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
                    _buildTeamLogo(match.awayTeam?.logo),
                    const SizedBox(height: 12),
                    Text(
                      match.awayTeam?.name ?? 'Away',
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
                        fontSize: 11,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(match.status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              match.resultDisplay ?? match.statusName,
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

  Widget _buildTeamLogo(String? logo) {
    if (logo != null && logo.isNotEmpty) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: ClipOval(
          child: Image.network(
            logo,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholderLogo(),
          ),
        ),
      );
    }
    return _buildPlaceholderLogo();
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: const Icon(Icons.shield, size: 32, color: Colors.white),
    );
  }

  Widget _buildAdminActions(MatchModel match) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aksi Admin',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Start Match / End Match button
              if (match.status == 'scheduled')
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.play_arrow,
                    label: 'Mulai Match',
                    color: Colors.green,
                    onTap: () => _showStartMatchDialog(match),
                  ),
                ),
              if (match.status == 'ongoing') ...[
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.sports_score,
                    label: 'Input Hasil',
                    color: Colors.blue,
                    onTap: () => _showRecordResultDialog(match),
                  ),
                ),
              ],
              if (match.status == 'scheduled' || match.status == 'ongoing')
                const SizedBox(width: 12),
              if (match.status != 'completed' && match.status != 'cancelled')
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.cancel,
                    label: 'Batalkan',
                    color: Colors.orange,
                    onTap: () => _showCancelMatchDialog(match),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsSection(MatchModel match) {
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
              Icon(Icons.sports_soccer, color: AppTheme.primaryColor, size: 20),
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
          ...match.goals!.map((goal) => _buildGoalItem(goal, match)),
        ],
      ),
    );
  }

  Widget _buildGoalItem(GoalModel goal, MatchModel match) {
    final isHomeTeamGoal = goal.teamId == match.homeTeamId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          if (isHomeTeamGoal) ...[
            Expanded(
              child: Row(
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
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            const Expanded(child: SizedBox()),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.red),
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

  // Dialogs
  void _showStartMatchDialog(MatchModel match) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Text('Mulai Pertandingan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
        content: Text(
          'Apakah kamu yakin ingin memulai pertandingan ini?\n\n${match.homeTeam?.name} vs ${match.awayTeam?.name}',
          style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.poppins(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _startMatch(match.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Ya, Mulai', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showCancelMatchDialog(MatchModel match) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.cancel, color: Colors.orange),
            ),
            const SizedBox(width: 12),
            Text('Batalkan Match', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
        content: Text(
          'Apakah kamu yakin ingin membatalkan pertandingan ini?',
          style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tidak', style: GoogleFonts.poppins(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _cancelMatch(match.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Ya, Batalkan', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showRecordResultDialog(MatchModel match) {
    final homeScoreController = TextEditingController();
    final awayScoreController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.sports_score, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Input Hasil', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        match.homeTeam?.name ?? 'Home',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: homeScoreController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          hintText: '0',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('-', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700)),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        match.awayTeam?.name ?? 'Away',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: awayScoreController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          hintText: '0',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.poppins(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final homeScore = int.tryParse(homeScoreController.text) ?? 0;
              final awayScore = int.tryParse(awayScoreController.text) ?? 0;
              Navigator.pop(context);
              await _recordResult(match.id, homeScore, awayScore);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Simpan Hasil', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete, color: Colors.red),
            ),
            const SizedBox(width: 12),
            Text('Hapus Match', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus pertandingan ini? Aksi ini tidak dapat dibatalkan.',
          style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.poppins(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteMatch();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Ya, Hapus', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // Actions
  Future<void> _startMatch(String id) async {
    try {
      final success = await ref.read(matchProvider.notifier).updateMatch(id, {'status': 'ongoing'});

      if (success) {
        _showSnackBar('Pertandingan dimulai!', Colors.green);
        if (mounted) context.pop();
      } else {
        _showSnackBar('Gagal memulai pertandingan', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  Future<void> _cancelMatch(String id) async {
    _showLoading();
    try {
      final success = await ref.read(matchProvider.notifier).updateMatch(id, {'status': 'cancelled'});
      _hideLoading();

      if (success) {
        _showSnackBar('Pertandingan dibatalkan', Colors.orange);
      } else {
        _showSnackBar('Gagal membatalkan pertandingan', Colors.red);
      }
    } catch (e) {
      _hideLoading();
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  Future<void> _recordResult(String id, int homeScore, int awayScore) async {
    try {
      final success = await ref.read(matchProvider.notifier).recordResult(id, {
        'home_score': homeScore,
        'away_score': awayScore,
        'goals': [],
      });

      if (success) {
        _showSnackBar('Hasil pertandingan disimpan!', Colors.green);
        if (mounted) context.pop();
      } else {
        _showSnackBar('Gagal menyimpan hasil', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  Future<void> _deleteMatch() async {
    _showLoading();
    try {
      final success = await ref.read(matchProvider.notifier).deleteMatch(widget.matchId);
      _hideLoading();

      if (success) {
        _showSnackBar('Pertandingan dihapus', Colors.green);
        if (mounted) context.pop();
      } else {
        _showSnackBar('Gagal menghapus pertandingan', Colors.red);
      }
    } catch (e) {
      _hideLoading();
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      ),
    );
  }

  void _hideLoading() {
    if (mounted) Navigator.of(context).pop();
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'scheduled':
        return 'Dijadwalkan';
      case 'ongoing':
        return 'Sedang Berlangsung';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return Colors.blue;
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return AppTheme.primaryColor;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
