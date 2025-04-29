import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keanggotaan/features/identity/presentation/cubit/identity_cubit.dart';
import '../molecules/identity_content.dart';

class IdentitySection extends StatelessWidget {
  const IdentitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IdentityCubit, IdentityState>(
      builder: (context, state) {
        if (state is IdentityLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is IdentityLoaded) {
          return IdentityContent(identity: state.item);
        } else if (state is IdentityError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
