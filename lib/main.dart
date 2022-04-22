import 'package:flutter/material.dart';
import 'package:hosanalyst/pages/game_view_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/all_games.dart';
import './pages/login_page.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _hasToken = false;
  var window;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken();
    window = WidgetsBinding.instance!.window;
  }

  void checkToken() async {
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');
    token != null
        ? setState(() {
            _hasToken = true;
          })
        : setState(() {
            _hasToken = false;
          });
  }

  @override
  Widget build(BuildContext context) {
    const MaterialColor kPrimaryColor = MaterialColor(
      0xFF298939,
      <int, Color>{
        50: Color(0xFF298939),
        100: Color(0xFF298939),
        200: Color(0xFF298939),
        300: Color(0xFF298939),
        400: Color(0xFF298939),
        500: Color(0xFF298939),
        600: Color(0xFF298939),
        700: Color(0xFF298939),
        800: Color(0xFF298939),
        900: Color(0xFF298939),
      },
    );
    // var brightness = SchedulerBinding.instance!.window.platformBrightness;
    

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: kPrimaryColor,
        primaryColor: kPrimaryColor,
        accentColor: Colors.black,
        textTheme: TextTheme(),

        backgroundColor: Color(0xFFF5F5F5),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: kPrimaryColor,
        primaryColor: kPrimaryColor,
        accentColor: Colors.white,
        textTheme: TextTheme(),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      themeMode: ThemeMode.system,
      // home: const AllGames(),
      home: SplashScreenView(
        navigateRoute: _hasToken ? const AllGames() : const Signin(),
        duration: 3000,
        imageSize: 250,
        imageSrc: "assets/images/HosanalystLogo.png",
        backgroundColor: window.platformBrightness == Brightness.dark
            ? Colors.black12
            : Colors.white,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
