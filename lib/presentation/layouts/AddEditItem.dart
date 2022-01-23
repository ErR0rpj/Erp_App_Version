import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/blocs/blocs.dart';
import 'package:inventory_app/utils/consts.dart';
import 'package:inventory_app/presentation/elements/BigWideButton.dart';
import 'package:inventory_app/presentation/elements/TextInput.dart';
import 'package:inventory_app/repos/repos.dart';
import 'package:inventory_app/models/models.dart';

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
  //Batch Data
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _cgstController = TextEditingController();
  final TextEditingController _sgstController = TextEditingController();
  final TextEditingController _igstController = TextEditingController();
  final TextEditingController _cessController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime _date = DateTime.now();
  DateTime _expiry = DateTime.now();

  @override
  void didChangeDependencies() {
    setState(() {
      _itemData = ModalRoute.of(context)?.settings.arguments as Item;
    });
    super.didChangeDependencies();
    updateDataIfAvailable();
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
        barcode: _barcodeController.text);
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
        location: _locationController.text,
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
              TextInput(
                  fieldName: 'Product Category',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _categoryController),
              const SizedBox(height: MEDIUM_PAD),
              TextInput(
                  fieldName: 'Company',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _companyController),
              const SizedBox(height: MEDIUM_PAD),
              TextInput(
                  fieldName: 'Item Name',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _nameController),
              const SizedBox(height: MEDIUM_PAD),
              TextInput(
                  fieldName: 'Weight Volume',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _wtvolController),
              const SizedBox(height: MEDIUM_PAD),
              TextInput(
                  fieldName: 'Unit Data',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _unitController),
              const SizedBox(height: MEDIUM_PAD),
              TextInput(
                  fieldName: 'HSN',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _hsnController),
              const SizedBox(height: MEDIUM_PAD),
              TextInput(
                  fieldName: 'Barcode',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _barcodeController),
              const SizedBox(height: MEDIUM_PAD),
              !_isEdit
                  ? TextInput(
                      fieldName: 'Quantity',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _quantityController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextInput(
                      fieldName: 'Cost Price',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _costPriceController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextInput(
                      fieldName: 'Selling Price',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _sellPriceController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextInput(
                      fieldName: 'MRP',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _mrpController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextInput(
                      fieldName: 'CGST',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _cgstController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextInput(
                      fieldName: 'SGST',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _sgstController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextInput(
                      fieldName: 'IGST',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _igstController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextInput(
                      fieldName: 'Cess',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _cessController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? TextInput(
                      fieldName: 'Location',
                      validator: nameValidator,
                      keyboardType: TextInputType.text,
                      inputController: _locationController)
                  : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit ? const SizedBox(height: MEDIUM_PAD) : Container(),
              !_isEdit
                  ? MaterialButton(
                      child: Text('Choose Date'),
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
                      child: const Text('Choose Expiry'),
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
