import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foriyana_app/presentation/widgets/search_bottom_sheet.dart';

class FilterDrawer extends StatefulWidget {
  final Function()? onApply;

  const FilterDrawer({super.key, this.onApply});

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  int selectedCategoryIndex = 0;
  int selectedRating = -1;
  int selectedDiscount = 0;

  final List<Map<String, String>> categories = [
    {'label': 'T-shirt', 'icon': 'assets/icons/tshirt.svg'},
    {'label': 'Jeans', 'icon': 'assets/icons/jeans.svg'},
    {'label': 'Dress', 'icon': 'assets/icons/dress.svg'},
    {'label': 'Shoes', 'icon': 'assets/icons/shoes.svg'},
  ];

  void resetFilter() {
    setState(() {
      selectedCategoryIndex = 0;
      selectedRating = -1;
    });
  }

  Widget buildCategory(int index) {
    final isSelected = selectedCategoryIndex == index;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? Colors.black.withOpacity(0.15)
                : Colors.transparent,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.black : Colors.grey.shade200,
            ),
            child: SvgPicture.asset(
              categories[index]['icon']!,
              width: 24,
              height: 24,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          categories[index]['label']!,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildRatingStar(int index) {
    final isSelected = selectedRating == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRating = index;
        });
      },
      child: Container(
        padding: isSelected ? const EdgeInsets.all(2) : EdgeInsets.zero,
        decoration: isSelected
            ? BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.15),
              )
            : null,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.black : Colors.transparent,
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/icons/star.svg",
                    height: 12,
                    color: isSelected ? Colors.white : Colors.black),
                const SizedBox(width: 2),
                Text(
                  '${index + 1}',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: isSelected ? Colors.white : Colors.black,
                      color: isSelected ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SvgPicture.asset(
                    "assets/icons/filter.svg",
                    color: Colors.black,
                  )
                ],
              ),
              const SizedBox(height: 12),
              Divider(),
              const SizedBox(height: 12),
              PriceRangeSlider(),
              const SizedBox(height: 24),
              const Text(
                'Color',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: [
                  CircleAvatar(backgroundColor: Colors.red, radius: 14),
                  CircleAvatar(backgroundColor: Colors.green, radius: 14),
                  CircleAvatar(backgroundColor: Colors.blue, radius: 14),
                  CircleAvatar(backgroundColor: Colors.yellow, radius: 14),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Star Rating',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: buildRatingStar(index),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              BottomSheetSelector(
                label: "",
                selectedValue: "T-Shirt",
                items: ["T-Shirt"],
                onSelected: (p0) {},
              ),
              const SizedBox(height: 24),
              const Text(
                'Discount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [10, 20, 30, 50]
                    .map((discount) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDiscount = 10;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 18),
                            decoration: true
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: Colors.black, // warna border hitam
                                    ),
                                  )
                                : null,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${discount}% off',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          true ? Colors.black : Colors.white,
                                      color:
                                          true ? Colors.black : Colors.white),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                SvgPicture.asset("assets/icons/close.svg")
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: resetFilter,
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onApply,
                      child: const Text(
                        'Apply',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PriceRangeSlider extends StatefulWidget {
  const PriceRangeSlider({super.key});

  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  RangeValues _currentRange = const RangeValues(10, 80);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: const CustomWhiteThumbShape(thumbRadius: 8),
            overlayShape: SliderComponentShape.noOverlay,
            trackHeight: 2,
            trackShape: const RectangularSliderTrackShape(),
          ),
          child: RangeSlider(
            values: _currentRange,
            min: 0,
            max: 100,
            divisions: 20,
            activeColor: Colors.black,
            inactiveColor: Colors.grey.shade300,
            labels: RangeLabels(
              '\$${_currentRange.start.round()}',
              '\$${_currentRange.end.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRange = values;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${_currentRange.start.round()}'),
            Text('\$${_currentRange.end.round()}'),
          ],
        ),
      ],
    );
  }
}

class CustomWhiteThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const CustomWhiteThumbShape({this.thumbRadius = 8.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, thumbRadius, paint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}
