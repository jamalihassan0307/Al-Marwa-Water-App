import 'package:al_marwa_water_app/core/constants/global_variable.dart';
import 'package:al_marwa_water_app/models/bills_model.dart';
import 'package:al_marwa_water_app/models/customers_model.dart';
import 'package:al_marwa_water_app/models/products_model.dart';
import 'package:al_marwa_water_app/routes/app_routes.dart';
import 'package:al_marwa_water_app/viewmodels/auth_controller.dart';
import 'package:al_marwa_water_app/viewmodels/bills_controller.dart';
import 'package:al_marwa_water_app/viewmodels/customer_controller.dart';
import 'package:al_marwa_water_app/viewmodels/products_controller.dart';
import 'package:al_marwa_water_app/viewmodels/vat_controller.dart';
import 'package:al_marwa_water_app/views/bills/widgets/amount_field_widget.dart';
import 'package:al_marwa_water_app/views/bills/widgets/quantity_rate.dart';
import 'package:al_marwa_water_app/widgets/custom_elevated_button.dart';
import 'package:al_marwa_water_app/widgets/custom_textform_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditBillScreen extends StatefulWidget {
  final Bill bill;
  const EditBillScreen({super.key, required this.bill});

  @override
  State<EditBillScreen> createState() => _EditBillScreenState();
}

class _EditBillScreenState extends State<EditBillScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController newdateController = TextEditingController();
  final TextEditingController trnController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController vatController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController rateController = TextEditingController(text: '0');
  bool isVATChecked = true;
  double totalAmount = 0.0;
  int? selectedProductId;
  String selectedProduct = '';
  CustomerController? customerController;
  String? selectedCustomerName;
  int? selectedCustomerId;
  ProductsTypeController? productsTypeController;
  CustomerData? selectedCustomer;
  @override
  void initState() {
    totalAmount = widget.bill.total;
    dateController.text = widget.bill.date;
    newdateController.text = widget.bill.date;
    trnController.text = widget.bill.trn;
    selectedCustomerName = widget.bill.customer;
    selectedProduct = widget.bill.product;
    quantityController.text = widget.bill.quantity.toString();
    rateController.text = widget.bill.rate.toString();
    isVATChecked = widget.bill.isVAT;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController = Provider.of<CustomerController>(
        context,
        listen: false,
      );
      productsTypeController = Provider.of<ProductsTypeController>(
        context,
        listen: false,
      );

      // ✅ Get product id and price from selectedProduct
      final selected = productsTypeController!.ProductTypes.firstWhere(
        (e) => e.name == selectedProduct,
        orElse: () => ProductsModel(price: '0'),
      );
      selectedProductId = selected.id ?? 0;
      rateController.text = selected.price ?? '0';

      quantityController.addListener(_calculateAmount);
      rateController.addListener(_calculateAmount);
      _calculateAmount();

      Future.microtask(() {
        Provider.of<VatProvider>(context, listen: false).fetchVatPercentage();
      });

      final customers = customerController!.customers;
      final match = customers.firstWhere(
        (c) =>
            c.personName == selectedCustomerName ||
            '${c.customerCode}. ${c.personName}' == selectedCustomerName ||
            c.customerCode == selectedCustomerName,
        orElse: () => CustomerData(
          id: -1,
          customerCode: '',
          personName: 'N/A',
          date: '',
          customerType: '',
          buildingName: '',
          blockNo: '',
          roomNo: '',
          phone1: '',
          phone2: '',
          deliveryDays: '',
          customerPayId: '',
          bottleGiven: '',
          price: '',
          paidDeposit: '',
          amount: '',
          phone3: '',
          phone4: '',
          email: '',
          tradeName: '',
          trnNumber: '',
          authPersonName: '',
          salePersonId: 0,
          createdAt: '',
          updatedAt: '',
        ),
      );

      if (match.id != -1) {
        setState(() {
          selectedCustomer = match;
          selectedCustomerId = match.id;
          trnController.text =
              match.trnNumber == "N/A" || match.trnNumber.isEmpty
                  ? ''
                  : match.trnNumber;
        });
      }
    });
  }

  void _calculateAmount() {
    final quantity = double.tryParse(quantityController.text) ?? 0.0;
    final rate = double.tryParse(rateController.text) ?? 0.0;

    final vat = Provider.of<VatProvider>(context, listen: false).vatPercentage;

    double amount = quantity * rate;

    setState(() {
      if (isVATChecked == true) {
        amount += amount * (vat / 100); // Apply VAT as a percentage
      }
      totalAmount = amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final productsTypeController = Provider.of<ProductsTypeController>(context);
    print(widget.bill.isCreditBill);
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: colorScheme(context).onPrimary),
        ),
        title: Text(
          widget.bill.isCreditBill ? 'Edit credit Bill' : 'Edit Bill',
          style: textTheme(context).titleLarge?.copyWith(
                color: colorScheme(context).onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme(context).primary,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: colorScheme(context).primary,
                    ),
                    color: colorScheme(context).primary.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "id : ${widget.bill.id}",
                          style: textTheme(context).titleMedium?.copyWith(
                                color: colorScheme(context).onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        _buildDateField(context),
                        const SizedBox(height: 12),
                        Consumer<CustomerController>(
                          builder: (context, customerController, _) {
                            final allCustomers = customerController.customers;

                            return DropdownSearch<CustomerData>(
                              validator: (CustomerData? customer) {
                                if (customer == null) {
                                  return 'Please select a customer';
                                }
                                return null;
                              },
                              key: ValueKey(allCustomers.length),
                              selectedItem: selectedCustomer,
                              itemAsString: (CustomerData? customer) {
                                if (customer == null) return '';
                                return customer.personName == "N/A"
                                    ? customer.customerCode
                                    : '${customer.customerCode}. ${customer.buildingName} - ${customer.personName} ${customer.roomNo}- ${customer.blockNo}';
                              },
                              asyncItems: (String filter) async {
                                // ✅ Perform live filtering on all 5 fields
                                return allCustomers.where((customer) {
                                  final lowerFilter = filter.toLowerCase();

                                  return customer.customerCode
                                          .toLowerCase()
                                          .contains(lowerFilter) ||
                                      customer.personName
                                          .toLowerCase()
                                          .contains(lowerFilter) ||
                                      customer.buildingName
                                          .toLowerCase()
                                          .contains(lowerFilter) ||
                                      customer.roomNo
                                          .toLowerCase()
                                          .contains(lowerFilter) ||
                                      customer.blockNo
                                          .toLowerCase()
                                          .contains(lowerFilter);
                                }).toList();
                              },
                              onChanged: (CustomerData? newCustomer) {
                                if (newCustomer != null) {
                                  setState(() {
                                    selectedCustomer = newCustomer;
                                    selectedCustomerId = newCustomer.id;
                                    rateController.text =
                                        newCustomer.price == 'N/A'
                                            ? ''
                                            : newCustomer.price;
                                    trnController.text =
                                        newCustomer.trnNumber == 'N/A'
                                            ? ''
                                            : newCustomer.trnNumber;
                                  });
                                }
                              },
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Select Customer",
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(12),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              popupProps: PopupProps.menu(
                                constraints: BoxConstraints(
                                  maxHeight: allCustomers.length == 1
                                      ? 200
                                      : allCustomers.length <= 5
                                          ? allCustomers.length *
                                              60.0 // ≈ height per item
                                          : 500, // max height
                                ),
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: "Type to search...",
                                    contentPadding: const EdgeInsets.all(12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                itemBuilder: (context, item, isSelected) {
                                  final displayText = item.personName == "N/A"
                                      ? item.customerCode
                                      : '${item.customerCode}. ${item.personName}';
                                  return ListTile(
                                    title: Text(displayText),
                                    selected: isSelected,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          hint: 'Select Product',
                          value:
                              productsTypeController.ProductTypeNames.contains(
                            selectedProduct,
                          )
                                  ? selectedProduct
                                  : null,
                          items: productsTypeController.ProductTypeNames.toSet()
                              .toList(), // ✅ ensures unique items
                          onChanged: (value) {
                            setState(() {
                              selectedProduct = value!;

                              final selected = productsTypeController
                                  .ProductTypes.firstWhere(
                                (e) => e.name == selectedProduct,
                                orElse: () => ProductsModel(price: '0'),
                              );

                              rateController.text = selected.price ?? '0';
                              selectedProductId = selected.id ?? 0;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextFormField(
                          controller: trnController,
                          fillColor: Colors.white,
                          hint: 'TRN',
                          filled: true,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: isVATChecked,
                              onChanged: (val) {
                                final vatProvider = Provider.of<VatProvider>(
                                  context,
                                  listen: false,
                                );

                                setState(() {
                                  isVATChecked = val!;
                                  _calculateAmount();

                                  if (isVATChecked) {
                                    vatController.text =
                                        "${vatProvider.vatPercentage}";
                                  } else {
                                    vatController
                                        .clear(); // Optional: clear VAT when unchecked
                                  }
                                });
                              },
                            ),
                            const Text(
                              'VAT',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 12),
                        QuantityRateRow(
                          quantityController: quantityController,
                          rateController: rateController,
                        ),
                        const SizedBox(height: 16),
                        AmountFieldWidget(amount: totalAmount),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final controller = Provider.of<BillController>(
                        context,
                        listen: false,
                      );
                      final provider = Provider.of<AuthController>(
                        context,
                        listen: false,
                      );

                      final updatedData = {
                        "date": dateController.text,
                        "customer_id": "${selectedCustomerId ?? 0}",
                        "product_id": "${selectedProductId ?? 1}",
                        "sale_user_id": provider.userId.toString(),
                        "trn": trnController.text,
                        "vat": isVATChecked == true
                            ? "${vatController.text}%"
                            : "0%",
                        "quantity": quantityController.text,
                        "rate": rateController.text,
                        "amount": totalAmount.toStringAsFixed(2),
                        // "date": "2025-04-30",
                        // "customer_id": "1",
                        // "product_id": "2",
                        // "sale_user_id": "1",
                        // "trn": "TRN123",
                        // "vat": "5%",
                        // "quantity": "10",
                        // "rate": "506",
                        // "amount": "500",
                      };

                      await controller.updateBill(
                        isCredit: widget.bill.isCreditBill,
                        billId: widget.bill.id ?? 0,
                        updatedData: updatedData,
                        token:
                            "${provider.userId}", // Replace with actual token
                        context: context,
                      );
                    }
                  },
                  text: 'Update Bill',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please select a product';
        }
        return null;
      },
      style: TextStyle(
        color: Colors.black, // selected item text color
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
        ),
      ),
      hint: Text(
        hint,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField(BuildContext context) {
    if (dateController.text.isEmpty) {
      dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
    return SizedBox(
      child: TextFormField(
        controller: dateController,
        readOnly: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.calendar_today,
            color: Theme.of(context).colorScheme.primary,
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Select Date',
          hintStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.all(12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
          ),
        ),
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a date';
          }
          return null;
        },
      ),
    );
  }
}
