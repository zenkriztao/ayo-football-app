import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/core/widgets/Widgets.dart';
import 'package:ayo_football_app/features/auth/presentation/providers/AuthProvider.dart';
import 'package:ayo_football_app/features/player/presentation/providers/PlayerProvider.dart';
import 'package:ayo_football_app/features/player/presentation/providers/PlayerState.dart';

/// Page Detail Player using Riverpod
/// Applying Single Responsibility Principle
class PlayerDetailPage extends ConsumerStatefulWidget {
  final String playerId;

  const PlayerDetailPage({super.key, required this.playerId});

  @override
  ConsumerState<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends ConsumerState<PlayerDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(playerProvider.notifier).getPlayerById(widget.playerId));
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final player = playerState.selectedPlayer;
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(player?.name ?? 'Player Details'),
        actions: [
          if (isAdmin && player != null) _buildPopupMenu(),
        ],
      ),
      body: _buildBody(playerState),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'edit') {
          context.push('/players/${widget.playerId}/edit');
        } else if (value == 'delete') {
          final success = await ref
              .read(playerProvider.notifier)
              .deletePlayer(widget.playerId);
          if (success && mounted) {
            context.pop();
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Widget _buildBody(PlayerState state) {
    if (state.status == PlayerStatus.loading) {
      return const LoadingWidget();
    }

    final player = state.selectedPlayer;
    if (player == null) {
      return const EmptyStateWidget(message: 'Player not found');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildJerseyAvatar(player.jerseyNumber),
          const SizedBox(height: 24),
          _buildInfoCard(player),
        ],
      ),
    );
  }

  Widget _buildJerseyAvatar(int jerseyNumber) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: AppTheme.primaryColor,
      child: Text(
        '$jerseyNumber',
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoCard(player) {
    return InfoCard(
      rows: [
        InfoRow(label: 'Name', value: player.name, labelWidth: 120),
        InfoRow(label: 'Position', value: player.positionName, labelWidth: 120),
        InfoRow(
            label: 'Jersey Number',
            value: '${player.jerseyNumber}',
            labelWidth: 120),
        InfoRow(label: 'Height', value: '${player.height} cm', labelWidth: 120),
        InfoRow(label: 'Weight', value: '${player.weight} kg', labelWidth: 120),
        if (player.team != null)
          InfoRow(label: 'Team', value: player.team!.name, labelWidth: 120),
      ],
    );
  }
}
