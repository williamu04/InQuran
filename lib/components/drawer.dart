import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/components/drawer_text_button.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/viewmodel/drawer.dart';

enum DrawerSide { left, right }

class SlideDrawer extends StatefulWidget {
  final DrawerSide side;
  final Duration duration = const Duration(milliseconds: 300);
  final String title;
  final List<TextButtonDrawerModel> textButtonList;
  final SlideDrawerViewModel viewModel;

  const SlideDrawer({
    Key? key,
    this.side = DrawerSide.left,
    required this.title,
    required this.textButtonList, 
    required this.viewModel,
  }) : super(key: key);

  @override
  State<SlideDrawer> createState() => SlideDrawerState();
}

class SlideDrawerState extends State<SlideDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    widget.viewModel.addListener(() {
      if (widget.viewModel.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDrawerContent(BuildContext context) {
    return Material( 
      color: Colors.white,
      child: Column(
        children: [
          RoundedCard(
            padding: const EdgeInsets.only(
                top: 70, bottom: 25, left: 40, right: 20),
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
                  onPressed: () => widget.viewModel.close(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: widget.textButtonList.length,
              itemBuilder: (context, index) {
                final button = widget.textButtonList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2, horizontal: 15),
                  child: TextButtonDrawer(
                    model: button,
                    viewModel: widget.viewModel,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final slide = Tween<Offset>(
      begin:
          widget.side == DrawerSide.left
              ? const Offset(-1, 0)
              : const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return _controller.value > 0
                ? GestureDetector(
                  onTap: () => widget.viewModel.close(),
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
  }
}
