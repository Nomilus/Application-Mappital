import 'package:flutter/material.dart';
import 'package:application_mappital/view/event/auth_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: theme.colorScheme.primary)),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildContent(theme: theme),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: SafeArea(
                child: IconButton(
                  onPressed: () => controller.toggleTheme(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      theme.colorScheme.surfaceContainerHigh,
                    ),
                  ),
                  icon: controller.isDarkMode.value
                      ? const Icon(Icons.dark_mode)
                      : const Icon(Icons.light_mode),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, theme.colorScheme.surfaceContainerLow],
          stops: const [0, 0.8],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Mappital', style: theme.textTheme.displaySmall),
          const SizedBox(width: 8),
          Text(
            '\u0009คือผู้ช่วยฉุกเฉินส่วนตัว ที่ออกแบบมาเพื่อช่วยเหลือคุณในเวลาสำคัญ! เราให้คุณสามารถค้นหา โรงพยาบาลที่อยู่ใกล้ที่สุด ได้ทันที พร้อมระบบ SOS แจ้งเตือนฉุกเฉิน ที่ทำให้คุณสามารถส่งสัญญาณขอความช่วยเหลือได้อย่างรวดเร็ว',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _buildSignInWithGoogleButton(theme: theme),
        ],
      ),
    );
  }

  Widget _buildSignInWithGoogleButton({required ThemeData theme}) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => controller.submitSignInWithGoogle(),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              theme.colorScheme.surfaceContainerHigh,
            ),
          ),
          child: controller.isLoading.value
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.google),
                    SizedBox(width: 5),
                    Text('Sign in with google'),
                  ],
                ),
        ),
      ),
    );
  }
}
