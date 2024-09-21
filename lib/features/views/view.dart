import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview/features/views/components/app_bar.dart';
import 'package:interview/widgets/dialogues.dart';
import 'package:person_edits/person_edits.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../bloc/forms_bloc.dart';

class MultiStepView extends StatefulWidget {
  const MultiStepView({super.key});

  @override
  State<MultiStepView> createState() => _MultiStepViewState();
}

class _MultiStepViewState extends State<MultiStepView> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final List<String> _selectedSkills = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Person _person = Person();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: BlocConsumer<FormsBloc, FormsState>(
        listener: (context, state) {
          if (state is FormSubmitted) {
            showSubmissionStatusDialog(context, state.status, () {
              //todo: I am just tired
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // Global key for form validation
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder(
                      future: context.read<FormsBloc>().initializePerson(),
                      builder: (context, snapshot) {
                        _initializePerson(context);
                        if (state is FormStep1) {
                          return _buildStep1(context);
                        } else if (state is FormStep2) {
                          return _buildStep2(context);
                        } else if (state is FormStep3) {
                          return _buildStep3(context);
                        } else if (state is FormStep4) {
                          return _buildReviewAndSubmit(context);
                        }
                        return _buildReviewAndSubmit(context);
                      },
                    ),
                    const SizedBox(height: 20),
                    _progressIndicator()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _initializePerson(BuildContext context) {
    Person databasePerson = context.read<FormsBloc>().person ?? _person;
    _person = _person.copyWith(databasePerson);
    _fullNameController.text = _person.fullName ?? '';
    _emailController.text = _person.email ?? '';
    _phoneController.text = _person.phoneNumber ?? '';
    _countryController.text = _person.country ?? '';
    _cityController.text = _person.city ?? '';
    _postalCodeController.text = _person.postalCode ?? '';
  }

  Widget _progressIndicator() {
    return BlocBuilder<FormsBloc, FormsState>(
      builder: (context, state) {
        return StepProgressIndicator(
          totalSteps: 4,
          currentStep: state is FormStep1
              ? 1
              : state is FormStep2
                  ? 2
                  : state is FormStep3
                      ? 3
                      : 4,
          size: 36,
          selectedColor: Colors.green,
          unselectedColor: Colors.grey,
          customStep: (index, color, _) => InkWell(
            child: Container(
              color: color,
              child: Icon(
                color == Colors.green ? Icons.check : Icons.remove,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep1(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
            _fullNameController, 'Full Name', 'Please enter your full name',
            icon: Icons.person_3_rounded),
        _buildTextField(_emailController, 'Email', 'Please enter a valid email',
            emailValidation: true),
        _buildTextField(_phoneController, 'Phone Number',
            'Please enter a valid phone number',
            icon: Icons.phone, isNumber: true),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              BlocProvider.of<FormsBloc>(context).add(FormNextStep(
                step: 2,
                person: Person(
                  fullName: _fullNameController.text,
                  email: _emailController.text,
                  phoneNumber: _phoneController.text,
                ),
              ));
            }
          },
          child: const Text("Next"),
        ),
      ],
    );
  }

  Widget _buildStep2(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
            _countryController, 'Country', 'Please enter your country',
            icon: Icons.flag),
        _buildTextField(_cityController, 'City', 'Please enter your city',
            icon: Icons.location_city),
        _buildTextField(_postalCodeController, 'Postal Code',
            'Please enter your postal code',
            isNumber: true, icon: Icons.location_on_rounded),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => BlocProvider.of<FormsBloc>(context)
                  .add(FormNextStep(step: 1)),
              child: const Text("Back"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<FormsBloc>(context).add(FormNextStep(
                    step: 3,
                    person: Person(
                      country: _countryController.text,
                      city: _cityController.text,
                      postalCode: _postalCodeController.text,
                    ),
                  ));
                }
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('State Management'),
          value: _selectedSkills.contains('State Management'),
          onChanged: (value) => _toggleSkill('State Management'),
        ),
        CheckboxListTile(
          title: const Text('Firebase Integration'),
          value: _selectedSkills.contains('Firebase Integration'),
          onChanged: (value) => _toggleSkill('Firebase Integration'),
        ),
        CheckboxListTile(
          title: const Text('UI Design'),
          value: _selectedSkills.contains('UI Design'),
          onChanged: (value) => _toggleSkill('UI Design'),
        ),
        CheckboxListTile(
          title: const Text('API Integration'),
          value: _selectedSkills.contains('API Integration'),
          onChanged: (value) => _toggleSkill('API Integration'),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => BlocProvider.of<FormsBloc>(context).add(
                  FormNextStep(
                      step: 2, person: Person(preferences: _selectedSkills))),
              child: const Text("Back"),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<FormsBloc>(context).add(FormNextStep(
                  step: 4,
                  person: Person(preferences: _selectedSkills),
                ));
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String errorMessage,
      {bool emailValidation = false,
      bool isNumber = false,
      IconData icon = Icons.text_fields}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          icon: emailValidation ? const Icon(Icons.email) : Icon(icon),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorMessage;
          }
          if (emailValidation &&
              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Invalid email format';
          }
          return null;
        },
      ),
    );
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  Widget _buildReviewAndSubmit(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Full Name'),
          subtitle: Text(_fullNameController.text),
        ),
        ListTile(
          title: const Text('Email'),
          subtitle: Text(_emailController.text),
        ),
        ListTile(
          title: const Text('Phone Number'),
          subtitle: Text(_phoneController.text),
        ),
        ListTile(
          title: const Text('Country'),
          subtitle: Text(_countryController.text),
        ),
        ListTile(
          title: const Text('City'),
          subtitle: Text(_cityController.text),
        ),
        ListTile(
          title: const Text('Postal Code'),
          subtitle: Text(_postalCodeController.text),
        ),
        ListTile(
          title: const Text('Skills'),
          subtitle: Row(
            children: [
              for (var skil in _selectedSkills) Text('$skil, '),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => BlocProvider.of<FormsBloc>(context)
                  .add(FormNextStep(step: 3)),
              child: const Text("Back"),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<FormsBloc>(context)
                    .add(FormSubmit(person: _person));
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ],
    );
  }
}
