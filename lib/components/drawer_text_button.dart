
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/routes/route_model.dart';
import 'package:mtqmnuns/viewmodel/drawer.dart';


class TextButtonDrawer extends StatefulWidget {
  final TextButtonDrawerModel model;
  final SlideDrawerViewModel viewModel;

  const TextButtonDrawer({
    super.key,
    required this.model,
    required this.viewModel,
  });

  @override
  State<TextButtonDrawer> createState() => _TextButtonDrawerState();
}

class _TextButtonDrawerState extends State<TextButtonDrawer>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _handleAction(BuildContext context, DrawerAction action) {
    if (action is NavigateAction) {
      context.push(action.route.path);
      widget.viewModel.close();
    } else if (action is SystemAction) {
      action.function();
    } else if (action is ExpandNestedDrawerAction) {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.consumer == null) {
      return _buildButton(context);
    }

    return AnimatedBuilder(
      animation: widget.model.consumer!,
      builder: (context, _) => _buildButton(context),
    );
  }

  Widget _buildNestedDrawer(ExpandNestedDrawerAction action) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: action.nestedButtons
            .map((b) =>
                TextButtonDrawer(model: b, viewModel: widget.viewModel))
            .toList(),
      ),
    );
  }


  Widget _buildButton(BuildContext context) {

    final action = widget.model.action;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _handleAction(context, action),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.model.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.model.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (action is ExpandNestedDrawerAction)
                  Icon(
                    _isExpanded
                        ? LucideIcons.chevronDown
                        : LucideIcons.chevronRight,
                    size: 20,
                    color: widget.model.color,
                  )
                else if (widget.model.showIcon)
                  Icon(LucideIcons.chevronRight,
                      size: 20, color: widget.model.color),
              ],
            ),
          ),
        ),

        // Expandable children
        if (action is ExpandNestedDrawerAction && _isExpanded) _buildNestedDrawer(action)
        else const SizedBox.shrink(),
      ],
    );
  }
}


class TextButtonDrawerModel {
  final String text;
  final DrawerAction action;
  final Color Function()? dynamicColor;
  final bool showIcon;
  final ChangeNotifier? consumer;

  TextButtonDrawerModel(
    {
    required this.text,
    required this.action,
    this.consumer,
    this.dynamicColor,
    this.showIcon = true,
  });
    Color get color => dynamicColor?.call() ?? const Color(0xFF672CBC);
}


abstract class DrawerAction {}

class NavigateAction extends DrawerAction {
  final AppRoute route;
  NavigateAction(this.route);
}

class SystemAction extends DrawerAction {
  final VoidCallback function;
  SystemAction(this.function);
}

class ExpandNestedDrawerAction extends DrawerAction {
  final List<TextButtonDrawerModel> nestedButtons;
  ExpandNestedDrawerAction(this.nestedButtons);
}
