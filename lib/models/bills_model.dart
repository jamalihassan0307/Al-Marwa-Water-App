class Bill {
  
  final String salesCode;
  final String siNumber;
  final String date;
  final String customer;
  final String product;
  final String trn;
  final double quantity;
  final bool isCreditBill;
  final String vatValue;
  final double rate;
  final bool isVAT;
  final double total;
  final int? id;

  Bill({
    this.id,
    required this.salesCode,
    required this.siNumber,
    required this.date,
    required this.customer,
    required this.product,
    required this.trn,
    required this.isCreditBill,
    required this.vatValue,
    required this.quantity,
    required this.rate,
    required this.isVAT,
    required this.total,
  });
}
