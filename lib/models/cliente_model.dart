import '../consulta.dart';

class Cliente {
  //Campos base, que não são alterados em toda nova consulta
  List<Consulta> consultas = [];
  int? id;
  String nome;
  String cpf;
  String? telefone;
  String? email;
  String? dataNascimento;
  int sexo;
  int diabetes;
  int hipertensao;
  String? alergia;
  String? doenca;
  String? medicacao;
  String? procEstetico;

  Cliente({
    this.id,
    //required this.consultas,
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.email,
    required this.dataNascimento,
    required this.sexo,
    required this.diabetes,
    required this.hipertensao,
    required this.alergia,
    required this.doenca,
    required this.medicacao,
    required this.procEstetico,
  });

  Cliente.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        //consultas = res["consultas"],
        nome = res["nome"],
        cpf = res["cpf"],
        telefone = res["telefone"],
        email = res["email"],
        dataNascimento = res["dataNascimento"],
        sexo = res["sexo"],
        diabetes = res["diabetes"],
        hipertensao = res["hipertensao"],
        alergia = res["alergia"],
        doenca = res["doenca"],
        medicacao = res["medicacao"],
        procEstetico = res["procEstetico"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      //'consultas': consultas,
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'email': email,
      'dataNascimento': dataNascimento,
      'sexo': sexo,
      'diabetes': diabetes,
      'hipertensao': hipertensao,
      'alergia': alergia,
      'doenca': doenca,
      'medicacao': medicacao,
      'procEstetico': procEstetico,
    };
  }
}
