import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/blocs/cubit/auth_cubit.dart';
import 'package:foriyana_app/presentation/blocs/cubit/profile_cubit.dart';
import 'package:foriyana_app/presentation/widgets/filter_drawer.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final categories = [
    {
      "title": "CLOTHING",
      "image": "assets/images/clothing.png",
      "color": const Color(0xFFB3B2A3),
    },
    {
      "title": "ACCESSORIES",
      "image": "assets/images/accessories.png",
      "color": const Color(0xFF9E918F),
    },
    {
      "title": "SHOES",
      "image": "assets/images/shoes.png",
      "color": const Color(0xFF3F4A52),
    },
    {
      "title": "COLLECTION",
      "image": "assets/images/collection.png",
      "color": const Color(0xFFD1C4C1),
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = context.watch<AuthCubit>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => profileCubit),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchBar(context),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return _buildCategoryCard(
                        title: item["title"] as String,
                        image: item["image"] as String,
                        color: item["color"] as Color,
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.searchDetail);
                        });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSearchBar(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 6,
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              icon: SvgPicture.asset(
                "assets/icons/home_search.svg",
                color: Colors.grey[500],
              ),
              hintText: "Search",
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            Scaffold.of(context).openEndDrawer();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                ),
              ],
            ),
            child: SvgPicture.asset("assets/icons/filter.svg",
                color: Colors.grey[500]),
          ),
        );
      })
    ],
  );
}

Widget _buildCategoryCard(
    {required String title,
    required String image,
    required Color color,
    VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          "", //title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 4,
              )
            ],
          ),
        ),
      ),
    ),
  );
}
