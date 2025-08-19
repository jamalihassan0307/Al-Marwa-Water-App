class CreateCreditBillModel {
  final bool status;
  final String message;
  final BillModel data;

  CreateCreditBillModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreateCreditBillModel.fromJson(Map<String, dynamic> json) {
    return CreateCreditBillModel(
      status: json['status'],
      message: json['message'],
      data: BillModel.fromJson(json['data']),
    );
  }
}

class BillModel {
  final String date;
  final int customerId;
  final int productId;
  final String trn;
  final String vat;
  final String quantity;
  final String rate;
  final String amount;
  final String saleUserId;
  final String createdAt;
  final String updatedAt;
  final int id;
  final String salesCode;
  final String srNo;

  BillModel({
    required this.date,
    required this.customerId,
    required this.productId,
    required this.trn,
    required this.vat,
    required this.quantity,
    required this.rate,
    required this.amount,
    required this.saleUserId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.salesCode,
    required this.srNo,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      date: json['date'],
      customerId: json['customer_id'],
      productId: json['product_id'],
      trn: json['trn'],
      vat: json['vat'],
      quantity: json['quantity'],
      rate: json['rate'],
      amount: json['amount'],
      saleUserId: json['sale_user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      id: json['id'],
      salesCode: json['sales_code'],
      srNo: json['sr_no'],
    );
  }
}
