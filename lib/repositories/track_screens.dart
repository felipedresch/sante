import 'package:flutter/cupertino.dart';

import '../models/cliente_model.dart';
import '../models/consulta_model.dart';

class TrackScreens extends ChangeNotifier {
  bool fromHome = false;
  bool fromClienteList = false;
  bool fromConsulta = false;
  Cliente? cliente;
  List<Sessao> consultasCliente = [];
}
