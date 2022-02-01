import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
  DateTime _date = DateTime.now();
  DateTime? _expiry = null;
  DateTime? _pkgOrMfg = null;
  String _location = 'Shelf';
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
      _cgstController.text = "0";
      _sgstController.text = "0";
      _igstController.text = "0";
      _cessController.text = "0";
      _costPriceController.text = "0";
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
      _location = _batchData.location ?? 'Shelf';
      if (!['Shelf', 'Carton'].contains(_location)) {
        _location = 'Shelf';
      }
      _date = DateTime.parse(_batchData.date ?? '');
      _expiry = _batchData.expiry != null
          ? DateTime.parse(_batchData.expiry ?? '')
          : null;
      _pkgOrMfg = _batchData.pkgOrMfg != null
          ? DateTime.parse(_batchData.pkgOrMfg ?? '')
          : null;
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
        expiry: _expiry != null ? _expiry.toString() : null,
        pkgOrMfg: _pkgOrMfg != null ? _pkgOrMfg.toString() : null,
        location: _location,
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
        expiry: _expiry != null ? _expiry.toString() : null,
        pkgOrMfg: _pkgOrMfg != null ? _pkgOrMfg.toString() : null,
        barcode: _batchData.barcode,
        location: _location,
        sellingPrice: double.parse(_sellPriceController.text),
        cess: double.parse(_cessController.text));
    await StoreRepository().updateBatch(newBatch);
    // Navigator.pop(context);
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
              // TextFieldInput(
              //     fieldName: 'Location',
              //     validator: nameValidator,
              //     keyboardType: TextInputType.text,
              //     inputController: _locationController),
              Container(child: Text('Location')),
              DropdownButton<String>(
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
              ),
              // Container(child:Text('Location')),
              // !_isEdit
              //     ? DropdownButton<String>(
              //   value: _location,
              //   elevation: 16,
              //   style: const TextStyle(color: Colors.deepPurple),
              //   underline: Container(
              //     height: 2,
              //     color: Colors.deepPurpleAccent,
              //   ),
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       _location = newValue!;
              //     });
              //   },
              //   items: ['Shelf', 'Carton']
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              // )
              //     : Container(),
              const SizedBox(height: MEDIUM_PAD),
              MaterialButton(
                child: Text(
                    'Choose Purchase Date | ${DateFormat.yMMMd().format(_date)}'),
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
                child: Text(
                    'Choose Expiry |${_expiry != null ? DateFormat.yMMMd().format(_expiry!) : ''}'),
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
              Container(child: Text('OR')),
              const SizedBox(height: MEDIUM_PAD),
              MaterialButton(
                child: Text(
                    'Choose Pkg/Mfg Date: | ${_pkgOrMfg != null ? DateFormat.yMMMd().format(_pkgOrMfg!) : ''}'),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 2000)),
                  ).then((date) {
                    setState(() {
                      _pkgOrMfg = date!;
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
