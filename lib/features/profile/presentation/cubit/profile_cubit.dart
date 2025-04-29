import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart'; // Import the UpdateProfileUseCase
import '../../domain/entities/profile_entity.dart';
import '../../presentation/models/profile_ui_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit(this.getProfileUseCase, this.updateProfileUseCase) 
      : super(ProfileInitial());

  // Fetch Profile Data
  Future<void> getData() async {
    emit(ProfileLoading());
    final result = await getProfileUseCase(NoParams());
    result.fold(
      (failure) => emit(ProfileError(_mapFailureToMessage(failure))),
      (items) => emit(ProfileLoaded(_mapEntityToUiModel(items))),
    );
  }

  // Update Profile Data
  Future<void> updateProfile(ProfileUiModel model) async {
    emit(ProfileLoading());
    final result = await updateProfileUseCase(UpdateProfileParams(
      fullName: model.fullName,
      gender: model.gender,
    ));
    
    result.fold(
      (failure) => emit(ProfileError(_mapFailureToMessage(failure))), // Handle failure
      (_) {
        getData();
      },
    );
  }

  // Convert domain entity to UI model
  ProfileUiModel _mapEntityToUiModel(ProfileEntity entity) {
    return ProfileUiModel.fromEntity(entity);
  }

  // Map failure to a message
  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
