import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/components/disclosure_button.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/models/disclosure_button.dart';
import 'package:mtqmnuns/state/disclosure_button.dart';
import 'package:mtqmnuns/viewmodel/drawer.dart';
import 'package:provider/provider.dart';

class GenericDrawer<T extends SlideDrawerViewModel> extends StatefulWidget {
  final Duration duration;
  final String title;
  final SlideDirection slideDirection;
  final List<DisclosureButtonModel> Function(GlobalConfig) createButtonList;
  final T Function(BuildContext) getViewModel;

  const GenericDrawer({
    super.key,
    this.duration = const Duration(milliseconds: 300),
    required this.title,
    required this.slideDirection,
    required this.createButtonList,
    required this.getViewModel,
  });

  @override
  State<GenericDrawer<T>> createState() => _GenericDrawerState<T>();
}

enum SlideDirection { left, right }

class _GenericDrawerState<T extends SlideDrawerViewModel> extends State<GenericDrawer<T>>
    with SingleTickerProviderStateMixin {
  final Set<int> _expandedIndices = {};

  late List<DisclosureButtonModel> buttonList;
  late AnimationController _controller;
  late ScrollController _listScrollController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _listScrollController = ScrollController();
    buttonList = widget.createButtonList(context.read<GlobalConfig>());
    context.read<GlobalConfig>().addListener(_onGlobalConfigChanged);
  }

  void _onGlobalConfigChanged() {
    if (!mounted) return;
    setState(() {
      buttonList = List.of(widget.createButtonList(context.read<GlobalConfig>()));
    });
  }

  @override
  void dispose() {
    context.read<GlobalConfig>().removeListener(_onGlobalConfigChanged);
    _listScrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDrawerContent(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          // Header
          roundedCard(
            padding: const EdgeInsets.only(top: 70, bottom: 25, left: 40, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontFamily: 'Plus Jakarta',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    LucideIcons.x,
                    size: 30,
                    color: Color(0xFF672CBC),
                  ),
                  onPressed: () => _closeDrawer(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: _listScrollController,
              primary: false,
              padding: const EdgeInsets.all(10),
              itemCount: buttonList.length,
              itemBuilder: (context, index) {
                final button = buttonList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DisclosureButton(
                        model: button,
                        isExpanded: _expandedIndices.contains(index),
                        onTap: () => _handleButtonTap(button, index),
                      ),
                      if (_expandedIndices.contains(index) && button.action is ExpandNestedDrawerAction)
                        _buildNestedDrawer((button.action as ExpandNestedDrawerAction).nestedButtons)
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNestedDrawer(List<DisclosureButtonModel> buttons) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buttons.asMap().entries.map((entry) {
          final nestedIndex = entry.key;
          final button = entry.value;

          return DisclosureButton(
            model: button,
            isExpanded: _expandedIndices.contains(nestedIndex),
            onTap: () => _handleButtonTap(button, nestedIndex),
          );
        }).toList(),
      ),
    );
  }

  void _handleButtonTap(DisclosureButtonModel button, int index) {
    switch (button.action) {
      case NavigateAction(:var route):
        context.push(route.path);
        _closeDrawer();

      case SystemAction(:var function):
        function();

      case ExpandNestedDrawerAction():
        setState(() {
          if (_expandedIndices.contains(index)) {
            _expandedIndices.remove(index);
          } else {
            _expandedIndices.add(index);
          }
        });
    }
  }

  void _closeDrawer() {
    widget.getViewModel(context).close();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final slideOffset = widget.slideDirection == SlideDirection.left 
        ? const Offset(-1, 0) 
        : const Offset(1, 0);
    
    final slide = Tween<Offset>(
      begin: slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    return Consumer<T>(
      builder: (context, viewModel, child) {
        final isOpen = viewModel.isOpen;
        
        if (isOpen && _controller.status != AnimationStatus.forward && _controller.status != AnimationStatus.completed) {
          buttonList = widget.createButtonList(context.read<GlobalConfig>());
          _controller.forward();
        } else if (!isOpen && _controller.status != AnimationStatus.reverse && _controller.status != AnimationStatus.dismissed) {
          _controller.reverse().then((_) {
            if (!mounted) return;
            setState(() {
              _expandedIndices.clear();
              _listScrollController.dispose();
              _listScrollController = ScrollController();
            });
          });
        }

        return Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return _controller.value > 0
                    ? GestureDetector(
                        onTap: () => _closeDrawer(),
                        child: Container(
                          color: Colors.black.withOpacity(0.5 * _controller.value),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
            SlideTransition(
              position: slide,
              child: SizedBox(width: width, child: _buildDrawerContent(context)),
            ),
          ],
        );
      },
    );
  }
}
