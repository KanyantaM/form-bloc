part of 'forms_bloc.dart';

enum SaveStatus {
  savedLocally,
  savedOnCloud,
  failed,
  syncFailed,
  savedLocallyButNotSynced
}

@immutable
abstract class FormsState extends Equatable {
  @override
  List<Object> get props => [];
}

class FormStep1 extends FormsState {}

class FormStep2 extends FormsState {}

class FormStep3 extends FormsState {}

class FormStep4 extends FormsState {}

class FormSubmitted extends FormsState {
  final SaveStatus status;

  FormSubmitted({required this.status});

  @override
  List<Object> get props => [status];
}
