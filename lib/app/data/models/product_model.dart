class ProductModel {
  final int? id;
  final String name;
  final String? description;
  final String unit;
  final double sellingPrice;
  final double fixedCost;
  final double variableCost;
  final int createdAt;
  final int updatedAt;

  ProductModel({
    this.id,
    required this.name,
    this.description,
    this.unit = 'unit',
    required this.sellingPrice,
    this.fixedCost = 0,
    this.variableCost = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'unit': unit,
      'selling_price': sellingPrice,
      'fixed_cost': fixedCost,
      'variable_cost': variableCost,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Create from database Map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      unit: map['unit'] as String? ?? 'unit',
      sellingPrice: (map['selling_price'] as num).toDouble(),
      fixedCost: (map['fixed_cost'] as num?)?.toDouble() ?? 0,
      variableCost: (map['variable_cost'] as num?)?.toDouble() ?? 0,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  // Copy with method
  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    String? unit,
    double? sellingPrice,
    double? fixedCost,
    double? variableCost,
    int? createdAt,
    int? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      fixedCost: fixedCost ?? this.fixedCost,
      variableCost: variableCost ?? this.variableCost,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'ProductModel(id: $id, name: $name, unit: $unit, sellingPrice: $sellingPrice)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
