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

class EntityFactory {
  static AccountEntity makeAccount() => AccountEntity(faker.guid.guid());
}

class ParamsFactory {
  static AuthenticationParams makeAuthentication() => AuthenticationParams(
    email: faker.internet.email(),
    secret: faker.internet.password()
  );
}

void main() {
  late StreamLoginPresenter sut;
  late ValidationSpy validation;
  late AuthenticationSpy authentication;
  late String email;
  late String password;

  When mockValidationCall(String? field) => when(() => validation.validate(
      field: field ?? any(named: 'field'), value: any(named: 'value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }
 
  When mockAuthenticationCall() => when(() => authentication.auth(ParamsFactory.makeAuthentication()));
  When mockAuthenticationErroCall() => when(() => authentication.auth(any()));

  void mockAuthentication() {
    mockAuthenticationCall()
        .thenAnswer((_) => EntityFactory.makeAccount());
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationErroCall().thenThrow(error);
  }

  setUpAll((){
    registerFallbackValue(EntityFactory.makeAccount());
    registerFallbackValue(ParamsFactory.makeAuthentication());
  });

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(
        validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
  });

  test('Should call Validation with correct email', () {
    sut.validationEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should email error if validate fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validationEmail(email);
    sut.validationEmail(email);
  });

  test('Should emits null if validation is succeeds only email', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validationEmail(email);
    sut.validationEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validationPassword(password);

    verify(() => validation.validate(field: 'password', value: password))
        .called(1);
  });

  test('Should password error if validate fails', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validationPassword(password);
    sut.validationPassword(password);
  });

  test('Should emits null if validation is succeeds only password', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validationPassword(password);
    sut.validationPassword(password);
  });

  test('Should emits email error if email is invalid', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validationEmail(email);
    sut.validationPassword(password);
  });

  test('Should emits isFormValidStream if all fields is valid', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validationEmail(email);
    await Future.delayed(Duration.zero);
    sut.validationPassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validationEmail(email);
    sut.validationPassword(password);

    await sut.auth();

    verify(() => authentication
        .auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validationEmail(email);
    sut.validationPassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validationEmail(email);
    sut.validationPassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validationEmail(email);
    sut.validationPassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Algo errado aconteceu. Tente novamente em breve!')));

    await sut.auth();
  });
}
