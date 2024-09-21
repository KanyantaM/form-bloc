import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:interview/features/bloc/forms_bloc.dart';
import 'package:interview/widgets/dialogues.dart';

void checkInternetAndUpload(
    BuildContext context, Function uploadToCloud) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    uploadToCloud();
  } else {
    // Show a message or save locally and retry later
    showSubmissionStatusDialog(context, SaveStatus.savedLocally, uploadToCloud);
  }
}
