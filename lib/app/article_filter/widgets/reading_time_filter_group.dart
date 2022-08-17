

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:news_app_2/core/ui/styles/app_colors.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ReadingTimeFilterGroup extends StatefulWidget {
  final ReadingTimeRange timeRange;
  final ValueChanged<ReadingTimeRange> onReadingTimeChanged;

  const ReadingTimeFilterGroup(
      {Key? key, required this.timeRange, required this.onReadingTimeChanged})
      : super(key: key);

  @override
  State<ReadingTimeFilterGroup> createState() => _ReadingTimeFilterGroupState();
}

class _ReadingTimeFilterGroupState extends State<ReadingTimeFilterGroup> {
  ReadingTimeRange get timeRange => widget.timeRange;

  late SfRangeValues _values;
  final labelStyle = const TextStyle(fontSize: 11.5, color: AppColors.textGrey);

  @override
  Widget build(BuildContext context) {
    _values = SfRangeValues(timeRange.min.toDouble(), timeRange.max.toDouble());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reading time",
          style: TextStyle(fontSize: 15.5),
        ),
        const SizedBox(height: 12),
        SfRangeSliderTheme(
          data: SfRangeSliderThemeData(
            activeTrackHeight: 8,
            inactiveTrackHeight: 8,
            thumbRadius: 8,
            thumbColor: Colors.white,
            overlayColor: Colors.black.withOpacity(0.2),
            overlayRadius: 16.5,
            activeTrackColor: Colors.black,
            inactiveTrackColor: AppColors.textGrey.withOpacity(0.15),
            activeLabelStyle: labelStyle,
            inactiveLabelStyle: labelStyle,
            tooltipTextStyle: labelStyle.copyWith(color: Colors.white),
          ),
          child: SfRangeSlider(
            min: 0.0,
            max: 30.0,
            values: _values,
            interval: 5,
            showLabels: true,
            enableTooltip: true,
            showDividers: true,
            showTicks: false,
            stepSize: 1,
            dividerShape: _DividerShape(),
            tooltipTextFormatterCallback: (actualValue, formattedText) {
              return getFormattedText(actualValue, formattedText);
            },
            labelFormatterCallback: (actualValue, formattedText) {
              return getFormattedText(actualValue, formattedText);
            },
            onChanged: (SfRangeValues values) {
              final min = values.start;
              final max = values.end;

              final readingTimeRange =
                  ReadingTimeRange(min: min.toInt(), max: max.toInt());
              widget.onReadingTimeChanged(readingTimeRange);
            },
          ),
        ),
      ],
    );
  }

  String getFormattedText(dynamic actualValue, String formattedText) {
    if (actualValue == 0) {
      return "1m";
    }

    if (actualValue > 25) {
      return "∞";
    }

    return "${formattedText}m";
  }
}

class _DividerShape extends SfDividerShape {
  @override
  void paint(PaintingContext context, Offset center, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection}) {
    final bool isActive =
        center.dx >= startThumbCenter!.dx && center.dx <= endThumbCenter!.dx;
    context.canvas.drawRect(
        Rect.fromCenter(center: center, width: 1.5, height: 14.0),
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..color = isActive
              ? themeData.activeTrackColor!
              : AppColors.textGrey.withOpacity(0.15));
  }
}

class ReadingTimeRange extends Equatable {
  final int min;
  final int max;

  const ReadingTimeRange({this.min = 0, this.max = 30});

  @override
  List<Object?> get props => [min, max];

  @override
  bool get stringify => true;
}
