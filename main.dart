import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Peyman3DApp());
}

const Color brandOrange = Color(0xFFFF7A00);
const Color pageBlack = Color(0xFF101010);
const Color cardBlack = Color(0xFF1C1C1C);

class Peyman3DApp extends StatelessWidget {
  const Peyman3DApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PEYMAN3D',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: pageBlack,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandOrange,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: pageBlack,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardBlack,
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: brandOrange, width: 1.5),
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class PrintOrder {
  final String id;
  final String customer;
  final String partName;
  final String filament;
  final double weight;
  final double hours;
  final double materialCost;
  final double electricityCost;
  final double depreciationCost;
  final double paintingCost;
  final double baseCost;
  final double profit;
  final double finalPrice;
  final DateTime createdAt;

  const PrintOrder({
    required this.id,
    required this.customer,
    required this.partName,
    required this.filament,
    required this.weight,
    required this.hours,
    required this.materialCost,
    required this.electricityCost,
    required this.depreciationCost,
    required this.paintingCost,
    required this.baseCost,
    required this.profit,
    required this.finalPrice,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'customer': customer, 'partName': partName,
    'filament': filament, 'weight': weight, 'hours': hours,
    'materialCost': materialCost, 'electricityCost': electricityCost,
    'depreciationCost': depreciationCost, 'paintingCost': paintingCost,
    'baseCost': baseCost, 'profit': profit, 'finalPrice': finalPrice,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PrintOrder.fromJson(Map<String, dynamic> j) => PrintOrder(
    id: j['id'] ?? '',
    customer: j['customer'] ?? '',
    partName: j['partName'] ?? '',
    filament: j['filament'] ?? 'PLA',
    weight: (j['weight'] as num? ?? 0).toDouble(),
    hours: (j['hours'] as num? ?? 0).toDouble(),
    materialCost: (j['materialCost'] as num? ?? 0).toDouble(),
    electricityCost: (j['electricityCost'] as num? ?? 0).toDouble(),
    depreciationCost: (j['depreciationCost'] as num? ?? 0).toDouble(),
    paintingCost: (j['paintingCost'] as num? ?? 0).toDouble(),
    baseCost: (j['baseCost'] as num? ?? 0).toDouble(),
    profit: (j['profit'] as num? ?? 0).toDouble(),
    finalPrice: (j['finalPrice'] as num? ?? 0).toDouble(),
    createdAt: DateTime.tryParse(j['createdAt'] ?? '') ?? DateTime.now(),
  );
}

class OrderStore {
  static const String _key = 'peyman3d_orders_v1';

  static Future<List<PrintOrder>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => PrintOrder.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(PrintOrder order) async {
    final orders = await load();
    orders.insert(0, order);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(orders.map((e) => e.toJson()).toList()));
  }

  static Future<void> delete(String id) async {
    final orders = await load();
    orders.removeWhere((e) => e.id == id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(orders.map((e) => e.toJson()).toList()));
  }
}

String money(num value) {
  final rounded = value.round().toString();
  final out = StringBuffer();
  for (int i = 0; i < rounded.length; i++) {
    out.write(rounded[i]);
    final remaining = rounded.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) out.write(',');
  }
  return '${out.toString()} تومان';
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PEYMAN3D', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
        actions: [
          IconButton(
            tooltip: 'سوابق',
            icon: const Icon(Icons.history, color: brandOrange),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage())),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF33200F), Color(0xFF1B1B1B)],
                  begin: Alignment.topRight, end: Alignment.bottomLeft,
                ),
                border: Border.all(color: brandOrange.withOpacity(.45)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.view_in_ar, color: brandOrange, size: 52),
                  SizedBox(height: 18),
                  Text('چاپ سه‌بعدی، با قیمت‌گذاری دقیق', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('محاسبه هزینه و قیمت فروش قطعات چاپی با پرینتر Ender 3', style: TextStyle(color: Colors.white70, height: 1.6)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _HomeTile(
              icon: Icons.calculate_outlined,
              title: 'محاسبه هزینه چاپ',
              subtitle: 'فیلامنت، زمان، برق و استهلاک',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculatorPage())),
            ),
            const SizedBox(height: 12),
            _HomeTile(
              icon: Icons.receipt_long_outlined,
              title: 'سوابق محاسبات',
              subtitle: 'سفارش‌های ذخیره‌شده و گزارش قیمت',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage())),
            ),
            const SizedBox(height: 24),
            const Text('نسخه ۱.۰ • ذخیره‌سازی داخل گوشی', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38)),
          ],
        ),
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _HomeTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardBlack,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        leading: CircleAvatar(backgroundColor: brandOrange.withOpacity(.15), child: Icon(icon, color: brandOrange)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(padding: const EdgeInsets.only(top: 5), child: Text(subtitle)),
        trailing: const Icon(Icons.chevron_left, color: brandOrange),
        onTap: onTap,
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _customer = TextEditingController();
  final _part = TextEditingController();
  final _weight = TextEditingController(text: '50');
  final _hours = TextEditingController(text: '2');
  final _minutes = TextEditingController(text: '0');
  final _spoolPrice = TextEditingController(text: '600000');
  final _power = TextEditingController(text: '120');
  final _electricRate = TextEditingController(text: '3000');
  final _depreciationRate = TextEditingController(text: '10000');
  final _painting = TextEditingController(text: '0');
  final _profit = TextEditingController(text: '30');

  String _filament = 'PLA';
  bool _profitIsPercent = true;
  double _num(TextEditingController c) => double.tryParse(c.text.trim().replaceAll(',', '.')) ?? 0;
  double get _totalHours => _num(_hours) + _num(_minutes) / 60;
  double get _material => _num(_weight) * (_num(_spoolPrice) / 1000);
  double get _electricity => (_num(_power) / 1000) * _totalHours * _num(_electricRate);
  double get _depreciation => _totalHours * _num(_depreciationRate);
  double get _paint => _num(_painting);
  double get _base => _material + _electricity + _depreciation + _paint;
  double get _profitAmount => _profitIsPercent ? _base * _num(_profit) / 100 : _num(_profit);
  double get _finalPrice => _base + _profitAmount;

  @override
  void dispose() {
    for (final c in [_customer, _part, _weight, _hours, _minutes, _spoolPrice, _power, _electricRate, _depreciationRate, _painting, _profit]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _requiredNumber(String? value) {
    final n = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
    if (n == null || n < 0) return 'عدد صفر یا بزرگ‌تر وارد کنید';
    return null;
  }

  Widget _field(String label, TextEditingController controller, {String? hint, bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: required ? _requiredNumber : null,
        decoration: InputDecoration(labelText: label, hintText: hint),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('محاسبه قیمت چاپ')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionTitle('مشخصات سفارش'),
              _field('نام قطعه', _part, hint: 'مثلاً مجسمه یا قطعه یدکی', required: false),
              _field('نام مشتری (اختیاری)', _customer, required: false),
              const SizedBox(height: 4),
              const _SectionTitle('مواد اولیه و زمان چاپ'),
              DropdownButtonFormField<String>(
                value: _filament,
                decoration: const InputDecoration(labelText: 'نوع فیلامنت'),
                items: const [
                  DropdownMenuItem(value: 'PLA', child: Text('PLA')),
                  DropdownMenuItem(value: 'ABS', child: Text('ABS')),
                ],
                onChanged: (v) => setState(() => _filament = v ?? 'PLA'),
              ),
              const SizedBox(height: 12),
              _field('وزن مصرفی قطعه (گرم)', _weight),
              _field('قیمت یک کیلو فیلامنت (تومان)', _spoolPrice),
              Row(
                children: [
                  Expanded(child: _field('ساعت چاپ', _hours)),
                  const SizedBox(width: 10),
                  Expanded(child: _field('دقیقه چاپ', _minutes)),
                ],
              ),
              const _SectionTitle('برق و استهلاک Ender 3'),
              _field('توان متوسط مصرفی (وات)', _power),
              _field('قیمت هر کیلووات‌ساعت برق (تومان)', _electricRate),
              _field('استهلاک پرینتر در هر ساعت (تومان)', _depreciationRate),
              const _SectionTitle('پرداخت و سود'),
              _field('هزینه رنگ‌آمیزی و پرداخت (تومان)', _painting),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: brandOrange,
                title: const Text('سود به‌صورت درصدی محاسبه شود'),
                subtitle: Text(_profitIsPercent ? 'درصد سود روی هزینه تمام‌شده' : 'مبلغ ثابت سود به تومان'),
                value: _profitIsPercent,
                onChanged: (v) => setState(() => _profitIsPercent = v),
              ),
              _field(_profitIsPercent ? 'درصد سود دلخواه' : 'مبلغ سود دلخواه (تومان)', _profit),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBlack,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: brandOrange.withOpacity(.65)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CostRow('هزینه فیلامنت', _material),
                    _CostRow('هزینه برق', _electricity),
                    _CostRow('استهلاک پرینتر', _depreciation),
                    _CostRow('رنگ‌آمیزی و پرداخت', _paint),
                    const Divider(height: 24),
                    _CostRow('هزینه تمام‌شده', _base, bold: true),
                    _CostRow('سود', _profitAmount),
                    const SizedBox(height: 10),
                    const Text('قیمت پیشنهادی برای مشتری', style: TextStyle(color: brandOrange, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(money(_finalPrice), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: brandOrange, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 15)),
                icon: const Icon(Icons.save_outlined),
                label: const Text('ذخیره سفارش در سوابق', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: _saveOrder,
              ),
              const SizedBox(height: 20),
              const Text('نکته: توان برق و استهلاک، مقادیر تخمینی هستند؛ برای قیمت دقیق‌تر آن‌ها را مطابق دستگاه و تعرفه خود تنظیم کنید.', style: TextStyle(color: Colors.white54, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveOrder() async {
    if (!_formKey.currentState!.validate()) {
      showMessage(context, 'لطفاً ورودی‌های عددی را بررسی کنید.');
      return;
    }
    if (_totalHours <= 0) {
      showMessage(context, 'زمان چاپ باید بیشتر از صفر باشد.');
      return;
    }
    final order = PrintOrder(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      customer: _customer.text.trim(),
      partName: _part.text.trim().isEmpty ? 'قطعه بدون نام' : _part.text.trim(),
      filament: _filament,
      weight: _num(_weight),
      hours: _totalHours,
      materialCost: _material,
      electricityCost: _electricity,
      depreciationCost: _depreciation,
      paintingCost: _paint,
      baseCost: _base,
      profit: _profitAmount,
      finalPrice: _finalPrice,
      createdAt: DateTime.now(),
    );
    await OrderStore.save(order);
    if (!mounted) return;
    showMessage(context, 'سفارش در گوشی ذخیره شد.');
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 12),
    child: Row(children: [
      Container(width: 4, height: 22, decoration: BoxDecoration(color: brandOrange, borderRadius: BorderRadius.circular(4))),
      const SizedBox(width: 9),
      Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
    ]),
  );
}

class _CostRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool bold;
  const _CostRow(this.label, this.amount, {this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Expanded(child: Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal))),
      Text(money(amount), style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: bold ? brandOrange : Colors.white)),
    ]),
  );
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<PrintOrder>> _future;
  @override
  void initState() {
    super.initState();
    _future = OrderStore.load();
  }

  void _reload() => setState(() => _future = OrderStore.load());

  String _report(PrintOrder o) {
    final date = '${o.createdAt.year}/${o.createdAt.month.toString().padLeft(2, '0')}/${o.createdAt.day.toString().padLeft(2, '0')}';
    return 'PEYMAN3D | گزارش قیمت چاپ سه‌بعدی\n'
        'تاریخ: $date\n'
        'نام قطعه: ${o.partName}\n'
        'نام مشتری: ${o.customer.isEmpty ? 'ثبت نشده' : o.customer}\n'
        'فیلامنت: ${o.filament}\n'
        'وزن: ${o.weight.toStringAsFixed(1)} گرم\n'
        'زمان چاپ: ${o.hours.toStringAsFixed(2)} ساعت\n'
        'هزینه فیلامنت: ${money(o.materialCost)}\n'
        'هزینه برق: ${money(o.electricityCost)}\n'
        'استهلاک پرینتر: ${money(o.depreciationCost)}\n'
        'رنگ‌آمیزی: ${money(o.paintingCost)}\n'
        'هزینه تمام‌شده: ${money(o.baseCost)}\n'
        'سود: ${money(o.profit)}\n'
        'قیمت پیشنهادی: ${money(o.finalPrice)}\n'
        '\nبا تشکر از انتخاب PEYMAN3D';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('سوابق محاسبات')),
        body: FutureBuilder<List<PrintOrder>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: brandOrange));
            }
            final orders = snapshot.data ?? [];
            if (orders.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.receipt_long_outlined, size: 58, color: brandOrange),
                    SizedBox(height: 12),
                    Text('هنوز سفارشی ذخیره نشده است', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('پس از محاسبه قیمت، گزینه ذخیره سفارش را بزنید.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
                  ]),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final o = orders[index];
                return Card(
                  color: cardBlack,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ExpansionTile(
                    leading: const CircleAvatar(backgroundColor: Color(0x33FF7A00), child: Icon(Icons.print, color: brandOrange)),
                    title: Text(o.partName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${o.filament} • ${o.weight.toStringAsFixed(1)} گرم • ${money(o.finalPrice)}'),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      _CostRow('هزینه تمام‌شده', o.baseCost),
                      _CostRow('رنگ‌آمیزی', o.paintingCost),
                      _CostRow('سود', o.profit),
                      _CostRow('قیمت پیشنهادی', o.finalPrice, bold: true),
                      if (o.customer.isNotEmpty) Align(alignment: Alignment.centerRight, child: Text('مشتری: ${o.customer}')),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('گزارش قیمت مشتری'),
                                content: SingleChildScrollView(child: SelectableText(_report(o))),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('بستن')),
                                  TextButton(onPressed: () {
                                    Navigator.pop(ctx);
                                    showMessage(context, 'متن گزارش را انتخاب و کپی کنید.');
                                  }, child: const Text('تمام')),
                                ],
                              ),
                            ),
                            icon: const Icon(Icons.description_outlined),
                            label: const Text('گزارش قیمت'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'حذف سفارش',
                          color: Colors.redAccent,
                          onPressed: () async {
                            final yes = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('حذف سفارش؟'),
                                content: const Text('این سفارش از سوابق همین گوشی حذف می‌شود.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('انصراف')),
                                  FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حذف')),
                                ],
                              ),
                            );
                            if (yes == true) {
                              await OrderStore.delete(o.id);
                              _reload();
                            }
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ]),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
