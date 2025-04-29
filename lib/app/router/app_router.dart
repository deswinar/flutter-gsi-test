import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:keanggotaan/features/auth/presentation/pages/getting_started_page.dart';
import 'package:keanggotaan/features/auth/presentation/pages/sign_in_page.dart';
import 'package:keanggotaan/features/auth/presentation/pages/sign_up_page.dart';
import 'package:keanggotaan/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:keanggotaan/features/profile/presentation/pages/profile_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    // Define your routes here
    GoRoute(path: '/', builder: (context, state) => const GettingStartedPage()),
    GoRoute(path: '/sign-in', builder: (context, state) => const SignInPage()),
    GoRoute(path: '/sign-up', builder: (context, state) => const SignUpPage()),
    GoRoute(path: '/profile', builder: (context, state) {
      return const ProfilePage();
    }),
    GoRoute(path: '/edit-profile', builder: (context, state) {
      return const EditProfilePage();
    }),
  ],
);
