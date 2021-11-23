import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:electricity_manager/app_bloc/bloc.dart';
import 'package:electricity_manager/data/remote/auth_remote_provider.dart';
import 'package:electricity_manager/models/user.dart';
import 'package:electricity_manager/utils/commons/role_constants.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRemoteProvider authRemoteProvider;

  User? user;

  bool get isAdmin => user?.profile?.isAdmin ?? false;

  AppBloc(this.authRemoteProvider) : super(AppUninitialized());

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppStarted) {
      // final token = await authenLocalProvider.getTokenFromLocal();
      final token = null;

      if (token != null) {
        yield AppAuthenticated();
      } else {
        yield AppUnauthenticated();
      }
    } else if (event is LoggedIn) {
      this.user = event.user;
      // final result =
      //     await authenLocalProvider.saveTokenToLocal('this_is_token');
      yield AppAuthenticated();
    } else if (event is LogOuted) {
      yield AppLoading();
      this.user = null;
      // final result = await authenLocalProvider.removeTokenFromLocal();
      yield HideAppLoading();
      yield AppUnauthenticated();
    }
  }
}
