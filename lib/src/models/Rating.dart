class Rating {

  String documentoID;
  String idCliente;
  int like;
  int dislike;
  int pedidos;

  Rating({
    this.documentoID,
    this.idCliente,
    this.like,
    this.dislike,
    this.pedidos
  });

  Rating.fromJson(Map<String, dynamic> json, String documentoID)
      : documentoID = documentoID,
        idCliente = json['idCliente'], 
        like = json['like'],
        dislike = json['dislike'],
        pedidos = json['pedidos'];

}