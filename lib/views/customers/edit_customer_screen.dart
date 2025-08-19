import 'dart:convert';

import 'package:al_marwa_water_app/core/utils/custom_snackbar.dart';
import 'package:al_marwa_water_app/models/customer_type_model.dart';
import 'package:al_marwa_water_app/models/customers_model.dart';
import 'package:al_marwa_water_app/models/pay_type.dart';
import 'package:al_marwa_water_app/routes/app_routes.dart';
import 'package:al_marwa_water_app/viewmodels/auth_controller.dart';
import 'package:al_marwa_water_app/viewmodels/customer_controller.dart';
import 'package:al_marwa_water_app/viewmodels/customer_type_controller.dart';
import 'package:al_marwa_water_app/viewmodels/pay_type_controller.dart';
import 'package:al_marwa_water_app/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class EditCustomerScreen extends StatefulWidget {
  final CustomerData customer;
  const EditCustomerScreen({super.key, required this.customer});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  final TextEditingController customerCodeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController newdateController = TextEditingController();
  final TextEditingController createCustomerController =
      TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController blockController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController mobile1Controller = TextEditingController();
  final TextEditingController mobile2Controller = TextEditingController();
  final TextEditingController bottleController = TextEditingController();
  final TextEditingController depositAmountController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController mobile3Controller = TextEditingController();
  final TextEditingController mobile4Controller = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tradeNameController = TextEditingController();
  final TextEditingController trnNumberController = TextEditingController();
  final TextEditingController authPersonNameController =
      TextEditingController();
  String? _depositPaid;
  String? selectedCustomerType;
  int? selectedCustomerId;
  PayType? selectedPayType;
  int? selectedPayTypeId;
  CustomerTypeModel? selectedCustomerTypeModel;
  String? selectedDeliveryDay;
  String? paymentType;
  String customerCode = '';
  final List<String> customerTypes = [];
  final List<String> deliveryDays = ['Daily', 'Alternate', 'Weekly'];

  PayTypeController? payTypeController;
  CustomersTypeController? customerTypeController;

  bool? isCoupon; // Change to false to disable the button
  final TextEditingController _remarksController = TextEditingController();

  void _showRemarksDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Remarks'),
        content: TextField(
          controller: _remarksController,
          decoration: InputDecoration(hintText: 'Type your remarks here...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              print("Remarks: ${_remarksController.text}");
              _remarksController.clear(); // Optionally clear after submit
            },
            child: Text('Submit'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeForm();

    createCustomerController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now());

    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    // customerCode = generateCustomerCode();
  }

  void formatDate(String format) {
    DateTime selectedDate = DateFormat('dd/MM/yyyy').parse(dateController.text);

    // Convert to ISO string and split
    newdateController.text = selectedDate.toIso8601String().split('T').first;

    print("✅ Final ISO Date: ${newdateController.text}");
  }

  int extractId(String input) {
    final regex = RegExp(r'id:\s*(\d+)');
    final match = regex.firstMatch(input);
    return match != null ? int.parse(match.group(1)!) : -1;
  }

  void initializeForm() {
    final customer = widget.customer;
    customerCodeController.text = customer.customerCode;
    newdateController.text = customer.date;

    createCustomerController.text = customer.date;
    buildingController.text = customer.buildingName;
    blockController.text = customer.blockNo;
    roomController.text = customer.roomNo;
    amountController.text = customer.amount;
    priceController.text = customer.price;
    mobile1Controller.text = customer.phone1;
    mobile2Controller.text = customer.phone2;
    mobile3Controller.text = customer.phone3;
    mobile4Controller.text = customer.phone4;
    emailController.text = customer.email;
    bottleController.text = customer.bottleGiven;
    depositAmountController.text = customer.paidDeposit;
    locationController.text = customer.buildingName;
    tradeNameController.text = customer.tradeName;
    trnNumberController.text = customer.trnNumber;
    authPersonNameController.text = customer.authPersonName;
    print(customer.id);

    // Select dropdown values if needed
    selectedDeliveryDay = customer.deliveryDays;
    _depositPaid = customer.paidDeposit == 'Yes' ? 'Yes' : 'No';
    selectedPayTypeId = extractId(customer.customerPayId.toString());
    selectedPayType = payTypeController?.payTypes.firstWhere(
      (e) => e.id == selectedPayTypeId,
      orElse: () => PayType(id: selectedPayTypeId!),
    );

    selectedCustomerId = extractId(customer.customerType.toString());
    final allCustomerTypes = customerTypeController?.customersTypes ?? [];

    selectedCustomerTypeModel = allCustomerTypes.firstWhere(
      (e) => e.id == selectedCustomerId,
      orElse: () => CustomerTypeModel(id: selectedCustomerId!),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // This will only run once
    if (payTypeController == null) {
      payTypeController = Provider.of<PayTypeController>(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        payTypeController!.fetchPayTypes();
      });
    }
    if (customerTypeController == null) {
      customerTypeController = Provider.of<CustomersTypeController>(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        customerTypeController!.fetchcustomersTypes();
      });
    }
    initializeForm(); // ✅ initialize AFTER fetch
    setState(() {}); // ✅ refresh UI
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final payTypeController = Provider.of<PayTypeController>(context);

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
          icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
        ),
        title: Text(
          'Edit Customer',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                _currentIndex == 0
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: colorScheme.primary,
                          ),
                          color: colorScheme.primary.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Form(
                          key: _formKey1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      "Date :",
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    flex: 3,
                                    child: _buildDateField(context),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Customer Type', textTheme),
                              SizedBox(height: 5),
                              Consumer<CustomersTypeController>(
                                builder: (context, CustomersTypeController, _) {
                                  final customers =
                                      CustomersTypeController.customersTypes;

                                  return DropdownButtonFormField<
                                      CustomerTypeModel>(
                                    style: TextStyle(
                                      color: Colors
                                          .black, // selected item text color
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
                                    hint: Text(
                                      "Select Customer Type",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    isExpanded: true,
                                    value: selectedCustomerTypeModel != null &&
                                            customers.contains(
                                              selectedCustomerTypeModel,
                                            )
                                        ? selectedCustomerTypeModel
                                        : null,
                                    items: customers.map((customer) {
                                      return DropdownMenuItem<
                                          CustomerTypeModel>(
                                        value: customer,
                                        child: Text(customer.name ?? 'Unknown'),
                                      );
                                    }).toList(),
                                    onChanged: (CustomerTypeModel? newValue) {
                                      setState(() {
                                        selectedCustomerTypeModel = newValue;
                                        selectedCustomerId = newValue?.id;

                                        print(
                                          "✅ Selected Customer ID: $selectedCustomerId",
                                        );
                                      });
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Building Name', textTheme),
                              SizedBox(height: 5),
                              _buildTextField(
                                'Enter Customer building Name',
                                controller: buildingController,
                                labelText: 'Building Name',
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 10),
                              _buildLabelRow('Block No', 'Room No', textTheme),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _buildTextField(
                                      nullable: true,
                                      'Enter block no.',
                                      controller: blockController,
                                      labelText: 'Block Number',
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    flex: 2,
                                    child: _buildTextField(
                                      'Enter room no.',
                                      controller: roomController,
                                      labelText: 'Room Number',
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              _buildLabel('Mobile No', textTheme),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _buildTextField(
                                      'Enter number',
                                      controller: mobile1Controller,
                                      keyboardType: TextInputType.phone,
                                      labelText: 'Phone Number',
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    flex: 2,
                                    child: _buildTextField(
                                      nullable: true,
                                      'Enter number',
                                      controller: mobile2Controller,
                                      keyboardType: TextInputType.phone,
                                      labelText: 'Phone Number',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: _buildLabel(
                                      'Delivery Days :',
                                      textTheme,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Flexible(
                                    flex: 3,
                                    child: _buildDropdown(
                                      hint: 'Select',
                                      value: selectedDeliveryDay,
                                      items: deliveryDays,
                                      onChanged: (value) {
                                        setState(
                                          () => selectedDeliveryDay = value,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              payTypeController.payTypeNames.isNotEmpty
                                  ? _buildLabel('Customer Pay', textTheme)
                                  : SizedBox(),
                              SizedBox(height: 10),
                              payTypeController.payTypeNames.isNotEmpty
                                  ? Row(
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children:
                                                payTypeController.payTypes.map((
                                              payType,
                                            ) {
                                              return Expanded(
                                                child: GestureDetector(
                                                  onTap: () => setState(() {
                                                    selectedPayType = payType;
                                                    selectedPayTypeId =
                                                        payType.id;
                                                    if (selectedPayType ==
                                                        "Coupon") {
                                                      isCoupon = true;
                                                    } else {
                                                      isCoupon = false;
                                                    }
                                                    print(
                                                      "✅ Selected Payment Type ID: $selectedPayTypeId",
                                                    );
                                                  }),
                                                  child: Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: [
                                                      Radio<PayType>(
                                                        value: payType,
                                                        groupValue:
                                                            selectedPayType,
                                                        onChanged:
                                                            (PayType? value) {
                                                          setState(() {
                                                            selectedPayType =
                                                                value!;
                                                            selectedPayTypeId =
                                                                value.id;
                                                            if (value.name ==
                                                                "Coupon") {
                                                              isCoupon = true;
                                                            } else {
                                                              isCoupon = false;
                                                            }
                                                            print(
                                                              "✅ Selected Payment Type ID: $selectedPayTypeId",
                                                            );
                                                            print(
                                                              "✅ Selected Payment Type Name: ${selectedPayType!.name}",
                                                            );
                                                          });
                                                        },
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        payType.name ??
                                                            'Unknown',
                                                        style: textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: CustomElevatedButton(
                                            text: "Btn",
                                            buttonColor: isCoupon == true
                                                ? colorScheme.primary
                                                : Colors.grey.shade300,
                                            borderColor: isCoupon == true
                                                ? colorScheme.primary
                                                : Colors.grey.shade400,
                                            textStyle: TextStyle(
                                              color: isCoupon == true
                                                  ? Colors.white
                                                  : Colors.grey[700],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                            ),
                                            onPressed: isCoupon == true
                                                ? () {
                                                    _showRemarksDialog();
                                                    // Implement your coupon logic here
                                                    print(
                                                      "Coupon button pressed",
                                                    );
                                                  }
                                                : () {},
                                          ),
                                        ),
                                      ],
                                    )
                                  : const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              _buildLabelRow(
                                'Bottle Given',
                                'Price',
                                textTheme,
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: _buildTextField(
                                      'Enter',
                                      controller: bottleController,
                                      keyboardType: TextInputType.number,
                                      labelText: 'Bottle Given',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 1,
                                    child: _buildTextField(
                                      '0.0 AED',
                                      controller: priceController,
                                      keyboardType: TextInputType.number,
                                      labelText: 'Price',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Paid Deposit',
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Amount',
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          value: 'Yes',
                                          groupValue: _depositPaid,
                                          onChanged: (value) {
                                            setState(() {
                                              _depositPaid = 'Yes';
                                              print(_depositPaid);
                                            });
                                          },
                                        ),
                                        const Text('Yes'),
                                        Radio<String>(
                                          value: 'No',
                                          groupValue: _depositPaid,
                                          onChanged: (value) {
                                            setState(() {
                                              _depositPaid = "No";
                                              print(_depositPaid);

                                              amountController.clear();
                                            });
                                          },
                                        ),
                                        const Text('No'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 1,
                                    child: _buildTextField(
                                      'AED',
                                      controller: amountController,
                                      labelText: 'Amount',
                                      keyboardType: TextInputType.number,
                                      enabled: _depositPaid == 'Yes',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Location', textTheme),
                              SizedBox(height: 5),
                              _buildTextField(
                                'Location',
                                controller: locationController,
                                labelText: 'Location',
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: colorScheme.primary,
                          ),
                          color: colorScheme.primary.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Form(
                          key: _formKey2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 40),
                              Text(
                                "Authorized Person Name",
                                style: textTheme.titleSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildTextField(
                                nullable: false,
                                'Enter Authorized Person Name',
                                labelText: 'Authorized Person Name',
                                controller: authPersonNameController,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Phone Number 3",
                                          style: textTheme.titleSmall?.copyWith(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        _buildTextField(
                                          nullable: true,
                                          'Enter Phone Number 3',
                                          labelText: 'Phone Number 3',
                                          controller: mobile3Controller,
                                          keyboardType: TextInputType.phone,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Phone Number 4",
                                          style: textTheme.titleSmall?.copyWith(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        _buildTextField(
                                          nullable: true,
                                          'Enter Phone Number 4',
                                          labelText: 'Phone Number 4',
                                          controller: mobile4Controller,
                                          keyboardType: TextInputType.phone,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Email",
                                style: textTheme.titleSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildTextField(
                                nullable: true,
                                'Enter Email',
                                labelText: 'Email',
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "TRN Number",
                                style: textTheme.titleSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildTextField(
                                nullable: true,
                                'Enter TRN Number',
                                labelText: 'TRN Number',
                                controller: trnNumberController,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Trade Name",
                                style: textTheme.titleSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildTextField(
                                nullable: true,
                                'Enter Trade Name',
                                labelText: 'Trade Name',
                                controller: tradeNameController,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
                _currentIndex == 1
                    ? CustomElevatedButton(
                        text: "Save ",
                        onPressed: () async {
                          context.loaderOverlay.show();
                          if (_formKey2.currentState!.validate()) {
                            final controller = Provider.of<CustomerController>(
                              context,
                              listen: false,
                            );
                            final provider = Provider.of<AuthController>(
                              context,
                              listen: false,
                            );
                            formatDate(createCustomerController.text);
                            print(_depositPaid);
                            final updatedData = {
                              "customer_code": customerCodeController.text,
                              "date": newdateController.text,
                              "customer_type":
                                  "${selectedCustomerTypeModel?.id ?? 1}",
                              "building_name": buildingController.text,
                              "block_no": blockController.text,
                              "room_no": roomController.text,
                              "phone1": mobile1Controller.text,
                              "phone2": mobile2Controller.text,
                              "delivery_days": selectedDeliveryDay,
                              "customer_pay_id": "${selectedPayTypeId ?? 1}",
                              "bottle_given": bottleController.text,
                              "price": priceController.text,
                              "paid_deposit": "Yes",
                              "amount": amountController.text.isNotEmpty
                                  ? amountController.text
                                  : "0",
                              "person_name": authPersonNameController.text,
                              "phone3": mobile3Controller.text,
                              "phone4": mobile4Controller.text,
                              "email": emailController.text,
                              "trade_name": tradeNameController.text,
                              "trn_number": trnNumberController.text,
                              "auth_person_name": authPersonNameController.text,
                              "sale_person_id": "${provider.userId}",
                            };

                            updatedData.forEach((key, value) {
                              print(
                                '[log] $key => $value (${value.runtimeType})',
                              );
                            });

                            await controller.updateCustomer(
                              customerId: widget.customer.id,
                              updatedData: updatedData,
                              token:
                                  "${provider.userId}", // Replace with actual token
                              context: context,
                            );
                          } else {
                            showSnackbar(
                              message: "Please fill all required fields",
                              isError: true,
                            );
                          }
                          // saveContact();
                          context.loaderOverlay.hide();
                        },
                      )
                    : CustomElevatedButton(
                        text: "update customer",
                        onPressed: () async {
                          context.loaderOverlay.show();
                          if (_formKey1.currentState!.validate()) {
                            final controller = Provider.of<CustomerController>(
                              context,
                              listen: false,
                            );
                            final provider = Provider.of<AuthController>(
                              context,
                              listen: false,
                            );
                            formatDate(createCustomerController.text);

                            final customerData = {
                              "date": newdateController.text,
                              "customer_type": "$selectedCustomerId",
                              "sale_person_id": "${provider.userId}",
                              "building_name":
                                  buildingController.text.isNotEmpty
                                      ? buildingController.text
                                      : "N/A",
                              "block_no": blockController.text.isNotEmpty
                                  ? blockController.text
                                  : "N/A",
                              "room_no": roomController.text.isNotEmpty
                                  ? roomController.text
                                  : "N/A",
                              "phone1": mobile1Controller.text.isNotEmpty
                                  ? mobile1Controller.text
                                  : "N/A",
                              "phone2": mobile2Controller.text.isNotEmpty
                                  ? mobile2Controller.text
                                  : "N/A",
                              "delivery_days":
                                  selectedDeliveryDay?.isNotEmpty == true
                                      ? selectedDeliveryDay
                                      : "N/A",
                              "customer_pay_id": "$selectedPayTypeId",
                              "bottle_given": bottleController.text.isNotEmpty
                                  ? bottleController.text
                                  : "0",
                              "price": priceController.text.isNotEmpty
                                  ? priceController.text
                                  : "0",
                              "paid_deposit": _depositPaid,
                              "amount": amountController.text.isNotEmpty
                                  ? amountController.text
                                  : "0",
                              "person_name":
                                  authPersonNameController.text.isNotEmpty
                                      ? authPersonNameController.text
                                      : "N/A",
                              "phone3": mobile3Controller.text.isNotEmpty
                                  ? mobile3Controller.text
                                  : "N/A",
                              "phone4": mobile4Controller.text.isNotEmpty
                                  ? mobile4Controller.text
                                  : "N/A",
                              "email": emailController.text.isNotEmpty
                                  ? emailController.text
                                  : "N/A",
                              "trade_name": tradeNameController.text.isNotEmpty
                                  ? tradeNameController.text
                                  : "N/A",
                              "trn_number": trnNumberController.text.isNotEmpty
                                  ? trnNumberController.text
                                  : "N/A",
                            };
                            customerData.forEach((key, value) {
                              print(
                                '[log] $key => $value (${value.runtimeType})',
                              );
                            });
                            print("Customer Data: ${jsonEncode(customerData)}");
                            controller.updateCustomer(
                              context: context,
                              customerId: widget.customer.id,
                              token: provider.token ?? "",
                              updatedData: customerData,
                            );
                          } else {
                            showSnackbar(
                              message: "Please fill all required fields",
                              isError: true,
                            );
                          }

                          context.loaderOverlay.hide();
                        },
                      ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        buttonColor: colorScheme.error,
                        text: "Cancel",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    _currentIndex == 0
                        ? Expanded(
                            child: CustomElevatedButton(
                              text: "Next",
                              onPressed: () {
                                if (_formKey1.currentState!.validate()) {
                                  if (selectedPayTypeId == null) {
                                    showSnackbar(
                                      message: "Please select a payment type",
                                      isError: true,
                                    );
                                  } else {
                                    setState(() {
                                      _currentIndex++;
                                    });
                                  }
                                } else {
                                  showSnackbar(
                                    message: "Please fill all required fields",
                                    isError: true,
                                  );
                                }
                              },
                            ),
                          )
                        : Expanded(
                            child: CustomElevatedButton(
                              text: "Previous",
                              onPressed: () {
                                setState(() {
                                  _currentIndex--;
                                });
                              },
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, TextTheme textTheme) {
    return Text(
      text,
      style: textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }

  Widget _buildLabelRow(String left, String right, TextTheme textTheme) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            left,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Text(
            right,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String hint, {
    TextEditingController? controller,
    bool enabled = true,
    bool nullable = false,
    String? labelText,
    required TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: keyboardType,
      validator: enabled && nullable == false
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }

              // Email validation only if keyboardType is email
              if (keyboardType == TextInputType.emailAddress) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email';
                }
              }

              return null;
            }
          : null,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: labelText ?? hint,
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
    );
  }

  Widget _buildDateField(BuildContext context) {
    if (createCustomerController.text.isEmpty) {
      createCustomerController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.now());
    }

    return SizedBox(
      child: TextFormField(
        controller: createCustomerController,
        readOnly: true,
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
            createCustomerController.text = DateFormat(
              'dd/MM/yyyy',
            ).format(pickedDate);
          }
        },
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
      style: TextStyle(
        color: Colors.black, // selected item text color
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please select $hint';
        }
        return null;
      },
    );
  }
}
