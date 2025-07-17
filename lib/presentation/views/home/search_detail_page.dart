import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/widgets/button_back.dart';
import 'package:foriyana_app/presentation/widgets/product_card.dart';

class SearchDetailPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dresses"),
        leading: ButtonBack(),
        leadingWidth: 40,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Found", style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 4),
                      Text(
                        "${products.length} Results",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.grey[200]!)),
                    padding: EdgeInsets.all(8),
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              // selectedValue != null
                              //     ? getLabel(selectedValue!)
                              //     :
                              "Filter",
                              style: TextStyle(
                                fontSize: 16,
                                // color: selectedValue == null ? Colors.grey : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset("assets/icons/dropdown.svg"),
                        SizedBox(
                          width: 8,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
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

class Product {
  final String name;
  final String imageUrl;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviewCount;
  final bool isFavorite;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.isFavorite,
  });
}
