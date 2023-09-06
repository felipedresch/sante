import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sante/container_all.dart';
import 'package:sante/models/consulta_model.dart';
import 'package:sante/repositories/cliente_repository.dart';
import 'package:sante/repositories/track_screens.dart';

import 'models/cliente_model.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  String title = "Visualização de Cadastro";

  final TextEditingController _nomeController = TextEditingController();

  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  int _sexo = 0;
  int _diabetes = 0;
  int _hipertensao = 0;
  int _alergia = 0;
  final TextEditingController _alergiaController = TextEditingController();
  int _doenca = 0;
  final TextEditingController _doencaController = TextEditingController();
  int _medicacao = 0;
  final TextEditingController _medicacaoController = TextEditingController();
  int _procEstetico = 0;
  final TextEditingController _procEsteticoController = TextEditingController();
  late ClienteRepository clienteRepository;
  //late Sessao consulta;
  List<Cliente> clienteList = [];
  List<Sessao> consultaList = [];
  List<Sessao> consultasCliente = [];
  bool fetching = true;
  int? id;

  @override
  void initState() {
    super.initState();
    clienteRepository = ClienteRepository();
    clienteRepository.initDB().whenComplete(() async {
      getData();
      //setState(() {});
    });
  }

  Future<void> getData() async {
    clienteList = await clienteRepository.recuperarClientes();
    consultaList = await clienteRepository.recuperarConsultas();
    if (mounted) {
      setState(() {
        fetching = false;
        buscarConsultas();
      });
    }
  }

  buscarConsultas() {
    if (consultaList.isNotEmpty) {
      for (var i = 0; i < consultaList.length; i++) {
        if (consultaList.elementAt(i).clienteID == id) {
          consultasCliente.add(consultaList.elementAt(i));
        }
      }
    }
    return consultasCliente;
  }

  @override
  Widget build(BuildContext context) {
    TrackScreens track = Provider.of<TrackScreens>(context);
    int? index;

    while (fetching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (clienteRepository.indexCliente != null && !fetching) {
      //Recupera as infos do cadastro e preenche nos campos
      getData();
      index = clienteRepository.indexCliente;
      _nomeController.text = clienteList[index!].nome;
      _cpfController.text = clienteList.elementAt(index).cpf;
      _telefoneController.text = clienteList.elementAt(index).telefone ?? "";
      _emailController.text = clienteList.elementAt(index).email ?? "";
      _dataNascimentoController.text =
          clienteList.elementAt(index).dataNascimento ?? "";
      _sexo = clienteList.elementAt(index).sexo;
      _diabetes = clienteList.elementAt(index).diabetes;
      _hipertensao = clienteList.elementAt(index).hipertensao;
      _alergiaController.text = clienteList.elementAt(index).alergia ?? "";
      _doencaController.text = clienteList.elementAt(index).doenca ?? "";
      _medicacaoController.text = clienteList.elementAt(index).medicacao ?? "";
      _procEsteticoController.text =
          clienteList.elementAt(index).procEstetico ?? "";

      id = clienteList.elementAt(index).id;
      //buscarConsultas(); //FAZ UMA LISTA INFINITAAAAAAAAAAAAAAAAAAAAAAA

      if (_alergiaController.text.isEmpty) {
        _alergia = 2;
      } else {
        _alergia = 1;
      }
      if (_doencaController.text.isEmpty) {
        _doenca = 2;
      } else {
        _doenca = 1;
      }
      if (_medicacaoController.text.isEmpty) {
        _medicacao = 2;
      } else {
        _medicacao = 1;
      }
      if (_procEsteticoController.text.isEmpty) {
        _procEstetico = 2;
      } else {
        _procEstetico = 1;
      }
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                clienteRepository.indexCliente = null;
                Navigator.popAndPushNamed(context, "/list");
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(title)),
        body: ContainerAll(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Padding(
                  //form 1: Nome
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Form(
                    //key: _nomeKey,
                    child: TextFormField(
                      controller: _nomeController,
                      style: const TextStyle(fontSize: 16),
                      readOnly: true,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Nome Completo",
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Form(
                    //key: _cpfKey,
                    child: TextFormField(
                      controller: _cpfController,
                      style: const TextStyle(fontSize: 16),
                      readOnly: true,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "CPF",
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  //form 3: Telefone
                  child: Form(
                    child: TextFormField(
                      controller: _telefoneController,
                      style: const TextStyle(fontSize: 16),
                      readOnly: true,
                      //enabled: false,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Telefone",
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  //form 4: E-mail
                  child: Form(
                    child: TextFormField(
                      controller: _emailController,
                      style: const TextStyle(fontSize: 16),
                      readOnly: true,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "E-mail",
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  //form 5: Data de Nascimento
                  child: Form(
                    child: TextFormField(
                      controller: _dataNascimentoController,
                      style: const TextStyle(fontSize: 16),
                      readOnly: true,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Data de Nascimento",
                        prefixIcon: Icon(Icons.date_range_outlined),
                      ),
                    ),
                  ),
                ),
                Row(
                  //Form Diabetes //CAMPO OBRIGATÓRIO
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 130,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(width: 0.5)),
                        child: Column(
                          children: [
                            const Text("Diabetes",
                                style: TextStyle(fontSize: 16)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Form(
                                  child: Radio(
                                      value: 1,
                                      groupValue: _diabetes,
                                      onChanged: (value) {}),
                                ),
                                const Text("Sim"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Form(
                                  child: Radio(
                                      value: 2,
                                      groupValue: _diabetes,
                                      onChanged: (value) {}),
                                ),
                                const Text("Não"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      //Form Hipertensão //CAMPO OBRIGATÓRIO
                      padding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 130,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(width: 0.5)),
                        child: Column(
                          children: [
                            const Text("Hipertensão",
                                style: TextStyle(fontSize: 16)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Form(
                                  child: Radio(
                                      value: 1,
                                      groupValue: _hipertensao,
                                      onChanged: (value) {}),
                                ),
                                const Text("Sim"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Form(
                                  child: Radio(
                                      value: 2,
                                      groupValue: _hipertensao,
                                      onChanged: (value) {}),
                                ),
                                const Text("Não"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 00, 0),
                        width: MediaQuery.of(context).size.width * 0.94,
                        height: 85,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(width: 0.5)),
                        child: Column(
                          children: [
                            const Text("Sexo", style: TextStyle(fontSize: 16)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Form(
                                  child: Radio(
                                      value: 1,
                                      groupValue: _sexo,
                                      onChanged: (value) {}),
                                ),
                                const Text("Feminino"),
                                Form(
                                  child: Radio(
                                      value: 2,
                                      groupValue: _sexo,
                                      onChanged: (value) {}),
                                ),
                                const Text("Masculino"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                (_alergia == 1) //CAMPO OBRIGATÓRIO
                    ? Row(
                        //Form Alergia opção sim
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.94,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(width: 0.5)),
                              child: Column(
                                children: [
                                  const Text("Possui Alguma Alergia?",
                                      style: TextStyle(fontSize: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Form(
                                        child: Radio(
                                            value: 1,
                                            groupValue: _alergia,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _alergia,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Não"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        width: 300,
                                        child: Form(
                                          child: TextFormField(
                                            controller: _alergiaController,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: "Especifique:",
                                              prefixIcon: Icon(
                                                  Icons.border_color_outlined),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        //Form Alergia opção não
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.94,
                              height: 85,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(width: 0.5)),
                              child: Column(
                                children: [
                                  const Text("Possui Alguma Alergia?",
                                      style: TextStyle(fontSize: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Form(
                                        child: Radio(
                                            value: 1,
                                            groupValue: _alergia,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _alergia,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Não"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                (_doenca == 1) //CAMPO OBRIGATÓRIO
                    ? Row(
                        //Form Doença Autoimune opção sim
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.94,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(width: 0.5)),
                              child: Column(
                                children: [
                                  const Text("Possui Alguma Doença Autoimune?",
                                      style: TextStyle(fontSize: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Form(
                                        child: Radio(
                                            value: 1,
                                            groupValue: _doenca,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _doenca,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Não"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        width: 300,
                                        child: Form(
                                          child: TextFormField(
                                            controller: _doencaController,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: "Especifique:",
                                              prefixIcon: Icon(
                                                  Icons.border_color_outlined),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        //Form Doença Autoimune opção não
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.94,
                              height: 85,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(width: 0.5)),
                              child: Column(
                                children: [
                                  const Text("Possui Alguma Doença Autoimune?",
                                      style: TextStyle(fontSize: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Form(
                                        child: Radio(
                                            value: 1,
                                            groupValue: _doenca,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _doenca,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Não"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                (_medicacao == 1) //CAMPO OBRIGATÓRIO
                    ? Row(
                        //Form Medicação Contínua opção sim
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.94,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(width: 0.5)),
                              child: Column(
                                children: [
                                  const Text(
                                      "Faz Uso de Alguma Medicação Contínua?",
                                      style: TextStyle(fontSize: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Form(
                                        child: Radio(
                                            value: 1,
                                            groupValue: _medicacao,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _medicacao,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Não"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        width: 300,
                                        child: Form(
                                          child: TextFormField(
                                            controller: _medicacaoController,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: "Especifique:",
                                              prefixIcon: Icon(
                                                  Icons.border_color_outlined),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        //Form Medicação Contínua opção não
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.94,
                              height: 85,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(width: 0.5)),
                              child: Column(
                                children: [
                                  const Text(
                                      "Faz Uso de Alguma Medicação Contínua?",
                                      style: TextStyle(fontSize: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Form(
                                        child: Radio(
                                            value: 1,
                                            groupValue: _medicacao,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _medicacao,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Não"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                (_procEstetico == 1)
                    ? Row(
                        //Form Procedimento Estético opção sim
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.94,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(width: 0.5)),
                              child: Column(
                                children: [
                                  const Text(
                                      "Já Realizou Algum Procedimento Estético?",
                                      style: TextStyle(fontSize: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Form(
                                        child: Radio(
                                            value: 1,
                                            groupValue: _procEstetico,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _procEstetico,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Não"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        width: 300,
                                        child: Form(
                                          child: TextFormField(
                                            controller: _procEsteticoController,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: "Especifique:",
                                              prefixIcon: Icon(
                                                  Icons.border_color_outlined),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        //Form Procedimento Estético opção não
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.94,
                              height: 85,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(width: 0.5)),
                              child: Column(
                                children: [
                                  const Text(
                                      "Já Realizou Algum Procedimento Estético?",
                                      style: TextStyle(fontSize: 16)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Form(
                                        child: Radio(
                                            value: 1,
                                            groupValue: _procEstetico,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _procEstetico,
                                            onChanged: (value) {}),
                                      ),
                                      const Text("Não"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                Container(
                  margin: const EdgeInsets.fromLTRB(40, 0, 40, 5),
                  child: OutlinedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/cadastrar");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: const Icon(Icons.edit),
                        ),
                        const Text("Editar Cadastro"),
                      ],
                    ),
                  ),
                ),
                Container(
                  //Botão de excluir usuario
                  margin: const EdgeInsets.fromLTRB(40, 0, 40, 10),
                  child: OutlinedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      foregroundColor: MaterialStatePropertyAll(Colors.red),
                    ),
                    onPressed: () async {
                      clienteRepository.indexCliente = null;
                      await clienteRepository
                          .removerClientes(clienteList.elementAt(index!).id!);
                      //EXIBIR NOTIFICACAO PERGUNTANDO SE DESEJA EXCLUIR
                      setState(() {
                        Navigator.popAndPushNamed(context, "/home");
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Cadastro Excluído!")));
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: const Icon(Icons.delete),
                        ),
                        const Text("Excluir Cadastro"),
                      ],
                    ),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                      child: Text(
                        "Histórico de sessões deste cliente",
                        style: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 63, 40, 133),
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                (consultasCliente.isNotEmpty)
                    ? SizedBox(
                        height: 400,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: consultasCliente.length,
                            prototypeItem: Card(
                              elevation: 6,
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.purple,
                                  child: Text("1"),
                                ),
                                title: Text(consultasCliente.first.data),
                                subtitle: Text(consultasCliente.first.queixa,
                                    overflow: TextOverflow.ellipsis),
                                trailing: const Icon(Icons.visibility_outlined),
                                onTap: () {
                                  //fromCadastroView = true
                                  clienteRepository.consultaSelected =
                                      consultasCliente
                                          .first; //SERA???????? NAO SEI!!
                                  clienteRepository.indexConsulta = 0;
                                  track.consultasCliente = consultasCliente;
                                  Navigator.popAndPushNamed(
                                      context, '/consultaView');
                                },
                              ),
                            ),
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 6,
                                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.purple,
                                    child: Text((index + 1).toString()),
                                  ),
                                  title: Text(consultasCliente[index].data),
                                  subtitle: Text(consultasCliente[index].queixa,
                                      overflow: TextOverflow.ellipsis),
                                  trailing:
                                      const Icon(Icons.visibility_outlined),
                                  onTap: () {
                                    //fromCadastroView = true
                                    clienteRepository.consultaSelected =
                                        consultasCliente[
                                            index]; //SERA???????? NAO SEI!!
                                    clienteRepository.indexConsulta = index;
                                    track.consultasCliente = consultasCliente;
                                    Navigator.popAndPushNamed(
                                        context, '/consultaView');
                                  },
                                ),
                              );
                            }),
                      )
                    : const Center(
                        child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Não há consultas",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 63, 40, 133),
                            )),
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
