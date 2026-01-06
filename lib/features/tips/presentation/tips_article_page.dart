import 'package:flutter/material.dart';

class TipsArticlePage extends StatelessWidget {
  final String title;
  const TipsArticlePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Article Content',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'This is a placeholder article about water tips. '
              'Replace with real content fetched from your data source.',
            ),
          ],
        ),
      ),
    );
  }
}
