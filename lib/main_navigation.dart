import 'package:async_redux_todo/client/counter/counter_widget.dart';
import 'package:async_redux_todo/client/main_screen/main_screen_widget.dart';
import 'package:async_redux_todo/client/todo/todo_details_widget.dart';
import 'package:flutter/material.dart';

abstract class MainNavigationRouteNames {
  static const auth = 'auth';
  static const mainScreen = '/';
  static const movieDetails = '/movie_details';
  static const resetPassword = '/reset_password';
  static const jsonTest = '/json_test';
  static const passDataToChild = '/pass_data_to_child';
  static const inheritedNotifierExample = '/inherited_notifier_example';
  static const todoDetails = '/todo_details';
  static const counter = '/counter';
}

class MainNavigation {
  String initialRoute(context, bool isAuth) => MainNavigationRouteNames.mainScreen;

  final routs = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.counter: (context) => const CounterWidget(),

    MainNavigationRouteNames.mainScreen: (context) => const MainScreenWidget(),
    MainNavigationRouteNames.todoDetails: (context) => const TodoDetailsWidget(),

  };
  
  // Route<Object> onGenereteRoute(RouteSettings settings) {
  //   switch (settings.name) {
  //     case MainNavigationRouteNames.movieDetails:
  //       final arguments = settings.arguments;
  //       final movieId = arguments is int ? arguments : 0;
  //       return MaterialPageRoute(
  //         builder: (context) => NotifierProvider(
  //           child: const MovieDetailsWidget(),
  //           create: () => MovieDetailsModel(movieId: movieId),
  //         ),
  //       );
  //     default:
  //     const widget = Text('Navigation Error!!!...');
  //     return MaterialPageRoute(builder: (context) => widget);
  //   }
  // }
}
