import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ayo_football_app/core/theme/AppTheme.dart';
import 'package:ayo_football_app/core/widgets/Widgets.dart';
import 'package:ayo_football_app/features/team/presentation/providers/TeamProvider.dart';
import 'package:ayo_football_app/features/team/presentation/providers/TeamState.dart';

/// Team Form Page for Create/Edit using Riverpod
/// Applying Single Responsibility Principle
class TeamFormPage extends ConsumerStatefulWidget {
  final String? teamId;

  const TeamFormPage({super.key, this.teamId});

  @override
  ConsumerState<TeamFormPage> createState() => _TeamFormPageState();
}

class _TeamFormPageState extends ConsumerState<TeamFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _logoController = TextEditingController();
  final _foundedYearController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  bool get isEditing => widget.teamId != null;
  bool _isPopulated = false;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      Future.microtask(
          () => ref.read(teamProvider.notifier).getTeamById(widget.teamId!));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _logoController.dispose();
    _foundedYearController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _populateFields(TeamState state) {
    if (_isPopulated) return;

    final team = state.selectedTeam;
    if (team != null) {
      _nameController.text = team.name;
      _logoController.text = team.logo ?? '';
      _foundedYearController.text = team.foundedYear.toString();
      _addressController.text = team.address ?? '';
      _cityController.text = team.city;
      _isPopulated = true;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'name': _nameController.text.trim(),
      'logo': _logoController.text.trim(),
      'founded_year': int.parse(_foundedYearController.text.trim()),
      'address': _addressController.text.trim(),
      'city': _cityController.text.trim(),
    };

    bool success;
    if (isEditing) {
      success =
          await ref.read(teamProvider.notifier).updateTeam(widget.teamId!, data);
    } else {
      success = await ref.read(teamProvider.notifier).createTeam(data);
    }

    if (success && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamProvider);

    // Listen for errors
    ref.listen<TeamState>(teamProvider, (previous, current) {
      if (current.status == TeamStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(current.errorMessage ?? 'An error occurred'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    });

    // Populate fields when editing
    if (isEditing) {
      _populateFields(teamState);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Team' : 'Create Team'),
      ),
      body: _buildBody(teamState),
    );
  }

  Widget _buildBody(TeamState state) {
    if (state.status == TeamStatus.loading &&
        isEditing &&
        state.selectedTeam == null) {
      return const LoadingWidget();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNameField(),
            const SizedBox(height: 16),
            _buildLogoField(),
            const SizedBox(height: 16),
            _buildFoundedYearField(),
            const SizedBox(height: 16),
            _buildAddressField(),
            const SizedBox(height: 16),
            _buildCityField(),
            const SizedBox(height: 32),
            _buildSubmitButton(state),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Team Name *',
        prefixIcon: Icon(Icons.groups),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter team name';
        }
        if (value.length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLogoField() {
    return TextFormField(
      controller: _logoController,
      decoration: const InputDecoration(
        labelText: 'Logo URL',
        prefixIcon: Icon(Icons.image),
        hintText: 'https://example.com/logo.png',
      ),
    );
  }

  Widget _buildFoundedYearField() {
    return TextFormField(
      controller: _foundedYearController,
      decoration: const InputDecoration(
        labelText: 'Founded Year *',
        prefixIcon: Icon(Icons.calendar_today),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter founded year';
        }
        final year = int.tryParse(value);
        if (year == null || year < 1800 || year > 2100) {
          return 'Please enter a valid year (1800-2100)';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Address',
        prefixIcon: Icon(Icons.location_on),
      ),
      maxLines: 2,
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      controller: _cityController,
      decoration: const InputDecoration(
        labelText: 'City *',
        prefixIcon: Icon(Icons.location_city),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter city';
        }
        if (value.length < 2) {
          return 'City must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(TeamState state) {
    return ElevatedButton(
      onPressed: state.status == TeamStatus.loading ? null : _submit,
      child: state.status == TeamStatus.loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(isEditing ? 'Update Team' : 'Create Team'),
    );
  }
}
