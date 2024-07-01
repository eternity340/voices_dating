class PurchaseProductEntity {
  PurchaseProductEntity({
    this.month,
    this.price,
    this.tag,
    this.isSelect,
    this.perPrice,
    this.saveCount,
    this.isRecommend = false,
  });


  int? month;
  String? price;
  String? perPrice;
  String? tag;
  String? saveCount;
  bool? isSelect;
  bool isRecommend;

}