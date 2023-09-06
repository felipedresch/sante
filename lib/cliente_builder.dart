import 'package:flutter/material.dart';
import 'package:sante/cadastro.dart';
import 'package:sante/repositories/cliente_repository.dart';

import 'models/cliente_model.dart';

class ClienteCardBuilder extends StatefulWidget {
  const ClienteCardBuilder({super.key});

  @override
  State<ClienteCardBuilder> createState() => _ClienteCardBuilderState();
}

class _ClienteCardBuilderState extends State<ClienteCardBuilder> {
  late ClienteRepository clienteRepository = ClienteRepository();
  late Cadastro cadastro = Cadastro();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: clienteRepository.recuperarClientes(),
        builder: (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, position) {
                  return Dismissible(
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(Icons.delete_forever),
                      ),
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction) async {
                        await clienteRepository
                            .removerClientes(snapshot.data![position].id!);
                      },
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        //onTap: () => cadastro.populateFields(snapshot.data![position]),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12.0, 12.0, 12.0, 6.0),
                                      child: Text(
                                        snapshot.data![position].nome,
                                        style: const TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12.0, 6.0, 12.0, 12.0),
                                      child: Text(
                                        snapshot.data![position].cpf.toString(),
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              height: 2.0,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ));
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
