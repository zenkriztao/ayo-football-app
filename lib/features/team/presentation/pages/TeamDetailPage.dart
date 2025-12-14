import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/core/widgets/Widgets.dart';
import 'package:ayo_football_app/features/auth/presentation/providers/AuthProvider.dart';
import 'package:ayo_football_app/features/team/presentation/providers/TeamProvider.dart';
import 'package:ayo_football_app/features/team/presentation/providers/TeamState.dart';

/// Team Detail Page using Riverpod
/// Applying Single Responsibility Principle
class TeamDetailPage extends ConsumerStatefulWidget {
  final String teamId;

  const TeamDetailPage({super.key, required this.teamId});

  @override
  ConsumerState<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends ConsumerState<TeamDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(teamProvider.notifier)
        .getTeamById(widget.teamId, withPlayers: true));
  }

  void _deleteTeam() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Team'),
        content: const Text('Are you sure you want to delete this team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await ref
                  .read(teamProvider.notifier)
                  .deleteTeam(widget.teamId);
              if (success && mounted) {
                context.pop();
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamProvider);
    final team = teamState.selectedTeam;
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(team?.name ?? 'Team Details'),
        actions: [
          if (isAdmin && team != null) _buildPopupMenu(),
        ],
      ),
      body: _buildBody(teamState),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          context.push('/teams/${widget.teamId}/edit');
        } else if (value == 'delete') {
          _deleteTeam();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(TeamState state) {
    if (state.status == TeamStatus.loading) {
      return const LoadingWidget();
    }

    if (state.status == TeamStatus.error) {
      return ErrorStateWidget(
        message: state.errorMessage ?? 'Failed to load team',
        onRetry: () => ref
            .read(teamProvider.notifier)
            .getTeamById(widget.teamId, withPlayers: true),
      );
    }

    final team = state.selectedTeam;
    if (team == null) {
      return const EmptyStateWidget(message: 'Team not found');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTeamAvatar(team),
          const SizedBox(height: 24),
          _buildInfoCard(team),
          const SizedBox(height: 24),
          _buildPlayersSection(),
        ],
      ),
    );
  }

  Widget _buildTeamAvatar(team) {
    return Center(
      child: CircleAvatar(
        radius: 60,
        backgroundColor: AppTheme.primaryColor,
        child: team.logo != null && team.logo!.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: team.logo!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Icon(
                    Icons.groups,
                    size: 60,
                    color: Colors.white,
                  ),
                  errorWidget: (_, __, ___) => const Icon(
                    Icons.groups,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              )
            : const Icon(
                Icons.groups,
                size: 60,
                color: Colors.white,
              ),
      ),
    );
  }

  Widget _buildInfoCard(team) {
    return InfoCard(
      rows: [
        InfoRow(label: 'Name', value: team.name),
        InfoRow(label: 'City', value: team.city),
        InfoRow(label: 'Founded', value: team.foundedYear.toString()),
        if (team.address != null) InfoRow(label: 'Address', value: team.address!),
      ],
    );
  }

  Widget _buildPlayersSection() {
    final isAdmin = ref.watch(isAdminProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Players',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (isAdmin)
              TextButton.icon(
                onPressed: () =>
                    context.push('/players/create?team_id=${widget.teamId}'),
                icon: const Icon(Icons.add),
                label: const Text('Add Player'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Go to Players tab to see team players',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
