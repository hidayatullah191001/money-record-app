class History {
  String? idHistory;
  String? idUser;
  String? type;
  String? date;
  String? total;
  String? details;
  String? createdAt;
  String? updatedAt;

  History(
      {this.idHistory,
      this.idUser,
      this.type,
      this.date,
      this.total,
      this.details,
      this.createdAt,
      this.updatedAt});

  History.fromJson(Map<String, dynamic> json) {
    idHistory = json['id_history'];
    idUser = json['id_user'];
    type = json['type'];
    date = json['date'];
    total = json['total'];
    details = json['details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_history'] = this.idHistory;
    data['id_user'] = this.idUser;
    data['type'] = this.type;
    data['date'] = this.date;
    data['total'] = this.total;
    data['detail'] = this.details;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
