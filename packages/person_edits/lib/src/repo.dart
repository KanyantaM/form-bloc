import 'package:person_edits/src/models/person.dart';

abstract class PersonRepo {
  //create person
  // this function should return a bool on the saving status of a person
  Future<bool> savingPerson(Person newPerson);

  //read person
  Future<Person> fetchPersonFromDataBase(String key);

  //update person
  Future<void> updatePerson(Person person);

  //delete person should only return true when the person has been deleted.
  Future<bool> deletePerson(String key);
}

// enum SavingStatus { none, offline, cloud }
