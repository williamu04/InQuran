import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/config/Global.dart';
import 'package:mtqmnuns/routes/route.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40), 
                
                Container(
                  margin: const EdgeInsets.only(bottom: 32.0),
                  child: Image.asset(
                    'assets/img/logoSplashScreen.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),

                const Text(
                  'QuranApp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF672CBC),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  'Slogan atau Jargon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4E2999),
                  ),
                ),
                
                const SizedBox(height: 24), 
                
                const Text(
                  '"Read and Understand\nThe Meaning of The Holy Verses Easily,\nAnytime and Anywhere."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,  
                    height: 1.3, 
                    color: Color(0xFF7C8BA0),
                  ),
                ),
                
                const SizedBox(height: 40), 
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox (
                      child: SizedBox(
                        height: 40, 
                        child: ElevatedButton(
                          onPressed: () async {
                            final isFirst = GlobalConfig().isFirstLaunch;
                            if (isFirst) {
                              await GlobalConfig().markLaunched(isDisabilityMode: false);
                            }
                            if (!mounted) return;
                            context.go(AppRoutes.home.path);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF672CBC),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            'Start Reading',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    SizedBox(
                      child: SizedBox(
                        height: 40, // Reduced button height
                        child: OutlinedButton(
                          onPressed: () async {
                            final isFirst = GlobalConfig().isFirstLaunch;
                            if (isFirst) {
                              await GlobalConfig().markLaunched(isDisabilityMode: true);
                            }
                            if (!mounted) return;
                            context.go(AppRoutes.voice.path);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF672CBC),
                            side: const BorderSide(
                              color: Color(0xFF672CBC),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          child: const Text(
                            'Voice Command Mode',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 150), 
              ],
            ),
          ),
      );
  }
}