import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';
import 'package:recompose_dart/recompose_dart.dart';

import './redux_store_component.dart';

typedef OutterP MapStoreToProps<
    State extends BuiltReducer<State, StateBuilder>,
    StateBuilder extends Builder<State, StateBuilder>,
    Actions extends ReduxActions,
    OwnProps,
    OutterP>(Store<State, StateBuilder, Actions> store, OwnProps ownProps);

/// Subscribes to the redux [store] and transforms the props with [mapper]
ComponentEnhancer<OwnProps, OutterP> mapStoreToProps<
        State extends BuiltReducer<State, StateBuilder>,
        StateBuilder extends Builder<State, StateBuilder>,
        Actions extends ReduxActions,
        OwnProps,
        OutterP>(MapStoreToProps<State, StateBuilder, Actions, OwnProps, OutterP> mapper) =>
    (FunctionalComponent<OutterP> baseComponent) => (OwnProps props) => (ReduxConnect()
      ..mapper = mapper
      ..ownProps = props
      ..baseComponent = baseComponent)();
