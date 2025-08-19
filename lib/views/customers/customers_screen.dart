import 'dart:async';
import 'package:al_marwa_water_app/core/constants/app_images.dart';
import 'package:al_marwa_water_app/core/constants/global_variable.dart';
import 'package:al_marwa_water_app/models/customers_model.dart';
import 'package:al_marwa_water_app/routes/app_routes.dart';
import 'package:al_marwa_water_app/viewmodels/customer_controller.dart';
import 'package:al_marwa_water_app/widgets/custom_textform_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  int? currentPage;
  int? lastPage;
  List<int> pages = [];
  bool isLoading = false;
  bool isFirstLoad = true;

  late List<CustomerData> _filterCustomers;
  late CustomerController customersProvider;
  final TextEditingController searchController = TextEditingController();

  // 🔁 Debounce variables
  Timer? _debounce;
  final Duration debounceDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    customersProvider = Provider.of<CustomerController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await customersProvider.fetchCustomersPage(context, search: '');
      setState(() {
        _filterCustomers = customersProvider.customersPagei;
        currentPage = customersProvider.currentPage;
        lastPage = customersProvider.lastPage;
        pages = List.generate(lastPage ?? 1, (index) => index + 1);
        isFirstLoad = false;
      });
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(debounceDuration, () async {
      if (!mounted) return;

      setState(() => isLoading = true);

      await customersProvider.fetchCustomersPage(context,
          search: query, page: 1);

      if (!mounted) return;

      setState(() {
        _filterCustomers = customersProvider.customersPagei;
        currentPage = customersProvider.currentPage;
        lastPage = customersProvider.lastPage;
        pages = List.generate(lastPage ?? 1, (index) => index + 1);
        isLoading = false;
      });
    });
  }

  void _goToPage(int page) async {
    if (page == customersProvider.currentPage || isLoading) return;

    setState(() => isLoading = true);
    await customersProvider.fetchCustomersPage(
      context,
      page: page,
      search: searchController.text,
    );
    setState(() {
      _filterCustomers = customersProvider.customersPagei;
      currentPage = customersProvider.currentPage;
      isLoading = false;
    });
  }

  List<int> getVisiblePages(int currentPage, int lastPage) {
    int start = (currentPage - 3).clamp(1, lastPage);
    int end = (currentPage + 3).clamp(1, lastPage);
    return List.generate(end - start + 1, (index) => start + index);
  }

  @override
  void dispose() {
    _debounce?.cancel(); // ⛔ Cancel debounce timer
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstLoad) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
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
            icon: const Icon(Icons.home, color: Colors.white),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: colorScheme(context).onPrimary),
        ),
        title: Text(
          'Customers',
          style: textTheme(context).titleLarge?.copyWith(
                color: colorScheme(context).onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme(context).primary,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue[900]))
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/back.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomTextFormField(
                      onChanged: _onSearchChanged,
                      controller: searchController,
                      hint: 'Search by name, email, TRN...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  Expanded(
                    child: _filterCustomers.isEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              customersProvider =
                                  Provider.of<CustomerController>(context,
                                      listen: false);

                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                await customersProvider
                                    .fetchCustomersPage(context, search: '');
                                setState(() {
                                  _filterCustomers =
                                      customersProvider.customersPagei;
                                  currentPage = currentPage ??
                                      customersProvider.currentPage;
                                  lastPage = customersProvider.lastPage;
                                  pages = List.generate(
                                      lastPage ?? 1, (index) => index + 1);
                                  isFirstLoad = false;
                                });
                              });
                            },
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                SizedBox(height: 200),
                                Icon(Icons.search_off,
                                    size: 80,
                                    color: colorScheme(context).primary),
                                const SizedBox(height: 16),
                                Center(
                                  child: Text(
                                    'No results found',
                                    style: textTheme(context)
                                        .titleMedium
                                        ?.copyWith(
                                            color: colorScheme(context).primary,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              customersProvider =
                                  Provider.of<CustomerController>(context,
                                      listen: false);
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) async {
                                  await customersProvider
                                      .fetchCustomersPage(context, search: '');
                                  setState(
                                    () {
                                      _filterCustomers =
                                          customersProvider.customersPagei;
                                      currentPage = currentPage ??
                                          customersProvider.currentPage;
                                      lastPage = customersProvider.lastPage;
                                      pages = List.generate(
                                          lastPage ?? 1, (index) => index + 1);
                                      isFirstLoad = false;
                                    },
                                  );
                                },
                              );
                            },
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: _filterCustomers.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              itemBuilder: (context, index) {
                                final customer = _filterCustomers[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.customerDetailScreen,
                                      arguments: customer,
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 28,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                child: ClipOval(
                                                  child: CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        AppImages.appLogo),
                                                    radius: 28,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  // '${customer.id}. ${customer.personName}',
                                                  customer.personName == "N/A"
                                                      ? ' ${customer.customerCode}'
                                                      : '${customer.customerCode}. ${customer.personName}',
                                                  style: textTheme(context)
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 14),
                                          Row(
                                            children: [
                                              const Icon(Icons.email,
                                                  size: 18,
                                                  color: Colors.blueGrey),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  customer.email,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: textTheme(context)
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color:
                                                              Colors.black87),
                                                ),
                                              ),
                                              const Icon(Icons.phone,
                                                  size: 18,
                                                  color: Colors.green),
                                              const SizedBox(width: 4),
                                              Text(
                                                customer.phone1,
                                                style: textTheme(context)
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons
                                                            .confirmation_number,
                                                        size: 18,
                                                        color: Colors.orange),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        'TRN: ${customer.trnNumber}',
                                                        style: textTheme(
                                                                context)
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                color: Colors
                                                                    .black87),
                                                      ),
                                                    ),
                                                    const Icon(Icons.date_range,
                                                        size: 18,
                                                        color: Colors
                                                            .purpleAccent),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      customer.date,
                                                      style: textTheme(context)
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .black87),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.water_drop,
                                                        size: 18,
                                                        color: Colors.blue),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Total Bottles: ${customer.bottleGiven}',
                                                      style: textTheme(context)
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .black87),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.local_shipping,
                                                        size: 18,
                                                        color: Colors.teal),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      customer.deliveryDays,
                                                      style: textTheme(context)
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .black87),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                  _filterCustomers.isEmpty
                      ? SizedBox.shrink()
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                                onPressed: currentPage! > 1
                                    ? () => _goToPage(currentPage! - 1)
                                    : null,
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: currentPage! > 1
                                      ? Colors.blue[900]
                                      : Colors.grey[400],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                      getVisiblePages(currentPage!, lastPage!)
                                          .map((page) {
                                    final bool isCurrent = page == currentPage;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (!isCurrent) _goToPage(page);
                                        },
                                        child: isCurrent
                                            ? CircleAvatar(
                                                backgroundColor:
                                                    Colors.blue[900],
                                                radius: 12,
                                                child: Text(
                                                  '$page',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            : Text(
                                                '$page',
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                                onPressed: currentPage! < lastPage!
                                    ? () => _goToPage(currentPage! + 1)
                                    : null,
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: currentPage! < lastPage!
                                      ? Colors.blue[900]
                                      : Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}
