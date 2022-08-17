


import 'package:flutter/material.dart';
import 'package:news_app_2/core/data/models/article_filter.dart';
import 'package:news_app_2/core/data/models/category.dart';
import 'package:news_app_2/core/ui/styles/app_colors.dart';

class CategoryFilterGroup extends StatelessWidget {
  final List<Category> allCategories;
  final List<int> selectedCategoryIds;
  final ValueChanged<FilterItem> onCategoryTap;

  const CategoryFilterGroup(
      {Key? key,
      required this.allCategories,
      required this.selectedCategoryIds,
      required this.onCategoryTap})
      : super(key: key);

  List<FilterItem> getCategoryFilterOptions() {
    return allCategories
        .map(
          (category) => FilterItem(
            id: category.id,
            name: category.name ?? "",
            isSelected: selectedCategoryIds.contains(category.id),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Categories", style: TextStyle(fontSize: 15.5),),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: [
            ...getCategoryFilterOptions().map(
              (item) {
                return CategoryChip(
                  category: item.name,
                  isSelected: item.isSelected,
                  onSelected: () => onCategoryTap.call(item),
                );
              },
            ).toList(),
          ],
        )
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onSelected;

  const CategoryChip(
      {Key? key,
      required this.category,
      required this.isSelected,
      required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = isSelected ? Icons.check : Icons.add;
    final color = isSelected ? Colors.black : AppColors.textGrey;
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      color: Colors.grey.withOpacity(0.2),
    );

    return GestureDetector(
      onTap: () {
        onSelected();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 9, vertical: 2),
        decoration: decoration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              icon,
              color: color,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }
}
