import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foriyana_app/core/util/date_format.dart';
import 'package:foriyana_app/data/models/product_response_model.dart';
import 'package:foriyana_app/data/models/statistic_response_model.dart';
import 'package:foriyana_app/generated/l10n.dart';
import 'package:foriyana_app/presentation/blocs/cubit/auth_cubit.dart';
import 'package:foriyana_app/presentation/notused/product_cubit.dart';
import 'package:foriyana_app/presentation/notused/product_plan_cubit.dart';
import 'package:foriyana_app/presentation/notused/statistic_cubit.dart';
import 'package:foriyana_app/presentation/views/login/login_page.dart';
import 'package:foriyana_app/presentation/notused/report_detail/report_chart_widget.dart';
import 'package:foriyana_app/presentation/widgets/filter_date.dart';
import 'package:foriyana_app/presentation/widgets/metric_card.dart';
import 'package:foriyana_app/presentation/widgets/on_tap_text.dart';

class ReportDetailPage extends StatefulWidget {
  const ReportDetailPage({super.key});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  DateTime selectedDate = DateTime.now();
  DateTime? selectedDate2;
  String? selectedMetric;
  List listMetric = [
    'Personal Info',
    'Declaration',
    'Payment',
    'Upload NRIC',
    "Issue Certificate",
  ];
  var selectedProduct = "All Product";
  var selectedPlan = "All Plan";

  late GlobalKey chartKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  StatisticCubit statisticCubit = StatisticCubit();
  ProductCubit productCubit = ProductCubit();
  ProductPlanCubit productPlanCubit = ProductPlanCubit();

  ChartCubit chartCubit = ChartCubit();
  void getData() async {
    try {
      productCubit.fetchProducts();
      statisticCubit.fetchStatisticData(
        selectedDate,
        selectedDate2 ?? selectedDate,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as Map?;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => statisticCubit),
        BlocProvider(create: (context) => productCubit),
        BlocProvider(create: (context) => productPlanCubit),
        BlocProvider(create: (context) => chartCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.report),
          leading: IconButton(
            icon: Icon(CupertinoIcons.chevron_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder(
                    bloc: productCubit,
                    builder: (context, state) {
                      String text = 'All Product';
                      if (state is ProductLoaded) {
                        if (selectedProduct != "All Product") {
                          text = (productCubit.state as ProductLoaded)
                                  .products
                                  .where((e) => e.id == selectedProduct)
                                  .first
                                  .name ??
                              "";
                        }
                      }
                      return OnTapText(
                        text: text,
                        asset: "assets/icons/report-chevron-down.svg",
                        onTap: () async {
                          var newSelectedProduct = selectedProduct;
                          var res = await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    padding: const EdgeInsets.only(
                                      top: 16,
                                      bottom: 16,
                                      left: 16,
                                      right: 12,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Select Product",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        ListTile(
                                          onTap: () {
                                            // newSelectedHotLeadValue =
                                            //     item["name"];
                                            setState(() {});
                                          },
                                          title: Text("All Product"),
                                          trailing: Radio<dynamic>(
                                            activeColor: Colors.red,
                                            value: "All Product",
                                            groupValue: newSelectedProduct,
                                            onChanged: (dynamic value) {
                                              setState(() {
                                                newSelectedProduct = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        BlocBuilder(
                                          bloc: productCubit,
                                          builder: (context, state) {
                                            if (state is ProductLoaded) {
                                              return Container(
                                                child: Column(
                                                  children: state.products
                                                      .asMap()
                                                      .entries
                                                      .map((
                                                    e,
                                                  ) {
                                                    return ListTile(
                                                      onTap: () {
                                                        newSelectedProduct =
                                                            e.value.id!;
                                                        setState(() {});
                                                      },
                                                      title: Text(
                                                        e.value.name ?? "",
                                                      ),
                                                      trailing: Radio<dynamic>(
                                                        activeColor: Colors.red,
                                                        value: e.value.id,
                                                        groupValue:
                                                            newSelectedProduct,
                                                        onChanged: (
                                                          dynamic value,
                                                        ) {
                                                          setState(() {
                                                            newSelectedProduct =
                                                                value!;
                                                          });
                                                        },
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              );
                                            }
                                            return Container();
                                          },
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStateProperty
                                                          .resolveWith<Color>(
                                                              (states) {
                                                    if (states.contains(
                                                      WidgetState.disabled,
                                                    )) {
                                                      return Colors.grey
                                                          .shade300; // warna saat disabled
                                                    }
                                                    return Colors
                                                        .white; // warna aktif
                                                  }),
                                                  shape:
                                                      WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        30,
                                                      ),
                                                      side: BorderSide(
                                                        color: Color(
                                                          0xff0D4290,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  S.current.close,
                                                  style: TextStyle(
                                                    color: Color(0xff0D4290),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStateProperty
                                                          .resolveWith<Color>(
                                                              (states) {
                                                    if (states.contains(
                                                      WidgetState.disabled,
                                                    )) {
                                                      return Colors.grey
                                                          .shade300; // warna saat disabled
                                                    }
                                                    return Colors
                                                        .red; // warna aktif
                                                  }),
                                                  shape:
                                                      WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(
                                                    context,
                                                    newSelectedProduct,
                                                  );
                                                },
                                                child: Text(
                                                  S.current.save,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
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
                          if (res != null) {
                            if (res != selectedProduct) {
                              setState(() {
                                selectedProduct = res;
                                selectedPlan = "All Plan";
                              });
                              productPlanCubit.fetchProductPlans(
                                selectedProduct,
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  BlocBuilder(
                    bloc: productPlanCubit,
                    builder: (context, state) {
                      String text = 'All Plan';
                      if (state is ProductPlanLoaded) {
                        if (selectedPlan != "All Plan") {
                          text = (productPlanCubit.state as ProductPlanLoaded)
                                  .productsPlans
                                  .where((e) => e.id == selectedPlan)
                                  .first
                                  .name ??
                              "";
                        }
                      }
                      return OnTapText(
                        text: text,
                        asset: "assets/icons/report-chevron-down.svg",
                        color: selectedProduct == "All Product"
                            ? Color.fromARGB(255, 232, 232, 232)
                            : Color(0xffFAFAFA),
                        onTap: selectedProduct == "All Product"
                            ? null
                            : () async {
                                var newSelectedPlan = selectedPlan;
                                var res = await showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return Container(
                                          padding: const EdgeInsets.only(
                                            top: 16,
                                            bottom: 16,
                                            left: 16,
                                            right: 12,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Select Plan",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              ListTile(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                title: Text("All Plan"),
                                                trailing: Radio<dynamic>(
                                                  activeColor: Colors.red,
                                                  value: "All Plan",
                                                  groupValue: newSelectedPlan,
                                                  onChanged: (dynamic value) {
                                                    setState(() {
                                                      newSelectedPlan = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              BlocBuilder(
                                                bloc: productPlanCubit,
                                                builder: (context, state) {
                                                  if (state
                                                      is ProductPlanLoaded) {
                                                    return Container(
                                                      child: Column(
                                                        children: state
                                                            .productsPlans
                                                            .asMap()
                                                            .entries
                                                            .map((
                                                          e,
                                                        ) {
                                                          return ListTile(
                                                            onTap: () {
                                                              newSelectedPlan =
                                                                  e.value.id!;
                                                              setState(
                                                                () {},
                                                              );
                                                            },
                                                            title: Text(
                                                              e.value.name ??
                                                                  "",
                                                            ),
                                                            trailing:
                                                                Radio<dynamic>(
                                                              activeColor:
                                                                  Colors.red,
                                                              value: e.value.id,
                                                              groupValue:
                                                                  newSelectedPlan,
                                                              onChanged: (
                                                                dynamic value,
                                                              ) {
                                                                setState(() {
                                                                  newSelectedPlan =
                                                                      value!;
                                                                });
                                                              },
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    );
                                                  }
                                                  return Container();
                                                },
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStateProperty
                                                                .resolveWith<
                                                                        Color>(
                                                                    (states) {
                                                          if (states.contains(
                                                            WidgetState
                                                                .disabled,
                                                          )) {
                                                            return Colors.grey
                                                                .shade300; // warna saat disabled
                                                          }
                                                          return Colors
                                                              .white; // warna aktif
                                                        }),
                                                        shape:
                                                            WidgetStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              30,
                                                            ),
                                                            side: BorderSide(
                                                              color: Color(
                                                                0xff0D4290,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                        );
                                                      },
                                                      child: Text(
                                                        S.current.close,
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xff0D4290,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStateProperty
                                                                .resolveWith<
                                                                        Color>(
                                                                    (states) {
                                                          if (states.contains(
                                                            WidgetState
                                                                .disabled,
                                                          )) {
                                                            return Colors.grey
                                                                .shade300; // warna saat disabled
                                                          }
                                                          return Colors
                                                              .red; // warna aktif
                                                        }),
                                                        shape:
                                                            WidgetStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              30,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                          newSelectedPlan,
                                                        );
                                                      },
                                                      child: Text(
                                                        S.current.save,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
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
                                if (res != null) {
                                  if (res != selectedPlan) {
                                    setState(() {
                                      selectedPlan = res;
                                    });
                                  }
                                }
                              },
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  OnTapText(
                    text: DateUtil.formatDateIndonesian(
                      selectedDate,
                      selectedDate2,
                    ),
                    onTap: () async {
                      var val = await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return FilterDateWidget();
                        },
                      );
                      if (val != null) {
                        selectedDate2 = null; //remove val2
                        final DateTime now = DateTime.now();
                        if (val["value"] == "1") {
                          selectedDate = now;
                        }
                        if (val["value"] == "2") {
                          selectedDate = now.subtract(Duration(days: 6));
                          selectedDate2 = now;
                        }
                        if (val["value"] == "3") {
                          selectedDate = now.subtract(Duration(days: 29));
                          selectedDate2 = now;
                        }
                        if (val["value"] == "4") {
                          if (val["start_date"] != null) {
                            selectedDate = DateTime.parse(val["start_date"]);
                          }
                          if (val["end_date"] != null) {
                            selectedDate2 = DateTime.parse(val["end_date"]);
                          }
                        }
                        setState(() {});
                        statisticCubit.fetchStatisticData(
                          selectedDate,
                          selectedDate2 ?? selectedDate,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/gwp-team-detail");
                    },
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/report-protection.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "RM 0",
                                        style: TextStyle(
                                          color: Color(0xff0D4290),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "GWP",
                                        style: TextStyle(
                                          color: Color(0xff0D4290),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/report-affiliate.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "0",
                                        style: TextStyle(
                                          color: Color(0xff0D4290),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Affiliate Fee",
                                        style: TextStyle(
                                          color: Color(0xff0D4290),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 15),
                            Icon(
                              CupertinoIcons.chevron_forward,
                              color: Color(0xff0D4290),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<StatisticCubit, StatisticState>(
                    builder: (context, state) {
                      StatisticResponseModel? item;
                      if (state is StatisticLoaded) {
                        item = state.statisticData;
                        context.read<ChartCubit>().updateSelectedMetric(
                              item?.dates,
                              selectedMetric ?? "Personal Info",
                            ); // after load, set new data to chart cubic
                      }
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Text(
                              "Metric",
                              style: TextStyle(
                                color: Color(0xff0D4290),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: MetricCard(
                                    asset:
                                        "assets/icons/home-personal-info.svg",
                                    title: "Personal Info",
                                    count: "${item?.personalInfo ?? 0}",
                                    focus: selectedMetric == listMetric[0],
                                    onTap: () {
                                      setState(() {
                                        selectedMetric = listMetric[0];
                                        context
                                            .read<ChartCubit>()
                                            .updateSelectedMetric(
                                              item?.dates,
                                              selectedMetric!,
                                            );
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: MetricCard(
                                    asset: "assets/icons/home-declaration.svg",
                                    title: "Declaration",
                                    count: "${item?.declaration ?? 0}",
                                    focus: selectedMetric == listMetric[1],
                                    onTap: () {
                                      setState(() {
                                        selectedMetric = listMetric[1];
                                        context
                                            .read<ChartCubit>()
                                            .updateSelectedMetric(
                                              item?.dates,
                                              selectedMetric!,
                                            );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: MetricCard(
                                    asset: "assets/icons/home-payment.svg",
                                    title: "Payment",
                                    count: "${item?.payment ?? 0}",
                                    focus: selectedMetric == listMetric[2],
                                    onTap: () {
                                      setState(() {
                                        selectedMetric = listMetric[2];
                                        context
                                            .read<ChartCubit>()
                                            .updateSelectedMetric(
                                              item?.dates,
                                              selectedMetric!,
                                            );
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: MetricCard(
                                    asset: "assets/icons/home-uploadnric.svg",
                                    title: "Upload NRIC",
                                    count: "${item?.uploadNRIC ?? 0}",
                                    focus: selectedMetric == listMetric[3],
                                    onTap: () {
                                      setState(() {
                                        selectedMetric = listMetric[3];
                                        context
                                            .read<ChartCubit>()
                                            .updateSelectedMetric(
                                              item?.dates,
                                              selectedMetric!,
                                            );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: MetricCard(
                                    asset: "assets/icons/home-declaration.svg",
                                    title: "Issue Certificate",
                                    count: "${item?.issueCertificate ?? 0}",
                                    focus: selectedMetric == listMetric[4],
                                    onTap: () {
                                      setState(() {
                                        selectedMetric = listMetric[4];
                                        context
                                            .read<ChartCubit>()
                                            .updateSelectedMetric(
                                              item?.dates,
                                              selectedMetric!,
                                            );
                                      });
                                    },
                                  ),
                                ),
                                Expanded(child: Text("")),
                              ],
                            ),

                            // tambain
                            BlocBuilder(
                              bloc: chartCubit,
                              builder: (context, state) {
                                Map<String, dynamic> dataStates = {};
                                String? metric;
                                if (state is ChartLoaded) {
                                  dataStates = state.dates;
                                  metric = state.metric;
                                }
                                return Visibility(
                                  visible: selectedMetric != null,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 12),
                                      Text(
                                        "${selectedMetric} Graphic",
                                        style: TextStyle(
                                          color: Color(0xff0D4290),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      ReportChartWidget(
                                        dates: dataStates,
                                        metric: metric ?? "Personal Info",
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Best Product",
                    style: TextStyle(
                      color: Color(0xff0D4290),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  BlocBuilder(
                    bloc: productCubit,
                    builder: (context, state) {
                      if (state is ProductLoaded) {
                        if (state.products.isEmpty) {
                          return Container();
                        }
                        return Card(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.products.first.name ?? "",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "RMNAN",
                                        style: TextStyle(
                                          color: Color(0xff0D4290),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("GWP"),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    String link =
                                        state.products.first.name ?? "";
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Text(
                                                  "Share Link Product",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 25,
                                                    child: SvgPicture.asset(
                                                      'assets/icons/home-dollar.svg',
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      "Get X% commission on every purchase.",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                "Link",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(height: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 16,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffFAFAFA),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "$link",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await Clipboard.setData(
                                                          ClipboardData(
                                                            text: "$link",
                                                          ),
                                                        );

                                                        Fluttertoast.showToast(
                                                          msg:
                                                              "Copied to clipboard",
                                                        );
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/icons/home-copy.svg',
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              Container(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty
                                                            .resolveWith<Color>(
                                                                (states) {
                                                      if (states.contains(
                                                        WidgetState.disabled,
                                                      )) {
                                                        return Colors.grey
                                                            .shade300; // warna saat disabled
                                                      }
                                                      return Colors
                                                          .red; // warna aktif
                                                    }),
                                                    shape:
                                                        WidgetStateProperty.all(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    S.current.close,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/home-sharelink.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
