import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const CafeManagerApp());

class CafeManagerApp extends StatelessWidget {
  const CafeManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cafe Manager',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.brown),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String money(double value) =>
      '${NumberFormat('#,##0.00').format(value)} ETB';

  @override
  Widget build(BuildContext context) {
    final cards = [
      ('Sales Today', 25500.0, Icons.point_of_sale),
      ('Purchases Today', 14000.0, Icons.shopping_cart),
      ('Expenses Today', 2000.0, Icons.receipt_long),
      ('Net Profit', 9500.0, Icons.trending_up),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Cafe Manager')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.restaurant, size: 48),
                  SizedBox(height: 12),
                  Text('Restaurant / Cafe',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('ETB • One Shop'),
                ],
              ),
            ),
            _item(context, 'Dashboard', Icons.dashboard, const DashboardPage()),
            _item(context, 'Orders / POS', Icons.table_restaurant, const OrdersPage()),
            _item(context, 'Purchases', Icons.shopping_cart, const PlaceholderPage(title: 'Purchases')),
            _item(context, 'Inventory', Icons.inventory_2, const PlaceholderPage(title: 'Inventory')),
            _item(context, 'Menu & Products', Icons.restaurant_menu, const PlaceholderPage(title: 'Menu & Products')),
            _item(context, 'Expenses', Icons.money_off, const PlaceholderPage(title: 'Expenses')),
            _item(context, 'Profit & Loss', Icons.analytics, const PlaceholderPage(title: 'Profit & Loss')),
            _item(context, 'Employees & Users', Icons.people, const PlaceholderPage(title: 'Employees & Users')),
            _item(context, 'Suppliers', Icons.local_shipping, const PlaceholderPage(title: 'Suppliers')),
            _item(context, 'Reports', Icons.assessment, const PlaceholderPage(title: 'Reports')),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Today', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.55,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (_, i) => Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(cards[i].$3, size: 28),
                    const Spacer(),
                    Text(cards[i].$1),
                    Text(money(cards[i].$2),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.table_restaurant),
              title: const Text('Open POS'),
              subtitle: const Text('Manage tables and customer orders'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const OrdersPage())),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _item(BuildContext context, String title, IconData icon, Widget page) =>
      ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      );
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<String> tables = List.generate(12, (i) => 'Table ${i + 1}');
  final Set<String> occupied = {'Table 2', 'Table 5', 'Table 9'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders / POS')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tables.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (_, i) {
          final table = tables[i];
          final isBusy = occupied.contains(table);
          return Card(
            child: InkWell(
              onTap: () => _openOrder(table),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.table_restaurant, size: 36),
                  const SizedBox(height: 6),
                  Text(table),
                  Text(isBusy ? 'Occupied' : 'Available',
                      style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openOrder(String table) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => OrderPage(table: table),
    ));
  }
}

class OrderPage extends StatefulWidget {
  final String table;
  const OrderPage({super.key, required this.table});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final Map<String, double> menu = {
    'Macchiato': 80,
    'Cappuccino': 120,
    'Tea': 60,
    'Shiro': 180,
    'Pasta': 220,
    'Burger': 250,
    'Juice': 100,
  };
  final Map<String, int> cart = {};

  double get total =>
      cart.entries.fold(0, (sum, e) => sum + menu[e.key]! * e.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.table)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: menu.entries.map((e) {
                return ListTile(
                  title: Text(e.key),
                  subtitle: Text('${e.value.toStringAsFixed(2)} ETB'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () => setState(() => cart[e.key] = (cart[e.key] ?? 0) + 1),
                  ),
                );
              }).toList(),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Text('Total: ${total.toStringAsFixed(2)} ETB',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: cart.isEmpty ? null : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order saved. Ready for payment.')),
                      );
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text('Save Order'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
      child: Text('$title module — next development stage',
          style: const TextStyle(fontSize: 18)),
    ),
  );
}
