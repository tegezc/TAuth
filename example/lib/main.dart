// file: example/lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'blocs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Firebase (PENTING: Gunakan file firebase_options.dart Anda)
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Setup Dependency Injection
  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppSessionBloc(locator())),
        BlocProvider(create: (_) => LoginBloc(locator(), locator())),
      ],
      child: MaterialApp(
        title: 'TAuth Example',
        home: BlocBuilder<AppSessionBloc, SessionState>(
          builder: (context, state) {
            // Routing Reaktif Murni!
            if (state is SessionLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
            if (state is SessionUnauthenticated) return const LoginScreen();
            if (state is SessionAuthenticated) return DashboardScreen(user: state.user);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// --- SCREENS ---

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) return const Center(child: CircularProgressIndicator());

          return Center(
            child: ElevatedButton(
              onPressed: () => context.read<LoginBloc>().loginWithGoogle(),
              child: const Text('Login with Google'),
            ),
          );
        },
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final user; // Ganti dengan tipe AuthUser
  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<LoginBloc>().logout(),
          )
        ],
      ),
      body: Center(
        child: Text('Selamat datang,\n${user.email}', textAlign: TextAlign.center),
      ),
    );
  }
}