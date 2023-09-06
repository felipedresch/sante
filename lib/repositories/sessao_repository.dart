import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/consulta_model.dart';

class ConsultaRepository extends ChangeNotifier {
  //late Database db;
  List<Sessao> _consultas = [];
  Sessao? consultaSelected;
  int? indexConsulta;

  UnmodifiableListView<Sessao> get listaConsultas =>
      UnmodifiableListView(_consultas);


  

 

  

 
}