import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/presentation/blocs/cubit/auth_cubit.dart';
import 'package:foriyana_app/presentation/blocs/cubit/profile_cubit.dart';
import 'package:foriyana_app/presentation/widgets/banner_carousel.dart';
import 'package:foriyana_app/presentation/widgets/feature_product.dart';
import 'package:foriyana_app/presentation/widgets/recommended_product.dart';
import 'package:foriyana_app/presentation/widgets/top_collection.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DateTime selectedDate = DateTime.now();
  DateTime? selectedDate2;
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  ProfileCubit profileCubit = ProfileCubit();
  void getData() async {
    try {} catch (ex) {}
  }

  final List<Map<String, String>> categories = [
    {'label': 'Women', 'icon': 'assets/icons/woman.svg'},
    {'label': 'Men', 'icon': 'assets/icons/man.svg'},
    {'label': 'Accessories', 'icon': 'assets/icons/accessories.svg'},
    {'label': 'Beauty', 'icon': 'assets/icons/beauty.svg'},
  ];

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = context.watch<AuthCubit>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => profileCubit),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(categories.length, (index) {
                  final category = categories[index];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selectedCategoryIndex == index
                                      ? Colors.black
                                      : Colors.transparent,
                                )),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedCategoryIndex == index
                                    ? Colors.black
                                    : Colors.grey.shade200,
                              ),
                              child: SvgPicture.asset(
                                category['icon']!,
                                color: selectedCategoryIndex == index
                                    ? Colors.white
                                    : Colors.black26,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['label']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: selectedCategoryIndex == index
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              BannerCarouselSection(),
              FeatureProductSection(),
              SizedBox(
                height: 16,
              ),
              Image.asset("assets/images/banner1.png",
                  height: 200, fit: BoxFit.cover),
              SizedBox(
                height: 16,
              ),
              RecommendedProductSection(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Image.asset("assets/images/banner2.png",
                      height: 180, fit: BoxFit.fitWidth),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Image.asset("assets/images/banner3.png",
                      height: 220, fit: BoxFit.fitWidth),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Image.asset("assets/images/banner4.png",
                            height: 200, fit: BoxFit.fitWidth),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Image.asset("assets/images/banner5.png",
                            height: 200, fit: BoxFit.fitWidth),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTab extends StatelessWidget {
  final String label;
  final String iconAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTab({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              iconAsset,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
