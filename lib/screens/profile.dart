import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/disclosure_button.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/models/disclosure_button.dart';
import 'package:mtqmnuns/state/disclosure_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<DisclosureButtonModel> buttonList;

  final Set<int> _expandedIndices = {};
  final double fontSize = 14;

  @override
  void initState() {
    super.initState();
    buttonList = _createButtonList();
  }
  

  List<DisclosureButtonModel> _createButtonList() {
    return [
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Notes",
        fontSize: 14,
        action: SystemAction(() => {}),
      ),
      DisclosureButtonModel(
        textWidget: Text.rich(
          TextSpan(children: [
            TextSpan(
             text:  'Favourites  ·  ',
             style: TextStyle(fontSize: 14, color: Color(0xFF672CBC), fontWeight: FontWeight.bold)
            ),
            TextSpan(
             text:  '2 Items',
             style: TextStyle(fontSize: 14, color: Color(0xFF7C8BA0), fontWeight: FontWeight.w300)
            )
          ])

        ),
        action: SystemAction(() => {}),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Points",
        fontSize: 14,
        action: SystemAction(() => {}),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: 'Help & Support',
        fontSize: 14,
        action: SystemAction(() => {}),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: "logout",
        action: SystemAction(()=> {}),
        fontSize: 14,
        showIcon: false,
        color: Color(0xFFEA4335)
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          roundedCard(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 80, maxHeight: 300),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double pohotoHeight = constraints.maxHeight * 0.35; 
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
                            child: TopBarUtility.buildDefaultTopBar(
                              context: context,
                              title: "Account Profile",
                            ),
                          ),
                          Container(
                            height: pohotoHeight,
                            width: pohotoHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              // image: DecorationImage(...),
                            ),
                          ),
                          Column(
                            children: [
                              const Text(
                                "Sebelas Maret",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Basic Account ",
                                    style: TextStyle(color: Color(0xFF994EF8), fontWeight: FontWeight.bold),
                                  ),
                                  Icon(Icons.info_outline, color: Color(0xFF994EF8), size: 14),
                                ],
                              ),
                              SizedBox(height: 10)
                            ],
                          )
                        ],
                      );
                    },
                  ),
              
            ),
          ),


          Expanded(
            child: ListView.builder(
              primary: false,
              padding: const EdgeInsets.only(top:50, left: 40,right: 40),
              itemCount: buttonList.length,
              itemBuilder: (context, index) {
                final button = buttonList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
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

          return Padding(
            padding: const EdgeInsets.only(top:6),
            child: DisclosureButton(
              model: button,
              isExpanded: _expandedIndices.contains(nestedIndex),
              onTap: () => _handleButtonTap(button, nestedIndex),
            )
          ,); 
        }).toList(),
      ),
    );
  }

  void _handleButtonTap(DisclosureButtonModel button, int index) {
    switch (button.action) {
      case NavigateAction(:var route):
        context.push(route.path);

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

  Widget unauthorized(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),

        OutlinedButton(
          onPressed: () {
            context.push('/signup');
          },
          child: const Text("Go to Signup"),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            context.push('/login');
          },
          child: const Text("Go to Login"),
        ),
        const SizedBox(height: 16),
      ],
    );

  }
}
