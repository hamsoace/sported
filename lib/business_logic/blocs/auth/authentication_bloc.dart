import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';
import 'package:sported_app/data/models/ourUser.dart';
import 'package:sported_app/data/repositories/auth_repo.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepo _authMethods;
  StreamSubscription<UserModel> _userSubscription;
  AuthenticationBloc({@required AuthRepo authMethods})
      : assert(authMethods != null),
        _authMethods = authMethods,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authMethods.user.listen(
      (user) => add(AuthenticationUserChanged(user: user)),
    );
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authMethods.signOut());
    } else if (event is AuthenticationDeleteRequested) {
      await _authMethods.deleteAccountAndProfileData();
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  AuthenticationState _mapAuthenticationUserChangedToState(AuthenticationUserChanged event) {
    return event.user != UserModel.empty ? AuthenticationState.authenticated(event.user) : AuthenticationState.unauthenticated(null);
  }
}
