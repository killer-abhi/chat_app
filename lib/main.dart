import 'package:flutter/material.dart';
import 'package:global_chat/providers/current_user.dart';
import 'package:global_chat/providers/google_sign_in.dart';
import 'package:global_chat/navigation/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (context) => CurrentUserProvider()),
      ],
      child: MaterialApp(
        title: 'FlutterChat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177),
          ),
        ),
        // darkTheme: ThemeData.dark(useMaterial3: true),
        home: const Home(),
      ),
    );
  }
}
