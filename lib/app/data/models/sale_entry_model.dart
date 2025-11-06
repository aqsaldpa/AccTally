class SaleEntryModel {
  final int? id;
  final int productId;
  final int quantity;
  final double unitPrice;
  final double totalRevenue;
  final int saleDate;
  final String? notes;
  final int createdAt;
  final int updatedAt;

  SaleEntryModel({
    this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalRevenue,
    required this.saleDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_revenue': totalRevenue,
      'sale_date': saleDate,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Create from database Map
  factory SaleEntryModel.fromMap(Map<String, dynamic> map) {
    return SaleEntryModel(
      id: map['id'] as int?,
      productId: map['product_id'] as int,
      quantity: map['quantity'] as int,
      unitPrice: (map['unit_price'] as num).toDouble(),
      totalRevenue: (map['total_revenue'] as num).toDouble(),
      saleDate: map['sale_date'] as int,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  // Copy with method
  SaleEntryModel copyWith({
    int? id,
    int? productId,
    int? quantity,
    double? unitPrice,
    double? totalRevenue,
    int? saleDate,
    String? notes,
    int? createdAt,
    int? updatedAt,
  }) {
    return SaleEntryModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      saleDate: saleDate ?? this.saleDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'SaleEntryModel(id: $id, productId: $productId, quantity: $quantity, totalRevenue: $totalRevenue)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleEntryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productId == other.productId &&
          saleDate == other.saleDate;

  @override
  int get hashCode => id.hashCode ^ productId.hashCode ^ saleDate.hashCode;
}
