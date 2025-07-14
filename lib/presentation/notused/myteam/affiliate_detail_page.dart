import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/core/util/date_format.dart';
import 'package:foriyana_app/core/util/string_util.dart';
import 'package:foriyana_app/data/models/affiliate_response_model.dart';
import 'package:foriyana_app/data/models/statistic_response_model.dart';
import 'package:foriyana_app/generated/l10n.dart';
import 'package:foriyana_app/presentation/notused/affiliator_cubit.dart';
import 'package:foriyana_app/presentation/blocs/cubit/auth_cubit.dart';
import 'package:foriyana_app/presentation/notused/statistic_cubit.dart';
import 'package:foriyana_app/presentation/views/login/login_page.dart';
import 'package:foriyana_app/presentation/widgets/filter_date.dart';
import 'package:foriyana_app/presentation/widgets/metric_card.dart';
import 'package:foriyana_app/presentation/widgets/on_tap_text.dart';

class AffiliateDetailPage extends StatefulWidget {
  const AffiliateDetailPage({super.key});

  @override
  State<AffiliateDetailPage> createState() => _AffiliateDetailPageState();
}

class _AffiliateDetailPageState extends State<AffiliateDetailPage> {
  late AffiliateResponseModelData item;
  DateTime selectedDate = DateTime.now();
  DateTime? selectedDate2;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  StatisticCubit statisticCubit = StatisticCubit();
  void getData() async {
    try {
      statisticCubit.fetchDownlineStatisticData(
        selectedDate,
        selectedDate2 ?? selectedDate,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as Map?;

    item = args?["item"];

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => statisticCubit)],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Affiliator Detail"),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.accountAffiliateResponseModelData?.name ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(item?.accountAffiliateResponseModelData?.email ?? ""),
                  Text(
                    item?.accountAffiliateResponseModelData?.phoneNumber ?? "",
                  ),
                ],
              ),
              Divider(height: 20),
              Center(
                child: Container(
                  // width: 350, // Adjust width as needed
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xffEE1C25),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/gwp-team-detail",
                                  );
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/home-protection.svg',
                                      width: 25,
                                      height: 25,
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "RM 0",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "Commission",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/home-affiliate.svg',
                                    width: 25,
                                    height: 25,
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "0",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "Points",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/home-discount.svg',
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                "Potential Affiliate Fee",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "RM 0",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<StatisticCubit, StatisticState>(
                  builder: (context, state) {
                    StatisticResponseModel? itemStatistic;
                    if (state is StatisticLoaded) {
                      itemStatistic = state.statisticData;
                    }
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12),
                          OnTapText(
                            text: DateUtil.formatDateIndonesian(
                              selectedDate,
                              selectedDate2,
                            ),
                            asset: "assets/icons/home-calendar.svg",
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
                                  selectedDate = now.subtract(
                                    Duration(days: 6),
                                  );
                                  selectedDate2 = now;
                                }
                                if (val["value"] == "3") {
                                  selectedDate = now.subtract(
                                    Duration(days: 29),
                                  );
                                  selectedDate2 = now;
                                }
                                if (val["value"] == "4") {
                                  if (val["start_date"] != null) {
                                    selectedDate = DateTime.parse(
                                      val["start_date"],
                                    );
                                  }
                                  if (val["end_date"] != null) {
                                    selectedDate2 = DateTime.parse(
                                      val["end_date"],
                                    );
                                  }
                                }
                                setState(() {});
                                statisticCubit.fetchDownlineStatisticData(
                                  selectedDate,
                                  selectedDate2 ?? selectedDate,
                                );
                              }
                            },
                          ),
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
                                  asset: "assets/icons/home-personal-info.svg",
                                  title: "Personal Info",
                                  count: "${itemStatistic?.personalInfo ?? 0}",
                                ),
                              ),
                              Expanded(
                                child: MetricCard(
                                  asset: "assets/icons/home-landing.svg",
                                  title: "Landing",
                                  count: "${itemStatistic?.landingPage ?? 0}",
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
                                  count: "${itemStatistic?.payment ?? 0}",
                                ),
                              ),
                              Expanded(
                                child: MetricCard(
                                  asset: "assets/icons/home-uploadnric.svg",
                                  title: "Upload NRIC",
                                  count: "${itemStatistic?.uploadNRIC ?? 0}",
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
                                  count: "${itemStatistic?.declaration ?? 0}",
                                ),
                              ),
                              Expanded(child: Text("")),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
