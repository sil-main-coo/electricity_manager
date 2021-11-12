import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:electricity_manager/app_bloc/bloc.dart';
import 'package:electricity_manager/data/remote/auth_remote_provider.dart';
import 'package:electricity_manager/screens/login/bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AppBloc appBloc;
  final AuthRemoteProvider authRemoteProvider;

  LoginBloc({required this.appBloc, required this.authRemoteProvider})
      : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final user = await authRemoteProvider.signIn(event.account);

        appBloc.add(LoggedIn(user: user!));
        yield HiddenLoginLoading();
        yield LoginInitial();
      } catch (error) {
        yield HiddenLoginLoading();
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
