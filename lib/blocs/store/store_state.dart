// lib/blocs/login/login_state.dart

import 'package:equatable/equatable.dart';
import 'package:inventory_app/models/models.dart';

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

class StoreItemBatchLoaded extends StoreState {
  @override
  final String storeName;

  final List<Batch> batchData;

  const StoreItemBatchLoaded({required this.storeName, required this.batchData})
      : super(storeName: storeName);

  @override
  List<Object> get props => [storeName, batchData];
}
