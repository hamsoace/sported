import 'package:get_it/get_it.dart';

import 'data/repositories/auth_repo.dart';
import 'data/repositories/storage_repo.dart';
import 'data/services/authentication_service.dart';
import 'data/services/user_controller.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthRepo>(AuthRepo());
  locator.registerSingleton<StorageRepo>(StorageRepo());
  locator.registerSingleton<AuthenticationService>(AuthenticationService());
  locator.registerSingleton<UserController>(UserController());
}
