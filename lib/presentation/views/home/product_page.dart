import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/views/home/search_detail_page.dart';
import 'package:foriyana_app/presentation/widgets/button_back.dart';
import 'package:foriyana_app/presentation/widgets/product_card.dart';

class ProductPage extends StatelessWidget {
  final List<Product> products = [
    Product(
      name: "Linen Dress",
      imageUrl: "assets/images/startup1.webp",
      price: 52.00,
      oldPrice: 90.00,
      rating: 4.5,
      reviewCount: 64,
      isFavorite: true,
    ),
    Product(
      name: "Filted Waist Dress",
      imageUrl: "assets/images/startup1.webp",
      price: 47.99,
      oldPrice: 82.00,
      rating: 4.2,
      reviewCount: 53,
      isFavorite: false,
    ),
    Product(
      name: "Maxi Dress",
      imageUrl: "assets/images/startup1.webp",
      price: 68.00,
      oldPrice: null,
      rating: 4.7,
      reviewCount: 46,
      isFavorite: false,
    ),
    Product(
      name: "Front Tie Mini Dress",
      imageUrl: "assets/images/startup1.webp",
      price: 59.00,
      oldPrice: 82.00,
      rating: 4.3,
      reviewCount: 38,
      isFavorite: true,
    ),
  ];
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

  @override
  Widget build(BuildContext context) {
    String title = 'Feature Product';

    var args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      if (args["title"] != null) {
        title = args["title"];
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: ButtonBack(),
        leadingWidth: 40,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.45, //aspect ration height
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.productDetail,
                            arguments: {"item": product});
                      },
                      child: ProductCard(product: product));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
