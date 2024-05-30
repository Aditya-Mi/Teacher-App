import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/blocs/auth/auth_bloc.dart';
import 'package:teacher_app/blocs/cubits/app_user_cubit.dart';
import 'package:teacher_app/blocs/student/student_bloc.dart';
import 'package:teacher_app/firebase_options.dart';
import 'package:teacher_app/navigation_provider.dart';
import 'package:teacher_app/presentation/screens/login_screen.dart';
import 'package:teacher_app/presentation/screens/main_screen.dart';
import 'package:teacher_app/repositories/firebase_auth_repository.dart';
import 'package:teacher_app/repositories/firestore_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authRepository = FirebaseAuthRepository(FirebaseAuth.instance);
  final firestoreRepository = FirestoreRepository(FirebaseFirestore.instance);
  final appUserCubit = AppUserCubit();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            firebaseAuthRepository: authRepository,
            firestoreRepository: firestoreRepository,
            appUserCubit: appUserCubit,
          ),
        ),
        BlocProvider<StudentBloc>(
          create: (context) => StudentBloc(
            firestoreRepository: firestoreRepository,
            appUserCubit: appUserCubit,
          ),
        ),
        BlocProvider<AppUserCubit>(
          create: (context) => appUserCubit,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavigationProvider>(
      create: (context) => NavigationProvider(),
      child: MaterialApp(
        title: 'Teacher App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            color: Colors.blue,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        home: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is AppUserLoggedIn;
          },
          builder: (context, isLoggedIn) {
            if (isLoggedIn) {
              return const MainScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
