import 'package:flutter/material.dart';
import 'package:interview/widgets/dialogues.dart';

AppBar appBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    title: const Row(
      children: [
        Icon(Icons.assignment, color: Colors.white), // Add an icon
        SizedBox(width: 10), // Spacing between icon and title
        Text(
          "Multi-Step Form",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
    backgroundColor: Colors.teal, // Customize background color
    actions: [
      IconButton(
        icon: const Icon(Icons.help_outline),
        tooltip: 'Help',
        onPressed: () {
          // Show a dialog with a message about the demonstration
          kanyantaDialogue(context);
        },
      ),
    ],
    elevation: 0, // Remove shadow for a flat look (optional)
  );
}
