import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class NoteDisplay extends StatelessWidget {
  final String note;

  const NoteDisplay({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    const int maxLinesPreview = 4;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: note,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      maxLines: maxLinesPreview,
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 64); // Adjust for padding

    final bool isTruncated = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          note,
          maxLines: isTruncated ? maxLinesPreview : null,
          overflow: isTruncated ? TextOverflow.ellipsis : TextOverflow.visible,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (isTruncated)
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Full Workout Note'),
                    content: SingleChildScrollView(
                      child: Text(note),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Show More'),
          ),
      ],
    );
  }
}