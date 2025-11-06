class CostEntryModel {
  final int? id;
  final int productId;
  final int categoryId;
  final String itemName;
  final double amount;
  final int costDate;
  final String? notes;
  final int createdAt;
  final int updatedAt;

  CostEntryModel({
    this.id,
    required this.productId,
    required this.categoryId,
    required this.itemName,
    required this.amount,
    required this.costDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'category_id': categoryId,
      'item_name': itemName,
      'amount': amount,
      'cost_date': costDate,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Create from database Map
  factory CostEntryModel.fromMap(Map<String, dynamic> map) {
    return CostEntryModel(
      id: map['id'] as int?,
      productId: map['product_id'] as int,
      categoryId: map['category_id'] as int,
      itemName: map['item_name'] as String,
      amount: (map['amount'] as num).toDouble(),
      costDate: map['cost_date'] as int,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  // Copy with method
  CostEntryModel copyWith({
    int? id,
    int? productId,
    int? categoryId,
    String? itemName,
    double? amount,
    int? costDate,
    String? notes,
    int? createdAt,
    int? updatedAt,
  }) {
    return CostEntryModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      itemName: itemName ?? this.itemName,
      amount: amount ?? this.amount,
      costDate: costDate ?? this.costDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'CostEntryModel(id: $id, itemName: $itemName, amount: $amount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostEntryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          itemName == other.itemName;

  @override
  int get hashCode => id.hashCode ^ itemName.hashCode;
}
