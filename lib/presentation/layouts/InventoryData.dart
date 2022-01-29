import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/blocs/store/store_bloc.dart';
import 'package:inventory_app/blocs/store/store_event.dart';
import 'package:inventory_app/blocs/store/store_state.dart';
import 'package:inventory_app/models/batch.dart';
import 'package:inventory_app/models/item.dart';
import 'package:inventory_app/presentation/elements/Dialog.dart';
import 'package:inventory_app/utils/consts.dart';
import 'package:inventory_app/repos/repos.dart';

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
  bool isExpand = false;
  Map<String, bool> expansionState = <String, bool>{};
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    _itemSearchController = TextEditingController();
    setState(() {
      itemsToShow = widget.data;
    });
    super.initState();
  }

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
        if (item.barcode!.toLowerCase().contains(_scanBarcode.toLowerCase())) {
          itemsToShow.add(item);
          _itemSearchController.clear();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {
        if (state is StoreDataLoaded) {
          setState(() {
            itemsToShow = state.itemData;
            _itemSearchController.clear();
          });
        }
      },
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        const SizedBox(height: V_LARGE_PAD),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: AppConstants().width * 0.6,
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
                icon: const Icon(Icons.photo_camera)),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ITEM_ADDEDIT_PATH).then(
                      (value) => BlocProvider.of<StoreBloc>(context)
                          .add(GetStoreItems()));
                },
                icon: const Icon(Icons.add_box)),
          ],
        ),
        const SizedBox(
          height: MEDIUM_PAD,
        ),
        Expanded(
            child: ExpandableTheme(
          data: const ExpandableThemeData(
              iconColor: Colors.blue, useInkWell: false, hasIcon: false),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: itemsToShow.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpandableWidget(itemsToShow[index]);
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ))
      ]),
    );
  }
}

class ExpandableWidget extends StatefulWidget {
  late Item itemData;

  ExpandableWidget(Item entry, {Key? key}) : super(key: key) {
    itemData = entry;
  }

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  late List<Batch> batches = [];

  @override
  Widget build(BuildContext context) {
    deleteItem() async {
      await StoreRepository().deleteItem(widget.itemData.sId ?? '');
      BlocProvider.of<StoreBloc>(context).add(GetStoreItems());
    }

    buildHeader() {
      return Builder(
        builder: (context) {
          var controller = ExpandableController.of(context);
          if (batches.isNotEmpty &&
              widget.itemData.sId != batches[0].itemCode) {
            controller?.expanded = false;
          }
          return Container(
            width: double.infinity,
            height: 25.0 * 5,
            alignment: Alignment.center,
            child: Stack(children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.fromLTRB(SMALL_PAD, V_SMALL_PAD, 0, 0),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Name: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: '${widget.itemData.name}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: V_SMALL_PAD,
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Barcode: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: '${widget.itemData.barcode}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: V_SMALL_PAD,
                    ),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'HSN: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: '${widget.itemData.hSNCode}',
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'Company: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: '${widget.itemData.company}',
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: V_SMALL_PAD,
                    ),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'Cat: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: '${widget.itemData.category}',
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'Tot Units: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: '${widget.itemData.totalUnits}',
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: V_SMALL_PAD,
                    ),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'Wt/Vol: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: '${widget.itemData.weightVolume}',
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'Unit: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: '${widget.itemData.unit}',
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: MaterialButton(
                  onPressed: () async {
                    controller?.toggle();
                    var batchesList = await StoreRepository()
                        .getItemBatchData(widget.itemData.sId!);
                    setState(() {
                      batches = batchesList;
                    });
                  },
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                    onPressed: () => Navigator.of(context)
                            .pushNamed(ITEM_ADDEDIT_PATH,
                                arguments: widget.itemData)
                            .then((value) {
                          BlocProvider.of<StoreBloc>(context)
                              .add(GetStoreItems());
                        }),
                    icon: const Icon(Icons.edit)),
              ),
              Positioned(
                right: 40,
                child: IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                        BATCH_ADDEDIT_PATH,
                        arguments: Batch(
                            itemCode: widget.itemData.sId,
                            barcode: widget.itemData.barcode,
                            userId: widget.itemData.userId)),
                    icon: const Icon(Icons.add)),
              ),
              Positioned(
                right: 80,
                child: IconButton(
                    onPressed: () async {
                      showDialogWrapper(
                          context: context,
                          affirmAction: () => deleteItem(),
                          dialogMessage:
                              'Are you sure you want to Delete this item?',
                          title: 'Delete Item',
                          barrierDismissible: true);
                    },
                    icon: const Icon(Icons.delete)),
              )
            ]),
          );
        },
      );
    }

    deleteBatch(Batch batchData) async {
      await StoreRepository().deleteBatch(batchData.barcode ?? '',
          batchData.itemCode ?? '', batchData.date ?? '');
      List<Batch> batcheData =
          await StoreRepository().getItemBatchData(widget.itemData.sId!);
      setState(() {
        batches = batcheData;
      });
    }

    buildExpanded() {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: batches.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Sno.: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${index + 1}',
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialogWrapper(
                                context: context,
                                affirmAction: () => deleteBatch(batches[index]),
                                dialogMessage:
                                    'Are you sure you want to Delete this batch?',
                                title: 'Delete Batch',
                                barrierDismissible: true);
                          }),
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => Navigator.of(context)
                                  .pushNamed(BATCH_ADDEDIT_PATH,
                                      arguments: batches[index])
                                  .then((value) {
                                setState(() async {
                                  batches = await StoreRepository()
                                      .getItemBatchData(widget.itemData.sId!);
                                });
                              })),
                      const SizedBox(
                        width: SMALL_PAD,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Qty: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].quantity}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: V_SMALL_PAD,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Date: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].date}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: V_SMALL_PAD,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: V_SMALL_PAD,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'MRP: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].mRP}',
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'CGST: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].cGST}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: V_SMALL_PAD,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'IGST: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].iGST}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: V_SMALL_PAD,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'SGST: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].sGST}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: V_SMALL_PAD,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: V_SMALL_PAD,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Expiry: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].expiry}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: V_SMALL_PAD,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: V_SMALL_PAD,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Cost Price: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].costPrice}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: V_SMALL_PAD,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Sell Price: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].sellingPrice}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: V_SMALL_PAD,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'MRP: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].mRP}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: V_SMALL_PAD,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: V_SMALL_PAD,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Location: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].location}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: V_SMALL_PAD,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Cess: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].cess}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: V_SMALL_PAD,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Barcode: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].barcode}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: V_SMALL_PAD,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'HSN: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: '${batches[index].hSNCode}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: V_SMALL_PAD,
                  ),
                ],
              ));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    }

    return ExpandableNotifier(
        child: Container(
      color: Colors.amber[600],
      padding: const EdgeInsets.only(left: 10.0, right: 0, bottom: 0),
      child: ScrollOnExpand(
        child: ExpandablePanel(
          header: buildHeader(),
          expanded: buildExpanded(),
          collapsed: Container(),
        ),
      ),
    ));
  }
}
