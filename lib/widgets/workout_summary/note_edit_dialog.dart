import 'package:flutter/material.dart';

class NoteEditDialog extends StatefulWidget {
  final String initialNote;
  final Function(String) onSave;
  final int characterLimit;

  const NoteEditDialog({
    super.key,
    required this.initialNote,
    required this.onSave,
    required this.characterLimit,
  });

  @override
  State<NoteEditDialog> createState() => _NoteEditDialogState();
}

class _NoteEditDialogState extends State<NoteEditDialog> {
  late TextEditingController _noteTextController;

  @override
  void initState() {
    super.initState();
    _noteTextController = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Workout Note'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextFormField(
              controller: _noteTextController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              maxLength: widget.characterLimit,
              decoration: const InputDecoration(
                hintText: 'How did it feel? Note any PBs, pain, or equipment used.',
                labelText: 'Your Workout Note',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            widget.onSave(_noteTextController.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}