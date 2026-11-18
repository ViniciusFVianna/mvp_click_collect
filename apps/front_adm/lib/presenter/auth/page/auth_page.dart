import 'package:flutter/material.dart';
import 'auth_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthController controller = AuthController();

  @override
    void initState() {
      super.initState();
      controller.onInit();
    }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListenableBuilder(
        listenable: controller.state,
      builder: (context, state) => switch (controller.state.data) {
        AuthState.initial =>  _Body(controller: controller),
        AuthState.loading => const Center(child: CircularProgressIndicator()),
        AuthState.success =>  _Body(controller: controller),
        AuthState.failure => throw UnimplementedError(),
      }
    ),
  );
}

class _Body extends StatelessWidget {
  final AuthController controller;
  const _Body({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}