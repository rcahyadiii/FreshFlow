import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:freshflow_app/features/report/presentation/create_report_page.dart';
import 'package:provider/provider.dart';
import 'package:freshflow_app/features/report/data/report_repository.dart';
import 'package:freshflow_app/features/report/domain/report_item.dart';
import 'package:freshflow_app/features/report/presentation/report_detail_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int _tabIndex = 0; // 0: Report, 1: History

  void _onCreateReport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateReportPage()),
    );
  }

  Widget _tab(String text, {required bool active, required VoidCallback onTap}) {
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(padding: const EdgeInsets.all(4), child: child),
    );
  }


  Widget _reportList(List<ReportItem> items, {required String title, required bool completed}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return _HistoryOrReportTile(
                item: item,
                completed: completed,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ReportDetailPage(item: item)),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<ReportRepository>();
    final ongoingItems = repo.ongoing;
    final completedItems = repo.completed;

    final reportTab = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: 374,
            height: 100,
            child: ElevatedButton.icon(
              onPressed: () => _onCreateReport(context),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Create New Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
        Expanded(child: _reportList(ongoingItems, title: 'Report', completed: false)),
      ],
    );

    final historyTab = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Expanded(child: _reportList(completedItems, title: 'History', completed: true)),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tab('Report', active: _tabIndex == 0, onTap: () => setState(() => _tabIndex = 0)),
                  const SizedBox(width: 16),
                  _tab('History', active: _tabIndex == 1, onTap: () => setState(() => _tabIndex = 1)),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _tabIndex == 0 ? reportTab : historyTab,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryOrReportTile extends StatelessWidget {
  final ReportItem item;
  final bool completed;
  final VoidCallback onTap;

  const _HistoryOrReportTile({required this.item, required this.completed, required this.onTap});

  String _formatDate(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Widget _thumbnails(ReportItem item) {
    const size = 44.0;
    final thumbs = item.images.take(2).toList();
    final extra = item.images.length - thumbs.length;

    List<Widget> row = [
      for (final url in thumbs)
        Container(
          width: size,
          height: size,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          clipBehavior: Clip.antiAlias,
          child: url.startsWith('http')
              ? Image.network(url, fit: BoxFit.cover)
              : Image.file(File(url), fit: BoxFit.cover),
        ),
    ];
    if (extra > 0) {
      row.add(Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text('+$extra', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
      ));
    }
    return Row(children: row);
  }

  @override
  Widget build(BuildContext context) {
    final hasReview = (item.rating ?? 0) > 0 || (item.review?.isNotEmpty ?? false);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDate(item.date), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (completed ? const Color(0xFFE8F5E9) : const Color(0xFFE3F2FD)),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: completed ? const Color(0xFF43A047) : AppTheme.primary),
                            ),
                            child: Text(
                              completed ? 'Completed' : 'Ongoing',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: completed ? const Color(0xFF2E7D32) : AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(item.address, style: const TextStyle(fontSize: 12, color: Color(0xFFBABBBB))),
                      const SizedBox(height: 8),
                      _thumbnails(item),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
              ],
            ),
              if (completed && !hasReview) ...[
              const SizedBox(height: 10),
              _InlineReview(item: item),
            ],
          ],
        ),
      ),
    );
  }
}

class _InlineReview extends StatefulWidget {
  final ReportItem item;
  const _InlineReview({required this.item});

  @override
  State<_InlineReview> createState() => _InlineReviewState();
}

class _InlineReviewState extends State<_InlineReview> {
  int _rating = 0;
  final TextEditingController _controller = TextEditingController();
  bool _showInput = false;
  bool _submitting = false;
  bool _locked = false;
  bool _showThanks = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.item.rating ?? 0;
    _controller.text = widget.item.review ?? '';
    final hasExisting = _rating > 0 || _controller.text.isNotEmpty;
    _locked = hasExisting;
    _showInput = !hasExisting && _rating > 0; // only show input when user first taps
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStarTap(int value) {
    if (_locked) return;
    setState(() {
      _rating = value;
      _showInput = true;
    });
  }

  void _submit() async {
    if (_rating < 1 || _controller.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    try {
      context.read<ReportRepository>().addReviewByItem(
            widget.item,
            rating: _rating,
            review: _controller.text.trim(),
          );
      if (mounted) {
        setState(() {
          _locked = true;
          _showInput = false;
          _showThanks = true;
        });
        unawaited(Future.delayed(const Duration(seconds: 3), () {
          if (!mounted) return;
          setState(() => _showThanks = false);
        }));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentReviewText = (widget.item.review?.isNotEmpty ?? false)
        ? widget.item.review!
        : _controller.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (i) {
            final filled = i < _rating;
            return IconButton(
              iconSize: 24,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32),
              onPressed: _locked ? null : () => _onStarTap(i + 1),
              icon: Icon(
                filled ? Icons.star : Icons.star_border,
                color: filled ? Colors.amber : Colors.grey,
              ),
            );
          }),
        ),
        if (_locked && currentReviewText.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            currentReviewText,
            style: const TextStyle(fontSize: 14),
          ),
        ] else if (_showInput) ...[
          TextField(
            controller: _controller,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Write your review...'
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: (_rating < 1 || _controller.text.trim().isEmpty || _submitting) ? null : _submit,
              icon: const Icon(Icons.send),
              label: Text(_submitting ? 'Submitting...' : 'Submit'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
            ),
          ),
        ],
        if (_showThanks) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, size: 18, color: Color(0xFF2E7D32)),
                SizedBox(width: 8),
                Text('Thank you for your feedback', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
