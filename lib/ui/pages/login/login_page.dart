import 'package:flutter/material.dart';
import '../../components/components.dart';

import './login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;
  const LoginPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            const HeadLine1(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                  child: Column(
                children: [
                  StreamBuilder<String?>(
                    stream: presenter.emailErrorStream,
                    builder: (context, snapshot) {
                      return TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          icon: Icon(Icons.email, color: Theme.of(context).primaryColor,),
                          errorText: snapshot.data?.isEmpty == true ? null : snapshot.data
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: presenter.validateEmail,
                      );
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    child: StreamBuilder<String?>(
                      stream: presenter.passwordErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                            icon: Icon(Icons.lock, color: Theme.of(context).primaryColor,),
                            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data
                          ),
                          obscureText: true,
                          onChanged: presenter.validatePassword,
                        );
                      }
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: presenter.isFormValidStream,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: snapshot.data == true ? (){} : null,
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                        ),
                        child: Text('Entrar'.toUpperCase()),
                      );
                    }
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    icon: const Icon(Icons.person),
                    label: const Text('Criar conta'),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
