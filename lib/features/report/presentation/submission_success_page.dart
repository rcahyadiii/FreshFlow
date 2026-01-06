import 'package:flutter/material.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';

class SubmissionSuccessPage extends StatefulWidget {
  final bool autoBack;
  final int delayMs;

  const SubmissionSuccessPage({super.key, this.autoBack = true, this.delayMs = 2500});

  @override
  State<SubmissionSuccessPage> createState() => _SubmissionSuccessPageState();
}

class _SubmissionSuccessPageState extends State<SubmissionSuccessPage> {
  @override
  void initState() {
    super.initState();
    if (widget.autoBack) {
      Future.delayed(Duration(milliseconds: widget.delayMs), () {
        if (!mounted) return;
        // Pop success screen, then CreateReportPage to return to ReportPage
        final nav = Navigator.of(context);
        if (nav.canPop()) nav.pop();
        if (nav.canPop()) nav.pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Report Submitted!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.check, color: Colors.white, size: 64),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
