import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  final int initialPage;
  final dynamic Function(
      TextFieldController email, TextFieldController password) onEmailSignUp;
  final dynamic Function(
      TextFieldController email, TextFieldController password) onEmailSignIn;
  final dynamic Function(TextFieldController email) onEmailSendPassword;
  final dynamic Function(TextFieldController phone) onPhoneSendCode;
  final dynamic Function()? onAppleLogin;
  final Widget? termsScreen;

  const LoginPage({
    this.initialPage = 1,
    required this.onEmailSignUp,
    this.termsScreen,
    required this.onEmailSignIn,
    required this.onEmailSendPassword,
    required this.onPhoneSendCode,
    this.onAppleLogin,
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late PageController pageController;

  get page => pageController.hasClients
      ? pageController.page!.round()
      : widget.initialPage;

  final GlobalKey _pageViewKey = GlobalKey<State<StatefulWidget>>();
  final GlobalKey _signUpKey = GlobalKey<SignUpViewState>();
  final GlobalKey _signInKey = GlobalKey<SignInViewState>();
  final GlobalKey _sendPasswordKey = GlobalKey<SendPasswordViewState>();

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);
    pageController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => ScaffoldWidget(
        title: [
          'Sign Up',
          'Sign In',
          'Send Password',
        ][page],
        body: OrientationBuilderWidget(
          portraitBuilder: portraitLogin,
          landscapeBuilder: landscapeLogin,
        ),
        actions: const [
          BrigthnessSwitchComponent(),
        ],
      );

  Widget portraitLogin(BuildContext context) => SafeArea(
        child: ColumnWidget(
          maxWidth: 600,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView(
                  key: _pageViewKey,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    SignUpView(
                      key: _signUpKey,
                      toSignIn: () => pageController.go(1),
                      signUp: (email, password, agree) async {
                        TextInput.finishAutofillContext();
                        FocusScope.of(context).unfocus();

                        if (!agree.state) {
                          ToastController()
                              .show('Please agree to the Terms of Service.');
                          return;
                        }
                        if (!email.isValid() || !password.isValid()) return;

                        try {
                          await widget.onEmailSignUp(email, password);
                        } catch (e) {
                          password.setError(e.toString());
                          return;
                        }
                      },
                      agreementText: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            'I have read and agree to the ',
                            style: context.textTheme.labelSmall,
                          ),
                          TextWidget('Terms of Service',
                              style: context.textTheme.labelSmall,
                              color: context.config.primaryColor,
                              onTap: () => widget.termsScreen == null
                                  ? null
                                  : Navigation.push(
                                      widget: widget.termsScreen!)),
                          TextWidget(
                            '.',
                            style: context.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    SignInView(
                      key: _signInKey,
                      toSignUp: () => pageController.go(0),
                      toSendPassword: () => pageController.go(2),
                      signIn: (email, password) async {
                        TextInput.finishAutofillContext();
                        FocusScope.of(context).unfocus();

                        if (!email.isValid() || !password.isValid()) return;

                        try {
                          await widget.onEmailSignIn(email, password);
                        } catch (e) {
                          password.setError(e.toString());
                          return;
                        }
                      },
                    ),
                    SendPasswordView(
                      key: _sendPasswordKey,
                      toSignIn: () => pageController.go(1),
                      sendPassword: (email) async {
                        TextInput.finishAutofillContext();
                        FocusScope.of(context).unfocus();

                        if (!email.isValid()) return;

                        try {
                          await widget.onEmailSendPassword(email);
                        } catch (e) {
                          email.setError(e.toString());
                          return;
                        }
                      },
                    ),
                  ]),
            ),
            ElevatedButtonWidget(
              [
                'Sign Up',
                'Sign In',
                'Send Password',
              ][page],
              onPressed: () async {
                await [
                  (_signUpKey.currentState as SignUpViewState?)?.signUp,
                  (_signInKey.currentState as SignInViewState?)?.signIn,
                  (_sendPasswordKey.currentState as SendPasswordViewState?)
                      ?.sendPassword,
                ][page]
                    ?.call();
              },
              margin: EdgeInsets.fromLTRB(
                context.config.padding,
                0,
                context.config.padding,
                context.config.paddingH,
              ),
            ),
            const DividerWidget('Or Login with'),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  context.config.paddingH, 0, context.config.paddingH, 0),
              child: Row(
                children: [
                  // other authentication providers possible
                  Expanded(
                    child: ThirdPartyLoginButton(
                      'Phone',
                      Icons.phone_rounded,
                      onPressed: () async =>
                          Navigation.pushPopup(widget: SendPhoneCodeView(
                        onSendPhoneCode: (phone) async {
                          TextInput.finishAutofillContext();
                          FocusScope.of(context).unfocus();

                          if (!phone.isValid()) return;

                          try {
                            await widget.onPhoneSendCode(phone);
                          } catch (e) {
                            phone.setError(e.toString());
                            return;
                          }
                        },
                      )),
                    ),
                  ),
                  if (widget.onAppleLogin != null)
                    Expanded(
                      child: ThirdPartyLoginButton('Apple', Icons.apple_rounded,
                          onPressed: () async {
                        TextInput.finishAutofillContext();
                        FocusScope.of(context).unfocus();
                        try {
                          await widget.onAppleLogin!();
                        } catch (e) {
                          ToastController().show(e);
                          return;
                        }
                      }),
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget landscapeLogin(BuildContext context) => SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.config.padding,
            context.config.padding,
            context.config.padding,
            context.config.padding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: PageView(
                    scrollDirection: Axis.vertical,
                    key: _pageViewKey,
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      SignUpView(
                        key: _signUpKey,
                        toSignIn: () => pageController.go(1),
                        signUp: (email, password, agree) async {
                          TextInput.finishAutofillContext();
                          FocusScope.of(context).unfocus();

                          if (!agree.state) {
                            ToastController()
                                .show('Please agree to the Terms of Service.');
                            return;
                          }
                          if (!email.isValid() || !password.isValid()) {
                            return;
                          }

                          try {
                            await widget.onEmailSignUp(email, password);
                          } catch (e) {
                            password.setError(e.toString());
                            return;
                          }
                        },
                        agreementText: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              'I have read and agree to the ',
                              style: context.textTheme.labelSmall,
                            ),
                            TextWidget('Terms of Service',
                                style: context.textTheme.labelSmall,
                                color: context.config.primaryColor,
                                onTap: () => widget.termsScreen == null
                                    ? null
                                    : Navigation.push(
                                        widget: widget.termsScreen!)),
                            TextWidget(
                              '.',
                              style: context.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      SignInView(
                        key: _signInKey,
                        toSignUp: () => pageController.go(0),
                        toSendPassword: () => pageController.go(2),
                        signIn: (email, password) async {
                          TextInput.finishAutofillContext();
                          FocusScope.of(context).unfocus();

                          if (!email.isValid() || !password.isValid()) {
                            return;
                          }

                          try {
                            await widget.onEmailSignIn(email, password);
                          } catch (e) {
                            password.setError(e.toString());
                            return;
                          }
                        },
                      ),
                      SendPasswordView(
                        key: _sendPasswordKey,
                        toSignIn: () => pageController.go(1),
                        sendPassword: (email) async {
                          TextInput.finishAutofillContext();
                          FocusScope.of(context).unfocus();

                          if (!email.isValid()) return;

                          try {
                            await widget.onEmailSendPassword(email);
                          } catch (e) {
                            email.setError(e.toString());
                            return;
                          }
                        },
                      ),
                    ]),
              ),
              Expanded(
                flex: 2,
                child: ColumnWidget(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButtonWidget(
                      [
                        'Sign Up',
                        'Sign In',
                        'Send Password',
                      ][page],
                      onPressed: () async {
                        await [
                          (_signUpKey.currentState as SignUpViewState?)?.signUp,
                          (_signInKey.currentState as SignInViewState?)?.signIn,
                          (_sendPasswordKey.currentState
                                  as SendPasswordViewState?)
                              ?.sendPassword,
                        ][page]
                            ?.call();
                      },
                      margin: EdgeInsets.fromLTRB(
                        context.config.padding,
                        context.config.padding,
                        context.config.padding,
                        context.config.paddingH,
                      ),
                    ),
                    const DividerWidget('Or Login with'),
                    Padding(
                      padding: EdgeInsets.fromLTRB(context.config.paddingH, 0,
                          context.config.paddingH, context.config.paddingH),
                      child: Row(
                        children: [
                          // other authentication providers possible
                          Expanded(
                            child: ThirdPartyLoginButton(
                              'Phone',
                              Icons.phone_rounded,
                              onPressed: () async => Navigation.pushPopup(
                                  widget: SendPhoneCodeView(
                                onSendPhoneCode: (phone) async {
                                  TextInput.finishAutofillContext();
                                  FocusScope.of(context).unfocus();

                                  if (!phone.isValid()) return;

                                  try {
                                    await widget.onPhoneSendCode(phone);
                                  } catch (e) {
                                    phone.setError(e.toString());
                                    return;
                                  }
                                },
                              )),
                            ),
                          ),
                          if (widget.onAppleLogin != null)
                            Expanded(
                              child: ThirdPartyLoginButton(
                                  'Apple', Icons.apple_rounded,
                                  onPressed: () async {
                                TextInput.finishAutofillContext();
                                FocusScope.of(context).unfocus();
                                try {
                                  await widget.onAppleLogin!();
                                } catch (e) {
                                  ToastController().show(e);
                                  return;
                                }
                              }),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
