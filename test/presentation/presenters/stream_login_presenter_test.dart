import 'package:test/test.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

abstract class Validation {
  String? validate({required String field, required String value});
}

class StreamLoginPresenter {
  final Validation validation;
  StreamLoginPresenter({required this.validation});

  void validationEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  test('Should call Validation with correct email', () {
    final validation = ValidationSpy();
    final sut = StreamLoginPresenter(validation: validation);
    final email = faker.internet.email();

    sut.validationEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });
}