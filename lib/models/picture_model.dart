class Picture {
 int? id;
 String title;
 String path;
 int clienteID;
 int consultaID;

 Picture({this.id, required this.title, required this.path, required this.clienteID, required this.consultaID});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'path': path,
      'clienteID': clienteID,
      'consultaID': consultaID,
    };
  }

  Picture.fromMap(Map<String, dynamic> res)
      : id = res["id"],
      title = res["title"],
      path = res["path"],
      clienteID = res["clienteID"],
      consultaID = res["consultaID"];
}