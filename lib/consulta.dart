import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sante/container_all.dart';
import 'package:sante/models/cliente_model.dart';
import 'package:sante/models/picture_model.dart';
import 'package:sante/repositories/cliente_repository.dart';
import 'package:sante/repositories/sessao_repository.dart';
import 'package:sante/repositories/track_screens.dart';
import 'models/consulta_model.dart';
import 'package:path_provider/path_provider.dart';



class Consulta extends StatefulWidget {
  const Consulta({super.key});

  @override
  State<Consulta> createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {
  final _clienteKey = GlobalKey<FormState>();
  final TextEditingController _clienteController = TextEditingController();
  final _dataKey = GlobalKey<FormState>();
  final TextEditingController _dataController = TextEditingController();
  final _valorKey = GlobalKey<FormState>();
  final TextEditingController _valorController = TextEditingController();
  final _pagamentoKey = GlobalKey<FormState>();
  final TextEditingController _pagamentoController = TextEditingController();
  final _observacoesKey = GlobalKey<FormState>();
  final TextEditingController _observacoesController = TextEditingController();
  final _pesoKey = GlobalKey<FormState>();
  final TextEditingController _pesoController = TextEditingController();
  final _alturaKey = GlobalKey<FormState>();
  final TextEditingController _alturaController = TextEditingController();
  final _estomagoKey = GlobalKey<FormState>();
  final TextEditingController _estomagoController = TextEditingController();
  final _cinturaKey = GlobalKey<FormState>();
  final TextEditingController _cinturaController = TextEditingController();
  final _quadrilKey = GlobalKey<FormState>();
  final _quadrilController = TextEditingController();
  final _umbigoKey = GlobalKey<FormState>();
  final TextEditingController _umbigoController = TextEditingController();
  final _queixaKey = GlobalKey<FormState>();
  final TextEditingController _queixaController = TextEditingController();
  final _alimentacaoKey = GlobalKey<FormState>();
  final TextEditingController _alimentacaoController = TextEditingController();
  final _tratamentoKey = GlobalKey<FormState>();
  final TextEditingController _tratamentoController = TextEditingController();
  int _exFisico = 0;
  int _hidratacao = 0;
  late ConsultaRepository consultaRepository;
  late ClienteRepository clienteRepository;
  late TrackScreens tracks;
  late Sessao _consulta;
  bool fetching = true;
  bool edicao = false;
  int? index;
  int? id;
  bool possuiAnexo = false;
  String title = "";
  List<Sessao> consultaList = [];
  List<Cliente> clienteList = [];
  List<String> listaFotosPaths = [];
  
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    clienteRepository = ClienteRepository();
    tracks = TrackScreens();
    clienteRepository.initDB().whenComplete(() async {
      getData();
    });
  }

  void getData() async {
    consultaList = await clienteRepository.recuperarConsultas();
    clienteList = await clienteRepository.recuperarClientes();
    setState(() {
      fetching = false;
      editar();
    });
  }

  buscarDaGaleria() async{
    final images = await ImagePicker.platform.getMultiImageWithOptions();
    if (images.isEmpty) {
      return;
    }

    List<XFile> originalImages = images.map((e) => XFile(e.path)).toList();

    //convertendo de xfile para UInt8List
    List<Uint8List> imgList = [];
    for (var element in originalImages) {
      Uint8List img = await element.readAsBytes();
      imgList.add(img);
    }

    //busca o caminho da pasta do app e constrói o caminho para a pasta a ser criada
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagesPath = '${appDir.path}/imagens'; //caminho da pasta imagens
    //cria a pasta /imagens
    Directory newDir = await Directory(imagesPath).create(recursive: true);

    //Salvar as imagens como UInt8 na pasta /images do app
    for (var i = 0; i < imgList.length; i++) {
      //criar o caminho do arquivo
      File file = File('$imagesPath/foto$i.jpg');
      //escrever o arquivo na pasta
      if(! await file.exists()){   
        file.create(recursive: true); 
      } 
      await file.writeAsBytes(imgList.elementAt(i));
      //Salvar o path das fotos na pasta /imagens no BD
      listaFotosPaths.add('$imagesPath/foto$i.jpg');
    }

  }

  String? procuraNomeCliente(int id) {
    String? nome;
    for (var i = 0; i < clienteList.length; i++) {
      if (clienteList[i].id == id) {
        nome = clienteList[i].nome;
        return nome;
      }
    }
    return nome;
    //Funcionando, mas é uma implementação custosa para uma lista extensa
    //TODO: Refatorar usando uma rawQuery para melhorar performance

    //List resultado = await clienteRepository.db.rawQuery('SELECT nome FROM clientes WHERE id=' [id]); //ta errado
    //resultado.forEach((row) => print(row));
    //return resultado.first; //retorna uma row, por isso da erro
    //return resultado;
  }

  Future<int> addConsulta(Sessao consulta) async {
    return await clienteRepository.salvarConsultas(consulta);
  }

  Future<int> updateConsultas(Sessao consulta) async {
    return await clienteRepository.atualizarConsultas(consulta);
  }

  editar() {
    if (clienteRepository.indexConsulta != null && !fetching) {
      consultaList = tracks.consultasCliente;
      edicao = true;
      setState(() {
        title = "Editar Consulta";
      });
      index = clienteRepository.indexConsulta;
      int idCliente = consultaList[index!].clienteID;
      _clienteController.text =
          procuraNomeCliente(idCliente) ?? ""; //FUNCIONOU (mas mudar dps)
      _dataController.text = consultaList[index!].data;
      if (consultaList[index!].valor == null) {
        _valorController.text = "";
      } else {
        _valorController.text = consultaList[index!].valor.toString();
      }
      _pagamentoController.text =
          consultaList.elementAt(index!).pagamento ?? "";
      _pesoController.text = consultaList[index!].peso ?? "";
      _alturaController.text = consultaList[index!].altura ?? "";
      _estomagoController.text = consultaList[index!].estomago ?? "";
      _cinturaController.text = consultaList[index!].cintura ?? "";
      _quadrilController.text = consultaList[index!].quadril ?? "";
      _umbigoController.text = consultaList[index!].umbigo ?? "";
      _queixaController.text = consultaList[index!].queixa;
      _alimentacaoController.text = consultaList[index!].alimentacao ?? "";
      _tratamentoController.text = consultaList[index!].tratamento ?? "";
      _observacoesController.text = consultaList[index!].observacoes ?? "";
      _exFisico = consultaList[index!].exFisico ?? 0;
      _hidratacao = consultaList[index!].hidratacao ?? 0;
      id = consultaList[index!].id;
    } else {
      setState(() {
        title = "Nova Consulta";
      });
    }
  }

  void resetData() {
    _dataController.clear();
    _valorController.clear();
    _pagamentoController.clear();
    _pesoController.clear();
    _alturaController.clear();
    _estomagoController.clear();
    _cinturaController.clear();
    _quadrilController.clear();
    _umbigoController.clear();
    _umbigoController.clear();
    _queixaController.clear();
    _alimentacaoController.clear();
    _tratamentoController.clear();
    _queixaController.clear();
    _observacoesController.clear();
    _exFisico = 0;
    _hidratacao = 0;
    edicao = false;
    tracks.cliente = null;
    tracks.fromConsulta = false;
    listaFotosPaths.clear();
  }

  Future<void> save() async {
    _dataKey.currentState?.save();
    _valorKey.currentState?.save();
    _pagamentoKey.currentState?.save();
    _pesoKey.currentState?.save();
    _alturaKey.currentState?.save();
    _estomagoKey.currentState?.save();
    _cinturaKey.currentState?.save();
    _quadrilKey.currentState?.save();
    _umbigoKey.currentState?.save();
    _queixaKey.currentState?.save();
    _alimentacaoKey.currentState?.save();
    _tratamentoKey.currentState?.save();
    _observacoesKey.currentState?.save();

    if (_queixaKey.currentState?.validate() == false ||
        _dataKey.currentState?.validate() == false ||
        _exFisico == 0 ||
        _hidratacao == 0 ||
        _clienteController.text.isEmpty) {
      return;
    }

    //Salvar as informações de todos os campos preenchidos
    if (!edicao) {
      Sessao consulta = Sessao(
          data: _dataController.text,
          valor: double.tryParse(_valorController.text),
          pagamento: _pagamentoController.text,
          peso: _pesoController.text,
          altura: _alturaController.text,
          estomago: _estomagoController.text,
          cintura: _cinturaController.text,
          quadril: _quadrilController.text,
          umbigo: _umbigoController.text,
          queixa: _queixaController.text,
          alimentacao: _alimentacaoController.text,
          tratamento: _tratamentoController.text,
          observacoes: _observacoesController.text,
          exFisico: _exFisico,
          hidratacao: _hidratacao,
          clienteID: tracks.cliente!.id!);
      await addConsulta(consulta);
      setState(() {
        consultaList.add(consulta);
      });
    } else {
      _consulta = Sessao(
          data: _dataController.text,
          valor: double.tryParse(_valorController.text),
          pagamento: _pagamentoController.text,
          peso: _pesoController.text,
          altura: _alturaController.text,
          estomago: _estomagoController.text,
          cintura: _cinturaController.text,
          quadril: _quadrilController.text,
          umbigo: _umbigoController.text,
          queixa: _queixaController.text,
          alimentacao: _alimentacaoController.text,
          tratamento: _tratamentoController.text,
          observacoes: _observacoesController.text,
          exFisico: _exFisico,
          hidratacao: _hidratacao,
          clienteID: consultaList[index!].clienteID,
          id: id);
      await updateConsultas(_consulta);
    }

    //TODO: Consertar bug onde as fotos adicionadas na edição de conusltas vão para outro
    //usuário. cadastroView -> consultaView -> consulta (edição)
    //nesse trajeto se perde o ID do cliente atual


    //salva as fotos no banco de dados
    if (listaFotosPaths.isNotEmpty) {
      for (var i = 0; i < listaFotosPaths.length; i++) {
        Picture pic;
        if (consultaList.length == 1){
          pic = Picture(title: "foto $i", path: listaFotosPaths[i], clienteID: tracks.cliente!.id!, consultaID: 1);
        }else{
          //o id é criado pelo BD e não por mim, e neste momento as informações ainda não foram para o BD,
          //então não posso acessar diretamente por id!. Motivo de eu usar (.length-2).id! + 1
          pic = Picture(title: "foto $i", path: listaFotosPaths[i], clienteID: tracks.cliente!.id!, consultaID: consultaList.elementAt(consultaList.length-2).id! + 1);
        }
        clienteRepository.savePicture(pic);
        
      }
      
    }

    if (tracks.fromClienteList) {
      tracks.fromClienteList = false;
    }
    tracks.fromConsulta = false;

    resetData();
    setState(() {
      Navigator.popAndPushNamed(context, "/home");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Sucesso!")));
    });
  }

  @override
  Widget build(BuildContext context) {
    tracks = Provider.of<TrackScreens>(context);

    if (tracks.fromClienteList) {
      //Se vier da lista é pq está escolhendo alguem para nova consulta
      _clienteController.text = tracks.cliente!.nome;
    }

    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.warning,
                title: "A consulta não foi salva",
                desc: "Deseja sair e descartar as informações?",
                buttons: [
                  DialogButton(
                    onPressed: () {
                      if (clienteRepository.indexConsulta != null) {
                        clienteRepository.indexConsulta = null;
                      }
                      tracks.fromClienteList = false;
                      tracks.fromConsulta = false;
                      Navigator.pop(context);
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
              //Navigator.popAndPushNamed(context, '/home');
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
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Form(
                  key: _clienteKey,
                  child: TextFormField(
                    controller: _clienteController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: "Nome do Cliente",
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                    readOnly: edicao ? false : true,
                    onTap: () {
                      if (!edicao) {
                        tracks.fromConsulta = true;
                        Navigator.popAndPushNamed(context, "/list");
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                //form Data da Consulta
                child: Form(
                  key: _dataKey,
                  child: TextFormField(
                    controller: _dataController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: "Data da Consulta",
                      prefixIcon: Icon(Icons.date_range_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty || value.length != 10) {
                        return "Data inválida!";
                      } else {
                        return null;
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      DataInputFormatter(),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        key: _valorKey,
                        child: TextFormField(
                          controller: _valorController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: "Valor",
                            prefixIcon: Icon(Icons.attach_money),
                            prefix: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text("R\$:"),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            RealInputFormatter()
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        key: _pagamentoKey,
                        child: TextFormField(
                          controller: _pagamentoController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: "Pagamento",
                            prefixIcon: Icon(Icons.payment),
                          ),
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form Peso
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        key: _pesoKey,
                        child: TextFormField(
                          controller: _pesoController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: "Peso",
                            prefixIcon: Icon(Icons.scale),
                            suffix: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text('Kg'),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            PesoInputFormatter()
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form Altura
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        key: _alturaKey,
                        child: TextFormField(
                          controller: _alturaController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: "Altura",
                            prefixIcon: Icon(Icons.height),
                            suffix: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text('metros'),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            AlturaInputFormatter()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form Estomago
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        key: _estomagoKey,
                        child: TextFormField(
                          controller: _estomagoController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: "Estômago",
                              prefixIcon: Icon(Icons.compare_arrows_rounded),
                              suffix: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('cm'),
                              )),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form Cintura
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        key: _cinturaKey,
                        child: TextFormField(
                          controller: _cinturaController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: "Cintura",
                              prefixIcon: Icon(Icons.swap_horiz_rounded),
                              suffix: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('cm'),
                              )),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form Quadril
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        key: _quadrilKey,
                        child: TextFormField(
                          controller: _quadrilController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: "Quadril",
                              prefixIcon: Icon(Icons.compare_arrows_rounded),
                              suffix: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('cm'),
                              )),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form Umbigo
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        key: _umbigoKey,
                        child: TextFormField(
                          controller: _umbigoController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: "Umbigo",
                              prefixIcon: Icon(Icons.swap_horiz_rounded),
                              suffix: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('cm'),
                              )),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                //form Queixa Principal
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(7)),
                  child: Form(
                    key: _queixaKey,
                    child: TextFormField(
                      maxLines: null,
                      controller: _queixaController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: "Queixa Principal",
                        prefixIcon: Icon(Icons.mood_bad),
                      ),
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Campo Obrigatório!";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                //form Alimentacao
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(7)),
                  child: Form(
                    key: _alimentacaoKey,
                    child: TextFormField(
                      maxLines: null,
                      controller: _alimentacaoController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: "Alimentação",
                        prefixIcon: Icon(Icons.restaurant_menu_rounded),
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
              ),
              Padding(
                //form Plano de Tratamento
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(7)),
                  child: Form(
                    key: _tratamentoKey,
                    child: TextFormField(
                      maxLines: null,
                      controller: _tratamentoController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: "Plano de Tratamento",
                        prefixIcon: Icon(Icons.my_library_books_outlined),
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
              ),
              Padding(
                //form Observações
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(7)),
                  child: Form(
                    key: _observacoesKey,
                    child: TextFormField(
                      maxLines: null,
                      controller: _observacoesController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: "Informações Adicionais",
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
              ),
              Row(
                //Form Exercicio Físico
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
                              "Pratica atividades físicas regularmente?",
                              style: TextStyle(fontSize: 16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Form(
                                child: Radio(
                                    value: 1,
                                    groupValue: _exFisico,
                                    onChanged: (value) {
                                      setState(() {
                                        _exFisico = value!;
                                      });
                                    }),
                              ),
                              const Text("Sim"),
                              Form(
                                child: Radio(
                                    value: 2,
                                    groupValue: _exFisico,
                                    onChanged: (value) {
                                      setState(() {
                                        _exFisico = value!;
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
                      const Text("Hidratação está adequada?",
                          style: TextStyle(fontSize: 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            child: Radio(
                                value: 1,
                                groupValue: _hidratacao,
                                onChanged: (value) {
                                  setState(() {
                                    _hidratacao = value!;
                                  });
                                }),
                          ),
                          const Text("Sim"),
                          Form(
                            child: Radio(
                                value: 2,
                                groupValue: _hidratacao,
                                onChanged: (value) {
                                  setState(() {
                                    _hidratacao = value!;
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
              Container(
                //Botão de salvar
                margin: const EdgeInsets.fromLTRB(70, 0, 70, 2),
                child: OutlinedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.white)),
                  onPressed: save,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: const Icon(Icons.search),
                      ),
                      const Text("Salvar"),
                    ],
                  ),
                ),
              ),
              Container(
                //Botão de salvar
                margin: const EdgeInsets.fromLTRB(70, 0, 70, 5),
                child: OutlinedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.white)),
                  onPressed: () {
                    buscarDaGaleria();
                    //Navigator.popAndPushNamed(context, "/imagens");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: const Icon(Icons.image_search_rounded),
                      ),
                      const Text("Anexar imagens"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
