import 'package:async_redux_todo/business/app_state.dart';
import 'package:async_redux_todo/business/todo/todo_actions.dart';
import 'package:async_redux_todo/images.dart';
import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //const posterPath = 'https://i.imgur.com/OvMZBs9.jpg';
    TextEditingController _searchController = TextEditingController(text: '');
    return ReduxConsumer<AppState>(
      builder: (context, store, state, dispatch, child) => Stack(
        children: [
          ListView.builder(
            controller: ScrollController(
              initialScrollOffset: 5,
              keepScrollOffset: false,
            ),
            padding: const EdgeInsets.only(top: 70),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount:
                state.todoState.todoItems.length, //model.todoItems.length,
            itemExtent: 110,
            itemBuilder: (BuildContext context, int index) {
              final todoItem = state.todoState.todoItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.black.withOpacity(0.2)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Row(
                        children: [
                          const Image(image: AppImages.todoImage, width: 95,),
                          // Image.network(
                          //   posterPath,
                          //   width: 95,
                          // ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  todoItem.title,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '??????????????????: ' +
                                          todoItem.priority
                                              .toString(), // movie.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                                                    Text(
                                  todoItem.isCompleted ? ' ??????????????????.' : ' ???? ??????????????????!',
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: todoItem.isCompleted
                                        ? Colors.grey
                                        : Colors.red,
                                  ),
                                ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      'id:' +
                                          todoItem.id
                                              .toString(), // movie.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => dispatch(
                            OpenTodoDetailsAction(todoId: todoItem.id)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: (String query) => dispatch(
                  SearchTodoListAction(searchQuery: _searchController.text)),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withAlpha(235),
                border: const OutlineInputBorder(),
                labelText: '??????????',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 610, left: 230),
            child: Row(
              children: [
                OutlinedButton(
                  child: const Text('refresh'),
                  onPressed: () => dispatch(GetTodoListAction()),
                ),
                OutlinedButton(
                  child: const Text('new'),
                  onPressed: () =>
                      dispatch(CreateNewAndOpenTodoDetailsAction()),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
