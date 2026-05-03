import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

// Import views (ตรวจสอบว่าชื่อไฟล์ในเครื่องตรงกัน)
import 'package:flutter_money_tracking_app/views/home_ui.dart';
import 'package:flutter_money_tracking_app/views/money_balance_ui.dart';
import 'package:flutter_money_tracking_app/views/money_in_ui.dart';
import 'package:flutter_money_tracking_app/views/money_out_ui.dart';
import 'package:flutter_money_tracking_app/views/splash_screen_ui.dart';
import 'package:flutter_money_tracking_app/views/welcome_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ตั้งค่า Locale ภาษาไทย
  await initializeDateFormatting('th', null);

  // เชื่อมต่อ Supabase
  await Supabase.initialize(
    url: 'https://fuprlordwixjsknsgfmp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1cHJsb3Jkd2l4anNrbnNnZm1wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3ODQ5ODIsImV4cCI6MjA5MzM2MDk4Mn0.JW3M8kD3ob7pMNRvpHE2kFPIkV53DRIs0Rrt3i8ndJg',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4D968E),
          primary: const Color(0xFF4D968E),
        ),
        textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme),
      ),
      // กำหนดเส้นทางหน้าจอ
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/welcome': (context) => const WelcomeUI(),
        '/home': (context) => const HomeUI(),
        '/money_in': (context) => const MoneyInUI(),
        '/money_out': (context) => const MoneyOutUI(),
        '/money_balance': (context) => const MoneyBalanceUI(),
      },
    );
  }
}
