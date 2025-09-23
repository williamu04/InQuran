import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/viewmodel/toggleable.dart';
import 'package:provider/provider.dart';

class ButtonModalModel {
  final Color buttonColor;
  final Color textColor;
  final VoidCallback onButtonPressed;
  final String text;

  ButtonModalModel({
    required this.text,
    required this.onButtonPressed,
    this.buttonColor = const Color(0xFF672CBC),
    this.textColor = Colors.white,
  });
}

class ReusableModal<T extends ToggleableUiViewModel> extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool closeOnlyOnButtonPress; 
  final Widget? customContentSubtitle;
  final List<ButtonModalModel> buttonList;

  const ReusableModal({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonList,
    this.closeOnlyOnButtonPress = false, 
    this.customContentSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, viewModel, child) {
        if (!viewModel.isOpen) return const SizedBox.shrink();

        final bool backdropClickable = !closeOnlyOnButtonPress;

        return GestureDetector(
          onTap: backdropClickable ? () => viewModel.close() : null, 
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: GestureDetector(
                onTap: () {}, 
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            if (!closeOnlyOnButtonPress)
                              IconButton(
                                icon: const Icon(LucideIcons.x, color: Colors.black),
                                onPressed: () => viewModel.close(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 14),
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        if (customContentSubtitle != null) ...[
                          customContentSubtitle!,
                          const SizedBox(height: 20),
                        ],
                        Column(
                          children: buttonList.map((button) => modalButton(context, button)).toList(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget modalButton(BuildContext context, ButtonModalModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          model.onButtonPressed();
          context.read<T>().close();
        }, 
        style: ElevatedButton.styleFrom(
          backgroundColor: model.buttonColor ,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          model.text,
          style: TextStyle(
            color: model.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
