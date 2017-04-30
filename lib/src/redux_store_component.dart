import 'dart:async';

import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';
import 'package:over_react/over_react.dart';
import 'package:recompose_dart/recompose_dart.dart';

import 'redux_store_connect.dart';

@Factory()
UiFactory<ReduxConnectProps> ReduxConnect;

@Props()
class ReduxConnectProps<
    State extends BuiltReducer<State, StateBuilder>,
    StateBuilder extends Builder<State, StateBuilder>,
    Actions extends ReduxActions,
    OwnProps,
    OutterP> extends UiProps {
  MapStoreToProps<State, StateBuilder, Actions, OwnProps, OutterP> mapper;
  FunctionalComponent<OutterP> baseComponent;
  OwnProps ownProps;
}

@Component()
class ReduxConnectComponent<
        State extends BuiltReducer<State, StateBuilder>,
        StateBuilder extends Builder<State, StateBuilder>,
        Actions extends ReduxActions,
        OwnProps,
        OutterP>
    extends UiComponent<ReduxConnectProps<State, StateBuilder, Actions, OwnProps, OutterP>> {
  /// List of store subscriptions created when the component mounts.
  ///
  /// These subscriptions are canceled when the component is unmounted.
  StreamSubscription<StoreChange<State, StateBuilder, dynamic>> _subscription;

  @override
  Iterable<String> get contextKeys => const ['redux_store'];

  OutterP _mappedProps;

  void componentWillMount() {
    super.componentWillMount();
    var store = context['redux_store'];
    _mappedProps = props.mapper(store, props.ownProps);
    _subscription = store.subscribe.listen((StoreChange<State, StateBuilder, dynamic> stateChange) {
      var nextProps = props.mapper(store, props.ownProps);
      if (_mappedProps != nextProps) {
        _mappedProps = nextProps;
        redraw();
      }
    });
  }

  void componentWillUnmount() {
    super.componentWillUnmount();
    _subscription.cancel();
  }

  render() => props.baseComponent(_mappedProps);
}
