enum CostType { fixed, variable }

extension CostTypeExtension on CostType {
  String toStringValue() => this == CostType.fixed ? 'fixed' : 'variable';

  String get label => this == CostType.fixed ? 'Fixed Cost' : 'Variable Cost';

  static CostType fromString(String value) {
    return value == 'fixed' ? CostType.fixed : CostType.variable;
  }
}

class CategoryModel {
  final int? id;
  final String name;
  final CostType costType;
  final String? description;
  final int createdAt;
  final int updatedAt;

  CategoryModel({
    this.id,
    required this.name,
    required this.costType,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost_type': costType.toStringValue(),
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Create from database Map
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      costType: CostTypeExtension.fromString(map['cost_type'] as String),
      description: map['description'] as String?,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  // Copy with method
  CategoryModel copyWith({
    int? id,
    String? name,
    CostType? costType,
    String? description,
    int? createdAt,
    int? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      costType: costType ?? this.costType,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'CategoryModel(id: $id, name: $name, costType: ${costType.label})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
