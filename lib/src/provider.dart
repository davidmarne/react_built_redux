import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ProviderProps> Provider;

@Props()
class ProviderProps<P, S extends BuiltReducer<S, B>, B extends Builder<S, B>,
    A extends ReduxActions> extends UiProps {
  Store<S, B, A> store;
}

@Component()
class ProviderComponent<P, S extends BuiltReducer<S, B>, B extends Builder<S, B>,
    A extends ReduxActions> extends UiComponent<ProviderProps<P, S, B, A>> {
  @override
  Map getChildContext() => {'redux_store': props.store};

  @override
  Iterable<String> get childContextKeys => const ['redux_store'];

  render() => Dom.div()(props.children);
}
