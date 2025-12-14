import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/core/widgets/Widgets.dart';
import 'package:ayo_football_app/features/player/data/models/PlayerModel.dart';
import 'package:ayo_football_app/features/player/presentation/providers/PlayerProvider.dart';
import 'package:ayo_football_app/features/player/presentation/providers/PlayerState.dart';
import 'package:ayo_football_app/features/team/presentation/providers/TeamProvider.dart';
import 'package:ayo_football_app/features/team/data/models/TeamModel.dart';

/// AYO-style Player Form Page with Team Dropdown Selector
class PlayerFormPage extends ConsumerStatefulWidget {
  final String? playerId;
  final String? teamId;

  const PlayerFormPage({super.key, this.playerId, this.teamId});

  @override
  ConsumerState<PlayerFormPage> createState() => _PlayerFormPageState();
}

class _PlayerFormPageState extends ConsumerState<PlayerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _jerseyNumberController = TextEditingController();
  TeamModel? _selectedTeam;
  String _selectedPosition = 'forward';

  bool get isEditing => widget.playerId != null;
  bool _isPopulated = false;

  @override
  void initState() {
    super.initState();
    // Fetch teams when form loads
    Future.microtask(() {
      ref.read(teamProvider.notifier).getTeams(refresh: true, limit: 100);
    });
    if (isEditing) {
      Future.microtask(() =>
          ref.read(playerProvider.notifier).getPlayerById(widget.playerId!));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _jerseyNumberController.dispose();
    super.dispose();
  }

  void _populateFields(PlayerState state, List<TeamModel> teams) {
    if (_isPopulated) return;

    final player = state.selectedPlayer;
    if (player != null) {
      _nameController.text = player.name;
      _heightController.text = player.height.toString();
      _weightController.text = player.weight.toString();
      _jerseyNumberController.text = player.jerseyNumber.toString();
      _selectedPosition = player.position;

      // Find and set the team
      if (teams.isNotEmpty) {
        _selectedTeam = teams.where((t) => t.id == player.teamId).firstOrNull;
      }
      _isPopulated = true;
    }

    // If teamId is provided via route parameter
    if (widget.teamId != null && teams.isNotEmpty && _selectedTeam == null) {
      _selectedTeam = teams.where((t) => t.id == widget.teamId).firstOrNull;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTeam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a team', style: GoogleFonts.poppins()),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final data = {
      'team_id': _selectedTeam!.id,
      'name': _nameController.text.trim(),
      'height': double.parse(_heightController.text.trim()),
      'weight': double.parse(_weightController.text.trim()),
      'position': _selectedPosition,
      'jersey_number': int.parse(_jerseyNumberController.text.trim()),
    };

    bool success;
    if (isEditing) {
      success = await ref
          .read(playerProvider.notifier)
          .updatePlayer(widget.playerId!, data);
    } else {
      success = await ref.read(playerProvider.notifier).createPlayer(data);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? 'Player updated successfully!' : 'Player created successfully!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final teamState = ref.watch(teamProvider);

    // Populate fields when editing
    if (isEditing || widget.teamId != null) {
      _populateFields(playerState, teamState.teams);
    }

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
          isEditing ? 'Edit Player' : 'Create Player',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: _buildBody(playerState, teamState),
    );
  }

  Widget _buildBody(PlayerState playerState, teamState) {
    if (playerState.status == PlayerStatus.loading &&
        isEditing &&
        playerState.selectedPlayer == null) {
      return const LoadingWidget();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Team'),
            const SizedBox(height: 12),
            _buildTeamSelector(teamState.teams, teamState.isLoading),
            const SizedBox(height: 24),
            _buildSectionTitle('Player Information'),
            const SizedBox(height: 12),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildPositionField(),
            const SizedBox(height: 16),
            _buildJerseyNumberField(),
            const SizedBox(height: 24),
            _buildSectionTitle('Physical Attributes'),
            const SizedBox(height: 12),
            _buildMeasurementFields(),
            const SizedBox(height: 32),
            _buildSubmitButton(playerState),
          ],
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

  Widget _buildTeamSelector(List<TeamModel> teams, bool isLoading) {
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
              value: _selectedTeam,
              decoration: InputDecoration(
                labelText: 'Select Team',
                labelStyle: GoogleFonts.poppins(color: AppTheme.textSecondary),
                prefixIcon: Icon(Icons.groups, color: AppTheme.primaryColor),
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
              onChanged: (team) => setState(() => _selectedTeam = team),
              validator: (value) => value == null ? 'Please select a team' : null,
            ),
    );
  }

  Widget _buildNameField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: TextFormField(
        controller: _nameController,
        style: GoogleFonts.poppins(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          labelText: 'Player Name',
          labelStyle: GoogleFonts.poppins(color: AppTheme.textSecondary),
          prefixIcon: Icon(Icons.person, color: AppTheme.primaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
      ),
    );
  }

  Widget _buildPositionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedPosition,
        style: GoogleFonts.poppins(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          labelText: 'Position',
          labelStyle: GoogleFonts.poppins(color: AppTheme.textSecondary),
          prefixIcon: Icon(Icons.sports_soccer, color: AppTheme.primaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        dropdownColor: Colors.white,
        icon: Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
        items: PlayerModel.positions.entries
            .map((e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(
                    e.value,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) setState(() => _selectedPosition = value);
        },
      ),
    );
  }

  Widget _buildJerseyNumberField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: TextFormField(
        controller: _jerseyNumberController,
        style: GoogleFonts.poppins(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          labelText: 'Jersey Number',
          labelStyle: GoogleFonts.poppins(color: AppTheme.textSecondary),
          prefixIcon: Icon(Icons.tag, color: AppTheme.primaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: TextInputType.number,
        validator: (v) {
          if (v?.isEmpty ?? true) return 'Required';
          final num = int.tryParse(v!);
          if (num == null || num < 1 || num > 99) {
            return 'Must be 1-99';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildMeasurementFields() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: TextFormField(
              controller: _heightController,
              style: GoogleFonts.poppins(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                labelStyle: GoogleFonts.poppins(color: AppTheme.textSecondary),
                prefixIcon: Icon(Icons.height, color: AppTheme.primaryColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: TextFormField(
              controller: _weightController,
              style: GoogleFonts.poppins(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                labelStyle: GoogleFonts.poppins(color: AppTheme.textSecondary),
                prefixIcon: Icon(Icons.fitness_center, color: AppTheme.primaryColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(PlayerState state) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: state.status == PlayerStatus.loading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: state.status == PlayerStatus.loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                isEditing ? 'Update Player' : 'Create Player',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
