class ReviewCartModel {
  String? cartId;
  String? cartImage;
  String? cartName;
  int? cartPrice;
  int? cartQuantity;
  var cartUnit;
  String? orderId;
  ReviewCartModel({
   this.cartId,
    this.cartUnit,
     this.cartImage,
    this.cartName,
    this.cartPrice,
    this.cartQuantity,
    this.orderId,
  });
}
