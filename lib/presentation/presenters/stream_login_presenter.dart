import 'dart:async';

import '../protocols/protocols.dart';

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();
  Stream<String?> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValidStream).distinct();

  StreamLoginPresenter({required this.validation});

  void _update() => _controller.add(_state);

  void validationEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validationPassword(String password) {
    _state.password = password;
    _state.passwordError =
        validation.validate(field: 'password', value: password);
    _update();
  }
}

class LoginState {
  String? email;
  String? password;
  String? emailError;
  String? passwordError;
  bool get isFormValidStream =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}
