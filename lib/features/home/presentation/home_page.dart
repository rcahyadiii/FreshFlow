import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshflow_app/features/report/presentation/report_page.dart';
import 'package:freshflow_app/features/tips/presentation/tips_article_page.dart';
import 'package:freshflow_app/features/shell/presentation/shell_view_model.dart';
import 'package:freshflow_app/features/onboarding/data/auth_repository.dart';
import 'package:freshflow_app/features/profile/data/profile_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:freshflow_app/features/notifications/presentation/notification_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _locationText;
  bool _locating = false;
  latlng.LatLng? _latLng;
  final MapController _mapController = MapController();

  void _zoom(double delta) {
    try {
      final center = _mapController.camera.center;
      final zoom = _mapController.camera.zoom;
      final nextZoom = (zoom + delta).clamp(2.0, 19.0);
      _mapController.move(center, nextZoom);
    } catch (_) {
      // ignore zoom errors
    }
  }

  List<Marker> _buildQualityMarkers() {
    if (_latLng == null) return const [];
    final base = _latLng!;
    latlng.LatLng at(double dLat, double dLon) => latlng.LatLng(base.latitude + dLat, base.longitude + dLon);

    // Sample bubbles around current location: blue=good, red=bad
    final bubbles = <({latlng.LatLng pos, bool good, double size})>[
      (pos: at(0.0008, 0.0008), good: true, size: 80),
      (pos: at(-0.0009, 0.0005), good: false, size: 90),
      (pos: at(0.0012, -0.0007), good: true, size: 70),
      (pos: at(-0.0006, -0.0006), good: false, size: 100),
      (pos: at(0.0003, -0.0011), good: true, size: 60),
    ];

    Color bubbleColor(bool good) => (good ? Colors.blue : Colors.red).withValues(alpha: 0.25);
    Color borderColor(bool good) => good ? Colors.blue : Colors.red;

    return bubbles
        .map(
          (b) => Marker(
            point: b.pos,
            width: b.size,
            height: b.size,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bubbleColor(b.good),
                border: Border.all(color: borderColor(b.good), width: 2),
              ),
            ),
          ),
        )
        .toList();
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: 1),
      );

  Future<void> _getLocation() async {
    setState(() => _locating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _locationText = 'Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        setState(() => _locationText = 'Location permission denied');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _locationText = 'Location permission permanently denied');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _latLng = latlng.LatLng(pos.latitude, pos.longitude);

      // Reverse geocode to a readable place name
      String pretty = '';
      try {
        final placemarks = await geocoding.placemarkFromCoordinates(pos.latitude, pos.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = <String?>[
            (p.name?.isNotEmpty ?? false) ? p.name : null,
            (p.locality?.isNotEmpty ?? false) ? p.locality : null,
            (p.administrativeArea?.isNotEmpty ?? false) ? p.administrativeArea : null,
          ].whereType<String>().toList();
            pretty = parts.isNotEmpty ? parts.join(', ') : '';
        }
      } catch (_) {
        // Fallback to coordinates if reverse geocoding fails
      }

      setState(() {
        _locationText = pretty.isNotEmpty
            ? pretty
            : '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';

      });
    } catch (e) {
      setState(() => _locationText = 'Failed to get location');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = context.select<AuthRepository, String?>(
      (repo) => repo.username,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 374,
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              _ProfileAvatar(),
                              const SizedBox(width: 10),
                              Text(
                                username?.isNotEmpty == true ? username! : 'User',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const NotificationListPage()),
                            );
                          },
                          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: 374,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Find Location',
                    prefixIcon: const Icon(Icons.search, color: Colors.black54),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    border: _border(AppTheme.primary),
                    enabledBorder: _border(AppTheme.primary),
                    focusedBorder: _border(AppTheme.primary),
                    hintStyle: const TextStyle(color: Color(0xFFBABBBB), fontSize: 12),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: 374,
                child: ElevatedButton(
                  onPressed: _locating ? null : _getLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _locating
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.my_location, size: 18, color: Colors.white),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _locationText == null ? 'Your location' : _locationText!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: 374,
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primary, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _latLng == null
                        ? const Center(
                            child: Text(
                              'Location map will appear here',
                              style: TextStyle(color: Colors.black54, fontSize: 12),
                            ),
                          )
                        : Stack(
                            children: [
                              FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(
                                  initialCenter: _latLng!,
                                  initialZoom: 15,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.freshflowApp',
                                  ),
                                  // Bubble heatmap layer for water quality
                                  MarkerLayer(markers: _buildQualityMarkers()),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: _latLng!,
                                        width: 40,
                                        height: 40,
                                        child: const Icon(Icons.location_pin, color: AppTheme.primary, size: 32),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Column(
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () => _zoom(1.0),
                                        child: const Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Icon(Icons.add, size: 20, color: AppTheme.primary),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () => _zoom(-1.0),
                                        child: const Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Icon(Icons.remove, size: 20, color: AppTheme.primary),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () async {
                                          await _getLocation();
                                          if (_latLng != null) {
                                            _mapController.move(_latLng!, 15);
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Icon(Icons.my_location, size: 20, color: AppTheme.primary),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: SafeArea(
                                  minimum: const EdgeInsets.only(bottom: 12),
                                  child: _ReportOverlayButton(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => const ReportPage()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const _WaterInfoSection(),

              const SizedBox(height: 12),
              const _WaterTipsSection(),

              // Status text removed per request
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final photoPath = context.select<ProfileRepository, String?>((repo) => repo.photoPath);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Switch to Profile tab within the shell to keep bottom navbar
          context.read<ShellViewModel>().setIndex(4);
        },
        child: Ink(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: ClipOval(
            child: (photoPath == null || photoPath.isEmpty)
                ? const Icon(Icons.person, color: AppTheme.primary)
                : Image.file(
                    File(photoPath),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}

class _WaterInfoSection extends StatelessWidget {
  const _WaterInfoSection();

  @override
  Widget build(BuildContext context) {
    // Dummy data
    const double qualityRate = 0.72; // 0..1
    const String flowStatus = 'Good'; // Very Bad..Very Good
    const double ph = 7.2; // 0..14
    const int likes = 34;
    const int dislikes = 5;
    const List<double> trend = [0.4, 0.55, 0.5, 0.62, 0.7, 0.68, 0.75, 0.72];

    return SizedBox(
      width: 374,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clickable title row -> switches to Info tab (keeps bottom navbar)
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              context.read<ShellViewModel>().setIndex(1);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/Information.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(AppTheme.primary, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Water Info',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Colors.black54),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Content box
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
              children: [
                _InfoRow(
                  title: 'Water Quality Rate',
                  trailing: Text('${(qualityRate * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: qualityRate,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE9EDF1),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),

                const SizedBox(height: 16),
                _InfoRow(
                  title: 'Water Flow',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
                    ),
                    child: Text(flowStatus, style: const TextStyle(color: AppTheme.primary)),
                  ),
                ),

                const SizedBox(height: 16),
                _InfoRow(
                  title: 'Water pH',
                  trailing: SizedBox(
                    width: 200,
                    child: _PhBar(ph: ph),
                  ),
                ),

                const SizedBox(height: 16),
                _InfoRow(
                  title: 'Report',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text('Water Quality Trend', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: _TrendSparkline(values: trend),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final Widget trailing;
  const _InfoRow({required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Colors.black87)),
        const Spacer(),
        trailing,
      ],
    );
  }
}

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

class _TrendSparkline extends StatelessWidget {
  final List<double> values; // 0..1
  const _TrendSparkline({required this.values});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SparklinePainter(values: values),
    );
  }
}

class _WaterTipsSection extends StatelessWidget {
  const _WaterTipsSection();

  @override
  Widget build(BuildContext context) {
    final tips = const [
      {'title': 'How to conserve clean water at home'},
      {'title': 'Detecting early signs of water contamination'},
      {'title': 'Maintaining pH balance for household use'},
    ];

    return SizedBox(
      width: 374,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('Water Tips', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              for (final t in tips)
                _TipsItem(
                  title: t['title'] as String,
                  onOpen: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TipsArticlePage(title: t['title'] as String),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TipsItem extends StatelessWidget {
  final String title;
  final VoidCallback onOpen;
  const _TipsItem({required this.title, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 56,
              height: 56,
              color: const Color(0xFFEFF6FF),
              child: const Center(
                child: Icon(Icons.water_drop, color: AppTheme.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            onPressed: onOpen,
            icon: const Icon(Icons.chevron_right, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  _SparklinePainter({required this.values});

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
    // draw horizontal grid lines
    for (int i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final path = Path();
    final int n = values.length;
    for (int i = 0; i < n; i++) {
      final x = (size.width - 8) * i / (n - 1) + 4; // padding 4
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
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => oldDelegate.values != values;
}

class _ReportOverlayButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ReportOverlayButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/Report.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(AppTheme.primary, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              const Text(
                'Report',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
