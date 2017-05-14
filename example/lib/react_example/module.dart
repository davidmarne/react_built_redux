library module;

import 'package:recompose_dart/recompose_dart.dart';
import 'package:react_built_redux/react_built_redux.dart';
import 'package:over_react/over_react.dart';
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';

import '../reducers/app_state.dart';
import '../reducers/todo.dart';
import '../reducers/group.dart';
import 'select.dart';
import 'creator.dart';

part 'module.g.dart';

abstract class TodoProps implements Built<TodoProps, TodoPropsBuilder> {
  AppStateActions get actions;

  @nullable
  Group get currentGroup;

  BuiltMap<int, Group> get groups;
  BuiltMap<int, Todo> get todos;
  String get title;

  TodoProps._();
  factory TodoProps([updates(TodoPropsBuilder b)]) = _$TodoProps;
}

var todosReduxBuilder = compose<dynamic, TodoProps>([
  mapStoreToProps<AppState, AppStateBuilder, AppStateActions, dynamic, TodoProps>(
      (Store<AppState, AppStateBuilder, AppStateActions> store, dynamic _) =>
          new TodoProps((TodoPropsBuilder b) => b
            ..actions = store.actions
            ..currentGroup = store.state.groups.currentGroup?.toBuilder()
            ..groups.addAll(store.state.groups.groupMap.asMap())
            ..todos.addAll(store.state.currentGroupTodos.asMap())
            ..title = "redux")),
  pure,
  lifecycle<TodoProps>(
      componentDidUpdate: (oldProps, newProps) => print('prev: $oldProps\nnew: $newProps')),
])(todosComponent);

ReactElement todosComponent(TodoProps props) => Dom.div()(
      todoHeader(props),
      selectComponent(new SelectProps()
        ..label = 'group'
        ..currentGroup = props.currentGroup == null ? -1 : props.currentGroup.id
        ..optionMap = props.groups
        ..onSelect = props.actions.groupActions.setCurrentGroup),
      creatorComponent(new CreatorProps()
        ..onSubmit = props.actions.creationActions.createGroup
        ..name = 'group'),
      Dom.div()(),
      creatorComponent(new CreatorProps()
        ..onSubmit = props.actions.creationActions.createTodo
        ..name = 'todo'),
      todoItems(props),
      (Dom.button()..onClick = (_) => props.actions.setBogus(3))('bogus props change'),
    );

ReactElement todoHeader(TodoProps props) =>
    Dom.div()('${props.title} TODOS: (${props.todos.length})');

ReactElement todoItems(TodoProps props) => Dom.div()(
      props.todos.values.map(
        (Todo todo) => todoItem(todo, props.actions.todosActions.updateTodoStatus),
      ),
    );

ReactElement todoItem(Todo todo, ActionDispatcher<int> updateTodoStatus) =>
    (Dom.div()..key = todo.id)(
      todo.text,
      (Dom.input()
        ..onChange = ((_) => updateTodoStatus(todo.id))
        ..checked = todo.done
        ..type = 'checkbox')(),
    );
