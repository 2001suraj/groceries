import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:groceries/const/app_color.dart';
import 'package:groceries/provider/product_provider.dart';
import 'package:groceries/screen/add_product_screen.dart';

class CategoryListWidget extends ConsumerWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedList = ref.watch(selectedChipProvider);
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: List<Widget>.generate(
          categoty_list.length,
          (int index) {
            return ChoiceChip(
              selectedColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              label: Text(categoty_list[index]),
              selected: selectedList.contains(categoty_list[index]),
              onSelected: (bool selected) {
                ref.read(selectedChipProvider.notifier).removeAll();
                ref.read(selectedChipProvider.notifier).addId1(categoty_list[index]);
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
