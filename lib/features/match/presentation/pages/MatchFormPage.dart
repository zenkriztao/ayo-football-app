import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ayo_football_app/features/match/presentation/providers/MatchProvider.dart';
import 'package:ayo_football_app/features/match/presentation/providers/MatchState.dart';

/// Page Form Match for Create using Riverpod
/// Applying Single Responsibility Principle
class MatchFormPage extends ConsumerStatefulWidget {
  final String? matchId;

  const MatchFormPage({super.key, this.matchId});

  @override
  ConsumerState<MatchFormPage> createState() => _MatchFormPageState();
}

class _MatchFormPageState extends ConsumerState<MatchFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _homeTeamController = TextEditingController();
  final _awayTeamController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _homeTeamController.dispose();
    _awayTeamController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'match_date':
          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
      'match_time':
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      'home_team_id': _homeTeamController.text.trim(),
      'away_team_id': _awayTeamController.text.trim(),
    };

    final success = await ref.read(matchProvider.notifier).createMatch(data);

    if (success && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Match')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHomeTeamField(),
              const SizedBox(height: 16),
              _buildAwayTeamField(),
              const SizedBox(height: 16),
              _buildDatePicker(),
              _buildTimePicker(),
              const SizedBox(height: 32),
              _buildSubmitButton(matchState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTeamField() {
    return TextFormField(
      controller: _homeTeamController,
      decoration: const InputDecoration(
        labelText: 'Home Team ID *',
        prefixIcon: Icon(Icons.home),
      ),
      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
    );
  }

  Widget _buildAwayTeamField() {
    return TextFormField(
      controller: _awayTeamController,
      decoration: const InputDecoration(
        labelText: 'Away Team ID *',
        prefixIcon: Icon(Icons.flight),
      ),
      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: const Text('Match Date'),
      subtitle: Text(
        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: _selectDate,
    );
  }

  Widget _buildTimePicker() {
    return ListTile(
      title: const Text('Match Time'),
      subtitle: Text(_selectedTime.format(context)),
      trailing: const Icon(Icons.access_time),
      onTap: _selectTime,
    );
  }

  Widget _buildSubmitButton(MatchState state) {
    return ElevatedButton(
      onPressed: state.status == MatchStatus.loading ? null : _submit,
      child: const Text('Create Match'),
    );
  }
}
