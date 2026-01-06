import 'package:flutter/material.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:freshflow_app/features/info/presentation/faq_page.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data - mirror HomePage values for now
    const double qualityRate = 0.72; // 0..1
    const String flowStatus = 'Good'; // Very Bad..Very Good
    const double ph = 7.2; // 0..14
    const int likes = 34;
    const int dislikes = 5;
    const List<double> trend = [0.4, 0.55, 0.5, 0.62, 0.7, 0.68, 0.75, 0.72];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Water Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.primary),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FaqPage()),
                      );
                    },
                    icon: const Icon(Icons.help_outline, color: AppTheme.primary),
                    tooltip: 'FAQ',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'These values are demo data and will be replaced by live measurements.',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 12),
                  // 1. Water Quality Rate
                  _SectionCard(
                    title: 'Water Quality Rate',
                    subtitle: 'Percentage of clean water quality based on recent sensors.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${(qualityRate * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: qualityRate,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE9EDF1),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // 2. Water Flow
                  _SectionCard(
                    title: 'Water Flow',
                    subtitle: 'Current water flow status at your location.',
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
                        ),
                        child: Text(flowStatus, style: const TextStyle(color: AppTheme.primary)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // 3. Water pH
                  _SectionCard(
                    title: 'Water pH',
                    subtitle: 'Acidity/alkalinity scale: 0 acidic, 14 alkaline.',
                    child: const SizedBox(width: double.infinity, child: _PhBar(ph: ph)),
                  ),

                  const SizedBox(height: 16),
                  // 4. Community Report
                  _SectionCard(
                    title: 'Community Report',
                    subtitle: 'Community feedback on recent water conditions.',
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(Icons.thumb_up_alt_outlined, color: Colors.green, size: 18),
                        const SizedBox(width: 4),
                        Text('$likes'),
                        const SizedBox(width: 12),
                        const Icon(Icons.thumb_down_alt_outlined, color: Colors.red, size: 18),
                        const SizedBox(width: 4),
                        Text('$dislikes'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // 5. Water Quality Trend
                  _SectionCard(
                    title: 'Water Quality Trend',
                    subtitle: 'Quality trend over recent days.',
                    child: const SizedBox(height: 100, width: double.infinity, child: _TrendSparklinePainter(values: trend)),
                  ),

                  const SizedBox(height: 16),
                  // 6. Usage Tips
                  _SectionCard(
                    title: 'Usage Tips',
                    subtitle: 'Practical advice to keep water safe.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('• Boil water for 1–3 minutes if contamination is suspected.'),
                        SizedBox(height: 6),
                        Text('• Maintain filters and check pH periodically.'),
                        SizedBox(height: 6),
                        Text('• Store clean water in sealed containers away from sunlight.'),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  const _SectionCard({required this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
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
              if (subtitle != null) ...[
                Text(subtitle!, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                const SizedBox(height: 6),
              ],
              child,
            ],
          ),
        ),
      ],
    );
  }
}

// _InfoRow no longer used after section split; removed.

class _PhBar extends StatelessWidget {
  final double ph; // 0..14
  const _PhBar({required this.ph});

  @override
  Widget build(BuildContext context) {
    const double minPh = 0;
    const double maxPh = 14;
    final double frac = ((ph - minPh) / (maxPh - minPh)).clamp(0.0, 1.0);

    return Stack(
      children: [
        Container(
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFF3B82F6), Color(0xFF10B981)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment(frac * 2 - 1, 0),
            child: Container(
              width: 2,
              height: 16,
              color: Colors.white,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment(frac * 2 - 1, -1.8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.5)),
              ),
              child: Text('pH ${ph.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 10, color: AppTheme.primary)),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrendSparkline extends CustomPainter {
  final List<double> values;
  _TrendSparkline({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = const Color(0xFFF5F7FA)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(8)),
      bg,
    );

    final grid = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;
    for (int i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final path = Path();
    final int n = values.length;
    for (int i = 0; i < n; i++) {
      final x = (size.width - 8) * i / (n - 1) + 4;
      final y = size.height - (size.height - 8) * values[i] - 4;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final stroke = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, stroke);

    final dot = Paint()..color = AppTheme.primary;
    for (int i = 0; i < n; i++) {
      final x = (size.width - 8) * i / (n - 1) + 4;
      final y = size.height - (size.height - 8) * values[i] - 4;
      canvas.drawCircle(Offset(x, y), 2.5, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendSparkline oldDelegate) => oldDelegate.values != values;
}

class _TrendSparklinePainter extends StatelessWidget {
  final List<double> values;
  const _TrendSparklinePainter({required this.values});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _TrendSparkline(values: values));
  }
}
