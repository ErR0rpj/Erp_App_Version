// lib/blocs/login/login_state.dart

import 'package:equatable/equatable.dart';
import 'package:inventory_app/models/item.dart';

abstract class StoreState extends Equatable {
  final String storeName;
  const StoreState({required this.storeName});
  @override
  List<Object> get props => [storeName];
}

class StoreNameLoaded extends StoreState {
  @override
  final String storeName;
  const StoreNameLoaded({required this.storeName})
      : super(storeName: storeName);

  @override
  List<Object> get props => [storeName];
}

class StoreDataLoaded extends StoreState {
  @override
  final String storeName;

  final List<Item> itemData;

  const StoreDataLoaded({required this.storeName, required this.itemData})
      : super(storeName: storeName);

  @override
  List<Object> get props => [storeName, itemData];
}

class StoreItemsLoaded extends StoreState {
  @override
  final String storeName;

  const StoreItemsLoaded({required this.storeName})
      : super(storeName: storeName);

  @override
  List<Object> get props => [storeName];
}
