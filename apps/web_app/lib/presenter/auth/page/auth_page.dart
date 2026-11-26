import 'package:design_system/design_system.dart';
import 'package:material_ui/material_ui.dart';
import 'package:get_it/get_it.dart';
import '../../../app/navigation/app_navigator.dart';
import '../../home/page/home_page.dart';
import 'auth_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final AuthController controller;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = GetIt.I<AuthController>();
    controller.tokenState.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    controller.tokenState.removeListener(_onAuthStateChanged);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (controller.tokenState.data != null) {
      AppNavigator.pushReplacement(HomePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ListenableBuilder(
                  listenable: Listenable.merge([controller.tokenState, controller.errorMessage]),
                  builder: (context, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.shopping_bag_rounded,
                          size: 64,
                          color: AppColors.primaryBase,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'MegaLoja - Click & Collect',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Faça login para continuar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (controller.errorMessage.data != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              controller.errorMessage.data!,
                              style: const TextStyle(color: AppColors.error, fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        AppInput(
                          label: 'E-mail',
                          hint: 'cliente@exemplo.com',
                          controller: emailController,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        AppInput(
                          label: 'Senha',
                          hint: '••••••••',
                          controller: passwordController,
                          prefixIcon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 24),
                        BaseButton(
                          label: 'Entrar',
                          isLoading: controller.tokenState.isLoading,
                          onPressed: () {
                            controller.login(
                              emailController.text.trim(),
                              passwordController.text,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
