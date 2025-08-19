class CustomerTypeModel {
  String? name;
  String? status;
  int? id;

  CustomerTypeModel({this.name, this.status, this.id});

  factory CustomerTypeModel.fromJson(Map<String, dynamic> json) {
    return CustomerTypeModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }
}
