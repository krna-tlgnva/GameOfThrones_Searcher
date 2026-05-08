import 'package:flutter/material.dart';

import '../widgets/app_background.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({
    super.key,
    required this.onStart,
    required this.onRegister,
  });

  final VoidCallback onStart;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    const deepPurple = Color(0xFF52139A);
    const iceText = Color(0xFFEAF2FF);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final logoHeight = (constraints.maxHeight * 0.58).clamp(
                    260.0,
                    600.0,
                  );

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/game_of_thrones_logo_cropped.png',
                          height: logoHeight,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          FilledButton(
                            onPressed: onStart,
                            style: FilledButton.styleFrom(
                              backgroundColor: deepPurple,
                              foregroundColor: iceText,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 6,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                'LOAD APP',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: iceText,
                                ),
                              ),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: onRegister,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: deepPurple,
                              side: const BorderSide(
                                color: deepPurple,
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                'REGISTER',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
