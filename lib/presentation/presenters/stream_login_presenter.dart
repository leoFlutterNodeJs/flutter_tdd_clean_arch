import 'dart:async';

import '../protocols/protocols.dart';

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String?> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct();
  Stream<bool> get isFormValidStream => _controller.stream.map((state) => state.isFormValidStream).distinct();

  StreamLoginPresenter({required this.validation});

  void validationEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}

class LoginState {
  String? emailError;
  bool get isFormValidStream => false;
}
