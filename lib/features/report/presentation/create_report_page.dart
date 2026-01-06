import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:freshflow_app/features/report/presentation/submission_success_page.dart';
import 'package:provider/provider.dart';
import 'package:freshflow_app/features/report/data/report_repository.dart';
import 'package:freshflow_app/features/report/domain/report_item.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  // Address shown on the floating card (read-only for now)
  String address = 'Jl. Bojongsoang';

  // Categories
  bool roadDamage = false;
  bool streetLight = false;
  bool flooding = false;
  bool fallenTree = false;
  bool noise = false;
  bool publicSafety = false;
  bool facilityDamage = false;
  bool cleanliness = false;
  bool other = false;
  final TextEditingController otherController = TextEditingController();

  // Description
  final TextEditingController descriptionController = TextEditingController();
  final int descriptionLimit = 1000;
  bool _submitting = false;

  // Evidence
  final ImagePicker _picker = ImagePicker();
  final List<XFile?> photoSlots = List<XFile?>.generate(5, (_) => null);
  final List<XFile?> videoSlots = List<XFile?>.generate(5, (_) => null);

  bool get hasAnyCategory => roadDamage || streetLight || flooding || fallenTree || noise || publicSafety || facilityDamage || cleanliness || other;
  bool get isSubmitDisabled => _submitting || !hasAnyCategory || descriptionController.text.trim().isEmpty;

  Future<void> _pickPhoto(int index) async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => photoSlots[index] = file);
    }
  }

  Future<void> _pickVideo(int index) async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      setState(() => videoSlots[index] = file);
    }
  }

  void _submit() {
    if (isSubmitDisabled) return;
    setState(() => _submitting = true);
    final selectedCategories = <String>[
      if (roadDamage) 'roadDamage',
      if (streetLight) 'streetLight',
      if (flooding) 'flooding',
      if (fallenTree) 'fallenTree',
      if (noise) 'noise',
      if (publicSafety) 'publicSafety',
      if (facilityDamage) 'facilityDamage',
      if (cleanliness) 'cleanliness',
      if (other) 'other',
    ];

    final photos = photoSlots.where((p) => p != null).map((p) => p!.path).toList();
    final videos = videoSlots.where((v) => v != null).map((v) => v!.path).toList();

    // Save into repository as an ongoing report
    final item = ReportItem(
      date: DateTime.now(),
      address: address,
      images: photos,
      videos: videos,
      description: descriptionController.text,
      categories: selectedCategories,
      completed: false,
    );
    context.read<ReportRepository>().addOngoing(item);

    // ignore: avoid_print
    print('Submitting report: ${item.address}');
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SubmissionSuccessPage()),
    );
  }

  @override
  void dispose() {
    otherController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.primary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create Report',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MapPreview(address: address),
              const SizedBox(height: 16),
              const Text('What issue would you like to report?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _CategoryCheckbox(
                label: 'Road damage',
                value: roadDamage,
                onChanged: (v) => setState(() => roadDamage = v ?? false),
              ),
              _CategoryCheckbox(
                label: 'Street light not working',
                value: streetLight,
                onChanged: (v) => setState(() => streetLight = v ?? false),
              ),
              _CategoryCheckbox(
                label: 'Flooding / blocked water flow',
                value: flooding,
                onChanged: (v) => setState(() => flooding = v ?? false),
              ),
              _CategoryCheckbox(
                label: 'Fallen tree',
                value: fallenTree,
                onChanged: (v) => setState(() => fallenTree = v ?? false),
              ),
              _CategoryCheckbox(
                label: 'Noise disturbance',
                value: noise,
                onChanged: (v) => setState(() => noise = v ?? false),
              ),
              _CategoryCheckbox(
                label: 'Public safety',
                value: publicSafety,
                onChanged: (v) => setState(() => publicSafety = v ?? false),
              ),
              _CategoryCheckbox(
                label: 'Public facility damage',
                value: facilityDamage,
                onChanged: (v) => setState(() => facilityDamage = v ?? false),
              ),
              _CategoryCheckbox(
                label: 'Environmental cleanliness',
                value: cleanliness,
                onChanged: (v) => setState(() => cleanliness = v ?? false),
              ),
              Row(children: [
                Checkbox(
                  value: other,
                  onChanged: (v) => setState(() => other = v ?? false),
                  activeColor: AppTheme.primary,
                ),
                const Text('Other:'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: otherController,
                    enabled: other,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText: 'Enter other issue',
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              const Text('Describe the issue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                onChanged: (val) {
                  if (val.length > descriptionLimit) {
                    descriptionController.text = val.substring(0, descriptionLimit);
                    descriptionController.selection = TextSelection.fromPosition(
                      TextPosition(offset: descriptionController.text.length),
                    );
                  }
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Write a detailed description of the issue...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text('${descriptionController.text.length}/$descriptionLimit', style: const TextStyle(fontSize: 12, color: Color(0xFFBABBBB))),
              ),
              const SizedBox(height: 16),
              const Text('Upload Evidence', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Photo Evidence', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _MediaGrid(
                count: 5,
                slots: photoSlots,
                onAddTap: _pickPhoto,
                isVideo: false,
              ),
              const SizedBox(height: 12),
              const Text('Video Evidence', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _MediaGrid(
                count: 5,
                slots: videoSlots,
                onAddTap: _pickVideo,
                isVideo: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isSubmitDisabled ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: const Color(0xFFE3F2FD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  const _CategoryCheckbox({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primary,
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

class _MapPreview extends StatelessWidget {
  final String address;
  const _MapPreview({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Center(child: Text('Map preview (read-only)', style: TextStyle(color: Color(0xFFBABBBB)))),
          // Red pin
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
                  ),
                  Container(
                    width: 0,
                    height: 0,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: const BoxDecoration(),
                    child: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          // Floating address card
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Text(address, style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaGrid extends StatelessWidget {
  final int count;
  final List<XFile?> slots;
  final void Function(int index) onAddTap;
  final bool isVideo;
  const _MediaGrid({required this.count, required this.slots, required this.onAddTap, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: count,
      itemBuilder: (context, index) {
        final file = slots[index];
        return InkWell(
          onTap: () => onAddTap(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            clipBehavior: Clip.antiAlias,
            child: file == null
                ? const Center(child: Text('+', style: TextStyle(color: Color(0xFFBABBBB), fontSize: 18)))
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      if (!isVideo)
                        Image.file(File(file.path), fit: BoxFit.cover)
                      else
                        Container(color: Colors.black12),
                      if (isVideo)
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(Icons.videocam, color: Colors.white70, size: 18),
                          ),
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
