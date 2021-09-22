import 'package:async_redux/async_redux.dart';
import 'package:async_redux_todo/business/app_state.dart';
import 'package:async_redux_todo/business/todo/todo_actions.dart';
import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class TodoDetailsWidget extends StatelessWidget {
  const TodoDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState? state = StoreProvider.state<AppState>(context);
    TextEditingController titleController =
        TextEditingController.fromValue(null);
    titleController.text = state!.todoState.todoItem.title;

    return ReduxConsumer<AppState>(
        builder: (context, store, state, dispatch, child) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  'TODO Details',
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              body: CustomMultiChildLayout(
                delegate: FormLayoutDelegate(position: const Offset(0, 0)),
                children: [
                  LayoutId(
                    id: 'Title',
                    child: TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      maxLines: 8,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  LayoutId(
                    id: 'id',
                    child:
                        Text('Id: ' + state.todoState.todoItem.id.toString()),
                  ),
                  LayoutId(
                    id: 'isCompletedLabel',
                    child: const Text('Выполнено: '),
                  ),
                  LayoutId(
                    id: 'isCompleted',
                    child: IsCompletedSwitchWidget(
                      isCompleted: state.todoState.todoItem.isCompleted,
                      onSwitched: (newValue) => dispatch(
                          IsCompletedSwitchedAction(
                              isCompletedNewvalue: newValue)),
                    ),
                  ),
                  LayoutId(
                    id: 'userId',
                    child: Text(
                        'User: ' + state.todoState.todoItem.userId.toString()),
                  ),
                  LayoutId(
                    id: 'openDate',
                    child: DatePickerMyWidget(
                      initialDate: state.todoState.todoItem.openDate,
                      label: 'Назначeно',
                      onDatePicked: (datePicked) => dispatch(
                          OpenDatePickedAction(datePicked: datePicked)),
                      //  => store
                      //     .dispatch(TodoDetailsOpenDateAction(openDate: _pickedDate)),
                    ),
                  ),
                  LayoutId(
                    id: 'closeDate',
                    child: DatePickerMyWidget(
                      initialDate: state.todoState.todoItem.closeDate,
                      label: 'Закрыто',
                      onDatePicked: (datePicked) => dispatch(
                          CloseDatePickedAction(datePicked: datePicked)),
                      //  => store
                      //     .dispatch(TodoDetailsCloseDateAction(closeDate: _pickedDate)),
                    ),
                  ),
                ],
              ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    tooltip: 'удалить',
                    onPressed: () => dispatch(
                        DeleteTodoDetailsAction(todoIdToDelete: state.todoState.todoItem.id)),
                    heroTag: null,
                    child: const Icon(Icons.delete),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    tooltip: 'сохранить',
                    onPressed: () => dispatch(SaveTodoDetailsAction(
                        changedTodoItem: state.todoState.todoItem.copy(
                      title: titleController.text,
                    ))),
                    heroTag: null,
                    child: const Icon(Icons.save),
                  ),
                ],
              ),
            ));
  }
}

// ignore: must_be_immutable
class DatePickerMyWidget extends StatefulWidget {
  DateTime initialDate;
  String label;
  Function onDatePicked;
  DatePickerMyWidget({
    Key? key,
    required this.initialDate,
    required this.label,
    required this.onDatePicked,
  }) : super(key: key);

  @override
  State<DatePickerMyWidget> createState() => _DatePickerMyWidgetState();
}

class _DatePickerMyWidgetState extends State<DatePickerMyWidget> {
  DateTime selectedDate = DateTime.now();
  // DateTime? initialDate;
  TextEditingController controller = TextEditingController();
  String? presentText;
  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.initialDate,
        firstDate: DateTime.parse('0001-01-01'),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text = picked.toString();
        widget.onDatePicked(selectedDate);
      });
    }
  }

  @override
  void initState() {
    controller.text = widget.initialDate.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                widget.label,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          GestureDetector(
              onTap: () => _selectDate(),
              child: AbsorbPointer(
                  child: TextFormField(
                controller: controller,
                initialValue: presentText,
              ))),
        ],
      ),
    );
  }
}

class FormLayoutDelegate extends MultiChildLayoutDelegate {
  FormLayoutDelegate({required this.position});

  final Offset position;

  @override
  void performLayout(Size size) {
    // `size` is the size of the `CustomMultiChildLayout` itself.

    // ignore: unused_local_variable
    Size leadingSize = Size.zero;
    if (hasChild('Title')) {
      leadingSize = layoutChild(
        'Title',
        const BoxConstraints(
          maxWidth: 300,
          maxHeight: 500,
        ),
      );
      // No need to position this child if we want to have it at Offset(0, 0).
      positionChild('Title', const Offset(95, 40));
    }
    if (hasChild('id')) {
      leadingSize = layoutChild('id', BoxConstraints.loose(size));
      positionChild('id', const Offset(40, 16));
    }
    if (hasChild('isCompletedLabel')) {
      leadingSize = layoutChild('isCompletedLabel', BoxConstraints.loose(size));
      positionChild('isCompletedLabel', const Offset(95, 16));
    }
    if (hasChild('isCompleted')) {
      leadingSize = layoutChild('isCompleted', BoxConstraints.loose(size));
      positionChild('isCompleted', const Offset(167, 0));
    }
    if (hasChild('userId')) {
      leadingSize = layoutChild('userId', BoxConstraints.loose(size));
      positionChild('userId', const Offset(23, 36));
    }
    if (hasChild('openDate')) {
      leadingSize = layoutChild('openDate', BoxConstraints.loose(size));
      positionChild('openDate', const Offset(6, 58));
    }
    if (hasChild('closeDate')) {
      leadingSize = layoutChild('closeDate', BoxConstraints.loose(size));
      positionChild('closeDate', const Offset(6, 146));
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

// ignore: must_be_immutable
class IsCompletedSwitchWidget extends StatefulWidget {
  bool isCompleted;
  Function onSwitched;
  IsCompletedSwitchWidget({
    Key? key,
    required this.isCompleted,
    required this.onSwitched,
  }) : super(key: key);

  @override
  _IsCompletedSwitchWidgetState createState() =>
      _IsCompletedSwitchWidgetState();
}

class _IsCompletedSwitchWidgetState extends State<IsCompletedSwitchWidget> {
// @override
// void didUpdateWidget(IsCompletedSwitchWidget oldWidget) {
//   super.didUpdateWidget(oldWidget);
//   if (oldWidget.hashCode != widget.hashCode) {
//     widget.onSwitched(widget.isCompleted);
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.isCompleted,
      onChanged: (bool newValue) {
        setState(() {
          widget.isCompleted = newValue;
          widget.onSwitched(widget.isCompleted);
        });
      },
    );
  }
}
