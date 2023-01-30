class AuditRequestDataModel {
  final String productCode;
  final String locationCode;
  final String dateTime;
  final String vendor;
  final String matDesc;
  final String poNo;
  final String itemCode;
  final String dept;
  final String qty;
  final String sieDate;
  final String sieNo;
  final String isProductChecked;
  final String remark;

  const AuditRequestDataModel({
    required this.productCode,
    required this.locationCode,
    required this.dateTime,
    required this.vendor,
    required this.matDesc,
    required this.poNo,
    required this.itemCode,
    required this.dept,
    required this.qty,
    required this.sieDate,
    required this.sieNo,
    required this.isProductChecked,
    required this.remark,
  });

  Map<String, dynamic> toMap() {
    return {
      "productCode": productCode,
      "locationCode": locationCode,
      "dateTime": dateTime,
      "vendor": vendor,
      "matDesc": matDesc,
      "poNo": poNo,
      "itemCode": itemCode,
      "dept": dept,
      "qty": qty,
      "sieDate": sieDate, //.toIso8601String(),
      "sieNo": sieNo,
      "isProductChecked": isProductChecked,
      "remark": remark,
    };
  }

  Map<String, dynamic> toJson() => {
        "productCode": productCode,
        "locationCode": locationCode,
        "dateTime": dateTime,
        "vendor": vendor,
        "matDesc": matDesc,
        "poNo": poNo,
        "itemCode": itemCode,
        "dept": dept,
        "qty": qty,
        "sieDate": sieDate, //.toIso8601String(),
        "sieNo": sieNo,
        "isProductChecked": isProductChecked,
        "remark": remark,
      };

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'auditProducts{productCode: $productCode, locationCode: $locationCode, dateTime: $dateTime, vendor: $vendor, matDesc: $matDesc, poNo: $poNo, itemCode: $itemCode, dept: $dept, qty: $qty, sieDate: $sieDate, sieNo: $sieNo, isProductChecked: $isProductChecked, remark: $remark}';
  }
}
