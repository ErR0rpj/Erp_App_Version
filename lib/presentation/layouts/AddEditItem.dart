import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/blocs/blocs.dart';
import 'package:inventory_app/utils/consts.dart';
import 'package:inventory_app/presentation/elements/BigWideButton.dart';
import 'package:inventory_app/presentation/elements/TextInput.dart';
import 'package:inventory_app/repos/repos.dart';
import 'package:inventory_app/models/models.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';

class AddEditItem extends StatefulWidget {
  @override
  _AddEditItemState createState() => _AddEditItemState();
}

class _AddEditItemState extends State<AddEditItem> {
  late Item _itemData;
  bool _isEdit = false;
  //Item Data
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _wtvolController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _hsnController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _shelfLife = TextEditingController();
  //Batch Data
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _cgstController = TextEditingController();
  final TextEditingController _sgstController = TextEditingController();
  final TextEditingController _igstController = TextEditingController();
  final TextEditingController _cessController = TextEditingController();
  String _location = 'Shelf';
  DateTime _date = DateTime.now();
  DateTime _expiry = DateTime.now().add(const Duration(days: 365 * 2));

  @override
  void didChangeDependencies() {
    setState(() {
      _itemData = ModalRoute.of(context)?.settings.arguments as Item;
    });
    super.didChangeDependencies();
    updateDataIfAvailable();
    _categoryController.addListener(_addCategory);
    _unitController.addListener(_addUnit);
    _cgstController.text="0";
    _sgstController.text="0";
    _igstController.text="0";
    _cessController.text="0";
    _costPriceController.text="0";
    _unitController.text="Pieces";
    _hsnController.text="0";
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
      _barcodeController.text = barcodeScanRes;
    });
  }

  void _addCategory() {
    if (_categoryController.text.isEmpty) {
      return;
    } else if (categories.contains(_categoryController.text)) {
      return;
    } else if (categories.length == 18) {
      categories.add(_categoryController.text);
    } else {
      categories.removeLast();
      categories.add(_categoryController.text);
    }
    setState(() {});
  }

  void _addUnit() {
    if (_unitController.text.isEmpty) {
      return;
    } else if (units.contains(_unitController.text)) {
      return;
    } else if (units.length == 3) {
      units.add(_unitController.text);
    } else {
      units.removeLast();
      units.add(_unitController.text);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _categoryController.removeListener(_addCategory);
    _unitController.removeListener(_addUnit);
    super.dispose();
  }

  Future<void> updateDataIfAvailable() async {
    if (_itemData == null ||
        _itemData.barcode == null ||
        _itemData.barcode == '') {
      return;
    }
    setState(() {
      _isEdit = true;
      _categoryController.text = _itemData.category ?? '';
      _companyController.text = _itemData.company ?? '';
      _nameController.text = _itemData.name ?? '';
      _wtvolController.text = _itemData.weightVolume ?? '';
      _unitController.text = _itemData.unit ?? '';
      _hsnController.text = _itemData.hSNCode ?? '';
      _barcodeController.text = _itemData.barcode ?? '';
      _shelfLife.text =
          _itemData.shelfLife != null ? _itemData.shelfLife.toString() : '';
    });
  }

  Future<void> createItem() async {
    Item newItem = Item(
        category: _categoryController.text,
        company: _companyController.text,
        name: _nameController.text,
        weightVolume: _wtvolController.text,
        unit: _unitController.text,
        hSNCode: _hsnController.text,
        barcode: _barcodeController.text,
        shelfLife: int.parse(_shelfLife.text));
    Batch newBatch = Batch(
        quantity: double.parse(_quantityController.text),
        costPrice: double.parse(_costPriceController.text),
        mRP: double.parse(_mrpController.text),
        cGST: double.parse(_cgstController.text),
        sGST: double.parse(_sgstController.text),
        iGST: double.parse(_igstController.text),
        barcode: _barcodeController.text,
        date: _date.toString(),
        expiry: _expiry.toString(),
        location: _location,
        sellingPrice: double.parse(_sellPriceController.text),
        cess: double.parse(_cessController.text));
    await StoreRepository().createItem(newItem, newBatch);
    Navigator.pop(context);
  }

  Future<void> updateItem() async {
    Item updateItem = Item(
        sId: _itemData.sId,
        category: _categoryController.text,
        company: _companyController.text,
        name: _nameController.text,
        weightVolume: _wtvolController.text,
        unit: _unitController.text,
        hSNCode: _hsnController.text,
        barcode: _barcodeController.text);
    await StoreRepository().updateItem(updateItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${_isEdit ? _itemData.name : "Create Item"}'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: AppConstants().height * 0.03,
                width: AppConstants().width,
              ),
              TextFieldInput(
                  fieldName: 'Product Category',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _categoryController),
              DropdownButton<String>(
                value: _categoryController.text,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _categoryController.text = newValue!;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'Company',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _companyController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'Item Name',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _nameController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'Weight Volume',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _wtvolController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'Unit',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _unitController),
              DropdownButton<String>(
                value: _unitController.text,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _unitController.text = newValue!;
                  });
                },
                items: units.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'HSN',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _hsnController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'Shelf Life',
                  validator: nameValidator,
                  keyboardType: TextInputType.number,
                  inputController: _shelfLife),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'Barcode',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _barcodeController),
              IconButton(
                  onPressed: () => scanBarcodeNormal(),
                  icon: const Icon(Icons.photo_camera)),
              const SizedBox(height: MEDIUM_PAD),
              !_isEdit
                  ? TextFieldInput(
                      fieldName: 'Quantity',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _quantityController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextFieldInput(
                      fieldName: 'Cost Price',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _costPriceController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextFieldInput(
                      fieldName: 'Selling Price',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _sellPriceController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextFieldInput(
                      fieldName: 'MRP',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _mrpController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextFieldInput(
                      fieldName: 'CGST',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _cgstController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextFieldInput(
                      fieldName: 'SGST',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _sgstController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextFieldInput(
                      fieldName: 'IGST',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _igstController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextFieldInput(
                      fieldName: 'Cess',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _cessController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              Container(child:Text('Location')),
              !_isEdit
                  ? DropdownButton<String>(
                      value: _location,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _location = newValue!;
                        });
                      },
                      items: ['Shelf', 'Carton']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? MaterialButton(
                      child: Text('Choose Purchase Date'),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 2000)),
                        ).then((date) {
                          setState(() {
                            _date = date!;
                          });
                        });
                      },
                    )
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? MaterialButton(
                      child: const Text('Choose Expiry Date'),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 2000)),
                        ).then((date) {
                          setState(() {
                            _expiry = date!;
                          });
                        });
                      },
                    )
                  : Container(),
              const SizedBox(height: MEDIUM_PAD),
              BigWideButton(
                text: _isEdit ? 'Update Item' : 'Create Item',
                onPressed: () {
                  _isEdit ? updateItem() : createItem();
                },
              ),
              const SizedBox(height: SMALL_PAD),
            ],
          ),
        ));
  }
}
