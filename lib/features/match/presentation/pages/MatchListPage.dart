import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/core/widgets/Widgets.dart';
import 'package:ayo_football_app/features/auth/presentation/providers/AuthProvider.dart';
import 'package:ayo_football_app/features/match/presentation/providers/MatchProvider.dart';
import 'package:ayo_football_app/features/match/presentation/providers/MatchState.dart';

/// AYO-style Match List Page
class MatchListPage extends ConsumerStatefulWidget {
  const MatchListPage({super.key});

  @override
  ConsumerState<MatchListPage> createState() => _MatchListPageState();
}

class _MatchListPageState extends ConsumerState<MatchListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilterIndex = 0;

  final List<AyoFilterItem> _statusFilters = const [
    AyoFilterItem(label: 'All'),
    AyoFilterItem(label: 'Upcoming'),
    AyoFilterItem(label: 'Live'),
    AyoFilterItem(label: 'Completed'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(
        () => ref.read(matchProvider.notifier).getMatches(refresh: true));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onFilterChanged(int index) {
    setState(() => _selectedFilterIndex = index);
    // TODO: Implement filter by status
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchProvider);
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: _buildMatchList(matchState),
          ),
        ],
      ),
      floatingActionButton: isAdmin ? _buildFab() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      title: Text(
        'Matches',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          color: AppTheme.primaryColor,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Live'),
              Tab(text: 'Results'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AyoFilterRow(
        filters: _statusFilters,
        selectedIndex: _selectedFilterIndex,
        onFilterChanged: _onFilterChanged,
        showFilterButton: true,
        onFilterButtonTap: () => _showFilterBottomSheet(),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Reset',
                  style: GoogleFonts.poppins(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Sort by',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildFilterOption('Date', true),
              _buildFilterOption('Team', false),
              _buildFilterOption('Score', false),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filter',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMatchList(MatchState state) {
    if (state.status == MatchStatus.loading && state.matches.isEmpty) {
      return const LoadingWidget();
    }

    if (state.matches.isEmpty) {
      return EmptyStateWidget(
        message: 'No matches scheduled',
        subtitle: 'Check back later for upcoming matches',
        illustrationPath: 'assets/images/players_match.png',
        icon: Icons.sports_soccer_outlined,
      );
    }

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () =>
          ref.read(matchProvider.notifier).getMatches(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.matches.length,
        itemBuilder: (context, index) {
          final match = state.matches[index];
          return MatchCard(
            match: match,
            onTap: () => context.push('/matches/${match.id}'),
          );
        },
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () => context.push('/matches/create'),
      backgroundColor: AppTheme.primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
