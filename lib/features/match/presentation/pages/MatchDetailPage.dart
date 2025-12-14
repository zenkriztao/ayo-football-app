import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/core/widgets/Widgets.dart';
import 'package:ayo_football_app/features/match/presentation/providers/MatchProvider.dart';
import 'package:ayo_football_app/features/match/presentation/providers/MatchState.dart';

/// Page Detail Match using Riverpod
/// Applying Single Responsibility Principle
class MatchDetailPage extends ConsumerStatefulWidget {
  final String matchId;

  const MatchDetailPage({super.key, required this.matchId});

  @override
  ConsumerState<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends ConsumerState<MatchDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(matchProvider.notifier).getMatchById(widget.matchId));
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Match Details')),
      body: _buildBody(matchState),
    );
  }

  Widget _buildBody(MatchState state) {
    if (state.status == MatchStatus.loading) {
      return const LoadingWidget();
    }

    final match = state.selectedMatch;
    if (match == null) {
      return const EmptyStateWidget(message: 'Match not found');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMatchCard(match),
          if (match.goals != null && match.goals!.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildGoalsSection(match),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchCard(match) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '${match.matchDate} - ${match.matchTime}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        match.homeTeam?.name ?? 'Home',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('HOME'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    match.scoreDisplay,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        match.awayTeam?.name ?? 'Away',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('AWAY'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StatusBadge(
              label: match.resultDisplay ?? match.statusName,
              isCompleted: match.isCompleted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSection(match) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Goals',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...match.goals!.map((goal) => _buildGoalCard(goal)),
      ],
    );
  }

  Widget _buildGoalCard(goal) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: Text(
            "${goal.minute}'",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(goal.playerName ?? 'Unknown'),
        subtitle: Text(goal.teamName ?? ''),
        trailing: goal.isOwnGoal ? const Chip(label: Text('OG')) : null,
      ),
    );
  }
}
