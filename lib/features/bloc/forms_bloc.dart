import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:person_edits/person_edits.dart'; // Assume you have a Person model
import 'package:connectivity_plus/connectivity_plus.dart';

part 'forms_event.dart';
part 'forms_state.dart';

class FormsBloc extends Bloc<FormsEvent, FormsState> {
  final SharedPreferencesPersonRepo sqliteRepo;
  final FirebasePersonRepo firebaseRepo;
  Person? person;

  FormsBloc({required this.sqliteRepo, required this.firebaseRepo})
      : super(FormStep1()) {
    on<FormNextStep>((event, emit) async {
      if (person != null) {
        person = person?.copyWith(event.person);
        if (await sqliteRepo.savingPerson(person!)) {
          person = await sqliteRepo.fetchPersonFromDataBase('1');
          if (event.step == 1) {
            emit(FormStep1());
          } else if (event.step == 2) {
            emit(FormStep2());
          } else if (event.step == 3) {
            emit(FormStep3());
          } else if (event.step == 4) {
            emit(FormStep4());
          }
        }
      }
    });

    // Handling form submission
    on<FormSubmit>((event, emit) async {
      // Save the data locally in SQLite regardless of network state
      bool savedLocally = await sqliteRepo.savingPerson(event.person);

      if (savedLocally) {
        emit(FormSubmitted(status: SaveStatus.savedLocally));

        // Check for network connectivity to sync data with Firebase
        List<ConnectivityResult> result =
            await Connectivity().checkConnectivity();
        if (result[0] == ConnectivityResult.mobile ||
            result[0] == ConnectivityResult.wifi) {
          // Attempt to sync to Firebase
          bool savedOnCloud = await firebaseRepo.savingPerson(event.person);

          if (savedOnCloud) {
            emit(FormSubmitted(status: SaveStatus.savedOnCloud));
          } else {
            emit(FormSubmitted(status: SaveStatus.syncFailed));
          }
        } else {
          emit(FormSubmitted(status: SaveStatus.savedLocallyButNotSynced));
        }
      } else {
        emit(FormSubmitted(status: SaveStatus.failed));
      }
    });
  }
  Future<void> initializePerson() async {
    // Check local storage
    try {
      person = await sqliteRepo.fetchPersonFromDataBase('1');
    } catch (e) {
      try {
        person = person ?? await firebaseRepo.fetchPersonFromDataBase('1');
      } catch (e) {
        person = Person();
        throw Exception(e);
      }
      throw Exception(e);
    }
  }
}
