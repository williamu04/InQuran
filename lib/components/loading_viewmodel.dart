import 'package:flutter/material.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';
import 'package:provider/provider.dart';

class LoadingModal<T extends StatefulViewModel> extends StatelessWidget {
  final String text;
  final Type showForState;

  const LoadingModal({
    super.key,
    required this.text,
    required this.showForState,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, viewModel, child) {
        if (viewModel.state.runtimeType != showForState) {
          return const SizedBox.shrink();
        }
        return _buildModal();
      },
    );
  }

  Widget _buildModal() {
    return Stack(
      children: [
        // Transparent black background
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.5)),
        ),
        // Centered modal
        Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 200, minWidth: 160),
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CircularProgressIndicator(
                        color: Color(0xFF672CBC),
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
