import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/core/util/date_format.dart';
import 'package:foriyana_app/data/models/product_hotlead_response_model.dart';
import 'package:foriyana_app/data/models/product_response_model.dart';
import 'package:foriyana_app/generated/l10n.dart';
import 'package:foriyana_app/presentation/blocs/cubit/auth_cubit.dart';
import 'package:foriyana_app/presentation/notused/product_hotleads_cubit.dart';
import 'package:foriyana_app/presentation/views/login/login_page.dart';
import 'package:foriyana_app/presentation/widgets/metric_card.dart';
import 'package:foriyana_app/presentation/widgets/on_tap_text.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductResponseModel item;
  ProductHotleadStatisticResponseModel? psFilter;
  String selectedHotLeadValue = "All";
  var filterHotleadItems = [
    {"name": "All", "value": 0},
    {"name": "Personal Info", "value": 1},
    {"name": "Declaration", "value": 2},
    {"name": "Payment", "value": 3},
    {"name": "Upload NRIC", "value": 4},
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  ProductHotleadCubit productHotleadCubit = ProductHotleadCubit();
  void getData() async {
    try {
      productHotleadCubit.fetchProductHotleads(
        item.id ?? "",
        selectedHotLeadValue,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getPS(item) {
    if (item["name"] == "All") {
      return "${psFilter?.all ?? 0}";
    }
    if (item["name"] == "Personal Info") {
      return "${psFilter?.personalInfo ?? 0}";
    }
    if (item["name"] == "Declaration") {
      return "${psFilter?.declaration ?? 0}";
    }
    if (item["name"] == "Payment") {
      return "${psFilter?.payment ?? 0}";
    }
    if (item["name"] == "Upload NRIC") {
      return "${psFilter?.uploadNRIC ?? 0}";
    }
    return "";
  }

  filterHotleads() {
    String newSelectedHotLeadValue = selectedHotLeadValue;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        if (productHotleadCubit.state is ProductHotleadLoaded) {
          psFilter =
              (productHotleadCubit.state as ProductHotleadLoaded).statistic;
        }
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select Filter",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Column(
                    children: filterHotleadItems.asMap().entries.map((e) {
                      final item = e.value as Map<String, dynamic>;
                      return ListTile(
                        onTap: () {
                          newSelectedHotLeadValue = item["name"];
                          setState(() {});
                        },
                        dense: true,
                        contentPadding: EdgeInsets.all(0),
                        title: Text("${item["name"]} (${getPS(item)})"),
                        trailing: Radio<dynamic>(
                          activeColor: Colors.red,
                          value: item["name"],
                          groupValue: newSelectedHotLeadValue,
                          onChanged: (dynamic value) {
                            setState(() {
                              newSelectedHotLeadValue = value!;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>((
                              states,
                            ) {
                              if (states.contains(WidgetState.disabled)) {
                                return Colors
                                    .grey.shade300; // warna saat disabled
                              }
                              return Colors.white; // warna aktif
                            }),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Color(0xff0D4290)),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            S.current.close,
                            style: TextStyle(color: Color(0xff0D4290)),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>((
                              states,
                            ) {
                              if (states.contains(WidgetState.disabled)) {
                                return Colors
                                    .grey.shade300; // warna saat disabled
                              }
                              return Colors.red; // warna aktif
                            }),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context, newSelectedHotLeadValue);
                            });
                          },
                          child: Text(
                            S.current.save,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String getShortName(String name) {
    return name.split("|")[0];
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as Map?;

    item = args?["item"];

    List<AffiliatesStatistics> finishList =
        item.affiliatesStatistics!.where((x) => x.status == "finish").toList();

    Map filterItem = filterHotleadItems.firstWhere(
      (e) => e["name"] == selectedHotLeadValue,
    );

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => productHotleadCubit)],
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.product),
          leading: IconButton(
            icon: Icon(CupertinoIcons.chevron_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name ?? "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${item.totalPolicy}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0D4290),
                                  ),
                                ),
                                Text("Policy", style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "RM${item.totalContribution}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0D4290),
                                  ),
                                ),
                                Text(
                                  "Total Contribution",
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "RM${item.totalCommission}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0D4290),
                                  ),
                                ),
                                Text(
                                  "Commission Fee",
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.red,
                        labelColor: Colors.red,
                        unselectedLabelColor: Color(0xffBBBDC0),
                        tabs: [
                          Tab(child: Text("Plan List")),
                          Tab(child: Text("Hot Leads")),
                        ],
                      ),
                      SizedBox(height: 12),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Container(
                              child: finishList.isEmpty
                                  ? Center(child: Text("DATA NOT FOUND"))
                                  : ListView.builder(
                                      itemCount: finishList.length,
                                      itemBuilder: (context, index) {
                                        AffiliatesStatistics item =
                                            finishList[index];
                                        String shortName = getShortName(
                                          item
                                                  .affiliatesCommissions
                                                  ?.first
                                                  .transactionData
                                                  ?.insurance
                                                  ?.plan
                                                  ?.name ??
                                              "",
                                        );
                                        String totalPolicy =
                                            (item.affiliatesCommissions ?? [])
                                                .length
                                                .toString();
                                        String amountCommision =
                                            item.amountCommission ?? "0";
                                        String totalContribution =
                                            item.amountContribution ?? "0";

                                        return Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Color(0xffEEEEEF),
                                              ),
                                              top: index > 0
                                                  ? BorderSide.none
                                                  : BorderSide(
                                                      color: Color(
                                                        0xffEEEEEF,
                                                      ),
                                                    ),
                                              left: BorderSide(
                                                color: Color(0xffEEEEEF),
                                              ),
                                              right: BorderSide(
                                                color: Color(0xffEEEEEF),
                                              ),
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: index == 0
                                                  ? Radius.circular(12)
                                                  : Radius.zero,
                                              topRight: index == 0
                                                  ? Radius.circular(12)
                                                  : Radius.zero,
                                              bottomLeft:
                                                  index == [1, 2, 3].length - 1
                                                      ? Radius.circular(12)
                                                      : Radius.zero,
                                              bottomRight:
                                                  index == [1, 2, 3].length - 1
                                                      ? Radius.circular(12)
                                                      : Radius.zero,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                shortName,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Policy: $totalPolicy",
                                                  ),
                                                  Text(
                                                    "+RM$amountCommision",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "Total Contribution: $totalContribution",
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            Column(
                              children: [
                                BlocBuilder(
                                  bloc: productHotleadCubit,
                                  builder: (context, state) {
                                    if (state is ProductHotleadLoaded) {
                                      psFilter = state.statistic;
                                    }
                                    return OnTapText(
                                      text: filterItem["name"] +
                                          " (${getPS(filterItem)})",
                                      asset:
                                          "assets/icons/report-chevron-down.svg",
                                      onTap: () async {
                                        var val = await filterHotleads();
                                        if (val != null) {
                                          if (val != selectedHotLeadValue) {
                                            setState(() {
                                              selectedHotLeadValue = val;
                                            });
                                            productHotleadCubit
                                                .fetchProductHotleads(
                                              item?.id ?? "",
                                              selectedHotLeadValue,
                                            );
                                          }
                                        }
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 12),
                                Expanded(
                                  child: BlocBuilder<ProductHotleadCubit,
                                      ProductHotleadState>(
                                    builder: (context, state) {
                                      if (state is ProductHotleadLoaded) {
                                        List<ProductHotleadResponseModelData>
                                            items = state.products;
                                        psFilter = (productHotleadCubit.state
                                                as ProductHotleadLoaded)
                                            .statistic;
                                        if (items.isEmpty) {
                                          return Center(
                                            child: Text("DATA NOT FOUND"),
                                          );
                                        }
                                        return ListView.builder(
                                          itemCount: items.length,
                                          itemBuilder: (context, index) {
                                            ProductHotleadResponseModelData
                                                item = items[index];

                                            return Container(
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Color(0xffEEEEEF),
                                                  ),
                                                  top: index > 0
                                                      ? BorderSide.none
                                                      : BorderSide(
                                                          color: Color(
                                                            0xffEEEEEF,
                                                          ),
                                                        ),
                                                  left: BorderSide(
                                                    color: Color(0xffEEEEEF),
                                                  ),
                                                  right: BorderSide(
                                                    color: Color(0xffEEEEEF),
                                                  ),
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: index == 0
                                                      ? Radius.circular(12)
                                                      : Radius.zero,
                                                  topRight: index == 0
                                                      ? Radius.circular(12)
                                                      : Radius.zero,
                                                  bottomLeft: index ==
                                                          [1, 2, 3].length - 1
                                                      ? Radius.circular(12)
                                                      : Radius.zero,
                                                  bottomRight: index ==
                                                          [1, 2, 3].length - 1
                                                      ? Radius.circular(12)
                                                      : Radius.zero,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${item.name ?? ""}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text("${item?.email}"),
                                                  Visibility(
                                                    visible: item.id == "4",
                                                    child: Text(
                                                      "Certificate Number: ${item.certificateNumber}",
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "${item.scheme} - Premi: ",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "OpenSans",
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              "RM ${item.premi ?? 0}",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "OpenSans",
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
