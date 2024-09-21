class Person {
  // Step 1: Personal Info
  String? fullName;
  String? email;
  String? phoneNumber;

  // Step 2: Address Info
  String? country;
  String? city;
  String? postalCode;

  // Step 3: Preferences from enum
  List<String> preferences;

  //id that is assigned to a person when they have been saved
  String? id;

  Person({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.country,
    this.city,
    this.postalCode,
    this.preferences = const [],
    this.id = '1',
  });

  // Convert enum to string for storing in the database
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'country': country,
      'city': city,
      'postalCode': postalCode,
      'preferences': preferences,
    };
  }

  // Parse string back to enum for loading from the database
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: '1',
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      country: json['country'],
      city: json['city'],
      postalCode: json['postalCode'],
      preferences: List<String>.from(json['preferences'] ?? []),
    );
  }

  // Copy method for creating a modified copy of the class
  Person copyWith(Person? person) {
    return (person != null)
        ? Person(
            id: person.id ?? '1',
            fullName: person.fullName ?? fullName,
            email: person.email ?? email,
            phoneNumber: person.phoneNumber ?? phoneNumber,
            country: person.country ?? country,
            city: person.city ?? city,
            postalCode: person.postalCode ?? postalCode,
            preferences:
                (person.preferences != []) ? person.preferences : preferences,
          )
        : this;
  }
}
