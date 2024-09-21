import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview/features/bloc/forms_bloc.dart';
import 'package:interview/features/views/view.dart';
import 'package:person_edits/person_edits.dart';

class MultiStepPage extends StatelessWidget {
  const MultiStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SharedPreferencesPersonRepo>(
            create: (context) => SharedPreferencesPersonRepo()),
        RepositoryProvider<FirebasePersonRepo>(
            create: (context) => FirebasePersonRepo()),
      ],
      child: BlocProvider(
        create: (context) => FormsBloc(
          sqliteRepo: context.read<SharedPreferencesPersonRepo>(),
          firebaseRepo: context.read<FirebasePersonRepo>(),
        ),
        child: const MultiStepView(),
      ),
    );
  }
}
