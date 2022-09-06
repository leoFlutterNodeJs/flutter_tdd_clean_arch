import 'package:test/test.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tdd_clean_arch/presentation/presenters/presenters.dart';
import 'package:tdd_clean_arch/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late StreamLoginPresenter sut;
  late Validation validation;
  late String email;
  late String password;

  When mockValidationCall(String? field) => when(() => validation.validate(
      field: field ?? any(named: 'field'), value: any(named: 'value')));
  
  void mockValidation({String? field, String? value}){
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validationEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should email error if validate fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validationEmail(email);
    sut.validationEmail(email);
  });

  test('Should emits null if validation is succeeds only email', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validationEmail(email);
    sut.validationEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validationPassword(password);

    verify(() => validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should password error if validate fails', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validationPassword(password);
    sut.validationPassword(password);
  });

  test('Should emits null if validation is succeeds only password', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validationPassword(password);
    sut.validationPassword(password);
  });

  test('Should emits email error if email is invalid', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validationEmail(email);
    sut.validationPassword(password);
  });
}
