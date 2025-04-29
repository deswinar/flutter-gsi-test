import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keanggotaan/app/injection/injection.dart';
import 'package:keanggotaan/features/identity/presentation/cubit/identity_cubit.dart';
import 'package:keanggotaan/features/profile/presentation/cubit/profile_cubit.dart';
import '../widgets/templates/profile_template.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF40916C),
        foregroundColor: Colors.white,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/edit-profile');
            },
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => locator<ProfileCubit>()..getData()),
          BlocProvider(create: (_) => locator<IdentityCubit>()..getData()),
        ],
        child: const ProfileTemplate(),
      ),
    );
  }
}
