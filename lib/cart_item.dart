class CartItem {
  final int itemId;
  final int variantId;
  final List<int> extraIds;
  final int quantity;
  final double price;

  CartItem({
    required this.itemId,
    required this.variantId,
    required this.extraIds,
    required this.quantity,
    required this.price,
  });
}
