import 'package:contact_app/auth_prefs.dart';
import 'package:contact_app/db/db_helper.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/pages/contact_details_page.dart';
import 'package:contact_app/pages/launcher_page.dart';
import 'package:contact_app/pages/login_page.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class ContactList extends StatefulWidget {
  static const String routename = '/';

  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
        actions: [
          PopupMenuButton(itemBuilder: (context)=>[
            PopupMenuItem(child: Text('Logout'),
            onTap: (){
              setLoginStatus(false).then((value){
                Navigator.pushReplacementNamed(context, LoginPage.routename);
              });
            },
            )
          ])
        ],
      ),
      bottomNavigationBar:
      Padding(
        padding: const EdgeInsets.only(left: 40,right: 40,bottom: 10),
        child: Consumer<ContactProvider>(
          builder:(context,provider,_)=> Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.grey[300]),
            child: GNav(

              gap:20,
             tabBorderRadius:30 ,
             // backgroundColor: Colors.lightBlueAccent,
             // tabBackgroundColor: Colors.blue.withOpacity(.6),
              tabActiveBorder: Border.all(color: Colors.blue,width: 1),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.favorite,
                  text: 'Favorite',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index){
                setState(() {
                  _selectedIndex = index;
                });
                provider.loadContact(_selectedIndex);
              },
            ),
          ),
        ),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, _) =>
            ListView.builder(
                itemCount: provider.contactList.length,
                itemBuilder: (context, index) {
                  final contact = provider.contactList[index];
                  return Dismissible(
                    confirmDismiss: _showConfirmationaDialog,
                    onDismissed: (direction) {
                      provider.deleteContact(contact.id!);
                    },
                    key: ValueKey(contact.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    child: ListTile(
                      onTap: () =>
                          Navigator.pushNamed(context, ContactDetails.routename,
                              arguments: contact.id),
                      title: Text(contact.name),
                      subtitle: Text(contact.number),
                      trailing: IconButton(
                        icon: Icon(
                            contact.favorite ? Icons.favorite : Icons
                                .favorite_border),
                        onPressed: () {
                          final value = contact.favorite ? 0 : 1;
                          provider.updateFavorite(contact.id!, value, index);
                        },
                      ),
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NewContact.routename);
        },
        child: Icon(Icons.add),
        tooltip: 'Add new Contact',
      ),
    );
  }

  Future<bool?> _showConfirmationaDialog(DismissDirection direction) {
    return showDialog(context: context, builder: (context) =>
        AlertDialog(
          title: const Text('Delete Contact'),
          content: const Text('Are you sure?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false),
                child: const Text('No')),
            TextButton(onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes')),
          ],
        ));
  }
}
