


import 'package:flutter/material.dart';
import 'package:news_app_2/core/app_colors.dart';
import 'package:news_app_2/core/models/article_filter.dart';
import 'package:news_app_2/core/utils.dart';

class ArticleDifficultyLevelGroup extends StatelessWidget {
  final List<String> allLevels;
  final List<String> selectedLevels;
  final ValueChanged<FilterItem> onLevelTap;
  const ArticleDifficultyLevelGroup(
      {Key? key,
      required this.allLevels,
      required this.selectedLevels,
      required this.onLevelTap})
      : super(key: key);

  List<FilterItem> getDifficultyLevelFilterOptions() {
    return allLevels
        .map(
          (level) => FilterItem(
            name: level,
            isSelected: selectedLevels.contains(level),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Difficulty",
          style: TextStyle(fontSize: 15.5),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: [
            ...getDifficultyLevelFilterOptions().map(
              (item) {
                return DifficultyLevelChip(
                  level: item.name,
                  isSelected: item.isSelected,
                  onSelected: () => onLevelTap.call(item),
                );
              },
            ).toList(),
          ],
        )
      ],
    );
  }
}

class DifficultyLevelChip extends StatelessWidget {
  final String level;
  final bool isSelected;
  final VoidCallback onSelected;

  const DifficultyLevelChip(
      {Key? key,
      required this.level,
      required this.isSelected,
      required this.onSelected})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    final icon = isSelected ? Icons.check : Icons.add;
    final color = getColor(level);

    return GestureDetector(
      onTap: () {
        onSelected();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: color.withOpacity(0.23)),
          color: isSelected ? color.withOpacity(0.23) : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  level,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7), fontSize: 11),
                )
              ],
            ),
            const SizedBox(width: 5),
            Icon(
              icon,
              color: Colors.black,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }
}
