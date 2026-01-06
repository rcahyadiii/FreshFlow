import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:freshflow_app/features/report/domain/report_item.dart';

class ReportDetailPage extends StatelessWidget {
  final ReportItem item;
  const ReportDetailPage({super.key, required this.item});

  String _formatDate(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  List<_ProgressStep> _buildSteps(ReportItem item) {
    final base = item.date;
    return [
      _ProgressStep('Report Submitted', base, _StepState.done),
      _ProgressStep('Report Accepted', base.add(const Duration(hours: 1)), item.completed ? _StepState.done : _StepState.current),
      _ProgressStep('Report In Progress', base.add(const Duration(days: 1)), item.completed ? _StepState.done : _StepState.future),
      _ProgressStep('Report Completed', base.add(const Duration(days: 2)), item.completed ? _StepState.done : _StepState.future),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final steps = _buildSteps(item);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primary),
        title: const Text('Report', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metadata
              Text(_formatDate(item.date), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(item.address, style: const TextStyle(fontSize: 12, color: Color(0xFFBABBBB))),

              const SizedBox(height: 16),
              const Text('Report Evidence', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: item.images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final url = item.images[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 120,
                        width: 160,
                        child: url.startsWith('http')
                            ? Image.network(url, fit: BoxFit.cover)
                            : Image.file(File(url), fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              const Text('Reported Issues', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final cat in item.categories)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 14)),
                          Expanded(child: Text(cat, style: const TextStyle(fontSize: 14))),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),
              const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(item.description, style: const TextStyle(fontSize: 14)),

              const SizedBox(height: 16),
              const Text('Report Result', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (item.resolveImages.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.resolveImages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final url = item.resolveImages[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 120,
                          width: 160,
                          child: url.startsWith('http')
                              ? Image.network(url, fit: BoxFit.cover)
                              : Image.file(File(url), fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                )
              else
                const Text('No resolve evidence yet', style: TextStyle(fontSize: 12, color: Color(0xFFBABBBB))),
              const SizedBox(height: 8),
              Text(item.resolveDescription ?? '—', style: const TextStyle(fontSize: 14)),

              const SizedBox(height: 16),
              const Text('Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _ReviewDisplay(item: item),

              const SizedBox(height: 16),
              const Text('Report Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _ProgressStepsView(steps: steps),
              const SizedBox(height: 100), // space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: item.completed ? const Color(0xFF43A047) : const Color(0xFFE0E0E0),
                disabledForegroundColor: item.completed ? Colors.white : const Color(0xFF9E9E9E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                item.completed ? 'Completed' : 'On Progress',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressStep {
  final String label;
  final DateTime time;
  final _StepState state;
  _ProgressStep(this.label, this.time, this.state);
}

enum _StepState { done, current, future }

class _ProgressStepsView extends StatelessWidget {
  final List<_ProgressStep> steps;
  const _ProgressStepsView({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < steps.length; i++)
          Expanded(
            child: _StepTile(step: steps[i]),
          ),
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  final _ProgressStep step;
  const _StepTile({required this.step});

  @override
  Widget build(BuildContext context) {
    final isActive = step.state == _StepState.done || step.state == _StepState.current;
    final color = isActive ? AppTheme.primary : const Color(0xFFBABBBB);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: isActive ? AppTheme.primary : const Color(0xFFE0E0E0), shape: BoxShape.circle),
          child: Icon(
            step.state == _StepState.done
                ? Icons.check
                : step.state == _StepState.current
                    ? Icons.timelapse
                    : Icons.circle,
            color: isActive ? Colors.white : const Color(0xFFBABBBB),
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(step.label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        const SizedBox(height: 4),
        Text(
          '${step.time.hour.toString().padLeft(2, '0')}:${step.time.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 10, color: Color(0xFFBABBBB)),
        ),
      ],
    );
  }
}

class _ReviewDisplay extends StatelessWidget {
  final ReportItem item;
  const _ReviewDisplay({required this.item});

  @override
  Widget build(BuildContext context) {
    final rating = item.rating ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            children: List.generate(5, (i) => Icon(
              i < rating ? Icons.star : Icons.star_border,
              color: i < rating ? Colors.amber : Colors.grey,
            )),
        ),
        const SizedBox(height: 8),
        Text(item.review?.isNotEmpty == true ? item.review! : 'No review yet',
            style: TextStyle(fontSize: 14, color: item.review?.isNotEmpty == true ? Colors.black : const Color(0xFFBABBBB))),
      ],
    );
  }
}
