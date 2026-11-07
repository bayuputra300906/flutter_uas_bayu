import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/destination_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/travel_note_provider.dart';
import 'providers/weather_provider.dart';
import 'repositories/destination_repository.dart';
import 'repositories/travel_note_repository.dart';
import 'repositories/weather_repository.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'services/destination_service.dart';
import 'services/travel_note_service.dart';
import 'services/weather_service.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TravelBuddyApp());
}

class TravelBuddyApp extends StatelessWidget {
  const TravelBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DestinationProvider(
            DestinationRepository(DestinationService()),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TravelNoteProvider(
            TravelNoteRepository(TravelNoteService()),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            WeatherRepository(WeatherService()),
          )..fetchWeather(),
        ),
      ],
      child: MaterialApp(
        title: 'TravelBuddy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: kPrimaryColor,
            primary: kPrimaryColor,
            secondary: kAccentColor,
          ),
          scaffoldBackgroundColor: kBackgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: kDarkColor,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkColor,
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
