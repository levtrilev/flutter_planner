import 'package:async_redux/async_redux.dart';
import 'package:async_redux_todo/client/Theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

import 'business/app_state.dart';
import 'main_navigation.dart';

late Store<AppState> store;
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  NavigateAction.setNavigatorKey(navigatorKey);
  store = Store<AppState>(initialState: AppState.initialState());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final mainNavigation = MainNavigation();

  @override
  Widget build(BuildContext context) {
    return AsyncReduxProvider<AppState>.value(
        value: store,
        child: MaterialApp(
          title: 'Flutter redux_async Demo',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.mainDarkBlue,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: AppColors.mainDarkBlue,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
            ),
          ),
          //home: CounterWidget(),
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: mainNavigation.initialRoute(context, true),
          routes: mainNavigation.routs,
          onGenerateRoute: (RouteSettings settings) {
            return MaterialPageRoute<void>(builder: (context) {
              return const Scaffold(
                body: Center(child: Text('Произошла ошибка навигации')),
              );
            });
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru', 'RU'), // Russian, country code
            Locale('en', 'EN'), // English, no country code
          ],
        ));
  }
}

// class MyHomePageConnector extends StatelessWidget {
//   MyHomePageConnector({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, ViewModel>(
//       vm: () => Factory(this),
//       builder: (BuildContext context, ViewModel vm) => MyHomePage(
//         counter: vm.counter,
//         message: vm.message,
//         onIncrement: vm.onIncrement,
//       ),
//     );
//   }
// }

// class Factory extends VmFactory<AppState, MyHomePageConnector> {
//   Factory(widget) : super(widget);

//   @override
//   ViewModel fromStore() => ViewModel(
//         counter: state.counter,
//         message: state.message,
//         onIncrement: () => dispatch(IncrementAction(amount: 2)),
//       );
// }

// class ViewModel extends Vm {
//   final int counter;
//   final String message;
//   final VoidCallback onIncrement;

//   ViewModel({
//     required this.counter,
//     required this.message,
//     required this.onIncrement,
//   }) : super(equals: [counter]);
// }

////////////////////////////

// class AppState {

//   final LoginState loginState;
//   final UserState userState;
//   final TodoState todoState;

//  AppState({
// 	this.loginState,
// 	this.userState,
// 	this.todoState,
//   });

//   AppState copy({
// 	LoginState loginState,
// 	UserState userState,
// 	TodoState todoState,
//   }) {
// 	return AppState(
// 	  login: loginState ?? this.loginState,
// 	  user: userState ?? this.userState,
// 	  todo: todoState ?? this.todoState,
// 	);
//   }

//   static AppState initialState() =>
// 	AppState(
// 	  loginState: LoginState.initialState(),
// 	  userState: UserState.initialState(),
// 	  todoState: TodoState.initialState());

//   @override
//   bool operator ==(Object other) =>
// 	identical(this, other) || other is AppState && runtimeType == other.runtimeType &&
// 	  loginState == other.loginState && userState == other.userState && todoState == other.todoState;

//   @override
//   int get hashCode => loginState.hashCode ^ userState.hashCode ^ todoState.hashCode;
// }