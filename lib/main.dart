import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Валідація номерного знака')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: LicensePlateForm(),
        ),
      ),
    );
  }
}

class LicensePlateForm extends StatefulWidget {
  const LicensePlateForm({super.key});

  @override
  State<LicensePlateForm> createState() => _LicensePlateFormState();
}

class _LicensePlateFormState extends State<LicensePlateForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: <Widget>[
          FormBuilderTextField(
            name: 'license_plate',
            decoration: const InputDecoration(labelText: 'Номерний знак'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                  errorText: 'Введіть номерний знак'),
              (value) {
                if (value == null || value.isEmpty) return null;
                if (!RegExp(
                        r'^[А-ЯІЄҐ]{2}\d{4}[А-ЯІЄҐ]{2}$|^[А-ЯІЄҐ]{2}\d{3}[А-ЯІЄҐ]{2}$')
                    .hasMatch(value.toUpperCase())) {
                  return 'Невірний формат номерного знака';
                }
                return null;
              },
            ]),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Номерний знак валідний!')),
                );
                print(_formKey.currentState!.value);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Невірний формат номерного знака')),
                );
              }
            },
            child: const Text('Перевірити'),
          ),
        ],
      ),
    );
  }
}
