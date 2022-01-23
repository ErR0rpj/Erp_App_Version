class Item {
  int? notifLimit;
  String? hSNCode;
  int? batches;
  List<Null>? batchIds;
  String? sId;
  String? userId;
  String? name;
  String? company;
  String? category;
  double? totalUnits;
  String? weightVolume;
  String? description;
  String? unit;
  String? barcode;

  Item(
      {this.notifLimit,
      this.hSNCode,
      this.batches,
      this.batchIds,
      this.sId,
      this.userId,
      this.name,
      this.company,
      this.category,
      this.totalUnits,
      this.weightVolume,
      this.description,
      this.unit,
      this.barcode});

  Item.fromJson(Map<String, dynamic> json) {
    notifLimit = json['NotifLimit'];
    hSNCode = json['HSN_Code'];
    batches = json['Batches'];
    if (json['BatchIds'] != null) {
      batchIds = [];
    }
    sId = json['_id'];
    userId = json['UserId'];
    name = json['Name'];
    company = json['Company'];
    category = json['Category'];
    totalUnits =
        json['Total_Units'] != null && json['Total_Units'].runtimeType == double
            ? json['Total_Units']
            : json['Total_Units']?.toDouble();
    weightVolume = json['Weight_Volume'];
    description = json['Description'];
    unit = json['Unit'];
    barcode = json['Barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NotifLimit'] = this.notifLimit;
    data['HSN_Code'] = this.hSNCode;
    data['Batches'] = this.batches;
    if (this.batchIds != null) {
      data['BatchIds'] = [];
    }
    data['_id'] = this.sId;
    data['UserId'] = this.userId;
    data['Name'] = this.name;
    data['Company'] = this.company;
    data['Category'] = this.category;
    data['Total_Units'] = this.totalUnits;
    data['Weight_Volume'] = this.weightVolume;
    data['Description'] = this.description;
    data['Unit'] = this.unit;
    data['Barcode'] = this.barcode;
    return data;
  }
}
