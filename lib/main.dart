import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:freshflow_app/core/routes/app_router.dart';
import 'package:freshflow_app/core/theme/app_theme.dart';
import 'package:freshflow_app/features/chat/data/chat_repository.dart';
import 'package:freshflow_app/features/chat/presentation/chat_view_model.dart';
import 'package:freshflow_app/features/onboarding/data/auth_repository.dart';
import 'package:freshflow_app/features/shell/presentation/shell_view_model.dart';
import 'package:freshflow_app/features/report/data/report_repository.dart';
import 'package:freshflow_app/features/report/domain/report_item.dart';
import 'package:freshflow_app/features/profile/data/profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepo = AuthRepository();
  await authRepo.load();
  runApp(App(authRepo: authRepo));
}

class App extends StatelessWidget {
  final AuthRepository authRepo;
  const App({super.key, required this.authRepo});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthRepository>.value(value: authRepo),
        ChangeNotifierProvider<ProfileRepository>(create: (_) => ProfileRepository()),
        ChangeNotifierProvider<ReportRepository>(
          create: (_) => ReportRepository()
            ..addCompleted(ReportItem(
              date: DateTime(2025, 9, 12),
              address: 'Jl. Zombos 22, Lada Selatan',
              images: [
                'https://placehold.co/120x120/1e88e5/ffffff?text=A',
                'https://placehold.co/120x120/e53935/ffffff?text=B',
                'https://placehold.co/120x120/43a047/ffffff?text=C',
              ],
              videos: [],
              description: 'Potholes and broken asphalt observed along the road.',
              categories: ['Road damage'],
              completed: true,
              resolveImages: [
                'https://placehold.co/120x120/4caf50/ffffff?text=RES1',
                'https://placehold.co/120x120/4caf50/ffffff?text=RES2',
              ],
              resolveDescription: 'Road patched and smoothed; traffic flow improved.',
            ))
            ..addCompleted(ReportItem(
              date: DateTime(2025, 9, 10),
              address: 'Jl. Merdeka 1, Bandung',
              images: [
                'https://placehold.co/120x120/43a047/ffffff?text=D',
                'https://placehold.co/120x120/fdd835/000000?text=E',
              ],
              videos: [],
              description: 'Street light not working near the intersection.',
              categories: ['Street light'],
              completed: true,
              resolveImages: [
                'https://placehold.co/120x120/1e88e5/ffffff?text=RES3',
              ],
              resolveDescription: 'Bulb replaced and electrical checked; lights operational.',
            ))
            ..addCompleted(ReportItem(
              date: DateTime(2025, 9, 9),
              address: 'Jl. Cendana 3, Cimahi',
              images: [
                'https://placehold.co/120x120/e53935/ffffff?text=F',
              ],
              videos: [],
              description: 'Flooding due to blocked drains after heavy rain.',
              categories: ['Flooding'],
              completed: true,
              resolveImages: const [],
              resolveDescription: 'Drain cleared and water receded; monitoring ongoing.',
            )),
        ),
        Provider<ChatRepository>(create: (_) => InMemoryChatRepository()),
        ChangeNotifierProvider<ChatViewModel>(
          create: (ctx) => ChatViewModel(ctx.read<ChatRepository>()),
        ),
        ChangeNotifierProvider<ShellViewModel>(create: (_) => ShellViewModel()),
      ],
      child: MaterialApp(
        title: 'Freshflow',
        theme: AppTheme.light(),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
