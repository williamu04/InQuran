import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String? value)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Remove canRequestFocus: false and just use normal FocusNode
  final FocusNode _focusNode = FocusNode();
  String? _errorText;
  bool _hasInteracted = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateInput);
    _isPasswordVisible = widget.isPassword ? false : true;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateInput);
    _focusNode.dispose();
    super.dispose();
  }

  void _validateInput() {
    if (widget.controller.text.isNotEmpty) {
      _hasInteracted = true;
    }
    
    if (_hasInteracted && widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(widget.controller.text);
      });
    }
  }

  void _onTogglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null && _errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F9FE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? Colors.red : const Color(0xFFE5E7EB),
              width: hasError ? 1.5 : 1,
            ),
          ),
          child: TextFormField(
            focusNode: _focusNode,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword && !_isPasswordVisible,
            autofocus: false,
            enableInteractiveSelection: true,
            onTapOutside: (event) {
              _focusNode.unfocus();
            },
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            onChanged: (value) {
              if (!_hasInteracted && value.isNotEmpty) {
                setState(() {
                  _hasInteracted = true;
                });
              }
            },
            validator: widget.validator,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                        color: const Color(0xFF6B7280),
                        size: 20,
                      ),
                      onPressed: _onTogglePasswordVisibility,
                    )
                  : null,
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: hasError ? null : 0,
          child: hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: AutoSizeText(
                          _errorText!,
                          maxFontSize: 9,
                          maxLines: 1,
                          minFontSize: 6,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
