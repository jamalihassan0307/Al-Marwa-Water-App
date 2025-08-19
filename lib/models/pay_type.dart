class PayType {
  String? name;
  String? status;
  int? id;

  PayType({this.name, this.status, this.id});

  factory PayType.fromJson(Map<String, dynamic> json) {
    return PayType(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }
}
