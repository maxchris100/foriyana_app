import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/blocs/cubit/auth_cubit.dart';
import 'package:foriyana_app/presentation/blocs/cubit/profile_cubit.dart';
import 'package:foriyana_app/presentation/widgets/app_drawer.dart';
import 'package:foriyana_app/presentation/widgets/feature_product.dart';
import 'package:foriyana_app/presentation/widgets/recommended_product.dart';
import 'package:foriyana_app/presentation/widgets/top_collection.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  DateTime selectedDate = DateTime.now();
  DateTime? selectedDate2;

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
          child: ListView(
            children: [
              FeatureProductSection(),
              RecommendedProductSection(),
              TopCollectionSection(),
            ],
          ),
        ),
      ),
    );
  }
}
