part of 'forms_bloc.dart';

@immutable
sealed class FormsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FormNextStep extends FormsEvent {
  final int step;
  final Person? person;
  FormNextStep({required this.step, this.person});
}

class FormPreviousStep extends FormsEvent {
  final int step;
  final Person? person;
  FormPreviousStep({required this.step, this.person});
}

class FormSubmit extends FormsEvent {
  final Person person;

  FormSubmit({required this.person});
}
