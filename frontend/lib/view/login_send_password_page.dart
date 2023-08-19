library login_flow;

import 'package:fitnessapp/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class LoginSendPasswordPage extends StatelessWidget {
  const LoginSendPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text('Send Password', style: context.textTheme.titleLarge),
          const SizedBox(height: 5),
          Row(
            children: [
              Text('Have your Password? ', style: context.textTheme.labelSmall),
              TextButton(
                onPressed: () =>
                    BlocProvider.of<LoginBloc>(context).add(LoginSignInEvent()),
                child: Text(
                  'Sign In',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          TextFieldWidget(
            (BlocProvider.of<LoginBloc>(context).state
                    as LoginSendPasswordState)
                .emailBloc,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
