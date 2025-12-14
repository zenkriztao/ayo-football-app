import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/core/widgets/Widgets.dart';
import 'package:ayo_football_app/features/auth/presentation/providers/AuthProvider.dart';
import 'package:ayo_football_app/features/team/presentation/providers/TeamProvider.dart';
import 'package:ayo_football_app/features/team/presentation/providers/TeamState.dart';

/// AYO-style Team List Page
class TeamListPage extends ConsumerStatefulWidget {
  const TeamListPage({super.key});

  @override
  ConsumerState<TeamListPage> createState() => _TeamListPageState();
}

class _TeamListPageState extends ConsumerState<TeamListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(teamProvider.notifier).getTeams(refresh: true));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(teamProvider.notifier).loadMore(search: _searchController.text);
    }
  }

  void _onSearch(String query) {
    ref.read(teamProvider.notifier).getTeams(refresh: true, search: query);
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamProvider);
    final isAdmin = ref.watch(isAdminProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(isAuthenticated),
      body: Column(
        children: [
          _buildSearchSection(),
          Expanded(
            child: _buildTeamList(teamState),
          ),
        ],
      ),
      floatingActionButton: isAdmin ? _buildFab() : null,
    );
  }

  PreferredSizeWidget _buildAppBar(bool isAuthenticated) {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      title: Text(
        'Teams',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isAuthenticated ? Icons.logout : Icons.login,
            color: Colors.white,
          ),
          onPressed: () {
            if (isAuthenticated) {
              ref.read(authProvider.notifier).logout();
            } else {
              context.push('/login');
            }
          },
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Container(
      color: AppTheme.primaryColor,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        decoration: const BoxDecoration(
          color: AppTheme.primaryColor,
        ),
        child: SearchTextField(
          controller: _searchController,
          hintText: 'Search teams...',
          onChanged: _onSearch,
          onClear: () => _onSearch(''),
        ),
      ),
    );
  }

  Widget _buildTeamList(TeamState state) {
    if (state.status == TeamStatus.loading && state.teams.isEmpty) {
      return const LoadingWidget();
    }

    if (state.status == TeamStatus.error && state.teams.isEmpty) {
      return ErrorStateWidget(
        message: state.errorMessage ?? 'Failed to load teams',
        onRetry: () => ref.read(teamProvider.notifier).getTeams(refresh: true),
      );
    }

    if (state.teams.isEmpty) {
      return EmptyStateWidget(
        message: 'No teams found',
        subtitle: 'Try searching with different keywords',
        illustrationPath: 'assets/images/player_kick.png',
        icon: Icons.groups_outlined,
      );
    }

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () => ref.read(teamProvider.notifier).getTeams(refresh: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.teams.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.teams.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
              ),
            );
          }

          final team = state.teams[index];
          return TeamCard(
            team: team,
            onTap: () => context.push('/teams/${team.id}'),
          );
        },
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () => context.push('/teams/create'),
      backgroundColor: AppTheme.primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
