import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sante/cadastro.dart';
import 'package:sante/cadastroView.dart';
import 'package:sante/consulta.dart';
import 'package:sante/repositories/cliente_repository.dart';
import 'package:sante/repositories/sessao_repository.dart';
import 'package:sante/repositories/track_screens.dart';

import 'cliente_list.dart';
import 'consulta_view.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TrackScreens()),
        ChangeNotifierProvider(create: (context) => ClienteRepository()),
        ChangeNotifierProvider(create: (context) => ConsultaRepository()),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Home(),
          routes: {
            "/cadastrar": (_) => const Cadastro(),
            "/list": (_) => const ClienteList(),
            "/home": (_) => const Home(),
            "/view": (_) => const CadastroView(),
            "/consulta": (_) => const Consulta(),
            "/consultaView": (_) => const ConsultaView(),
          },
        ),
      ),
    );
  }
}
