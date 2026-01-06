import 'package:flutter/material.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:freshflow_app/features/notifications/presentation/notification_detail_page.dart';
import 'package:freshflow_app/features/notifications/presentation/notification_settings_page.dart';

class NotificationListPage extends StatelessWidget {
  const NotificationListPage({super.key});

  String _previewFor(String t) {
    final lower = t.toLowerCase();
    if (lower.contains('flood')) {
      return 'Rising water levels reported. Avoid low areas and follow guidance.';
    } else if (lower.contains('heavy rain')) {
      return 'Forecast indicates heavy rainfall in the next 12–24 hours.';
    } else if (lower.contains('brown colour')) {
      return 'Teams investigating temporary discoloration; flushing underway.';
    }
    return 'System alert. More information will be available soon.';
  }

  @override
  Widget build(BuildContext context) {
    final items = const [
      'Flood in Batununggal',
      'Heavy Rain Incoming',
      'Brown Colour Water Issue Progress',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primary),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        centerTitle: true,
        title: const Text('Notification', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationSettingsPage()),
              );
            },
            icon: const Icon(Icons.settings, color: AppTheme.primary),
            tooltip: 'Settings',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final title = items[index];
            final preview = _previewFor(title);
            return Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => NotificationDetailPage(title: title)),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Color(0x12000000), blurRadius: 6, offset: Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(color: AppTheme.primary, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        preview,
                        style: const TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
