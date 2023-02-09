import 'package:contact_app/db/db_helper.dart';
import 'package:flutter/cupertino.dart';

import '../models/contact_model.dart';

class ContactProvider extends ChangeNotifier{
  List<ContactModel> contactList = [];

  getAllContact(){
    DBHelper.getAllContacts().then((value) {
      contactList = value;
      notifyListeners();
    });

  }
  getAllFavoriteContacts(){
    DBHelper.getAllFavoriteContacts().then((value) {
      contactList = value;
      notifyListeners();
    });

  }
  loadContact(int index){
    switch(index){
      case 0:
        getAllContact();
        break;
      case 1:
        getAllFavoriteContacts();
        break;
    }
  }

 Future<ContactModel> getContactById(int id) => DBHelper.getContactsById(id);

  Future <bool> addNewContact(ContactModel contactModel) async{
   final rowId = await  DBHelper.insertContact(contactModel);
   if(rowId > 0){
     contactModel.id = rowId;
     contactList.add(contactModel);
     notifyListeners();
     return true;
   }
   return false;
  }
  updateFavorite(int id, int value,int index){
    DBHelper.updateFavorite(id, value).then((value) {
      contactList[index].favorite= !contactList[index].favorite;
      notifyListeners();
    });
  }
  deleteContact(int id) async {
    final rowId = await DBHelper.deleteContact(id);
    if(rowId>0){
      contactList.removeWhere((element) => element.id == id);
      notifyListeners();
    }

  }

}