import 'package:flutter_test/flutter_test.dart';
import 'package:person_edits/src/models/person.dart';
import 'package:person_edits/src/repo_impementations/barrel_file.dart';

void main() async {
  Person person = Person(
      fullName: 'Kanyanta',
      email: 'kanyanta.1makasa@gmail.com',
      phoneNumber: '+260761951544',
      country: 'Zambia',
      city: 'Lusaka',
      postalCode: '10101',
      preferences: <String>[],
      id: '1');

  SQLitePersonRepo sqliteRepo = SQLitePersonRepo();

  setUp(() async {
    sqliteRepo = SQLitePersonRepo();
    await sqliteRepo.database; // Initialize database
  });

  tearDown(() async {
    // Optionally delete database after each test
  });

  test('Should save person in SQLite and fetch it successfully', () async {
    bool saveStatus = await sqliteRepo.savingPerson(person);
    expect(saveStatus, true);

    Person fetchedPerson = await sqliteRepo.fetchPersonFromDataBase('1');
    expect(fetchedPerson.fullName, 'Kanyanta');
    expect(fetchedPerson.preferences, <String>[
      // FlutterSkills.apiIntegration,
    ]);
  });

  // test('Should update person in SQLite successfully', () async {
  //   Person updatedPerson = person.copyWith(email: 'mulwandamakasa@gmail.com');
  //   await sqliteRepo.updatePerson(updatedPerson);

  //   Person fetchedPerson = await sqliteRepo.fetchPersonFromDataBase('1');
  //   expect(fetchedPerson.email, 'mulwandamakasa@gmail.com');
  // });

  test('Should delete person from SQLite successfully', () async {
    bool deleteStatus = await sqliteRepo.deletePerson('1');
    expect(deleteStatus, true);

    try {
      await sqliteRepo.fetchPersonFromDataBase('1');
      fail('Person should not be found');
    } catch (e) {
      expect(e.toString(), contains('Person not found'));
    }
  });
}
