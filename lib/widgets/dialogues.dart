import 'package:flutter/material.dart';
import 'package:interview/features/bloc/forms_bloc.dart';

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart'; // For checking network status

void showSubmissionStatusDialog(
    BuildContext context, SaveStatus status, Function retrySubmission) {
  // Helper function to check the network status
  Future<bool> _checkNetworkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.first == ConnectivityResult.mobile ||
        connectivityResult.first == ConnectivityResult.wifi) {
      return true; // Connected to the internet
    } else {
      return false; // No internet connection
    }
  }

  // Initial Dialog with FutureBuilder to show network-based result
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing while checking status
    builder: (BuildContext context) {
      return FutureBuilder<bool>(
        future: _checkNetworkConnection(), // Check network status
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while waiting for the future to resolve
            return AlertDialog(
              title: const Text(
                'Submitting...',
                style: TextStyle(color: Colors.orangeAccent),
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Please wait while we submit your form.'),
                  SizedBox(height: 10),
                  CircularProgressIndicator(),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            );
          } else if (snapshot.hasError || snapshot.data == false) {
            // If there was a network error or no connection
            return AlertDialog(
              title: const Text(
                'Submission Failed',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Your form has been saved locally, but we couldn\'t upload it due to no internet connection.'),
                  SizedBox(height: 10),
                  Icon(
                    Icons.warning,
                    color: Colors.orange,
                    size: 30,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    retrySubmission(); // Retry submission
                  },
                  child:
                      const Text('Retry', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('OK', style: TextStyle(color: Colors.blue)),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            );
          } else if (snapshot.data == true) {
            // If connected to the internet and cloud submission was successful
            return AlertDialog(
              title: const Text(
                'Submission Successful',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                  'Your form has been successfully uploaded to the cloud.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('OK', style: TextStyle(color: Colors.blue)),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }
          return const SizedBox(); // Empty widget as fallback
        },
      );
    },
  );
}

Future<dynamic> kanyantaDialogue(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Kanyanta\'s Demonstration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
            'This is Kanyanta\'s demonstration on BLoC state management and feature-oriented architecture. '
            'Explore the clean and structured approach of organizing Flutter apps!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );
    },
  );
}
