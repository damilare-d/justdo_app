import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' as hooks;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  runApp(const MaterialApp(home: Example1HomePage()));
}

enum ProductFilter { all, shortTexts, longTexts }

@immutable
class State {
  Iterable<String> products;
  ProductFilter filter;

  State({
    required this.products,
    required this.filter,
  });

  Iterable<String> get filteredProducts {
    switch (filter) {
      case ProductFilter.all:
        return products;
      case ProductFilter.shortTexts:
        return products.where((e) => e.length <= 3);
      case ProductFilter.longTexts:
        return products.where((e) => e.length >= 10);
    }
  }
}

@immutable
class ChangeFilterProductAction extends Action {
  final ProductFilter filter;
  const ChangeFilterProductAction({required this.filter});
}

@immutable
abstract class Action {
  const Action();
}

@immutable
abstract class ProductAction extends Action {
  final String product;
  const ProductAction(this.product);
}

@immutable
class AddProductAction extends ProductAction {
  const AddProductAction(String product) : super(product);
}

@immutable
class RemoveProductAction extends ProductAction {
  const RemoveProductAction(String product) : super(product);
}

extension AddRemoveProducts<T> on Iterable<T> {
  Iterable<T> operator +(T other) => followedBy([other]);
  Iterable<T> operator -(T other) => where((e) => e != other);
}

Iterable<String> addProductReducer(
  Iterable<String> previousItems,
  AddProductAction action,
) =>
    previousItems + action.product;

Iterable<String> removeProductReducer(
        Iterable<String> previousItems, RemoveProductAction action) =>
    previousItems - action.product;

Reducer<Iterable<String>> productsReducer = combineReducers<Iterable<String>>([
  TypedReducer<Iterable<String>, AddProductAction>(addProductReducer),
  TypedReducer<Iterable<String>, RemoveProductAction>(removeProductReducer),
]);

ProductFilter productFilterReducer(State oldState, Action action) {
  if (action is ChangeFilterProductAction) {
    return action.filter;
  } else {
    return oldState.filter;
  }
}

State appStateReducer(State oldState, action) => State(
    products: productsReducer(oldState.products, action),
    filter: productFilterReducer(oldState, action));

class Example1HomePage extends hooks.HookWidget {
  const Example1HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = hooks.useTextEditingController();
    final store = Store(
      appStateReducer,
      initialState: State(
        products: [],
        filter: ProductFilter.all,
      ),
    );
    return Scaffold(
      body: StoreProvider(
        store: store,
        child: Column(
          children: [
            Row(children: [
              TextButton(
                child: const Text('all'),
                onPressed: () {
                  store.dispatch(const ChangeFilterProductAction(
                      filter: ProductFilter.all));
                },
              ),
              TextButton(
                child: const Text('short texts'),
                onPressed: () {
                  store.dispatch(const ChangeFilterProductAction(
                      filter: ProductFilter.shortTexts));
                },
              ),
              TextButton(
                child: const Text('long texts'),
                onPressed: () {
                  store.dispatch(const ChangeFilterProductAction(
                      filter: ProductFilter.longTexts));
                },
              ),
            ]),
            TextField(
              controller: textController,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    final text = textController.text;
                    store.dispatch(AddProductAction(text));
                    textController.clear();
                  },
                  child: const Text('Add'),
                ),
                TextButton(
                    onPressed: () {
                      final text = textController.text;
                      store.dispatch(RemoveProductAction(text));
                      textController.clear();
                    },
                    child: const Text('Remove'))
              ],
            ),
            StoreConnector<State, Iterable<String>>(
              converter: (store) => store.state.filteredProducts,
              builder: (context, products) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          products.elementAt(index),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
