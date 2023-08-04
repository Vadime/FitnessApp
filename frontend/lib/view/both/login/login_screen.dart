library login_flow;

import 'package:fitness_app/bloc/login/login_bloc.dart';
import 'package:fitness_app/utils/src/navigation.dart';
import 'package:fitness_app/view/both/login/login_send_password_page.dart';
import 'package:fitness_app/view/both/login/login_sign_in_page.dart';
import 'package:fitness_app/view/both/login/login_sign_up_page.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension on PageController {
  void goToPage(int page) => animateToPage(
        page,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 200),
      );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late PageController pageController;

  var initialState = LoginSignInState();

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: initialState.page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Navigation.pushPopup(widget: const HomeFooter()),
          ),
        ],
        title: const Text(
          String.fromEnvironment('title'),
        ),
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(
          initialState: initialState,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: const [
                  SignUpPage(),
                  SignInPage(),
                  SendPasswordPage(),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) =>
                      pageController.goToPage(state.page),
                  builder: (context, state) => ElevatedButton(
                    onPressed: () async => await state.onDone(context),
                    child: Text(state.name),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
