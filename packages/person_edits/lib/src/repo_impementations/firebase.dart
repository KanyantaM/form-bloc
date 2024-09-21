import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:person_edits/src/repo.dart';

import '../models/person.dart';

class FirebasePersonRepo implements PersonRepo {
  final CollectionReference personCollection =
      FirebaseFirestore.instance.collection('persons');

  @override
  Future<bool> savingPerson(Person newPerson) async {
    try {
      await personCollection.doc(newPerson.id).set(newPerson.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Person> fetchPersonFromDataBase(String key) async {
    try {
      DocumentSnapshot docSnapshot = await personCollection.doc(key).get();
      if (docSnapshot.exists) {
        return Person.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Person not found');
      }
    } catch (e) {
      throw Exception('Error fetching person: $e');
    }
  }

  @override
  Future<void> updatePerson(Person person) async {
    try {
      await personCollection.doc(person.id).set(person.toJson());
    } catch (e) {
      throw Exception('Error updating person: $e');
    }
  }

  @override
  Future<bool> deletePerson(String key) async {
    try {
      await personCollection.doc(key).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> syncLocalData(List<Person> unsyncedPersons) async {
    for (var person in unsyncedPersons) {
      await savingPerson(person);
    }
  }
}
