import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suddy/login/sign_up_screen.dart';

void main() {
  runApp(SuddyApp());
}

class SuddyApp extends StatelessWidget {
  SuddyApp({super.key});
  final router = GoRouter(
    initialLocation: "/sign_up",
    routes: [
      // GoRoute(
      //   path: "/",
      //   builder: (context, state) => HomeScreen(),
      //   routes: [
      //     GoRoute(
      //       path: "cart/:uid",
      //       builder: (context, state) => CartScreen(
      //         uid: state.pathParameters["uid"] ?? "",
      //       ),
      //     ),
      //     GoRoute(
      //       path: "product",
      //       builder: (context, state)  {
      //         return ProductDetailScreen(product: state.extra as Product,);
      //       },
      //     ),
      //     GoRoute(
      //       path: "product/add",
      //       //builder: (context, state) => ProductDetailScreen(),
      //       builder: (context, state)  {
      //         return ProductDetailScreen(product: state.extra as Product,);
      //       },
      //     ),
      //   ],
      // ),
      // GoRoute(
      //   path: "/login",
      //   builder: (context, state) => LoginScreen(),
      // ),
      GoRoute(
        path: "/sign_up",
        builder: (context, state) => SignUpScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '플러터 마트',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: HomeScreen(),  라우터를 사용하면 home 이 사라진다.
      routerConfig: router,
    );
  }
}
