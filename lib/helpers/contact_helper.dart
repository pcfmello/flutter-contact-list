import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

// Classe que usa o padrão Singleton
// https://www.youtube.com/watch?v=BBywfIrmd5M*/

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async => _db != null ? _db : await initDb();

  Future<Database> initDb() async {
    // Obtém o caminho para a pasta que armazena os bancos de dados
    final databasesPath = await getDatabasesPath();

    // Junta o caminho com o nome do banco de dados
    final path = join(databasesPath, "contacts.db");

    // Abrir o banco de dados | onCreate cria o banco de dados na primeira vez que é acessado
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $contactTable ("
          "$idColumn INTEGER PRIMARY KEY,"
          "$nameColumn TEXT,"
          "$emailColumn TEXT,"
          "$phoneColumn TEXT,"
          "$imgColumn TEXT");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    // Obtém o DB
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;

    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);

    return maps.isEmpty ? null : Contact.fromMap(maps.first);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(),
        where: "$idColumn == ?", whereArgs: [contact.id]);
  }

  Future<int> deleteContact(id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<List<Contact>> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> contacts = List();

    for (Map map in listMap) {
      contacts.add(Contact.fromMap(map));
    }
    return contacts;
  }

  Future<int> getTotalContacts() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(
        await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future closeDb() async {
    Database dbContact = await db;
    await dbContact.close();
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
