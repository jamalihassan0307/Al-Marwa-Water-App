import 'package:al_marwa_water_app/models/customers_model.dart';
import 'package:al_marwa_water_app/routes/app_routes.dart';
import 'package:al_marwa_water_app/viewmodels/bottle_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerDetailScreen extends StatefulWidget {
  final CustomerData customer;
  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  SaleController? saleController;
  int totalBottles = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (saleController == null) {
      saleController = Provider.of<SaleController>(context);
      saleController!.getSalesByCustomerId(widget.customer.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    saleController = Provider.of<SaleController>(context);
    final sales = saleController?.allSales ?? [];

    // Compute total bottles safely
    totalBottles = sales.fold(0, (sum, item) {
      final qty = int.tryParse(item.quantity.trim()) ?? 0;
      return sum + qty;
    });

    String extractName(String input) {
      final regex = RegExp(r'name:\s*([^\}]+)');
      final match = regex.firstMatch(input);
      return match != null ? match.group(1)?.trim() ?? '' : '';
    }

    print(widget.customer.paidDeposit);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.homeScreen,
                (route) => false,
              );
            },
            icon: Icon(Icons.home, color: Colors.white),
          ),
        ],
        backgroundColor: color.primary,
        title: Text(
          'Customer',
          style: textTheme.titleLarge?.copyWith(color: color.onPrimary),
        ),
        centerTitle: true,
        leading: BackButton(color: color.onPrimary),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("Basic Details", color, textTheme),
                  infoRow(
                    "Customer Code",
                    widget.customer.customerCode,
                    textTheme,
                  ),
                  infoRow(
                    "Type",
                    extractName(widget.customer.customerType),
                    textTheme,
                  ),
                  infoRow(
                    "Customer Pay",
                    extractName(widget.customer.customerPayId),
                    textTheme,
                  ),
                  infoRow("TRN Number", widget.customer.trnNumber, textTheme),
                  const Divider(height: 32),
                  sectionTitle("Personal Details", color, textTheme),
                  infoRow("Person Name", widget.customer.personName, textTheme),
                  infoRow(
                    "Building Name",
                    widget.customer.buildingName,
                    textTheme,
                  ),
                  infoRow("Block No", widget.customer.blockNo, textTheme),
                  infoRow("Room No", widget.customer.roomNo, textTheme),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: contactCard(
                          Icons.call,
                          widget.customer.phone1,
                          color,
                          textTheme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: contactCard(
                          Icons.call,
                          widget.customer.phone2,
                          color,
                          textTheme,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: contactCard(
                          Icons.call,
                          widget.customer.phone3,
                          color,
                          textTheme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: contactCard(
                          Icons.call,
                          widget.customer.phone4,
                          color,
                          textTheme,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  sectionTitle("Added Date", color, textTheme),
                  dateCard(widget.customer.date, color, textTheme),
                  const Divider(height: 32),
                  sectionTitle("Delivery Info", color, textTheme),
                  infoRow(
                    "Bottle Delivery Days",
                    widget.customer.deliveryDays,
                    textTheme,
                  ),
                  infoRow(
                    "Paid Deposit",
                    widget.customer.paidDeposit,
                    textTheme,
                  ),
                  infoRow(
                    "Bottle Given",
                    widget.customer.bottleGiven,
                    textTheme,
                  ),
                  infoRow("Price", widget.customer.price, textTheme),
                  infoRow("Total Amount", widget.customer.amount, textTheme),
                  const Divider(height: 32),
                  sectionTitle("More Details", color, textTheme),
                  infoRow("Phone Number", widget.customer.phone3, textTheme),
                  infoRow("Email", widget.customer.email, textTheme),
                  infoRow("Trade Name", widget.customer.tradeName, textTheme),
                  infoRow(
                    "Authorized Person",
                    widget.customer.authPersonName,
                    textTheme,
                  ),
                  const Divider(height: 32),
                  sectionTitle("Order Details", color, textTheme),
                  (saleController?.allSales.isEmpty ?? true)
                      ? Text(
                          "No sales data available",
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                          ),
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date",
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Bottle Given",
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 0,
                              ),
                              itemBuilder: (context, index) {
                                final bottleData =
                                    saleController?.allSales[index];

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${bottleData?.createdAt.toLocal().toIso8601String().split('T').first}",
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: color.primary,
                                      ),
                                    ),
                                    Text(
                                      (bottleData?.quantity != null &&
                                              int.tryParse(
                                                    bottleData!.quantity
                                                        .toString(),
                                                  ) !=
                                                  null &&
                                              int.tryParse(
                                                    bottleData.quantity
                                                        .toString(),
                                                  )! >
                                                  0)
                                          ? "${bottleData.quantity} Bottles"
                                          : "No bottles",
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: color.primary,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: saleController?.allSales.length ?? 0,
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "$totalBottles",
                                  style: textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                  const SizedBox(height: 35),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.editCustomersScreen,
                          arguments: widget.customer,
                        );
                      },
                      child: Text(
                        "Edit Details",
                        style: textTheme.titleMedium?.copyWith(
                          color: color.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title, ColorScheme color, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          color: color.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget infoRow(String label, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 5,
            child: Text(
              overflow: TextOverflow.ellipsis,
              label,
              style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
          ),
          Spacer(),
          Flexible(
            flex: 6,
            child: Text(
              overflow: TextOverflow.ellipsis,
              value,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget contactCard(
    IconData icon,
    String phone,
    ColorScheme color,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color.primary),
          const SizedBox(height: 6),
          Text(
            phone,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget dateCard(String date, ColorScheme color, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: color.primary, size: 20),
          const SizedBox(width: 10),
          Text(
            date,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
