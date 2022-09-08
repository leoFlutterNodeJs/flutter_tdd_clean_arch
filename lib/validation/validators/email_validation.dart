import '../protocols/protocols.dart';

class EmailValidaton implements FieldValidation {
  @override
  final String field;

  EmailValidaton(this.field);

  @override
  String? validate(String? value) {
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value!);
    return isValid ? null : 'Campo inválido.';
  }
}