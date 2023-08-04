library login_flow;

import 'package:fitness_app/bloc/login/login_bloc.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/both/about_screen.dart';
import 'package:fitness_app/view/both/login/login_send_password_page.dart';
import 'package:fitness_app/view/both/login/login_sign_in_page.dart';
import 'package:fitness_app/view/both/login/login_sign_up_page.dart';
import 'package:fitness_app/view/both/privacy_screen.dart';
import 'package:fitness_app/view/both/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widgets/widgets.dart';

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
            onPressed: () => Navigation.pushPopup(
              widget: Footer(
                commercialText: 'made with ❤️',
                socials: [
                  SocialButton(
                    text: 'Twitter',
                    onPressed: () async => await UriLaunching.launch(
                      Uri.parse('https://pornhub.com'),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.twitter),
                  )
                ],
                buttons: [
                  FooterButton(
                    text: 'About',
                    onPressed: () =>
                        Navigation.push(widget: const AboutScreen()),
                  ),
                  FooterButton(
                    text: 'Contact',
                    onPressed: () async {
                      await UriLaunching.launch(
                        Uri.parse(
                          'mailto:traumteam@email.de?subject=Angelegenheit',
                        ),
                      ).then((value) {
                        if (!value) {
                          Navigation.pop();
                          Messaging.show(
                            message: 'Could not launch url',
                          );
                        }
                      }).catchError((e) {
                        debugPrint(e.toString());
                      });
                    },
                  ),
                  FooterButton(
                    text: 'Privacy',
                    onPressed: () =>
                        Navigation.push(widget: const PrivacyScreen()),
                  ),
                  FooterButton(
                    text: 'Terms',
                    onPressed: () =>
                        Navigation.push(widget: const TermsScreen()),
                  ),
                ],
              ),
            ),
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
