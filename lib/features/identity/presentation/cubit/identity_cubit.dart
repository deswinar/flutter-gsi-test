import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_identity_usecase.dart';
import '../../domain/usecases/update_identity_usecase.dart';
import '../../domain/entities/identity_entity.dart';
import '../../presentation/models/identity_ui_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

part 'identity_state.dart';

@injectable
class IdentityCubit extends Cubit<IdentityState> {
  final GetIdentityUseCase getIdentityUseCase;
  final UpdateIdentityUseCase updateIdentityUseCase;

  IdentityCubit(this.getIdentityUseCase, this.updateIdentityUseCase)
      : super(IdentityInitial());

  Future<void> getData() async {
    emit(IdentityLoading());
    final result = await getIdentityUseCase(NoParams());
    result.fold(
      (failure) => emit(IdentityError(_mapFailureToMessage(failure))),
      (items) => emit(IdentityLoaded(_mapEntityToUiModel(items))),
    );
  }

  Future<void> updateIdentity(IdentityUiModel model) async {
    emit(IdentityLoading());
    final result = await updateIdentityUseCase(UpdateIdentityParams(
      identityId: model.identityId,
      identityPhoto: model.identityPhoto,
      address: model.address,
    ));

    result.fold(
      (failure) => emit(IdentityError(_mapFailureToMessage(failure))),
      (_) {
        getData();
      },
    );
  }

  IdentityUiModel _mapEntityToUiModel(IdentityEntity entity) {
    return IdentityUiModel.fromEntity(entity);
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
