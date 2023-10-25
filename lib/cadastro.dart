//TODO: Avisos de excluir cadastro, implementar pesquisa por nome/cpf em clientelist

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sante/container_all.dart';
import 'package:sante/repositories/cliente_repository.dart';
import 'models/cliente_model.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  String title = "Criar Cadastro";
  final _nomeKey = GlobalKey<FormState>(); //form 1
  final TextEditingController _nomeController = TextEditingController();
  final _cpfKey = GlobalKey<FormState>(); //form 2
  final TextEditingController _cpfController = TextEditingController();
  final _telefoneKey = GlobalKey<FormState>(); //form 3
  final TextEditingController _telefoneController = TextEditingController();
  final _emailKey = GlobalKey<FormState>(); //form 4
  final TextEditingController _emailController = TextEditingController();
  final _dataNascimentoKey = GlobalKey<FormState>(); //form 5
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  int _sexo = 0;
  int _diabetes = 0;
  int _hipertensao = 0;
  int _alergia = 0;
  final _alergiaKey = GlobalKey<FormState>();
  final TextEditingController _alergiaController = TextEditingController();
  int _doenca = 0;
  final _doencaKey = GlobalKey<FormState>();
  final TextEditingController _doencaController = TextEditingController();
  int _medicacao = 0;
  final _medicacaoKey = GlobalKey<FormState>();
  final TextEditingController _medicacaoController = TextEditingController();
  int _procEstetico = 0;
  final _procEsteticoKey = GlobalKey<FormState>();
  final TextEditingController _procEsteticoController = TextEditingController();
  int? id;
  late ClienteRepository clienteRepository;
  late Cliente _cliente;
  bool edicao = false;
  bool fetching = true;
  List<Cliente> clienteList = [];
  int? index;

  @override
  void initState() {
    super.initState();
    clienteRepository = ClienteRepository();
    clienteRepository.initDB().whenComplete(() async {
      getData();
    });
  }

  void getData() async {
    clienteList = await clienteRepository.recuperarClientes();
    setState(() {
      fetching = false;
      editar();
    });
  }

  void editar() {
    if (clienteRepository.indexCliente != null) {
      edicao = true;
      index = clienteRepository.indexCliente;
      _nomeController.text = clienteList[index!].nome;
      _cpfController.text = clienteList.elementAt(index!).cpf;
      _telefoneController.text = clienteList.elementAt(index!).telefone ?? "";
      _emailController.text = clienteList.elementAt(index!).email ?? "";
      _dataNascimentoController.text =
          clienteList.elementAt(index!).dataNascimento ?? "";
      _sexo = clienteList.elementAt(index!).sexo;
      _diabetes = clienteList.elementAt(index!).diabetes;
      _hipertensao = clienteList.elementAt(index!).hipertensao;
      _alergiaController.text = clienteList.elementAt(index!).alergia ?? "";
      _doencaController.text = clienteList.elementAt(index!).doenca ?? "";
      _medicacaoController.text = clienteList.elementAt(index!).medicacao ?? "";
      _procEsteticoController.text =
          clienteList.elementAt(index!).procEstetico ?? "";
      id = clienteList.elementAt(index!).id;
      setState(() {
        title = "Edição de Cadastro";
      });

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
  }

  Future<int> addCliente(Cliente cliente) async {
    return await clienteRepository.salvarClientes(cliente);
  }

  Future<int> updateCliente(Cliente cliente) async {
    return await clienteRepository.atualizarClientes(cliente);
  }

  void resetData() {
    _nomeController.clear();
    _cpfController.clear();
    _emailController.clear();
    _telefoneController.clear();
    _dataNascimentoController.clear();
    _alergiaController.clear();
    _doencaController.clear();
    _medicacaoController.clear();
    _procEsteticoController.clear();
    edicao = false;
  }

  Future<void> salvar() async {
    if (_nomeKey.currentState?.validate() == false ||
        _cpfKey.currentState?.validate() == false ||
        _emailKey.currentState?.validate() == false ||
        _dataNascimentoKey.currentState?.validate() == false) {
      return;
    }
    if (_diabetes == 0 ||
        _hipertensao == 0 ||
        _sexo == 0 ||
        _alergia == 0 ||
        _doenca == 0 ||
        _medicacao == 0 ||
        _procEstetico == 0 ||
        (_alergia == 1 && _alergiaController.text.isEmpty) ||
        (_doenca == 1 && _doencaController.text.isEmpty) ||
        (_medicacao == 1 && _medicacaoController.text.isEmpty) ||
        (_procEstetico == 1 && _procEsteticoController.text.isEmpty)) {
      return;
    }

    if (_alergia == 2) {
      _alergiaController.text = "";
    }
    if (_doenca == 2) {
      _doencaController.text = "";
    }
    if (_medicacao == 2) {
      _medicacaoController.text = "";
    }
    if (_procEstetico == 2) {
      _procEsteticoController.text = "";
    }

    _nomeKey.currentState?.save();
    _cpfKey.currentState?.save();
    _telefoneKey.currentState?.save();
    _emailKey.currentState?.save();
    _dataNascimentoKey.currentState?.save();

    String nome = _nomeController.text;
    String cpf = _cpfController.text;
    String telefone = _telefoneController.text;
    String email = _emailController.text;
    String dataNascimento = _dataNascimentoController.text;
    int sexo = _sexo;
    int diabetes = _diabetes;
    int hipertensao = _hipertensao;
    String alergia = _alergiaController.text;
    String doenca = _doencaController.text;
    String medicacao = _medicacaoController.text;
    String procEstetico = _procEsteticoController.text;

    if (!edicao) {
      Cliente clienteLocal = Cliente(
          nome: nome,
          cpf: cpf,
          telefone: telefone,
          email: email,
          dataNascimento: dataNascimento,
          sexo: sexo,
          diabetes: diabetes,
          hipertensao: hipertensao,
          alergia: alergia,
          doenca: doenca,
          medicacao: medicacao,
          procEstetico: procEstetico);
      await addCliente(clienteLocal);
      setState(() {
        clienteList.add(clienteLocal);
      });
    } else {
      _cliente = Cliente(
          nome: nome,
          cpf: cpf,
          telefone: telefone,
          email: email,
          dataNascimento: dataNascimento,
          sexo: sexo,
          diabetes: diabetes,
          hipertensao: hipertensao,
          alergia: alergia,
          doenca: doenca,
          medicacao: medicacao,
          procEstetico: procEstetico,
          id: id);
      await updateCliente(_cliente);
    }
    resetData();
    setState(() {
      Navigator.popAndPushNamed(context, "/home");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cadastro realizado com sucesso!")));
    });
  }

  @override
  Widget build(BuildContext context) {
    while (fetching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Alert(
                  context: context,
                  type: AlertType.warning,
                  title: "O cadastro não foi salvo",
                  desc: "Deseja sair e descartar as informações?",
                  buttons: [
                    DialogButton(
                      onPressed: () {
                        if (clienteRepository.indexCliente != null) {
                          clienteRepository.indexCliente = null;
                          Navigator.popAndPushNamed(context, "/list");
                        } else {
                          Navigator.popAndPushNamed(context, "/home");
                        }
                      },
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(172, 132, 207, 1),
                        Color.fromRGBO(116, 116, 191, 1.0),
                      ]),
                      child: const Text(
                        "Sair",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    DialogButton(
                      onPressed: () => Navigator.pop(context),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(116, 116, 191, 1.0),
                        Color.fromRGBO(172, 132, 207, 1),
                      ]),
                      child: const Text(
                        "Ficar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ).show();
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
                  //form Nome
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Form(
                    key: _nomeKey,
                    child: TextFormField(
                      controller: _nomeController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Nome Completo",
                        prefixIcon: Icon(Icons.person),
                      ),
                      keyboardType: TextInputType.name,
                      onChanged: (value) => _nomeController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Campo vazio!";
                        } else if (!(value.contains(" "))) {
                          return "Nome incompleto!";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  //form CPF
                  child: Form(
                    key: _cpfKey,
                    child: TextFormField(
                      controller: _cpfController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "CPF",
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CpfInputFormatter()
                      ],
                      onChanged: (value) => _cpfController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Campo vazio!";
                        } else if (value.length != 14) {
                          return "CPF inválido!";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  //form Telefone
                  child: Form(
                    key: _telefoneKey,
                    child: TextFormField(
                      controller: _telefoneController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Telefone",
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter()
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  //form E-mail
                  child: Form(
                    key: _emailKey,
                    child: TextFormField(
                      controller: _emailController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "E-mail",
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,5}))$')
                            .hasMatch(value!) && value.isNotEmpty) {
                          return "E-mail inválido!";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  //form Data de Nascimento
                  child: Form(
                    key: _dataNascimentoKey,
                    child: TextFormField(
                      controller: _dataNascimentoController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Data de Nascimento",
                        prefixIcon: Icon(Icons.date_range_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        DataInputFormatter()
                      ],
                      validator: (value) {
                        if (value!.isNotEmpty && value.length != 10) {
                          return "Data inválida!";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Row(
                  //Form Diabetes
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
                                      onChanged: (value) {
                                        setState(() {
                                          _diabetes = value!;
                                        });
                                      }),
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
                                      onChanged: (value) {
                                        setState(() {
                                          _diabetes = value!;
                                        });
                                      }),
                                ),
                                const Text("Não"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      //Form Hipertensão
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
                                      onChanged: (value) {
                                        setState(() {
                                          _hipertensao = value!;
                                        });
                                      }),
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
                                      onChanged: (value) {
                                        setState(() {
                                          _hipertensao = value!;
                                        });
                                      }),
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
                                      onChanged: (value) {
                                        setState(() {
                                          _sexo = value!;
                                        });
                                      }),
                                ),
                                const Text("Feminino"),
                                Form(
                                  child: Radio(
                                      value: 2,
                                      groupValue: _sexo,
                                      onChanged: (value) {
                                        setState(() {
                                          _sexo = value!;
                                        });
                                      }),
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
                (_alergia == 1)
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
                                            onChanged: (value) {
                                              setState(() {
                                                _alergia = value!;
                                              });
                                            }),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _alergia,
                                            onChanged: (value) {
                                              setState(() {
                                                _alergia = value!;
                                              });
                                            }),
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
                                          key: _alergiaKey,
                                          child: TextFormField(
                                            controller: _alergiaController,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: "Especifique:",
                                              prefixIcon: Icon(
                                                  Icons.border_color_outlined),
                                            ),
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Campo vazio!";
                                              }
                                              return null;
                                            },
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
                                            onChanged: (value) {
                                              setState(() {
                                                _alergia = value!;
                                              });
                                            }),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _alergia,
                                            onChanged: (value) {
                                              setState(() {
                                                _alergia = value!;
                                              });
                                            }),
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
                (_doenca == 1)
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
                                            onChanged: (value) {
                                              setState(() {
                                                _doenca = value!;
                                              });
                                            }),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _doenca,
                                            onChanged: (value) {
                                              setState(() {
                                                _doenca = value!;
                                              });
                                            }),
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
                                          key: _doencaKey,
                                          child: TextFormField(
                                            controller: _doencaController,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: "Especifique:",
                                              prefixIcon: Icon(
                                                  Icons.border_color_outlined),
                                            ),
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Campo vazio!";
                                              }
                                              return null;
                                            },
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
                                            onChanged: (value) {
                                              setState(() {
                                                _doenca = value!;
                                              });
                                            }),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        //key: _doenca,
                                        child: Radio(
                                            value: 2,
                                            groupValue: _doenca,
                                            onChanged: (value) {
                                              setState(() {
                                                _doenca = value!;
                                              });
                                            }),
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
                (_medicacao == 1)
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
                                            onChanged: (value) {
                                              setState(() {
                                                _medicacao = value!;
                                              });
                                            }),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _medicacao,
                                            onChanged: (value) {
                                              setState(() {
                                                _medicacao = value!;
                                              });
                                            }),
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
                                          key: _medicacaoKey,
                                          child: TextFormField(
                                            controller: _medicacaoController,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: "Especifique:",
                                              prefixIcon: Icon(
                                                  Icons.border_color_outlined),
                                            ),
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Campo vazio!";
                                              }
                                              return null;
                                            },
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
                                            onChanged: (value) {
                                              setState(() {
                                                _medicacao = value!;
                                              });
                                            }),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _medicacao,
                                            onChanged: (value) {
                                              setState(() {
                                                _medicacao = value!;
                                              });
                                            }),
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
                                            onChanged: (value) {
                                              setState(() {
                                                _procEstetico = value!;
                                              });
                                            }),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _procEstetico,
                                            onChanged: (value) {
                                              setState(() {
                                                _procEstetico = value!;
                                              });
                                            }),
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
                                          key: _procEsteticoKey,
                                          child: TextFormField(
                                            controller: _procEsteticoController,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: "Especifique:",
                                              prefixIcon: Icon(
                                                  Icons.border_color_outlined),
                                            ),
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Campo vazio!";
                                              }
                                              return null;
                                            },
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
                                            onChanged: (value) {
                                              setState(() {
                                                _procEstetico = value!;
                                              });
                                            }),
                                      ),
                                      const Text("Sim"),
                                      Form(
                                        child: Radio(
                                            value: 2,
                                            groupValue: _procEstetico,
                                            onChanged: (value) {
                                              setState(() {
                                                _procEstetico = value!;
                                              });
                                            }),
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
                  //Botão de salvar
                  margin: const EdgeInsets.fromLTRB(70, 0, 70, 10),
                  child: OutlinedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: salvar,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          //height: 80,
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: const Icon(Icons.search),
                        ),
                        const Text("Salvar Cadastro"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
