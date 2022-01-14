import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:inventory_app/models/item.dart';
import 'package:inventory_app/utils/consts.dart';

class InventoryData extends StatefulWidget {
  final List<Item> data;
  final String storeName;
  const InventoryData({Key? key, required this.data, required this.storeName})
      : super(key: key);

  @override
  _InventoryDataState createState() => _InventoryDataState();
}

class _InventoryDataState extends State<InventoryData> {
  late TextEditingController _itemSearchController;
  List<Item> itemsToShow = [];

  @override
  void initState() {
    _itemSearchController = TextEditingController();
    setState(() {
      itemsToShow = widget.data;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _scanBarcode = 'Unknown';

    Future<void> scanBarcodeNormal() async {
      String barcodeScanRes;
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      } on PlatformException {
        barcodeScanRes = 'Failed to get platform version.';
      }
      if (!mounted) return;

      setState(() {
        _scanBarcode = barcodeScanRes;
        _itemSearchController.text = _scanBarcode;
        itemsToShow = [];
        widget.data.forEach((item) {
          if (item.name == null || item.barcode == null) {
            return;
          }
          if (item.barcode!
              .toLowerCase()
              .contains(_scanBarcode.toLowerCase())) {
            itemsToShow.add(item);
          }
        });
      });
    }

    return Column(mainAxisSize: MainAxisSize.max, children: [
      const SizedBox(height: V_LARGE_PAD),
      Row(
        children: [
          Container(
              width: AppConstants().width * 0.8,
              padding:
                  EdgeInsets.fromLTRB(0, AppConstants().height * 0.01, 0, 0),
              child: Material(
                elevation: 8,
                borderRadius: const BorderRadius.all(Radius.circular(36)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: TextField(
                      cursorColor: TEXT_FIELD_CURSOR_COLOR,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          disabledBorder: InputBorder.none,
                          suffixIcon: Icon(Icons.search),
                          hintText: 'Enter Device name or barcode',
                          errorStyle: TextStyle(height: 0),
                          fillColor: Colors.white),
                      controller: _itemSearchController,
                      onChanged: (searchString) {
                        if (searchString.length > 2) {
                          setState(() {
                            itemsToShow = [];
                            widget.data.forEach((item) {
                              if (item.name == null || item.barcode == null) {
                                return;
                              }
                              if (item.name!
                                      .toLowerCase()
                                      .contains(searchString.toLowerCase()) ||
                                  item.barcode!
                                      .toLowerCase()
                                      .contains(searchString.toLowerCase())) {
                                itemsToShow.add(item);
                              }
                            });
                          });
                        } else {
                          setState(() {
                            itemsToShow = widget.data;
                          });
                        }
                      }),
                ),
              )),
          IconButton(
              onPressed: () => scanBarcodeNormal(),
              icon: const Icon(Icons.photo_camera))
        ],
      ),
      const SizedBox(
        height: MEDIUM_PAD,
      ),
      Expanded(
          child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(
          thickness: 1,
        ),
        itemBuilder: (_, index) => ListTile(
            title: Text(
              "${itemsToShow[index].name}",
            ),
            subtitle: Row(
              children: [
                Text("${itemsToShow[index].batches}"),
                SizedBox(
                  width: SMALL_PAD,
                ),
                Text("${itemsToShow[index].barcode}"),
              ],
            ),
            onTap: () {
              // context
              //     .read<DeviceBloc>()
              //     .add(GetDeviceData(deviceId: _deviceList[index].deviceId));
            }),
        itemCount: itemsToShow.length,
      )),
    ]);
  }
}
