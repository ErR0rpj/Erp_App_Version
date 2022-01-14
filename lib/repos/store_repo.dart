import 'dart:async';
import 'package:inventory_app/models/item.dart';
import 'package:inventory_app/utils/consts.dart';
import 'package:inventory_app/utils/networking/RestWrapper.dart';
import 'package:inventory_app/models/models.dart';

abstract class StoreService {
  Future<String> getStoreName(String token);
  Future<List<Item>> getStoreData();
}

class StoreRepository extends StoreService {
  RestWrapper _provider = RestWrapper();

  @override
  Future<String> getStoreName(String token) async {
    await _provider.setToken(token);
    final String response = await _provider.get(STORE_NAME_URL);
    print(response);
    return response;
  }

  @override
  Future<List<Item>> getStoreData() async {
    print(STORE_ITEMS_URL);
    final List<dynamic> response = await _provider.get(STORE_ITEMS_URL);
    List<Item> items = [];
    for (var v in response) {
      items.add(Item.fromJson(v));
    }
    return items;
  }
}
