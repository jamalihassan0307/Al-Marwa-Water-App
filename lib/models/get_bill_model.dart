class PaginatedBills {
  final List<GetBillItem> bills;
  final int currentPage;
  final int lastPage;
  final String? nextPageUrl;

  PaginatedBills({
    required this.bills,
    required this.currentPage,
    required this.lastPage,
    required this.nextPageUrl,
  });
}

class BillModel {
  final bool status;
  final String message;
  final GetBillItem data;

  BillModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      status: json['status'],
      message: json['message'],
      data: GetBillItem.fromJson(json['data']),
    );
  }
}

class GetBillListModel {
  final bool status;
  final List<GetBillItem> data;

  GetBillListModel({
    required this.status,
    required this.data,
  });

  factory GetBillListModel.fromJson(Map<String, dynamic> json) {
    return GetBillListModel(
      status: json['status'],
      data: List<GetBillItem>.from(
        json['data'].map((item) => GetBillItem.fromJson(item)),
      ),
    );
  }
}

class GetBillItem {
  final int id;
  final String salesCode;
  final String srNo;
  final String date;
  final int customerId;
  final String customerName;
  final int productId;
  final String productName;
  final String trn;
  final String vat;
  final String quantity;
  final String rate;
  final String amount;
  final int saleUserId;
  final String createdAt;
  final String updatedAt;

  GetBillItem({
    required this.id,
    required this.salesCode,
    required this.srNo,
    required this.date,
    required this.customerId,
    required this.customerName,
    required this.productId,
    required this.productName,
    required this.trn,
    required this.vat,
    required this.quantity,
    required this.rate,
    required this.amount,
    required this.saleUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetBillItem.fromJson(Map<String, dynamic> json) {
    return GetBillItem(
      id: json['id'],
      salesCode: json['sales_code'],
      srNo: json['sr_no'],
      date: json['date'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      productId: json['product_id'],
      productName: json['product_name'],
      trn: json['trn'],
      vat: json['vat'],
      quantity: json['quantity'],
      rate: json['rate'],
      amount: json['amount'],
      saleUserId: json['sale_user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
