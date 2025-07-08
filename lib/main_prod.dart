// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:foriyana_app/generated/l10n.dart';
// import 'package:foriyana_app/presentation/blocs/cubit/auth_cubit.dart';
// import 'package:foriyana_app/presentation/blocs/cubit/language_cubit.dart';
// import 'package:foriyana_app/presentation/blocs/user/user_bloc.dart';
// import 'package:foriyana_app/presentation/views/home/home_page.dart';
// import 'package:foriyana_app/presentation/views/login/login_page.dart';
// import 'core/services/services_locator.dart' as di;
// import '../env/prod.dart'; // or '../env/prod.dart' based on your build

// // const kWindowsScheme = 'sample';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized
//   await di.init();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => AuthCubit()..checkAuthStatus(),
//         ),
//         BlocProvider<LanguageCubit>(
//           // ✅ Provide LanguageCubit
//           create: (context) => LanguageCubit(),
//         ),
//         BlocProvider(
//           create: (context) => di.sl<UserBloc>()..add(CheckUser()),
//         ),
//       ],
//       child: BlocBuilder<LanguageCubit, Locale>(
//         builder: (context, locale) {
//           // ✅ Use `locale`
//           return MaterialApp(
//             title: 'Affiliate Portal',
//             locale: locale, // ✅ This is required for localization to work
//             localizationsDelegates: [
//               S.delegate,
//               GlobalMaterialLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//               GlobalCupertinoLocalizations.delegate,
//             ],
//             supportedLocales: [
//               Locale('en'), // English
//               Locale('id'), // Indonesian
//             ],
//             debugShowCheckedModeBanner: false,
//             home: AuthWrapper(),
//             routes: {
//               "/login": (context) => LoginPage(),
//               "/home": (context) => HomePage(),
//             },
//             theme: ThemeData(
//               colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//               useMaterial3: true,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         if (state == AuthState.loading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state == AuthState.authenticated) {
//           return HomePage();
//         } else {
//           return LoginPage();
//         }
//       },
//     );
//   }
// }
