import 'package:person_edits/person_edits.dart';
import 'package:person_edits/src/repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesPersonRepo implements PersonRepo {
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  @override
  Future<bool> savingPerson(Person newPerson) async {
    final prefs = await _prefs;
    try {
      String personJson = jsonEncode(newPerson.toJson());
      return prefs.setString(newPerson.id.toString(), personJson);
    } catch (e) {
      print('Error saving person: $e');
      return false;
    }
  }

  @override
  Future<Person> fetchPersonFromDataBase(String key) async {
    final prefs = await _prefs;
    String? personJson = prefs.getString(key);

    if (personJson != null) {
      return Person.fromJson(jsonDecode(personJson));
    } else {
      throw Exception('Person not found');
    }
  }

  @override
  Future<void> updatePerson(Person person) async {
    // SharedPreferences doesn't have specific 'update', so we'll overwrite the existing value.
    await savingPerson(person);
  }

  @override
  Future<bool> deletePerson(String key) async {
    final prefs = await _prefs;
    return prefs.remove(key);
  }

  // Future<List<Person>> fetchUnsyncedPersons() async {
  //   final prefs = await _prefs;
  //   final keys = prefs.getKeys().where((key) => key.startsWith(personKey));
  //   List<Person> unsyncedPersons = [];
  //   for (var key in keys) {
  //     String? personJson = prefs.getString(key);
  //     if (personJson != null) {
  //       var person = Person.fromJson(jsonDecode(personJson));
  //       if (person.synced == 0) {
  //         unsyncedPersons.add(person);
  //       }
  //     }
  //   }
  //   return unsyncedPersons;
  // }
}
