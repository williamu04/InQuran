import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/components/popup_modal.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/screens/home_main.dart';
import 'package:mtqmnuns/screens/home_voice.dart';
import 'package:mtqmnuns/state/user.dart';
import 'package:mtqmnuns/viewmodel/toggleable.dart';
import 'package:mtqmnuns/viewmodel/user.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ToggleableUiController sessionExpiredPopUpController =
      ToggleableUiController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().loadUser();
    });
    super.initState();
  }

  Future<bool> _onWillPop() async {
    // Close the app when back button is pressed
    SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          Consumer<GlobalConfig>(
            builder: (context, config, _) {
              if (config.isVoiceMode) {
                return VoiceHomeScreen();
              } else {
                return MainHomeScreen();
              }
            },
          ),
          Consumer<UserViewModel>(
            builder: (context, vm, _) {
              if (vm.state is UserLoadSessionExpired) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  sessionExpiredPopUpController.open();
                });
              }
              if (vm.state is UserLoadUnauthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  sessionExpiredPopUpController.close();
                });
              }
              return SizedBox.shrink();
            },
          ),
          PopUpModal(
            title: "Sesion Expired",
            subtitle: "Apakah Kamu Ingin Login Kembali?",
            controller: sessionExpiredPopUpController,
            onClosed: () {
              context.read<UserViewModel>().setState(UserLoadUnauthenticated());
            },
            buttonList: [
              ButtonModalModel(
                text: "Login",
                onButtonPressed: () {
                  context.push(AppRoutes.login.path);
                },
              ),
              ButtonModalModel(
                text: "Batal",
                textColor: Colors.red,
                buttonColor: Colors.white,
                onButtonPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
