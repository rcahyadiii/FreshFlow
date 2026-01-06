import 'package:flutter/material.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primary),
        title: const Text('FAQ', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700)),
      ),
      backgroundColor: Colors.white,
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: _FaqContent(),
        ),
      ),
    );
  }
}

class _FaqContent extends StatelessWidget {
  const _FaqContent();

  @override
  Widget build(BuildContext context) {
    // Placeholder FAQ items
    final items = const [
      {
        'q': 'What is water quality rate?',
        'a': 'It indicates the percentage of clean water measured by sensors.'
      },
      {
        'q': 'How is pH measured?',
        'a': 'Using standard sensors; 7.0 is neutral, lower is acidic, higher is alkaline.'
      },
      {
        'q': 'Where do these values come from?',
        'a': 'Currently demo values; they will be replaced with live data soon.'
      },
    ];

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: const [
              BoxShadow(color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['q']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(item['a']!, style: const TextStyle(color: Colors.black87)),
            ],
          ),
        );
      },
    );
  }
}
