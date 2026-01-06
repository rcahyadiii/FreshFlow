import 'package:flutter/material.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:freshflow_app/features/report/presentation/report_page.dart';

class _HistoryItem {
  final DateTime date;
  final String address;
  const _HistoryItem({required this.date, required this.address});
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String _formatDate(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  List<_HistoryItem> _mockData() {
    const addr = 'Jl. Zombos 22, Lada Selatan';
    return [
      _HistoryItem(date: DateTime(2025, 9, 12), address: addr),
      _HistoryItem(date: DateTime(2025, 9, 11), address: addr),
      _HistoryItem(date: DateTime(2025, 9, 10), address: addr),
    ];
  }

  Widget _tab(String text, {required bool active, VoidCallback? onTap}) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(
            color: active ? AppTheme.primary : const Color(0xFFBABBBB),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        if (active)
          Container(height: 2, width: 60, color: AppTheme.primary)
        else
          const SizedBox(height: 2, width: 60),
      ],
    );
    return onTap == null
        ? child
        : InkWell(onTap: onTap, borderRadius: BorderRadius.circular(4), child: Padding(padding: const EdgeInsets.all(4), child: child));
  }

  @override
  Widget build(BuildContext context) {
    final items = _mockData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tab('Report', active: false, onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const ReportPage()),
                    );
                  }),
                  _tab('History', active: true),
                ],
              ),
              const SizedBox(height: 16),
              const Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_formatDate(item.date), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text(item.address, style: const TextStyle(fontSize: 12, color: Color(0xFFBABBBB))),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
