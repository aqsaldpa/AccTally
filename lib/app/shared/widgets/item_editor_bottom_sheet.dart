import 'package:acctally/core/constants/app_colors.dart';
import 'package:acctally/app/models/cost_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ItemEditorBottomSheet extends StatefulWidget {
  final String title;
  final String? initialName;
  final bool includeCostType;
  final CostType? initialCostType;
  final void Function(String name, CostType? costType) onSave;

  const ItemEditorBottomSheet({
    super.key,
    required this.title,
    required this.onSave,
    this.initialName,
    this.includeCostType = false,
    this.initialCostType,
  });

  @override
  State<ItemEditorBottomSheet> createState() => ItemEditorBottomSheetState();
}

class ItemEditorBottomSheetState extends State<ItemEditorBottomSheet> {
  late final TextEditingController nameController;
  CostType? selectedCostType;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName ?? '');
    selectedCostType = widget.initialCostType;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void handleSave() {
    final isNameValid = nameController.text.trim().isNotEmpty;
    final isCostValid = !widget.includeCostType || selectedCostType != null;

    if (!isNameValid || !isCostValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            !isNameValid
                ? 'Name is required'
                : 'Please select cost type',
          ),
        ),
      );
      return;
    }

    widget.onSave(nameController.text.trim(), selectedCostType);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.w,
        right: 20.w,
        top: 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          Gap(16.h),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          if (widget.includeCostType) ...[
            Gap(12.h),
            DropdownButtonFormField<CostType>(
              value: selectedCostType,
              items: CostType.values
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.label),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedCostType = v),
              decoration: InputDecoration(
                hintText: 'Cost type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
          Gap(20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ),
          Gap(12.h),
        ],
      ),
    );
  }
}
