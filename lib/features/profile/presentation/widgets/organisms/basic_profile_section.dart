import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keanggotaan/features/profile/presentation/cubit/profile_cubit.dart';
import '../molecules/profile_info_tile.dart';

class BasicProfileSection extends StatelessWidget {
  const BasicProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator(),);
        } else if (state is ProfileLoaded) {
          final profile = state.item;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Basic Info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ProfileInfoTile(label: 'Full Name', value: profile.fullName),
              ProfileInfoTile(label: 'Gender', value: profile.gender),
              ProfileInfoTile(label: 'Status', value: profile.status),
            ],
          );
        } else if (state is ProfileError) {
          return Text(state.message, style: const TextStyle(color: Colors.red));
        }
        return const SizedBox();
      },
    );
  }
}
