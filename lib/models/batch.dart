class Batch {
  num? cGST;
  num? sGST;
  num? iGST;
  String? hSNCode;
  String? sId;
  String? userId;
  String? barcode;
  String? date;
  String? itemCode;
  String? expiry;
  num? quantity;
  num? costPrice;
  num? sellingPrice;
  num? mRP;
  String? location;
  num? cess;

  Batch(
      {this.cGST,
      this.sGST,
      this.iGST,
      this.hSNCode,
      this.sId,
      this.userId,
      this.barcode,
      this.date,
      this.itemCode,
      this.quantity,
      this.costPrice,
      this.sellingPrice,
      this.expiry,
      this.location,
      this.cess,
      this.mRP});

  Batch.fromJson(Map<String, dynamic> json) {
    cGST = json['CGST'];
    sGST = json['SGST'];
    iGST = json['IGST'];
    hSNCode = json['HSN_Code'];
    sId = json['_id'];
    expiry = json['Expiry'];
    userId = json['UserId'];
    barcode = json['Barcode'];
    date = json['Date'];
    itemCode = json['ItemCode'];
    quantity = json['Quantity'];
    costPrice = json['Cost_Price'];
    sellingPrice = json['Selling_Price'];
    mRP = json['MRP'];
    location = json['Location'];
    cess = json['Cess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CGST'] = this.cGST;
    data['SGST'] = this.sGST;
    data['IGST'] = this.iGST;
    data['HSN_Code'] = this.hSNCode;
    data['_id'] = this.sId;
    data['UserId'] = this.userId;
    data['Barcode'] = this.barcode;
    data['Date'] = this.date;
    data['ItemCode'] = this.itemCode;
    data['Quantity'] = this.quantity;
    data['Cost_Price'] = this.costPrice;
    data['Selling_Price'] = this.sellingPrice;
    data['MRP'] = this.mRP;
    data['Expiry'] = this.expiry;
    data['Location'] = this.location;
    data['Cess'] = this.cess;
    data['PurchaseDate'] = this.date;
    return data;
  }
}
