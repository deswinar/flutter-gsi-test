#!/bin/bash

# Usage info
if [ -z "$1" ]; then
  echo "Usage: $0 <FeatureName> [--fetch] [--create] [--update] [--delete] [--detail] [--bottom-nav]"
  exit 1
fi

FEATURE_NAME_RAW=$1
shift # remove the first argument so we can parse the flags
FEATURE_NAME=$(echo "$FEATURE_NAME_RAW" | sed -r 's/([A-Z])/_\L\1/g' | sed -r 's/^_//')
PASCAL_CASE=$(echo "$FEATURE_NAME" | sed -r 's/(^|_)([a-z])/\U\2/g')

# Flags
FETCH=false
CREATE=false
UPDATE=false
DELETE=false
DETAIL=false
BOTTOM_NAV=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --fetch) FETCH=true ;;
    --create) CREATE=true ;;
    --update) UPDATE=true ;;
    --delete) DELETE=true ;;
    --detail) DETAIL=true ;;
    --bottom-nav) BOTTOM_NAV=true ;;
    *) echo "Unknown flag: $1"; exit 1 ;;
  esac
  shift
done

# Base path
BASE_PATH="lib/features/$FEATURE_NAME"

# Directory structure
mkdir -p $BASE_PATH/data/datasources
mkdir -p $BASE_PATH/data/models
mkdir -p $BASE_PATH/data/repositories
mkdir -p $BASE_PATH/domain/entities
mkdir -p $BASE_PATH/domain/repositories
mkdir -p $BASE_PATH/domain/usecases
mkdir -p $BASE_PATH/presentation/cubit
mkdir -p $BASE_PATH/presentation/models
mkdir -p $BASE_PATH/presentation/pages
mkdir -p $BASE_PATH/presentation/widgets/templates
mkdir -p $BASE_PATH/presentation/widgets/atoms
mkdir -p $BASE_PATH/presentation/widgets/molecules
mkdir -p $BASE_PATH/presentation/widgets/organisms

# Core files
touch $BASE_PATH/data/models/${FEATURE_NAME}_model.dart
touch $BASE_PATH/data/repositories/${FEATURE_NAME}_repository_impl.dart
touch $BASE_PATH/data/datasources/${FEATURE_NAME}_remote_data_source.dart
touch $BASE_PATH/data/datasources/${FEATURE_NAME}_local_data_source.dart
touch $BASE_PATH/presentation/cubit/${FEATURE_NAME}_cubit.dart
touch $BASE_PATH/presentation/cubit/${FEATURE_NAME}_state.dart
touch $BASE_PATH/presentation/models/${FEATURE_NAME}_ui_model.dart
touch $BASE_PATH/presentation/pages/${FEATURE_NAME}_page.dart
touch $BASE_PATH/presentation/widgets/templates/${FEATURE_NAME}_template.dart
touch $BASE_PATH/presentation/widgets/molecules/${FEATURE_NAME}_card.dart
touch $BASE_PATH/presentation/widgets/organisms/${FEATURE_NAME}_list.dart

# Entity boilerplate
ENTITY_FILE="$BASE_PATH/domain/entities/${FEATURE_NAME}_entity.dart"
cat <<EOF > $ENTITY_FILE
import 'package:equatable/equatable.dart';

class ${PASCAL_CASE}Entity extends Equatable {
  final String id;
  final String name;

  ${PASCAL_CASE}Entity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
EOF

# Repository Interface boilerplate
REPO_FILE="$BASE_PATH/domain/repositories/${FEATURE_NAME}_repository.dart"
cat <<EOF > $REPO_FILE
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/${FEATURE_NAME}_entity.dart';

abstract class ${PASCAL_CASE}Repository {
EOF

[ "$FETCH" = true ] && echo "  Future<Either<Failure, List<${PASCAL_CASE}Entity>>> get${PASCAL_CASE}s();" >> $REPO_FILE
[ "$CREATE" = true ] && echo "  Future<Either<Failure, void>> create${PASCAL_CASE}(${PASCAL_CASE}Entity entity);" >> $REPO_FILE
[ "$UPDATE" = true ] && echo "  Future<Either<Failure, void>> update${PASCAL_CASE}(${PASCAL_CASE}Entity entity);" >> $REPO_FILE
[ "$DELETE" = true ] && echo "  Future<Either<Failure, void>> delete${PASCAL_CASE}(String id);" >> $REPO_FILE
[ "$DETAIL" = true ] && echo "  Future<Either<Failure, ${PASCAL_CASE}Entity>> get${PASCAL_CASE}Detail(String id);" >> $REPO_FILE

echo "}" >> $REPO_FILE

# UseCase boilerplate generation
USECASE_PATH="$BASE_PATH/domain/usecases"

generate_usecase() {
  local action=$1
  local suffix=$2
  local method_prefix=$suffix
  local class_name="${method_prefix}${PASCAL_CASE}UseCase"
  local file_action=$action

  # Rename for 'fetch' action to get plural form
  if [ "$action" = "fetch" ]; then
    method_prefix="Get"
    file_action="get"
    class_name="${method_prefix}${PASCAL_CASE}sUseCase"
    # Add 's' to the filename for fetch action (to denote a list)
    local file_name="get_${FEATURE_NAME}s_usecase.dart"
  else
    local file_name="${file_action}_${FEATURE_NAME}_usecase.dart"
  fi

  # Return type
  local return_type="void"
  if [ "$action" = "fetch" ]; then
    return_type="List<${PASCAL_CASE}Entity>"
  fi

  # Param class & call parameters
  local param_class="Params"
  local call_params="Params params"
  local call_args="params"

  if [ "$action" = "fetch" ]; then
    param_class="NoParams"
    call_params="NoParams params"
    call_args=""
  elif [ "$action" = "create" ] || [ "$action" = "update" ]; then
    param_class="${PASCAL_CASE}Params"
    call_params="$param_class params"
    call_args="params.entity"
  elif [ "$action" = "delete" ]; then
    param_class="${PASCAL_CASE}IdParams"
    call_params="$param_class params"
    call_args="params.id"
  fi

  # Repository method
  local repo_call="${action}${PASCAL_CASE}"
  if [ "$action" = "fetch" ]; then
    repo_call="get${PASCAL_CASE}s"
  fi

  # Generate Dart usecase file
  cat <<EOF > $USECASE_PATH/$file_name
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/${FEATURE_NAME}_repository.dart';
import '../entities/${FEATURE_NAME}_entity.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class $class_name implements UseCase<$return_type, $param_class> {
  final ${PASCAL_CASE}Repository repository;

  $class_name(this.repository);

  @override
  Future<Either<Failure, $return_type>> call($call_params) async {
    return repository.$repo_call($call_args);
  }
}
EOF

  generate_params_class "$param_class" "$action" >> $USECASE_PATH/$file_name
}

generate_params_class() {
  local param_class=$1
  local action=$2

  if [ "$param_class" = "NoParams" ]; then
    echo ""
  elif [ "$action" = "create" ] || [ "$action" = "update" ]; then
    cat <<PARAMS

class $param_class {
  final ${PASCAL_CASE}Entity entity;

  $param_class(this.entity);
}
PARAMS
  elif [ "$action" = "delete" ]; then
    cat <<PARAMS

class $param_class {
  final String id;

  $param_class(this.id);
}
PARAMS
  fi
}

[ "$FETCH" = true ] && generate_usecase "fetch" "Get"
[ "$CREATE" = true ] && generate_usecase "create" "Create"
[ "$UPDATE" = true ] && generate_usecase "update" "Update"
[ "$DELETE" = true ] && generate_usecase "delete" "Delete"

# Model boilerplate
MODEL_FILE="$BASE_PATH/data/models/${FEATURE_NAME}_model.dart"
cat <<EOF > $MODEL_FILE
import '../../domain/entities/${FEATURE_NAME}_entity.dart';

class ${PASCAL_CASE}Model extends ${PASCAL_CASE}Entity {
  ${PASCAL_CASE}Model({
    required String id,
    required String name,
  }) : super(id: id, name: name);

  factory ${PASCAL_CASE}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_CASE}Model(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ${PASCAL_CASE}Model.fromEntity(${PASCAL_CASE}Entity entity) {
    return ${PASCAL_CASE}Model(
      id: entity.id,
      name: entity.name,
    );
  }

  ${PASCAL_CASE}Entity toEntity() {
    return ${PASCAL_CASE}Entity(
      id: id,
      name: name,
    );
  }
}
EOF

# Repository Implementation boilerplate
REPO_IMPL="$BASE_PATH/data/repositories/${FEATURE_NAME}_repository_impl.dart"
cat <<EOF > $REPO_IMPL
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/${FEATURE_NAME}_repository.dart';
import '../../domain/entities/${FEATURE_NAME}_entity.dart';
import '../models/${FEATURE_NAME}_model.dart';
import '../datasources/${FEATURE_NAME}_remote_data_source.dart';

@LazySingleton(as: ${PASCAL_CASE}Repository)
class ${PASCAL_CASE}RepositoryImpl implements ${PASCAL_CASE}Repository {
  final ${PASCAL_CASE}RemoteDataSource remoteDataSource;

  ${PASCAL_CASE}RepositoryImpl(this.remoteDataSource);
EOF

if [ "$FETCH" = true ]; then
cat <<EOF >> $REPO_IMPL

  @override
  Future<Either<Failure, List<${PASCAL_CASE}Entity>>> get${PASCAL_CASE}s() async {
    try {
      final result = await remoteDataSource.fetch${PASCAL_CASE}s();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }
EOF
fi

if [ "$CREATE" = true ]; then
cat <<EOF >> $REPO_IMPL

  @override
  Future<Either<Failure, void>> create${PASCAL_CASE}(${PASCAL_CASE}Entity entity) async {
    try {
      final model = ${PASCAL_CASE}Model.fromEntity(entity);
      await remoteDataSource.create${PASCAL_CASE}(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }
EOF
fi

if [ "$UPDATE" = true ]; then
cat <<EOF >> $REPO_IMPL

  @override
  Future<Either<Failure, void>> update${PASCAL_CASE}(${PASCAL_CASE}Entity entity) async {
    try {
      final model = ${PASCAL_CASE}Model.fromEntity(entity);
      await remoteDataSource.update${PASCAL_CASE}(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }
EOF
fi

if [ "$DELETE" = true ]; then
cat <<EOF >> $REPO_IMPL

  @override
  Future<Either<Failure, void>> delete${PASCAL_CASE}(String id) async {
    try {
      await remoteDataSource.delete${PASCAL_CASE}(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }
EOF
fi

if [ "$DETAIL" = true ]; then
cat <<EOF >> $REPO_IMPL

  @override
  Future<Either<Failure, ${PASCAL_CASE}Entity>> get${PASCAL_CASE}Detail(String id) async {
    try {
      final result = await remoteDataSource.fetch${PASCAL_CASE}Detail(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }
EOF
fi

# Close class
echo "}" >> $REPO_IMPL

# Remote Data Source boilerplate
REMOTE_DATASOURCE="$BASE_PATH/data/datasources/${FEATURE_NAME}_remote_data_source.dart"
cat <<EOF > "$REMOTE_DATASOURCE"
import 'package:injectable/injectable.dart';
import '../models/${FEATURE_NAME}_model.dart';

abstract class ${PASCAL_CASE}RemoteDataSource {
$(
  [ "$FETCH" = true ] && echo "  Future<List<${PASCAL_CASE}Model>> fetch${PASCAL_CASE}s();"
  [ "$DETAIL" = true ] && echo "  Future<${PASCAL_CASE}Model> fetch${PASCAL_CASE}Detail(String id);"
  [ "$CREATE" = true ] && echo "  Future<void> create${PASCAL_CASE}(${PASCAL_CASE}Model model);"
  [ "$UPDATE" = true ] && echo "  Future<void> update${PASCAL_CASE}(${PASCAL_CASE}Model model);"
  [ "$DELETE" = true ] && echo "  Future<void> delete${PASCAL_CASE}(String id);"
)
}

@LazySingleton(as: ${PASCAL_CASE}RemoteDataSource)
class ${PASCAL_CASE}RemoteDataSourceImpl implements ${PASCAL_CASE}RemoteDataSource {
$(
  [ "$FETCH" = true ] && cat <<METHOD
  @override
  Future<List<${PASCAL_CASE}Model>> fetch${PASCAL_CASE}s() async {
    // TODO: Implement actual API call
    return [];
  }
METHOD

  [ "$DETAIL" = true ] && cat <<METHOD
  @override
  Future<${PASCAL_CASE}Model> fetch${PASCAL_CASE}Detail(String id) async {
    // TODO: Implement actual API call
    return ${PASCAL_CASE}Model(id: 'defaultId', name: 'defaultName'); // Replace with real response
  }
METHOD

  [ "$CREATE" = true ] && cat <<METHOD
  @override
  Future<void> create${PASCAL_CASE}(${PASCAL_CASE}Model model) async {
    // TODO: Implement actual API call
  }
METHOD

  [ "$UPDATE" = true ] && cat <<METHOD
  @override
  Future<void> update${PASCAL_CASE}(${PASCAL_CASE}Model model) async {
    // TODO: Implement actual API call
  }
METHOD

  [ "$DELETE" = true ] && cat <<METHOD
  @override
  Future<void> delete${PASCAL_CASE}(String id) async {
    // TODO: Implement actual API call
  }
METHOD
)
}
EOF

# UI Model boilerplate
UI_MODEL_FILE="$BASE_PATH/presentation/models/${FEATURE_NAME}_ui_model.dart"
cat <<EOF > $UI_MODEL_FILE
import '../../domain/entities/${FEATURE_NAME}_entity.dart';

class ${PASCAL_CASE}UiModel {
  final String id;
  final String name;

  ${PASCAL_CASE}UiModel({
    required this.id,
    required this.name,
  });

  factory ${PASCAL_CASE}UiModel.fromEntity(${PASCAL_CASE}Entity entity) {
    return ${PASCAL_CASE}UiModel(
      id: entity.id,
      name: entity.name,
    );
  }
}
EOF

# Cubit boilerplate
CUBIT_FILE="$BASE_PATH/presentation/cubit/${FEATURE_NAME}_cubit.dart"
cat <<EOF > $CUBIT_FILE
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_${FEATURE_NAME}s_usecase.dart';
import '../../domain/entities/${FEATURE_NAME}_entity.dart';
import '../../presentation/models/${FEATURE_NAME}_ui_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

part '${FEATURE_NAME}_state.dart';

@injectable
class ${PASCAL_CASE}Cubit extends Cubit<${PASCAL_CASE}State> {
  final Get${PASCAL_CASE}sUseCase get${PASCAL_CASE}sUseCase;

  ${PASCAL_CASE}Cubit(this.get${PASCAL_CASE}sUseCase) : super(${PASCAL_CASE}Initial());

  Future<void> getData() async {
    emit(${PASCAL_CASE}Loading());
    final result = await get${PASCAL_CASE}sUseCase(NoParams());
    result.fold(
      (failure) => emit(${PASCAL_CASE}Error(_mapFailureToMessage(failure))),
      (items) => emit(${PASCAL_CASE}Loaded(_mapEntitiesToUiModels(items))),
    );
  }

  // Convert domain entity to UI model
  List<${PASCAL_CASE}UiModel> _mapEntitiesToUiModels(List<${PASCAL_CASE}Entity> entities) {
    return entities.map((entity) => ${PASCAL_CASE}UiModel.fromEntity(entity)).toList();
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
EOF

# State boilerplate
STATE_FILE="$BASE_PATH/presentation/cubit/${FEATURE_NAME}_state.dart"
cat <<EOF > $STATE_FILE

part of '${FEATURE_NAME}_cubit.dart';

abstract class ${PASCAL_CASE}State {}

class ${PASCAL_CASE}Initial extends ${PASCAL_CASE}State {}
class ${PASCAL_CASE}Loading extends ${PASCAL_CASE}State {}
class ${PASCAL_CASE}Loaded extends ${PASCAL_CASE}State {
  final List<${PASCAL_CASE}UiModel> items; # Using UI Model
  ${PASCAL_CASE}Loaded(this.items);
}
class ${PASCAL_CASE}Error extends ${PASCAL_CASE}State {
  final String message;
  ${PASCAL_CASE}Error(this.message);
}
EOF

# Card widget boilerplate
CARD_WIDGET="$BASE_PATH/presentation/widgets/molecules/${FEATURE_NAME}_card.dart"
cat <<EOF > $CARD_WIDGET
import 'package:flutter/material.dart';
import '../../../domain/entities/${FEATURE_NAME}_entity.dart';

class ${PASCAL_CASE}Card extends StatelessWidget {
  final ${PASCAL_CASE}Entity entity;

  const ${PASCAL_CASE}Card({Key? key, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(entity.name),
        subtitle: Text('ID: \${entity.id}'),
      ),
    );
  }
}
EOF

# List widget boilerplate
LIST_WIDGET="$BASE_PATH/presentation/widgets/organisms/${FEATURE_NAME}_list.dart"
cat <<EOF > $LIST_WIDGET
import 'package:flutter/material.dart';
import '../../../domain/entities/${FEATURE_NAME}_entity.dart';
import '../molecules/${FEATURE_NAME}_card.dart';

class ${PASCAL_CASE}List extends StatelessWidget {
  final List<${PASCAL_CASE}Entity> items;

  const ${PASCAL_CASE}List({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ${PASCAL_CASE}Card(entity: items[index]),
    );
  }
}
EOF

# Template boilerplate
TEMPLATE_FILE="$BASE_PATH/presentation/widgets/templates/${FEATURE_NAME}_template.dart"
cat <<EOF > $TEMPLATE_FILE
import 'package:flutter/material.dart';
import '../organisms/${FEATURE_NAME}_list.dart';
import '../../../presentation/models/${FEATURE_NAME}_ui_model.dart'; # Import UI Model

class ${PASCAL_CASE}Template extends StatelessWidget {
  final List<${PASCAL_CASE}UiModel> items;  # Use UI Model instead of Entity

  const ${PASCAL_CASE}Template({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ${PASCAL_CASE}List(items: items);  # Pass UI Models to the list widget
  }
}
EOF

# Page boilerplate (based on --bottom-nav)
PAGE_FILE="$BASE_PATH/presentation/pages/${FEATURE_NAME}_page.dart"

if [ "$BOTTOM_NAV" = true ]; then
cat <<EOF > $PAGE_FILE
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/${FEATURE_NAME}_cubit.dart';
import '../widgets/templates/${FEATURE_NAME}_template.dart';
import '../../../../app/injection/injection.dart';

class ${PASCAL_CASE}Page extends StatelessWidget {
  const ${PASCAL_CASE}Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<${PASCAL_CASE}Cubit>()..getData(),
      child: BlocBuilder<${PASCAL_CASE}Cubit, ${PASCAL_CASE}State>(
        builder: (context, state) {
          if (state is ${PASCAL_CASE}Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ${PASCAL_CASE}Loaded) {
            return ${PASCAL_CASE}Template(items: state.items);
          } else if (state is ${PASCAL_CASE}Error) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
EOF

else
cat <<EOF > $PAGE_FILE
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/${FEATURE_NAME}_cubit.dart';
import '../widgets/templates/${FEATURE_NAME}_template.dart';
import '../../../../app/injection/injection.dart';

class ${PASCAL_CASE}Page extends StatelessWidget {
  const ${PASCAL_CASE}Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<${PASCAL_CASE}Cubit>()..getData(),
      child: Scaffold(
        appBar: AppBar(title: const Text('${PASCAL_CASE}')),
        body: BlocBuilder<${PASCAL_CASE}Cubit, ${PASCAL_CASE}State>(
          builder: (context, state) {
            if (state is ${PASCAL_CASE}Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ${PASCAL_CASE}Loaded) {
              return ${PASCAL_CASE}Template(items: state.items);
            } else if (state is ${PASCAL_CASE}Error) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<${PASCAL_CASE}Cubit>().getData(),
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
EOF
fi

# Optional detail screen
if [ "$DETAIL" = true ]; then
  # domain directory
  USECASE_PATH="$BASE_PATH/domain/usecases"
  DETAIL_USECASE="$USECASE_PATH/get_${FEATURE_NAME}_detail_usecase.dart"

  mkdir -p "$USECASE_PATH"

# Detail usecase
cat <<EOF > "$DETAIL_USECASE"
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/${FEATURE_NAME}_entity.dart';
import '../repositories/${FEATURE_NAME}_repository.dart';

@injectable
class Get${PASCAL_CASE}DetailUseCase {
  final ${PASCAL_CASE}Repository repository;

  Get${PASCAL_CASE}DetailUseCase(this.repository);

  Future<Either<Failure, ${PASCAL_CASE}Entity>> call(Get${PASCAL_CASE}DetailParams params) {
    return repository.get${PASCAL_CASE}Detail(params.id);
  }
}

class Get${PASCAL_CASE}DetailParams extends Equatable {
  final String id;

  const Get${PASCAL_CASE}DetailParams({required this.id});

  @override
  List<Object> get props => [id];
}
EOF

  # presentation directory
  DETAIL_PAGE="$BASE_PATH/presentation/pages/${FEATURE_NAME}_detail_page.dart"
  DETAIL_BODY="$BASE_PATH/presentation/widgets/organisms/${FEATURE_NAME}_detail_body.dart"
  DETAIL_TEMPLATE="$BASE_PATH/presentation/widgets/templates/${FEATURE_NAME}_detail_template.dart"
  DETAIL_CUBIT="$BASE_PATH/presentation/cubit/${FEATURE_NAME}_detail_cubit.dart"
  DETAIL_STATE="$BASE_PATH/presentation/cubit/${FEATURE_NAME}_detail_state.dart"

  # Create directories for detail screen
  mkdir -p "$(dirname "$DETAIL_PAGE")"
  mkdir -p "$(dirname "$DETAIL_BODY")"
  mkdir -p "$(dirname "$DETAIL_TEMPLATE")"
  mkdir -p "$(dirname "$DETAIL_CUBIT")"
  mkdir -p "$(dirname "$DETAIL_STATE")"

# Detail cubit
cat <<EOF > "$DETAIL_CUBIT"
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/usecases/get_${FEATURE_NAME}_detail_usecase.dart';
import '../../domain/entities/${FEATURE_NAME}_entity.dart';
import '../../../../core/errors/failures.dart';

part '${FEATURE_NAME}_detail_state.dart';

@injectable
class ${PASCAL_CASE}DetailCubit extends Cubit<${PASCAL_CASE}DetailState> {
  final Get${PASCAL_CASE}DetailUseCase get${PASCAL_CASE}DetailUseCase;

  ${PASCAL_CASE}DetailCubit(this.get${PASCAL_CASE}DetailUseCase) : super(${PASCAL_CASE}DetailInitial());

  void loadDetail(String id) async {
    emit(${PASCAL_CASE}DetailLoading());
    final result = await get${PASCAL_CASE}DetailUseCase(Get${PASCAL_CASE}DetailParams(id: id));
    result.fold(
      (failure) => emit(${PASCAL_CASE}DetailError(_mapFailureToMessage(failure))),
      (item) => emit(${PASCAL_CASE}DetailLoaded(item: item)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
EOF

# Detail state
cat <<EOF > "$DETAIL_STATE"
part of '${FEATURE_NAME}_detail_cubit.dart';

abstract class ${PASCAL_CASE}DetailState {}

class ${PASCAL_CASE}DetailInitial extends ${PASCAL_CASE}DetailState {}

class ${PASCAL_CASE}DetailLoading extends ${PASCAL_CASE}DetailState {}

class ${PASCAL_CASE}DetailLoaded extends ${PASCAL_CASE}DetailState {
  final ${PASCAL_CASE}Entity item;

  ${PASCAL_CASE}DetailLoaded({required this.item});
}

class ${PASCAL_CASE}DetailError extends ${PASCAL_CASE}DetailState {
  final String message;

  ${PASCAL_CASE}DetailError(this.message);
}
EOF

# Detail Page
cat <<EOF > "$DETAIL_PAGE"
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/${FEATURE_NAME}_detail_cubit.dart';
import '../widgets/templates/${FEATURE_NAME}_detail_template.dart';
import '../widgets/organisms/${FEATURE_NAME}_detail_body.dart';
import '../../../../app/injection/injection.dart';

class ${PASCAL_CASE}DetailPage extends StatelessWidget {
  final String id;

  const ${PASCAL_CASE}DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<${PASCAL_CASE}DetailCubit>()..loadDetail(id),
      child: Scaffold(
        appBar: AppBar(title: const Text('${PASCAL_CASE} Detail')),
        body: BlocBuilder<${PASCAL_CASE}DetailCubit, ${PASCAL_CASE}DetailState>(
          builder: (context, state) {
            if (state is ${PASCAL_CASE}DetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ${PASCAL_CASE}DetailLoaded) {
              return ${PASCAL_CASE}DetailTemplate(
                header: Text('${PASCAL_CASE} Details', style: Theme.of(context).textTheme.headlineMedium),
                filters: const Text('Filters go here if any'),
                onRefresh: () => context.read<${PASCAL_CASE}DetailCubit>().loadDetail(id),
                organism: ${PASCAL_CASE}DetailBody(entity: state.item),
              );
            } else if (state is ${PASCAL_CASE}DetailError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
EOF

# Template
cat <<EOF > "$DETAIL_TEMPLATE"
import 'package:flutter/material.dart';
import '../organisms/${FEATURE_NAME}_detail_body.dart';

class ${PASCAL_CASE}DetailTemplate extends StatelessWidget {
  final Widget header;
  final Widget filters;
  final Function onRefresh;
  final Widget organism;

  const ${PASCAL_CASE}DetailTemplate({
    Key? key,
    required this.header,
    required this.filters,
    required this.onRefresh,
    required this.organism,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header,
        filters,
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              onRefresh();
            },
            child: organism,
          ),
        ),
      ],
    );
  }
}
EOF

# Organism (DetailBody)
cat <<EOF > "$DETAIL_BODY"
import 'package:flutter/material.dart';
import '../../../domain/entities/${FEATURE_NAME}_entity.dart';

class ${PASCAL_CASE}DetailBody extends StatelessWidget {
  final ${PASCAL_CASE}Entity? entity;

  const ${PASCAL_CASE}DetailBody({super.key, this.entity});

  @override
  Widget build(BuildContext context) {
    if (entity == null) {
      return const Center(child: Text('No data available.'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${PASCAL_CASE} Detail', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text('Entity Name: \${entity!.name}'),  // Example field from entity
          // Add more fields from the entity as needed
        ],
      ),
    );
  }
}
EOF
fi

# Final message
echo "✅ Feature '$FEATURE_NAME' created with:"
[ "$FETCH" = true ] && echo "  • Fetch"
[ "$CREATE" = true ] && echo "  • Create"
[ "$UPDATE" = true ] && echo "  • Update"
[ "$DELETE" = true ] && echo "  • Delete"
[ "$DETAIL" = true ] && echo "  • Detail"
[ "$BOTTOM_NAV" = true ] && echo "  • Bottom Navigation"