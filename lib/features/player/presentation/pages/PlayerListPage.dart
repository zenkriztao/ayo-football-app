import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/core/widgets/Widgets.dart';
import 'package:ayo_football_app/features/auth/presentation/providers/AuthProvider.dart';
import 'package:ayo_football_app/features/player/presentation/providers/PlayerProvider.dart';
import 'package:ayo_football_app/features/player/presentation/providers/PlayerState.dart';

/// AYO-style Player List Page (Community Style)
class PlayerListPage extends ConsumerStatefulWidget {
  const PlayerListPage({super.key});

  @override
  ConsumerState<PlayerListPage> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends ConsumerState<PlayerListPage> {
  final _searchController = TextEditingController();
  int _selectedFilterIndex = 0;

  final List<AyoFilterItem> _positionFilters = const [
    AyoFilterItem(label: 'All', icon: Icons.groups_outlined),
    AyoFilterItem(label: 'GK', icon: Icons.sports_handball),
    AyoFilterItem(label: 'DF', icon: Icons.shield_outlined),
    AyoFilterItem(label: 'MF', icon: Icons.swap_horiz),
    AyoFilterItem(label: 'FW', icon: Icons.sports_soccer),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(playerProvider.notifier).getPlayers(refresh: true));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    ref.read(playerProvider.notifier).getPlayers(refresh: true, search: query);
  }

  void _onFilterChanged(int index) {
    setState(() => _selectedFilterIndex = index);
    // TODO: Implement filter by position
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(),
        ],
        body: Column(
          children: [
            _buildFilterSection(),
            _buildResultCount(playerState),
            Expanded(
              child: _buildPlayerList(playerState),
            ),
          ],
        ),
      ),
      floatingActionButton: isAdmin ? _buildFab() : null,
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: AppTheme.backgroundColor,
      floating: true,
      pinned: true,
      elevation: 0,
      expandedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppTheme.backgroundColor,
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SearchTextField(
                  controller: _searchController,
                  hintText: 'Find Player',
                  onChanged: _onSearch,
                  onClear: () => _onSearch(''),
                  showLocationButton: true,
                ),
              ),
            ],
          ),
        ),
      ),
      title: Text(
        'Players',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: AyoFilterRow(
        filters: _positionFilters,
        selectedIndex: _selectedFilterIndex,
        onFilterChanged: _onFilterChanged,
        showFilterButton: true,
      ),
    );
  }

  Widget _buildResultCount(PlayerState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Showing ${state.players.length} players',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerList(PlayerState state) {
    if (state.status == PlayerStatus.loading && state.players.isEmpty) {
      return const LoadingWidget();
    }

    if (state.players.isEmpty) {
      return EmptyStateWidget(
        message: 'No players found',
        subtitle: 'Try searching with different keywords or filters',
        illustrationPath: 'assets/images/player_champion.png',
        icon: Icons.person_outline,
      );
    }

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () =>
          ref.read(playerProvider.notifier).getPlayers(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.players.length,
        itemBuilder: (context, index) {
          final player = state.players[index];
          return PlayerCard(
            player: player,
            onTap: () => context.push('/players/${player.id}'),
          );
        },
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () => context.push('/players/create'),
      backgroundColor: AppTheme.primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
