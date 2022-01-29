import 'dart:async';
import 'package:inventory_app/utils/consts.dart';
import 'package:inventory_app/utils/networking/RestWrapper.dart';
import 'package:inventory_app/models/models.dart';

abstract class StoreService {
  Future<String> getStoreName(String token);
  Future<List<Item>> getStoreData();
  Future<List<Batch>> getItemBatchData(String itemId);
  Future<void> createItem(Item itemData, Batch batchData);
  Future<void> updateItem(Item itemData);
  Future<void> updateBatch(Batch batchData);
  Future<void> createBatch(Batch batchData);
  Future<void> deleteItem(String itemCode);
  Future<void> deleteBatch(
      String barcode, String itemCode, String purchaseDate);
}

class StoreRepository extends StoreService {
  static final StoreRepository _instance = StoreRepository._internal();
  factory StoreRepository() {
    return _instance;
  }
  StoreRepository._internal();

  final RestWrapper _provider = RestWrapper();

  @override
  Future<String> getStoreName(String token) async {
    await _provider.setToken(token);
    final String response = await _provider.get(STORE_NAME_URL);
    return response;
  }

  @override
  Future<List<Item>> getStoreData() async {
    final List<dynamic> response = await _provider.get(STORE_ITEMS_URL);
    List<Item> items = [];
    for (var v in response) {
      items.add(Item.fromJson(v));
    }
    return items;
  }

  @override
  Future<List<Batch>> getItemBatchData(String itemId) async {
    final List<dynamic> response =
        await _provider.get(STORE_BATCHES_URL(itemId));
    List<Batch> items = [];
    for (var v in response) {
      items.add(Batch.fromJson(v));
    }
    return items;
  }

  @override
  Future<void> createItem(Item itemData, Batch batchData) async {
    Map<String, dynamic> createData = itemData.toJson();
    createData.addAll(batchData.toJson());
    await _provider.post(CREATE_ITEM_URL, createData);
  }

  @override
  Future<void> updateItem(Item itemData) async {
    await _provider.post(UPDATE_ITEM_URL, itemData.toJson());
  }

  @override
  Future<void> deleteItem(String itemCode) async {
    await _provider.post(DELETE_ITEM_URL, {"ItemCode": itemCode});
  }

  @override
  Future<void> createBatch(Batch batchData) async {
    await _provider.post(CREATE_BATCH_URL, batchData.toJson());
  }

  @override
  Future<void> updateBatch(Batch batchData) async {
    await _provider.post(UPDATE_BATCH_URL, batchData.toJson());
  }

  @override
  Future<void> deleteBatch(
      String barcode, String itemCode, String purchaseDate) async {
    await _provider.post(DELETE_BATCH_URL, {
      "Barcode": barcode,
      "ItemCode": itemCode,
      "PurchaseDate": purchaseDate
    });
  }
}
