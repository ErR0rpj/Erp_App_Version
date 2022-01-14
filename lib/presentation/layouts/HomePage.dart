import 'package:flutter/material.dart';
import 'package:inventory_app/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/blocs/store/store_bloc.dart';
import 'package:inventory_app/blocs/store/store_state.dart';
import 'package:inventory_app/presentation/layouts/InventoryData.dart';
import 'package:inventory_app/utils/consts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    AppConstants().calculateSize(context);
    return WillPopScope(onWillPop: () async {
      final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return EXIT_ALERT;
          });
      return value == true;
    }, child: Scaffold(
      body: Builder(builder: (context) {
        final storeBlocState = context.watch<StoreBloc>().state;
        if (storeBlocState is StoreNameLoaded) {
          return Center(
            child: Text('Loading Data for ${storeBlocState.storeName}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        } else if (storeBlocState is StoreDataLoaded) {
          return InventoryData(
            data: storeBlocState.itemData,
            storeName: storeBlocState.storeName,
          );
        } else {
          return const Text('User Not Loaded');
        }
      }),
    ));
  }
}
