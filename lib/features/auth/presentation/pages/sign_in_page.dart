import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keanggotaan/app/injection/injection.dart';

import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/sign_in/sign_in_cubit.dart';
import '../widgets/organisms/sign_in_card.dart';
import '../widgets/templates/auth_template.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SignInCubit>(),
      child: AuthTemplate(
        child: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              context.go('/profile');
            } else if (state is SignInFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return SignInCard(
              emailController: emailController,
              passwordController: passwordController,
              isLoading: state is SignInLoading,
              onLogin: () {
                // final email = emailController.text.trim();
                // final password = passwordController.text.trim();
                // context.read<SignInCubit>().signIn(email, password);
                context.go('/profile');
              },
              onForgotPassword: () {},
              onRegister: () {
                context.go('/sign-up');
              },
            );
          },
        ),
      ),
    );
  }
}
