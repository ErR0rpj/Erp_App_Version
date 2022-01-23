import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'store_event.dart';
import 'store_state.dart';
import 'package:inventory_app/repos/store_repo.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final StoreRepository _storeRepository;

  StoreBloc(StoreRepository storeRepository)
      : _storeRepository = storeRepository,
        super(const StoreNameLoaded(storeName: ''));

  @override
  Stream<StoreState> mapEventToState(StoreEvent event) async* {
    if (event is GetStoreName) {
      yield* _mapGetStoreName(event);
    } else if (event is GetStoreItems) {
      yield* _mapGetStoreItems(event);
    } else if (event is GetStoreItemBatches) {
      yield* _mapStoreGetItemBatch(event);
    }
  }

  Stream<StoreState> _mapGetStoreName(GetStoreName event) async* {
    try {
      final storeName = await _storeRepository.getStoreName(event.token);
      if (storeName != null) {
        add(GetStoreItems());
        yield StoreNameLoaded(storeName: storeName);
      }
    } catch (err) {
      print(err.toString());
      add(GetStoreItems());
      //TODO: Add read failure
    }
  }

  Stream<StoreState> _mapGetStoreItems(GetStoreItems event) async* {
    try {
      final storeItems = await _storeRepository.getStoreData();
      if (storeItems.isNotEmpty) {
        yield StoreDataLoaded(storeName: state.storeName, itemData: storeItems);
      }
    } catch (err) {
      print(err);
      //TODO: Add read failure
    }
  }

  Stream<StoreState> _mapStoreGetItemBatch(GetStoreItemBatches event) async* {
    try {
      final storeItems = await _storeRepository.getItemBatchData(event.itemId);
      if (storeItems.isNotEmpty) {
        print(storeItems.length);
        //yield StoreDataLoaded(storeName: state.storeName, itemData: storeItems);
      }
    } catch (err) {
      print(err);
      //TODO: Add read failure
    }
  }
}
