import 'package:contact_list/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper contactHelper = ContactHelper();


  @override
  void initState() {
    super.initState();

    Contact contact = Contact();
    contact.name = "Lukinhas Rodrigues";
    contact.email = "lukinhas@gmail.com";
    contact.phone = "99602-5678";
    contact.img = "teste/de/imagem2";

    contactHelper.saveContact(contact);

    contactHelper.getAllContacts().then((list) {
      print(list);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
