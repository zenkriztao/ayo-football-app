import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ayo_football_app/core/widgets/Widgets.dart';
import 'package:ayo_football_app/features/player/data/models/PlayerModel.dart';
import 'package:ayo_football_app/features/player/presentation/providers/PlayerProvider.dart';
import 'package:ayo_football_app/features/player/presentation/providers/PlayerState.dart';

/// Page Form Player for Create/Edit using Riverpod
/// Applying Single Responsibility Principle
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
  final _teamIdController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _jerseyNumberController = TextEditingController();
  String _selectedPosition = 'forward';

  bool get isEditing => widget.playerId != null;
  bool _isPopulated = false;

  @override
  void initState() {
    super.initState();
    if (widget.teamId != null) {
      _teamIdController.text = widget.teamId!;
    }
    if (isEditing) {
      Future.microtask(() =>
          ref.read(playerProvider.notifier).getPlayerById(widget.playerId!));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teamIdController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _jerseyNumberController.dispose();
    super.dispose();
  }

  void _populateFields(PlayerState state) {
    if (_isPopulated) return;

    final player = state.selectedPlayer;
    if (player != null) {
      _nameController.text = player.name;
      _teamIdController.text = player.teamId;
      _heightController.text = player.height.toString();
      _weightController.text = player.weight.toString();
      _jerseyNumberController.text = player.jerseyNumber.toString();
      _selectedPosition = player.position;
      _isPopulated = true;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'team_id': _teamIdController.text.trim(),
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
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);

    // Populate fields when editing
    if (isEditing) {
      _populateFields(playerState);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Player' : 'Create Player'),
      ),
      body: _buildBody(playerState),
    );
  }

  Widget _buildBody(PlayerState state) {
    if (state.status == PlayerStatus.loading &&
        isEditing &&
        state.selectedPlayer == null) {
      return const LoadingWidget();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTeamIdField(),
            const SizedBox(height: 16),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildPositionField(),
            const SizedBox(height: 16),
            _buildJerseyNumberField(),
            const SizedBox(height: 16),
            _buildMeasurementFields(),
            const SizedBox(height: 32),
            _buildSubmitButton(state),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamIdField() {
    return TextFormField(
      controller: _teamIdController,
      decoration: const InputDecoration(
        labelText: 'Team ID *',
        prefixIcon: Icon(Icons.groups),
      ),
      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Player Name *',
        prefixIcon: Icon(Icons.person),
      ),
      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
    );
  }

  Widget _buildPositionField() {
    return DropdownButtonFormField<String>(
      value: _selectedPosition,
      decoration: const InputDecoration(
        labelText: 'Position *',
        prefixIcon: Icon(Icons.sports_soccer),
      ),
      items: PlayerModel.positions.entries
          .map((e) => DropdownMenuItem(
                value: e.key,
                child: Text(e.value),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) setState(() => _selectedPosition = value);
      },
    );
  }

  Widget _buildJerseyNumberField() {
    return TextFormField(
      controller: _jerseyNumberController,
      decoration: const InputDecoration(
        labelText: 'Jersey Number *',
        prefixIcon: Icon(Icons.tag),
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
    );
  }

  Widget _buildMeasurementFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _heightController,
            decoration: const InputDecoration(
              labelText: 'Height (cm) *',
            ),
            keyboardType: TextInputType.number,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Weight (kg) *',
            ),
            keyboardType: TextInputType.number,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(PlayerState state) {
    return ElevatedButton(
      onPressed: state.status == PlayerStatus.loading ? null : _submit,
      child: Text(isEditing ? 'Update Player' : 'Create Player'),
    );
  }
}
