import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/blocs/blocs.dart';
import 'package:inventory_app/utils/consts.dart';
import 'package:inventory_app/presentation/elements/BigWideButton.dart';
import 'package:inventory_app/presentation/elements/TextInput.dart';
import 'package:inventory_app/repos/repos.dart';
import 'package:inventory_app/models/models.dart';

class AddEditBatch extends StatefulWidget {
  @override
  _AddEditBatchState createState() => _AddEditBatchState();
}

class _AddEditBatchState extends State<AddEditBatch> {
  late Batch _batchData;
  bool _isEdit = false;
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
  DateTime _expiry = DateTime.now().add(const Duration(days: 365 * 2));

  @override
  void didChangeDependencies() {
    setState(() {
      _batchData = ModalRoute.of(context)?.settings.arguments as Batch;
    });
    super.didChangeDependencies();
    updateDataIfAvailable();
  }

  Future<void> updateDataIfAvailable() async {
    if (_batchData == null || _batchData.mRP == null || _batchData.mRP == 0) {
      return;
    }
    setState(() {
      _isEdit = true;
      _quantityController.text =
          _batchData.quantity != null ? _batchData.quantity.toString() : '';
      _costPriceController.text =
          _batchData.costPrice != null ? _batchData.costPrice.toString() : '0';
      _sellPriceController.text = _batchData.sellingPrice != null
          ? _batchData.sellingPrice.toString()
          : '';
      _mrpController.text =
          _batchData.mRP != null ? _batchData.mRP.toString() : '';
      _cgstController.text =
          _batchData.cGST != null ? _batchData.cGST.toString() : '';
      _sgstController.text =
          _batchData.sGST != null ? _batchData.sGST.toString() : '';
      _igstController.text =
          _batchData.iGST != null ? _batchData.iGST.toString() : '';
      _cessController.text =
          _batchData.cess != null ? _batchData.cess.toString() : '';
      _locationController.text = _batchData.location ?? '';
      _date = DateTime.parse(_batchData.date ?? '');
      _expiry = DateTime.parse(_batchData.expiry ?? '');
    });
  }

  Future<void> createBatch() async {
    Batch newBatch = Batch(
        quantity: double.parse(_quantityController.text),
        costPrice: double.parse(_costPriceController.text),
        mRP: double.parse(_mrpController.text),
        cGST: double.parse(_cgstController.text),
        sGST: double.parse(_sgstController.text),
        iGST: double.parse(_igstController.text),
        itemCode: _batchData.itemCode,
        date: _date.toString(),
        userId: _batchData.userId,
        expiry: _expiry.toString(),
        location: _locationController.text,
        barcode: _batchData.barcode,
        sellingPrice: double.parse(_sellPriceController.text),
        cess: double.parse(_cessController.text));
    await StoreRepository().createBatch(newBatch);
    Navigator.pop(context);
  }

  Future<void> updateBatch() async {
    Batch newBatch = Batch(
        quantity: double.parse(_quantityController.text),
        costPrice: double.parse(_costPriceController.text),
        mRP: double.parse(_mrpController.text),
        cGST: double.parse(_cgstController.text),
        sGST: double.parse(_sgstController.text),
        iGST: double.parse(_igstController.text),
        date: _date.toString(),
        itemCode: _batchData.itemCode,
        userId: _batchData.userId,
        expiry: _expiry.toString(),
        barcode: _batchData.barcode,
        location: _locationController.text,
        sellingPrice: double.parse(_sellPriceController.text),
        cess: double.parse(_cessController.text));
    await StoreRepository().updateBatch(newBatch);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${_isEdit ? _batchData.date : "Create Batch"}'),
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
                  fieldName: 'Quantity',
                  validator: nameValidator,
                  keyboardType: TextInputType.number,
                  inputController: _quantityController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'Cost Price',
                  validator: nameValidator,
                  keyboardType: TextInputType.number,
                  inputController: _costPriceController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'Selling Price',
                  validator: nameValidator,
                  keyboardType: TextInputType.number,
                  inputController: _sellPriceController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'MRP',
                  validator: nameValidator,
                  keyboardType: TextInputType.number,
                  inputController: _mrpController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'CGST',
                  validator: nameValidator,
                  keyboardType: TextInputType.number,
                  inputController: _cgstController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'SGST',
                  validator: nameValidator,
                  keyboardType: TextInputType.number,
                  inputController: _sgstController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'IGST',
                  validator: nameValidator,
                  keyboardType: TextInputType.number,
                  inputController: _igstController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'Cess',
                  validator: nameValidator,
                  keyboardType: TextInputType.number,
                  inputController: _cessController),
              const SizedBox(height: MEDIUM_PAD),
              TextFieldInput(
                  fieldName: 'Location',
                  validator: nameValidator,
                  keyboardType: TextInputType.text,
                  inputController: _locationController),
              const SizedBox(height: MEDIUM_PAD),
              MaterialButton(
                child: const Text('Choose Date'),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 2000)),
                  ).then((date) {
                    setState(() {
                      _date = date!;
                    });
                  });
                },
              ),
              const SizedBox(height: MEDIUM_PAD),
              MaterialButton(
                child: const Text('Choose Expiry'),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 2000)),
                  ).then((date) {
                    setState(() {
                      _expiry = date!;
                    });
                  });
                },
              ),
              const SizedBox(height: MEDIUM_PAD),
              BigWideButton(
                text: _isEdit ? 'Update Batch' : 'Create Batch',
                onPressed: () {
                  _isEdit ? updateBatch() : createBatch();
                },
              ),
              const SizedBox(height: SMALL_PAD),
            ],
          ),
        ));
  }
}
