import 'dart:io';

import 'package:contact_app/db/db_helper.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewContact extends StatefulWidget {
  static const String routename = '/new_contact';

  const NewContact({Key? key}) : super(key: key);

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final companyController = TextEditingController();
  final designationController = TextEditingController();
  final websiteController = TextEditingController();

  final form_key = GlobalKey<FormState>();
  String? dob;
  String? genderGroupValue = 'Male';
  String? imagePath;
  ImageSource source = ImageSource.camera;

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
        actions: [IconButton(onPressed: _saveContact, icon: Icon(Icons.save))],
      ),
      body: Form(
        key: form_key,
        child: ListView(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Name', prefixIcon: Icon(Icons.person)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This Field must not be empty';
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: numberController,
              decoration: const InputDecoration(
                  labelText: 'Phone', prefixIcon: Icon(Icons.phone)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This Field must not be empty';
                }
                if (value.length > 11) {
                  return 'Must be 11 number!';
                }
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Email', prefixIcon: Icon(Icons.email)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This Field must not be empty';
                }
              },
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                  labelText: 'Address', prefixIcon: Icon(Icons.home)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This Field must not be empty';
                }
              },
            ),
            Card(
              elevation: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                      value: 'Male',
                      groupValue: genderGroupValue,
                      onChanged: (value) {
                        setState(() {
                          genderGroupValue = value!;
                        });
                      }),
                  const Text(('Male')),
                  Radio(
                      value: 'Female',
                      groupValue: genderGroupValue,
                      onChanged: (value) {
                        setState(() {
                          genderGroupValue = value!;
                        });
                      }),
                  const Text("Female"),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: _showDatePickerDialog,
                    child: const Text('Select Date of Birth')),
                Chip(label: Text(dob == null ? 'No date choosen' : dob!))
              ],
            ),
            Card(
                elevation: 10,
                child: imagePath == null
                    ? Image.asset(
                        'images/placeholder.jpg',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.file(File(imagePath!),
                        height: 100, width: 100, fit: BoxFit.cover)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                    onPressed: () {
                      source = ImageSource.camera;
                      _getImage();
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text('Capture')),
                TextButton.icon(
                    onPressed: () {
                      source = ImageSource.gallery;
                      _getImage();
                    },
                    icon: Icon(Icons.photo),
                    label: Text('Gallery'))
              ],
            )
          ],
        ),
      ),
    );
  }

  void _saveContact() async {
    if (form_key.currentState!.validate()) {
      final contact = ContactModel(
          name: nameController.text,
          number: numberController.text,
          email: emailController.text,
          address: addressController.text,
          dob: dob,
          image: imagePath,
          gender: genderGroupValue);
      print(contact.toString());
      final status = await Provider
          .of<ContactProvider>(context, listen: false).addNewContact(contact);
      if (status) {
        Navigator.pop(context);
      }
    }
  }

  void _showDatePickerDialog() async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1992),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      setState(() {
        dob = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  void _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }
}
