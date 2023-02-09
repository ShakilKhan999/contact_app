import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactDetails extends StatefulWidget {
  static const String routename = '/contact_details';

  const ContactDetails({Key? key}) : super(key: key);

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  int? id;
  @override
  void didChangeDependencies() {
    id = ModalRoute.of(context)!.settings.arguments as int;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts Details')),
      body: Center(
        child: Consumer<ContactProvider>(
          builder:(context,provider,_)=> FutureBuilder<ContactModel>(
            future: provider.getContactById(id!),
            builder: (context,snapshot){
              if(snapshot.hasData){
                final contact = snapshot.data;
                return ListView(
                  children: [
                    Image.file(File(contact!.image!),width: double.infinity,height: 300,fit: BoxFit.cover,),
                    ListTile(
                      title: Text(contact.name),
                      subtitle: Text(contact.number),

                    )
                  ],
                );
              }
              if(snapshot.hasError){
                return const Text('Failed to Fitch the Data');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
