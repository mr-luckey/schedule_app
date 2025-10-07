import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ListScreen
/// Single-file screen with embedded JSON data (no external assets required).
class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Wedding>> _weddingsFuture;
  final currencyFmt = NumberFormat.currency(
    locale: 'en_GB',
    symbol: '£',
    decimalDigits: 2,
  );
  final dateFmt = DateFormat.yMMMMEEEEd('en_GB');
  Timer? _timer;

  // Put your JSON here — I included the same sample entries used previously.
  static const String _embeddedJson = '''
[
  {
    "coupleNames": "Sarah & Michael Johnson",
    "date": "2025-10-12",
    "time": "18:00 - 23:30",
    "guests": 120,
    "package": "premium",
    "venue": "Royal Gardens Hotel, 45 Park Lane, London",
    "amount": 7963.20,
    "status": "confirmed",
    "contact": "+44 789-123-4567",
    "email": "sarah.johnson@email.com",
    "eventType": "Wedding Reception",
    "paymentMethod": "Bank Transfer",
    "accountManager": "Emma Wilson",
    "reference": "WEDDING-SJ-001",
    "foodItems": [
      {"item": "Chicken Tikka (per person)", "qty": 120, "price": 12.5, "total": 1500.0},
      {"item": "Paneer Tikka (per person)", "qty": 60, "price": 10.0, "total": 600.0}
    ],
    "services": [
      {"service": "Professional Waiter Service (6 hours)", "qty": 6, "rate": 150.0, "amount": 900.0}
    ],
    "pricing": {
      "foodSubtotal": 3900.0,
      "servicesSubtotal": 2620.0,
      "netAmount": 6520.0,
      "serviceCharge": 652.0,
      "discount": -316.0,
      "subtotalAfterDiscount": 6856.0,
      "vat": 1371.2,
      "totalAmount": 7963.2
    }
  },
  {
    "coupleNames": "Emma & James Wilson",
    "date": "2025-09-25",
    "time": "15:00 - 22:00",
    "guests": 85,
    "package": "luxury",
    "venue": "Mansion House, Cotswolds",
    "amount": 12500.0,
    "status": "confirmed",
    "contact": "+44 756-234-5678",
    "email": "emma.wilson@email.com",
    "eventType": "Luxury Wedding",
    "paymentMethod": "Credit Card",
    "accountManager": "James Thompson",
    "reference": "WEDDING-EW-002",
    "foodItems": [
      {"item": "Salmon Fillet (per person)", "qty": 85, "price": 18.5, "total": 1572.5}
    ],
    "services": [
      {"service": "Master Chef Service (8 hours)", "qty": 1, "rate": 800.0, "amount": 800.0}
    ],
    "pricing": {
      "foodSubtotal": 6302.5,
      "servicesSubtotal": 4265.0,
      "netAmount": 10567.5,
      "serviceCharge": 1056.75,
      "discount": -528.38,
      "subtotalAfterDiscount": 11096.87,
      "vat": 1403.13,
      "totalAmount": 12500.0
    }
  },
  {
    "coupleNames": "Olivia & David Thompson",
    "date": "2025-09-28",
    "time": "16:30 - 23:00",
    "guests": 95,
    "package": "premium",
    "venue": "Riverside Manor, Bath",
    "amount": 8750.5,
    "status": "pending",
    "contact": "+44 787-345-6789",
    "email": "olivia.thompson@email.com",
    "eventType": "Garden Wedding",
    "paymentMethod": "Bank Transfer",
    "accountManager": "Sophie Clarke",
    "reference": "WEDDING-OT-003",
    "foodItems": [
      {"item": "Roasted Chicken (per person)", "qty": 95, "price": 14.0, "total": 1330.0}
    ],
    "services": [
      {"service": "Professional Catering Staff (7 hours)", "qty": 6, "rate": 160.0, "amount": 960.0}
    ],
    "pricing": {
      "foodSubtotal": 2852.5,
      "servicesSubtotal": 2200.0,
      "netAmount": 5052.5,
      "serviceCharge": 505.25,
      "discount": -252.63,
      "subtotalAfterDiscount": 5305.12,
      "vat": 1061.02,
      "totalAmount": 8750.5
    }
  }
]
''';

  @override
  void initState() {
    super.initState();
    _weddingsFuture = _loadWeddingsFromEmbeddedJson();
    // refresh highlight state occasionally
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<List<Wedding>> _loadWeddingsFromEmbeddedJson() async {
    await Future.delayed(const Duration(milliseconds: 100)); // tiny async gap
    final decoded = jsonDecode(_embeddedJson);
    if (decoded is List) {
      final list = decoded
          .map((e) => Wedding.fromJson(e as Map<String, dynamic>))
          .toList();
      list.sort((a, b) => a.date.compareTo(b.date));
      return list;
    } else {
      return [];
    }
  }

  bool isUpcomingWedding(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    return diff >= 0 && diff <= 7;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Schedule'),
        backgroundColor: const Color(0xFF10B981),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF5F7FA),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: FutureBuilder<List<Wedding>>(
              future: _weddingsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final weddings = snapshot.data!;
                final totalBookings = weddings.length;
                final upcomingCount = weddings
                    .where((w) => isUpcomingWedding(w.date))
                    .length;
                final totalGuests = weddings.fold<int>(
                  0,
                  (s, w) => s + w.guests,
                );
                final totalRevenue = weddings.fold<double>(
                  0.0,
                  (s, w) => s + w.amount,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Booking Schedule',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Wedding Management System',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // stats
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _statCard('$totalBookings', 'Total Bookings'),
                        _statCard('$upcomingCount', 'Upcoming This Week'),
                        _statCard(
                          NumberFormat.decimalPattern().format(totalGuests),
                          'Total Guests',
                        ),
                        _statCard(
                          currencyFmt.format(totalRevenue),
                          'Total Revenue',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // table container
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            // header row
                            Container(
                              color: const Color(0xFFF8FAFB),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 14,
                              ),
                              child: Row(
                                children: const [
                                  Expanded(
                                    flex: 20,
                                    child: Text(
                                      'Couple Names',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 18,
                                    child: Text(
                                      'Wedding Date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Center(
                                      child: Text(
                                        'Guests',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 12,
                                    child: Center(
                                      child: Text(
                                        'Package',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 25,
                                    child: Text(
                                      'Venue',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'Amount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Center(
                                      child: Text(
                                        'Status',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            Expanded(
                              child: Scrollbar(
                                thumbVisibility: true,
                                child: ListView.separated(
                                  itemCount: weddings.length,
                                  separatorBuilder: (_, __) => const Divider(
                                    height: 1,
                                    color: Color(0xFFF1F3F5),
                                  ),
                                  itemBuilder: (context, index) {
                                    final w = weddings[index];
                                    final upcoming = isUpcomingWedding(w.date);
                                    return Material(
                                      color: upcoming
                                          ? const Color(0xFFD1FAE5)
                                          : Colors.white,
                                      child: InkWell(
                                        onTap: () =>
                                            _openWeddingDetail(context, w),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 14,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 20,
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        w.coupleNames,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    if (upcoming) ...[
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: const Color(
                                                            0xFF10B981,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4,
                                                              ),
                                                        ),
                                                        child: const Text(
                                                          'Urgent',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 18,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      dateFmt.format(w.date),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      w.time,
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Center(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF10B981,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '${w.guests}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 12,
                                                child: Center(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      color: _packageBgColor(
                                                        w.package,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      w.package.toUpperCase(),
                                                      style: TextStyle(
                                                        color:
                                                            _packageTextColor(
                                                              w.package,
                                                            ),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 25,
                                                child: Text(
                                                  w.venue,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    currencyFmt.format(
                                                      w.amount,
                                                    ),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Center(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      color: _statusBgColor(
                                                        w.status,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      w.status.toUpperCase(),
                                                      style: TextStyle(
                                                        color: _statusTextColor(
                                                          w.status,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
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
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // legend
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Wrap(
                        spacing: 24,
                        runSpacing: 12,
                        children: [
                          _legendItem(
                            const Color(0xFFD1FAE5),
                            'Urgent: Wedding within 7 days',
                            borderColor: const Color(0xFF10B981),
                          ),
                          _legendItem(
                            Colors.white,
                            'Regular Bookings',
                            borderColor: const Color(0xFFCBD5E0),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(
    Color bg,
    String text, {
    Color borderColor = Colors.black,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A5568),
          ),
        ),
      ],
    );
  }

  static Color _packageBgColor(String p) {
    switch (p.toLowerCase()) {
      case 'premium':
        return const Color(0xFFD1FAE5);
      case 'luxury':
        return const Color(0xFFDDD6FE);
      case 'classic':
      default:
        return const Color(0xFFBFDBFE);
    }
  }

  static Color _packageTextColor(String p) {
    switch (p.toLowerCase()) {
      case 'premium':
        return const Color(0xFF065F46);
      case 'luxury':
        return const Color(0xFF5B21B6);
      case 'classic':
      default:
        return const Color(0xFF1E40AF);
    }
  }

  static Color _statusBgColor(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFFD1FAE5);
      case 'pending':
        return const Color(0xFFFED7AA);
      case 'cancelled':
        return const Color(0xFFFECACA);
      default:
        return Colors.grey.shade200;
    }
  }

  static Color _statusTextColor(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF065F46);
      case 'pending':
        return const Color(0xFF92400E);
      case 'cancelled':
        return const Color(0xFF991B1B);
      default:
        return Colors.black;
    }
  }

  void _openWeddingDetail(BuildContext context, Wedding w) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => WeddingDetailPage(wedding: w)));
  }
}

// Detail page

class WeddingDetailPage extends StatelessWidget {
  final Wedding wedding;
  WeddingDetailPage({Key? key, required this.wedding}) : super(key: key);

  final currencyFmt = NumberFormat.currency(
    locale: 'en_GB',
    symbol: '£',
    decimalDigits: 2,
  );
  final dateFmt = DateFormat.yMMMMEEEEd('en_GB');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wedding.coupleNames),
        backgroundColor: const Color(0xFF10B981),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wedding.eventType,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text('${dateFmt.format(wedding.date)} • ${wedding.time}'),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _infoCard('Couple Names', wedding.coupleNames),
                  _infoCard('Event Date', dateFmt.format(wedding.date)),
                  _infoCard('Time', wedding.time),
                  _infoCard('Guests', '${wedding.guests} persons'),
                  _infoCard('Package', wedding.package.toUpperCase()),
                  _infoCard('Venue', wedding.venue),
                  _infoCard('Contact', wedding.contact),
                  _infoCard('Email', wedding.email),
                  _infoCard('Reference', wedding.reference),
                  _infoCard('Account Manager', wedding.accountManager),
                  _infoCard('Payment Method', wedding.paymentMethod),
                  _infoCard('Status', wedding.status.toUpperCase()),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Food Menu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _itemsTable(
                columns: const ['Item', 'Quantity', 'Unit Price', 'Total'],
                rows: wedding.foodItems
                    .map(
                      (f) => [
                        f.item,
                        '${f.qty}',
                        currencyFmt.format(f.price),
                        currencyFmt.format(f.total),
                      ],
                    )
                    .toList(),
              ),

              const SizedBox(height: 18),

              const Text(
                'Additional Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _itemsTable(
                columns: const ['Service', 'Quantity', 'Rate', 'Amount'],
                rows: wedding.services
                    .map(
                      (s) => [
                        s.service,
                        '${s.qty}',
                        currencyFmt.format(s.rate),
                        currencyFmt.format(s.amount),
                      ],
                    )
                    .toList(),
              ),

              const SizedBox(height: 18),

              const Text(
                'Pricing Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _priceRow(
                      'Food Items Subtotal',
                      wedding.pricing.foodSubtotal,
                    ),
                    _priceRow(
                      'Services Subtotal',
                      wedding.pricing.servicesSubtotal,
                    ),
                    _priceRow('Net Amount', wedding.pricing.netAmount),
                    _priceRow(
                      'Service Charge (10%)',
                      wedding.pricing.serviceCharge,
                    ),
                    _priceRow(
                      'Early Booking Discount (5%)',
                      wedding.pricing.discount,
                    ),
                    _priceRow(
                      'Subtotal after Discount',
                      wedding.pricing.subtotalAfterDiscount,
                    ),
                    _priceRow('VAT @ 20%', wedding.pricing.vat),
                    const Divider(),
                    _priceRow(
                      'TOTAL AMOUNT',
                      wedding.pricing.totalAmount,
                      emphasize: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD1FAE5), Color(0xFFA7F3D0)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF10B981)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Received',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF065F46),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Payment Amount (£)',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Payment Type',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'second',
                                child: Text('Second Payment'),
                              ),
                              DropdownMenuItem(
                                value: 'intermediate',
                                child: Text('Intermediate Payment'),
                              ),
                              DropdownMenuItem(
                                value: 'final',
                                child: Text('Final Payment'),
                              ),
                            ],
                            onChanged: (_) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _itemsTable({
    required List<String> columns,
    required List<List<String>> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            color: const Color(0xFFF8FAFB),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: columns
                  .map(
                    (c) => Expanded(
                      child: Text(
                        c,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const Divider(height: 1),
          ...rows
              .map(
                (r) => Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: r.map((c) => Expanded(child: Text(c))).toList(),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool emphasize = false}) {
    final style = emphasize
        ? const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF10B981),
          )
        : const TextStyle(fontSize: 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(currencyFmt.format(value), style: style),
        ],
      ),
    );
  }
}

// Models and JSON parsing

class Wedding {
  final String coupleNames;
  final DateTime date;
  final String time;
  final int guests;
  final String package;
  final String venue;
  final double amount;
  final String status;
  final String contact;
  final String email;
  final String eventType;
  final String paymentMethod;
  final String accountManager;
  final String reference;
  final List<FoodItem> foodItems;
  final List<ServiceItem> services;
  final Pricing pricing;

  Wedding({
    required this.coupleNames,
    required this.date,
    required this.time,
    required this.guests,
    required this.package,
    required this.venue,
    required this.amount,
    required this.status,
    required this.contact,
    required this.email,
    required this.eventType,
    required this.paymentMethod,
    required this.accountManager,
    required this.reference,
    required this.foodItems,
    required this.services,
    required this.pricing,
  });

  factory Wedding.fromJson(Map<String, dynamic> j) {
    DateTime parsedDate;
    final dateRaw = j['date'] ?? j['event_date'] ?? '';
    if (dateRaw is String && dateRaw.isNotEmpty) {
      parsedDate = DateTime.parse(dateRaw);
    } else if (j['date_ms'] != null) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(j['date_ms']);
    } else {
      parsedDate = DateTime.now();
    }

    return Wedding(
      coupleNames: j['coupleNames'] ?? j['couple_names'] ?? '',
      date: parsedDate,
      time: j['time'] ?? '',
      guests: (j['guests'] is int)
          ? j['guests']
          : int.tryParse('${j['guests']}') ?? 0,
      package: j['package'] ?? 'classic',
      venue: j['venue'] ?? '',
      amount: (j['amount'] is num)
          ? (j['amount'] as num).toDouble()
          : double.tryParse('${j['amount']}') ?? 0.0,
      status: j['status'] ?? 'pending',
      contact: j['contact'] ?? '',
      email: j['email'] ?? '',
      eventType: j['eventType'] ?? j['event_type'] ?? '',
      paymentMethod: j['paymentMethod'] ?? '',
      accountManager: j['accountManager'] ?? '',
      reference: j['reference'] ?? '',
      foodItems:
          (j['foodItems'] as List<dynamic>?)
              ?.map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      services:
          (j['services'] as List<dynamic>?)
              ?.map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pricing: Pricing.fromJson(
        j['pricing'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }
}

class FoodItem {
  final String item;
  final int qty;
  final double price;
  final double total;
  FoodItem({
    required this.item,
    required this.qty,
    required this.price,
    required this.total,
  });

  factory FoodItem.fromJson(Map<String, dynamic> j) {
    return FoodItem(
      item: j['item'] ?? '',
      qty: (j['qty'] is int) ? j['qty'] : int.tryParse('${j['qty']}') ?? 0,
      price: (j['price'] is num)
          ? (j['price'] as num).toDouble()
          : double.tryParse('${j['price']}') ?? 0.0,
      total: (j['total'] is num)
          ? (j['total'] as num).toDouble()
          : double.tryParse('${j['total']}') ?? 0.0,
    );
  }
}

class ServiceItem {
  final String service;
  final int qty;
  final double rate;
  final double amount;
  ServiceItem({
    required this.service,
    required this.qty,
    required this.rate,
    required this.amount,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> j) {
    return ServiceItem(
      service: j['service'] ?? '',
      qty: (j['qty'] is int) ? j['qty'] : int.tryParse('${j['qty']}') ?? 0,
      rate: (j['rate'] is num)
          ? (j['rate'] as num).toDouble()
          : double.tryParse('${j['rate']}') ?? 0.0,
      amount: (j['amount'] is num)
          ? (j['amount'] as num).toDouble()
          : double.tryParse('${j['amount']}') ?? 0.0,
    );
  }
}

class Pricing {
  final double foodSubtotal;
  final double servicesSubtotal;
  final double netAmount;
  final double serviceCharge;
  final double discount;
  final double subtotalAfterDiscount;
  final double vat;
  final double totalAmount;

  Pricing({
    required this.foodSubtotal,
    required this.servicesSubtotal,
    required this.netAmount,
    required this.serviceCharge,
    required this.discount,
    required this.subtotalAfterDiscount,
    required this.vat,
    required this.totalAmount,
  });

  factory Pricing.fromJson(Map<String, dynamic> j) {
    double p(String key) {
      final v = j[key];
      if (v is num) return v.toDouble();
      return double.tryParse('${v ?? 0}') ?? 0.0;
    }

    return Pricing(
      foodSubtotal: p('foodSubtotal'),
      servicesSubtotal: p('servicesSubtotal'),
      netAmount: p('netAmount'),
      serviceCharge: p('serviceCharge'),
      discount: p('discount'),
      subtotalAfterDiscount: p('subtotalAfterDiscount'),
      vat: p('vat'),
      totalAmount: p('totalAmount'),
    );
  }
}
