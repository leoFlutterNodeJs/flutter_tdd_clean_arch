import 'package:test/test.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tdd_clean_arch/domain/entities/account_entity.dart';
import 'package:tdd_clean_arch/domain/helpers/helpers.dart';
import 'package:tdd_clean_arch/domain/usecases/usecases.dart';

import 'package:tdd_clean_arch/presentation/presenters/presenters.dart';
import 'package:tdd_clean_arch/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

class ParamsFactory {
  static AuthenticationParams makeAuthentication() => AuthenticationParams(
      email: faker.internet.email(), secret: faker.internet.password());
}

class EntityFactory {
  static AccountEntity makeAccount() => AccountEntity(faker.guid.guid());
}

void main() {
  late GetxLoginPresenter sut;
  late ValidationSpy validation;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late AuthenticationSpy authentication;
  late String email;
  late String password;

  When mockValidationCall(String? field) => when(() => validation.validate(
      field: field ?? any(named: 'field'), value: any(named: 'value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  When mockAuthenticationCall() =>
      when(() => authentication.auth(ParamsFactory.makeAuthentication()));
  When mockAuthenticationErroCall() => when(() => authentication.auth(any()));

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) => EntityFactory.makeAccount());
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationErroCall().thenThrow(error);
  }

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAccount());
    registerFallbackValue(ParamsFactory.makeAuthentication());
    
  });

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
  });

  test('Should call Validation with correct email', () async {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should change page on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.auth();
  });

  test('Should email error if validate fails', () async {
    mockValidation(value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () async {
    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', value: password))
        .called(1);
  });

  test('Should password error if validate fails', () async {
    mockValidation(value: 'error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emits email error if email is invalid', () async {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) =>
        expect(error, 'Algo errado aconteceu. Tente novamente em breve!')));

    await sut.auth();
  });
}
