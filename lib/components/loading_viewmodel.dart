import 'package:flutter/material.dart';
import 'package:mtqmnuns/viewmodel/toggleable.dart';
import 'package:provider/provider.dart';

class LoadingModal extends StatelessWidget {
  final String text;
  final ToggleableUiController controller;

  const LoadingModal({
    super.key,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToggleableUiController>.value(
      value: controller,
      child: Consumer<ToggleableUiController>(
        builder: (context, controller, _) {
          if (!controller.isOpen) return const SizedBox.shrink();

          return GestureDetector(
            onTap: () {}, 
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 200, minWidth: 160),
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFF672CBC),
                            strokeWidth: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}