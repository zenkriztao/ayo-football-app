import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/features/match/presentation/providers/MatchProvider.dart';
import 'package:ayo_football_app/features/match/presentation/providers/MatchState.dart';
import 'package:ayo_football_app/features/team/presentation/providers/TeamProvider.dart';
import 'package:ayo_football_app/features/team/data/models/TeamModel.dart';

/// AYO-style Match Form Page with Team Dropdown Selector
class MatchFormPage extends ConsumerStatefulWidget {
  final String? matchId;

  const MatchFormPage({super.key, this.matchId});

  @override
  ConsumerState<MatchFormPage> createState() => _MatchFormPageState();
}

class _MatchFormPageState extends ConsumerState<MatchFormPage> {
  final _formKey = GlobalKey<FormState>();
  TeamModel? _selectedHomeTeam;
  TeamModel? _selectedAwayTeam;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    // Fetch teams when form loads
    Future.microtask(() {
      ref.read(teamProvider.notifier).getTeams(refresh: true, limit: 100);
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedHomeTeam == null || _selectedAwayTeam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select both teams', style: GoogleFonts.poppins()),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedHomeTeam!.id == _selectedAwayTeam!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Home and Away teams must be different', style: GoogleFonts.poppins()),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final data = {
      'match_date':
          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
      'match_time':
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      'home_team_id': _selectedHomeTeam!.id,
      'away_team_id': _selectedAwayTeam!.id,
    };

    final success = await ref.read(matchProvider.notifier).createMatch(data);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Match created successfully!', style: GoogleFonts.poppins()),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchProvider);
    final teamState = ref.watch(teamProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.matchId != null ? 'Edit Match' : 'Create Match',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Teams'),
              const SizedBox(height: 12),
              _buildTeamSelector(
                label: 'Home Team',
                icon: Icons.home,
                selectedTeam: _selectedHomeTeam,
                teams: teamState.teams,
                isLoading: teamState.isLoading,
                onChanged: (team) => setState(() => _selectedHomeTeam = team),
              ),
              const SizedBox(height: 16),
              _buildTeamSelector(
                label: 'Away Team',
                icon: Icons.flight,
                selectedTeam: _selectedAwayTeam,
                teams: teamState.teams,
                isLoading: teamState.isLoading,
                onChanged: (team) => setState(() => _selectedAwayTeam = team),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Schedule'),
              const SizedBox(height: 12),
              _buildDateTimePicker(),
              const SizedBox(height: 32),
              _buildSubmitButton(matchState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildTeamSelector({
    required String label,
    required IconData icon,
    required TeamModel? selectedTeam,
    required List<TeamModel> teams,
    required bool isLoading,
    required ValueChanged<TeamModel?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: isLoading
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loading teams...',
                    style: GoogleFonts.poppins(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : DropdownButtonFormField<TeamModel>(
              value: selectedTeam,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.poppins(color: AppTheme.textSecondary),
                prefixIcon: Icon(icon, color: AppTheme.primaryColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              dropdownColor: Colors.white,
              icon: Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
              isExpanded: true,
              items: teams.map((team) {
                return DropdownMenuItem<TeamModel>(
                  value: team,
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: team.logo != null && team.logo!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  team.logo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.shield,
                                    color: AppTheme.primaryColor,
                                    size: 18,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.shield,
                                color: AppTheme.primaryColor,
                                size: 18,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              team.name,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              team.city,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              validator: (value) => value == null ? 'Please select a team' : null,
            ),
    );
  }

  Widget _buildDateTimePicker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: [
          // Date Picker
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.calendar_today, color: AppTheme.primaryColor, size: 20),
            ),
            title: Text(
              'Match Date',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            subtitle: Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: AppTheme.textTertiary),
            onTap: _selectDate,
          ),
          Divider(height: 1, color: AppTheme.cardBorder),
          // Time Picker
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.access_time, color: AppTheme.primaryColor, size: 20),
            ),
            title: Text(
              'Match Time',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            subtitle: Text(
              _selectedTime.format(context),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: AppTheme.textTertiary),
            onTap: _selectTime,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(MatchState state) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: state.status == MatchStatus.loading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: state.status == MatchStatus.loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                widget.matchId != null ? 'Update Match' : 'Create Match',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
