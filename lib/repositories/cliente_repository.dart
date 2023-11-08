

import 'package:flutter/material.dart';
import 'package:sante/models/picture_model.dart';
import 'package:sqflite/sqflite.dart';
import '../models/cliente_model.dart';
import 'package:path/path.dart';
import '../models/consulta_model.dart';

class ClienteRepository extends ChangeNotifier {
  static final ClienteRepository _clienteRepository = ClienteRepository._();
  ClienteRepository._();
  late Database db;
  Cliente? clienteSelected;
  int? indexCliente;
  int? indexConsulta;
  Sessao? consultaSelected;

  factory ClienteRepository() {
    return _clienteRepository;
  }

  Future<void> initDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, 'sante.db'),
      onCreate: (database, version) async {
        await database.execute(_clientes);
        await database.execute(_consultas);
        await database.execute(_pictures);
      },
      version: 1,
    );
  }

  String get _clientes => '''
    CREATE TABLE clientes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      consultas TEXT,
      cpf TEXT,
      nome TEXT,
      telefone TEXT,
      email TEXT,
      dataNascimento TEXT,
      sexo INTEGER,
      diabetes INTEGER,
      hipertensao INTEGER,
      alergia TEXT,
      doenca TEXT,
      medicacao TEXT,
      procEstetico TEXT
    );
  ''';
  String get _consultas => '''
    CREATE TABLE consultas(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      data TEXT,
      valor REAL,
      pagamento TEXT,
      peso TEXT,
      altura TEXT, 
      estomago TEXT,
      cintura TEXT,
      quadril TEXT,
      umbigo TEXT,
      hidratacao INTEGER,
      queixa TEXT,
      alimentacao TEXT,
      tratamento TEXT,
      observacoes TEXT,
      exFisico INTEGER,
      cliente_id INTEGER,
      FOREIGN KEY (cliente_id) REFERENCES clientes(id)
    );
  ''';

  String get _pictures => '''
    CREATE TABLE pictures (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      path TEXT,
      clienteID INTEGER,
      consultaID INTEGER,
      FOREIGN KEY (clienteID) REFERENCES clientes(id),
      FOREIGN KEY (consultaID) REFERENCES consultas(id)
    );
  ''';

  Future<List<Cliente>> recuperarClientes() async {
    final List<Map<String, Object?>> queryResult = await db.query('clientes');
    List<Cliente> lista = queryResult.map((e) => Cliente.fromMap(e)).toList();
    lista.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toString().toLowerCase()));
        return lista;
  }

  Future<int> salvarClientes(Cliente cliente) async {
    int result = await db.insert('clientes', cliente.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> atualizarClientes(Cliente cliente) async {
    int result = await db.update(
      'clientes',
      cliente.toMap(),
      where: "id = ?",
      whereArgs: [cliente.id],
    );
    return result;
  }

  Future<void> removerClientes(int id) async {
    await db.delete(
      'clientes',
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<List<Sessao>> recuperarConsultas() async {
    final List<Map<String, Object?>> queryResult = await db.query('consultas');
    return queryResult.map((e) => Sessao.fromMap(e)).toList();
  }

  Future<int> salvarConsultas(Sessao consulta) async {
    int result = await db.insert('consultas', consulta.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> atualizarConsultas(Sessao consulta) async {
    int result = await db.update(
      'consultas',
      consulta.toMap(),
      where: "id = ?",
      whereArgs: [consulta.id],
    );
    return result;
  }

  Future<void> removerConsulta(int id) async {
    await db.delete(
      'consultas',
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<int> savePicture(Picture picture) async {
    int result = await db.insert('pictures', picture.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<Picture>> getPictures() async {
    final List<Map<String, Object?>> queryResult = await db.query('pictures');
    return queryResult.map((e) => Picture.fromMap(e)).toList();
  }


  Future deleteTable(String tableName) async {
    final db = ClienteRepository().db;
    return db.rawQuery("DELETE FROM $tableName");
  }

  Future<void> deleteDatabase(String path) =>
      databaseFactory.deleteDatabase(path);
}
