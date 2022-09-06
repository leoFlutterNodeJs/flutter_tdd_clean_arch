import 'dart:async';

import 'package:test/test.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

abstract class Validation {
  String? validate({required String field, required String value});
}

class LoginState {
  late String? emailError;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError);

  StreamLoginPresenter({required this.validation});

  void validationEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  late StreamLoginPresenter sut;
  late Validation validation;
  late String email;

  When mockValidationCall(String? field) => when(() => validation.validate(
      field: field ?? any(named: 'field'), value: any(named: 'value')));
  
  void mockValidation({String? field, String? value}){
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validationEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should email error if validate fails', () {
    mockValidation(value: 'error');

    expectLater(sut.emailErrorStream, emits('error'));

    sut.validationEmail(email);
  });
}
