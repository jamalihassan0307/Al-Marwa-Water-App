class PaginatedCreditBills {
  final List<GetCreditBillItem> bills;
  final int currentPage;
  final int lastPage;
  final String? nextPageUrl;

  PaginatedCreditBills({
    required this.bills,
    required this.currentPage,
    required this.lastPage,
    required this.nextPageUrl,
  });
}

class BillCreditModel {
  final bool status;
  final String message;
  final GetCreditBillItem data;

  BillCreditModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BillCreditModel.fromJson(Map<String, dynamic> json) {
    return BillCreditModel(
      status: json['status'],
      message: json['message'],
      data: GetCreditBillItem.fromJson(json['data']),
    );
  }
}

class GetCreditBillListModel {
  final bool status;
  final List<GetCreditBillItem> data;

  GetCreditBillListModel({
    required this.status,
    required this.data,
  });

  factory GetCreditBillListModel.fromJson(Map<String, dynamic> json) {
    return GetCreditBillListModel(
      status: json['status'],
      data: List<GetCreditBillItem>.from(
        json['data'].map((item) => GetCreditBillItem.fromJson(item)),
      ),
    );
  }
}

class GetCreditBillItem {
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

  GetCreditBillItem({
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

  factory GetCreditBillItem.fromJson(Map<String, dynamic> json) {
    return GetCreditBillItem(
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
