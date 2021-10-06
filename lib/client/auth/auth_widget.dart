import 'package:async_redux/async_redux.dart';
import 'package:async_redux_todo/business/app_state.dart';
import 'package:async_redux_todo/business/auth/auth_actions.dart';
import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

// import 'package:themoviedb/widgets/main_screen/main_screen_widget.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Login to your account')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 10),
            ),
            SizedBox(
              height: 12,
            ),
            _AuthForm(),
            Divider(
              thickness: 2,
            ),
            Text(
              'Преимущества членства',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            Text(
              'Создание учётной записи свободно и просто. Заполните форму ниже, чтобы начать.',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            GreetingRow(
              text:
                  'Find something to watch on your subscribed streaming services',
            ),
            GreetingRow(
              text: 'Журналировать отслеживаемые фильмы и телепередачи',
            ),
            GreetingRow(
              text:
                  'Отслеживать избранные фильмы и сериалы и получать на их основе рекомендации',
            ),
            GreetingRow(
              text: 'Создание и ведение персонального списка отслеживания',
            ),
            GreetingRow(
              text: 'Создание собственных смешанных списков (фильмы и ТВ)',
            ),
            GreetingRow(
              text: 'Участие в обсуждениях фильмов и телепередач',
            ),
            GreetingRow(
              text: 'Внесение и улучшение информации в нашей базе данных',
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({Key? key}) : super(key: key);

  void resetPassword() {
    // Navigator.of(context).pushNamed('/reset_password');
  }

  @override
  Widget build(BuildContext context) {
    //final model = NotifierProvider.read<AuthModel>(context);
    AppState? state = StoreProvider.state<AppState>(context);
    var loginTextController = TextEditingController.fromValue(null);
    var passwordTextController = TextEditingController.fromValue(null);
    var isAuthinProgress = state?.appStatus.isAuthInProgress;
    // final _buttonStyle = ButtonStyle(
    //     textStyle: MaterialStateProperty.all(
    //   TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    // ));
    return ReduxConsumer<AppState>(
      builder: (context, store, state, dispatch, child) => Column(children: [
        ...[
          const _ErrorMessageWidget(),
          const SizedBox(
            height: 8,
          )
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 6),
          child: TextField(
            obscureText: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              isCollapsed: true,
            ),
            controller:
                loginTextController, //model?.loginTextController, // _loginTextController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 6, 24, 6),
          child: TextField(
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              isCollapsed: true,
            ),
            controller:
                passwordTextController, //model?.passwordTextController, // _passwordTextController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Text(
              //     'Нажимая кнопку «Зарегистрироваться» ниже, я подтверждаю, что я прочитал и согласен с Условиями использования TMDb и Политикой конфиденциальности.'),
              const SizedBox(height: 25),
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                      const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    )),
                    child: isAuthinProgress == true ? const CircularProgressIndicator() : const Text('Login'),
                    onPressed: () => dispatch(AuthenticateAction(username: loginTextController.text, password: passwordTextController.text)), //onPressed,
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                      const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    )),
                    child: const Text('Reset password'),
                    onPressed: resetPassword,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                      const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    )),
                    child: const Text('Register'),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ]),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final errorMessage = NotifierProvider.watch<AuthModel>(context)?.errorMessage;
    //if (errorMessage == null) return const SizedBox.shrink();
    return const Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Text(
        'errorMessage',
        style: TextStyle(
          color: Colors.red,
          fontSize: 18,
        ),
      ),
    );
  }
}

class GreetingRow extends StatelessWidget {
  final String text;
  const GreetingRow({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 32.0),
            child: Icon(Icons.check),
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
              child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
            ),
          )),
        ],
      ),
    );
  }
}
