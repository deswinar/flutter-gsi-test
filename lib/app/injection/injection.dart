// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final GetIt locator = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async {

  await locator.init();
}
