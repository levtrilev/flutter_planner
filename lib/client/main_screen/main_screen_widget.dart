import 'package:async_redux/async_redux.dart';
import 'package:async_redux_todo/business/app_state.dart';
import 'package:async_redux_todo/business/todo/todo_actions.dart';
import 'package:async_redux_todo/client/todo/todo_list_widget.dart';
import 'package:async_redux_todo/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;

  //final todoListModel = TodoListModel();

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //todoListModel.loadTodoItems();

    //movieListModel.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(
        builder: (context, store, state, dispatch, child) {
          dispatch(InitialGetTodoListAction());
        return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Personal planner/tracker',
                ),
                actions: [
                  IconButton(
                    onPressed: () => dispatch(
                        NavigateAction<AppState>.pushNamed(
                            MainNavigationRouteNames.counter)),
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              body: IndexedStack(
                index: _selectedTab,
                children: const [
                  TodoListWidget(),
                  Text('const Center(child: PaintTestWidget())'),
                  Text('const TodoListWidgetR()'),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedTab,
                onTap: onSelectTab,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: 'Todo-s',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.tv,
                    ),
                    label: 'Notes',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.today,
                    ),
                    label: 'Meters',
                  ),
                ],
              ),
            );}
            );
  }
}
