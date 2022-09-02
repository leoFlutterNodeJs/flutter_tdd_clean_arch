import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/components.dart';

import './login_presenter.dart';

import 'components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;
  const LoginPage(this.presenter, {super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingStream.listen((isLoading) {
            isLoading ? showLoading(context) : hideLoading(context);
          });
          widget.presenter.mainErrorStream.listen((error) {
            if (error != null) {
              showErrorMessage(context, error);
            }
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginHeader(),
                const HeadLine1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => widget.presenter,
                    child: Form(
                        child: Column(
                      children: [
                        const EmailInput(),
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 32),
                          child: PasswordInput(),
                        ),
                        StreamBuilder<bool>(
                            stream: widget.presenter.isFormValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: snapshot.data == true
                                    ? widget.presenter.auth
                                    : null,
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                child: Text('Entrar'.toUpperCase()),
                              );
                            }),
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
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
