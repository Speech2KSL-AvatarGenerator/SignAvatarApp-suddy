import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suddy/login/sign_up_screen.dart';

import 'firebase_options.dart';
import 'home/home_screen.dart';
import 'home/script_detail_screen.dart';
import 'login/login_screen.dart';
import 'model/script.dart';

// 사용자 정보를 받아오자
UserCredential? userCredential;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // cameras = await availableCameras();

  // if (kDebugMode) {
  //   try {
  //     await FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
  //     // 에뮬레이터로 돌릴떄는 위에걸로 돌리자.
  //     // 에뮬레이터 안 쓸거면 위의 줄 끄고 돌려야 한다.
  //     // 아래 코드만 있어야 파이어베이스에 저장됨
  //     FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
  //     FirebaseStorage.instance.useStorageEmulator("localhost", 9199);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  runApp(SuddyApp());
}

class SuddyApp extends StatelessWidget {
  SuddyApp({super.key});
  // final router = GoRouter(
  //   initialLocation: "/login",
  //   routes: [
  //     GoRoute(
  //       path: "/",
  //       builder: (context, state) => HomeScreen(),
  //       routes: [
  //         // GoRoute(
  //         //   path: "cart/:uid",
  //         //   builder: (context, state) => CartScreen(
  //         //     uid: state.pathParameters["uid"] ?? "",
  //         //   ),
  //         // ),
  //         GoRoute(
  //           path: "script",
  //           builder: (context, state)  {
  //             return ScriptDetailScreen(script: state.extra as Script,);
  //           },
  //         ),
  //         // GoRoute(
  //         //   path: "product/add",
  //         //   //builder: (context, state) => ProductDetailScreen(),
  //         //   builder: (context, state)  {
  //         //     return ProductDetailScreen(script: state.extra as Script,);
  //         //   },
  //         // ),
  //       ],
  //     ),
  //     GoRoute(
  //       path: "/login",
  //       builder: (context, state) => LoginScreen(),
  //     ),
  //     GoRoute(
  //       path: "/sign_up",
  //       builder: (context, state) => SignUpScreen(),
  //     ),
  //   ],
  // );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Suddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: HomeScreen(),  라우터를 사용하면 home 이 사라진다.
      routerConfig: _router,
    );
  }

  // GoRouter를 정의합니다.
  final _router = GoRouter(
    redirect: (context, state) async {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggingIn = state.matchedLocation == '/login';

      // 사용자가 로그인되어 있지 않다면 로그인 화면으로 이동
      if (user == null && !isLoggingIn) {
        return '/login';
      }

      // 사용자가 로그인되어 있다면 홈 화면으로 이동
      if (user != null && isLoggingIn) {
        return '/';
      }

      // 그 외의 경우에는 그대로 진행
      return null;
    },
    initialLocation: "/login",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => HomeScreen(),
        routes: [
          GoRoute(
            path: "script",
            builder: (context, state) {
              return ScriptDetailScreen(script: state.extra as Script);
            },
          ),
        ],
      ),
      GoRoute(
        path: "/login",
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: "/sign_up",
        builder: (context, state) => SignUpScreen(),
      ),
    ],
  );
}
