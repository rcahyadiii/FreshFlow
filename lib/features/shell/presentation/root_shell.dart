import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:freshflow_app/features/chat/presentation/chat_page.dart';
import 'package:freshflow_app/features/home/presentation/home_page.dart';
import 'package:freshflow_app/features/info/presentation/info_page.dart';
import 'package:freshflow_app/features/profile/presentation/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:freshflow_app/features/shell/presentation/shell_view_model.dart';
import 'package:freshflow_app/features/report/presentation/report_page.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  final _pages = const [
    HomePage(),
    InfoPage(),
    ReportPage(),
    ChatPage(),
    ProfilePage(),
  ];

  // NavigationBar handles selection; no custom tap handler needed.

  @override
  Widget build(BuildContext context) {
    final shell = context.watch<ShellViewModel>();
    final index = shell.index;
    return Scaffold(
      body: _pages[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          indicatorColor: Colors.white,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final active = states.contains(WidgetState.selected);
            return TextStyle(
              color: active ? AppTheme.primary : Colors.grey,
              fontSize: 11,
            );
          }),
        ),
        child: Material(
          color: Colors.white,
          elevation: 8,
          shadowColor: const Color(0x22000000),
          child: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (i) => context.read<ShellViewModel>().setIndex(i),
            destinations: [
              _NavDest(label: 'Home', asset: 'assets/icons/Home.svg', isActive: index == 0),
              _NavDest(label: 'Info', asset: 'assets/icons/Information.svg', isActive: index == 1),
              _NavDest(label: 'Report', asset: 'assets/icons/Report.svg', isActive: index == 2),
              _NavDest(label: 'Chat', asset: 'assets/icons/Chat.svg', isActive: index == 3),
              _NavDest(label: 'Profile', asset: 'assets/icons/Profile.svg', isActive: index == 4),
            ],
          ),
        ),
      ),
    );
  }
}

// Legacy nav item removed in favor of NavigationBar destinations.

class _NavDest extends NavigationDestination {
  _NavDest({required super.label, required String asset, required bool isActive})
      : super(
          icon: _SvgIcon(asset: asset, active: false),
          selectedIcon: _SvgIcon(asset: asset, active: true),
        );
}

class _SvgIcon extends StatelessWidget {
  final String asset;
  final bool active;
  const _SvgIcon({required this.asset, required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.primary : Colors.grey;
    return SvgPicture.asset(
      asset,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
