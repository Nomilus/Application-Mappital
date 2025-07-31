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
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.primary,
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildContent(theme: theme),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Mappital',
            style: theme.textTheme.displaySmall?.apply(color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            'คือผู้ช่วยฉุกเฉินส่วนตัว ที่ออกแบบมาเพื่อช่วยเหลือคุณในเวลาสำคัญ! เราให้คุณสามารถค้นหา โรงพยาบาลที่อยู่ใกล้ที่สุด ได้ทันที พร้อมระบบ SOS แจ้งเตือนฉุกเฉิน ที่ทำให้คุณสามารถส่งสัญญาณขอความช่วยเหลือได้อย่างรวดเร็ว',
            style: theme.textTheme.bodyMedium?.apply(color: Colors.white),
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
