import 'package:flutter/material.dart';

import '../models/character.dart';
import '../repositories/character_repository.dart';
import '../utils/character_validator.dart';
import '../widgets/app_scaffold.dart';

class CreateCharacterScreen extends StatefulWidget {
  const CreateCharacterScreen({super.key, required this.repository});

  final CharacterRepository repository;

  @override
  State<CreateCharacterScreen> createState() => _CreateCharacterScreenState();
}

class _CreateCharacterScreenState extends State<CreateCharacterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _abilityController = TextEditingController();
  String _selectedType = 'House Stark';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _abilityController.dispose();
    super.dispose();
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final character = Character(
      name: CharacterValidator.normalizeInput(_nameController.text),
      type: _selectedType,
      ability: CharacterValidator.normalizeInput(_abilityController.text),
    );

    await widget.repository.saveCharacter(character);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Character saved locally.')),
    );

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Create Character',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: CharacterValidator.validateName,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'House',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'House Stark',
                    child: Text('House Stark'),
                  ),
                  DropdownMenuItem(
                    value: 'House Targaryen',
                    child: Text('House Targaryen'),
                  ),
                  DropdownMenuItem(
                    value: 'House Lannister',
                    child: Text('House Lannister'),
                  ),
                  DropdownMenuItem(
                    value: 'House Baratheon',
                    child: Text('House Baratheon'),
                  ),
                  DropdownMenuItem(
                    value: 'House Greyjoy',
                    child: Text('House Greyjoy'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _abilityController,
                decoration: const InputDecoration(
                  labelText: 'Title or Skill',
                  border: OutlineInputBorder(),
                ),
                minLines: 1,
                maxLines: 3,
                validator: CharacterValidator.validateTitleOrSkill,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _isSaving ? null : _saveCharacter,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
