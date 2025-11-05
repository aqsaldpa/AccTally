enum CostType { variable, fixed }

extension CostTypeLabel on CostType {
  String get label {
    switch (this) {
      case CostType.variable:
        return 'Variable cost';
      case CostType.fixed:
        return 'Fixed cost';
    }
  }
}

