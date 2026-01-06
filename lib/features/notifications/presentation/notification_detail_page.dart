import 'package:flutter/material.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';

class NotificationDetailPage extends StatelessWidget {
  final String title;
  const NotificationDetailPage({super.key, required this.title});

  String _descFor(String t) {
    if (t.toLowerCase().contains('flood')) {
      return 'Authorities reported rising water levels in Batununggal. Please avoid low-lying areas and follow official guidance. Sandbags are being distributed and pumps are operating.';
    } else if (t.toLowerCase().contains('heavy rain')) {
      return 'Meteorology department forecasts heavy rainfall over the next 12–24 hours. Secure outdoor items, check drainage, and be cautious when traveling.';
    } else if (t.toLowerCase().contains('brown colour')) {
      return 'Treatment teams are investigating temporary discoloration reported in several areas. Flushing is underway and quality tests are being performed. Updates will follow.';
    }
    return 'This is a system alert. More information will be displayed here as details become available.';
  }

  List<String> _imagesFor(String t) {
    // Placeholder images (royalty-free placeholders)
    return const [
      'https://picsum.photos/id/1015/600/400',
      'https://picsum.photos/id/1024/600/400',
      'https://picsum.photos/id/1039/600/400',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final desc = _descFor(title);
    final images = _imagesFor(title);

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
        title: const Text('Notification Detail', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(desc, style: const TextStyle(color: Colors.black87)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: images
                    .map(
                      (url) => ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          url,
                          width: 160,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
