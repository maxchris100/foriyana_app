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

class MyTeamPage extends StatefulWidget {
  const MyTeamPage({super.key});

  @override
  State<MyTeamPage> createState() => _MyTeamPageState();
}

class _MyTeamPageState extends State<MyTeamPage> {
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
  AffiliatorCubit affiliatorCubit = AffiliatorCubit();
  void getData() async {
    try {
      statisticCubit.fetchDownlineStatisticData(
        selectedDate,
        selectedDate2 ?? selectedDate,
      );
      affiliatorCubit.fetchAffiliators();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => statisticCubit),
        BlocProvider(create: (context) => affiliatorCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Team"),
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
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/home-invite-member.svg',
                    width: 25,
                    height: 25,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "Total team member",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0D4290),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  BlocBuilder(
                    bloc: affiliatorCubit,
                    builder: (context, state) {
                      if (state is AffiliatorLoaded) {
                        return Text(
                          state.affiliates.length.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0D4290),
                          ),
                        );
                      }
                      return Text("");
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                            Expanded(child: Text("Potential Affiliate Fee")),
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
                          Tab(child: Text("Metric")),
                          Tab(child: Text("Affiliator")),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            BlocBuilder<StatisticCubit, StatisticState>(
                              builder: (context, state) {
                                StatisticResponseModel? item;
                                if (state is StatisticLoaded) {
                                  item = state.statisticData;
                                }
                                return Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            statisticCubit
                                                .fetchDownlineStatisticData(
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
                                              asset:
                                                  "assets/icons/home-personal-info.svg",
                                              title: "Personal Info",
                                              count:
                                                  "${item?.personalInfo ?? 0}",
                                            ),
                                          ),
                                          Expanded(
                                            child: MetricCard(
                                              asset:
                                                  "assets/icons/home-landing.svg",
                                              title: "Landing",
                                              count:
                                                  "${item?.landingPage ?? 0}",
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: MetricCard(
                                              asset:
                                                  "assets/icons/home-payment.svg",
                                              title: "Payment",
                                              count: "${item?.payment ?? 0}",
                                            ),
                                          ),
                                          Expanded(
                                            child: MetricCard(
                                              asset:
                                                  "assets/icons/home-uploadnric.svg",
                                              title: "Upload NRIC",
                                              count: "${item?.uploadNRIC ?? 0}",
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: MetricCard(
                                              asset:
                                                  "assets/icons/home-declaration.svg",
                                              title: "Issue Certificate",
                                              count:
                                                  "${item?.declaration ?? 0}",
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
                            BlocBuilder<AffiliatorCubit, AffiliatorState>(
                              builder: (context, state) {
                                AffiliateResponseModelData? item;
                                if (state is AffiliatorLoaded) {
                                  if (state.affiliates.isEmpty) {
                                    return Center(
                                      child: Text("DATA NOT FOUND"),
                                    );
                                  }
                                  return ListView.separated(
                                    itemCount: state.affiliates.length,
                                    separatorBuilder: (context, index) {
                                      return Divider(height: 2);
                                    },
                                    itemBuilder: (context, index) {
                                      item = state.affiliates[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            "/affiliate-detail",
                                            arguments: {"item": item},
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(12),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item?.accountAffiliateResponseModelData
                                                              ?.name ??
                                                          "",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      item?.accountAffiliateResponseModelData
                                                              ?.email ??
                                                          "",
                                                    ),
                                                    Text(
                                                      item?.accountAffiliateResponseModelData
                                                              ?.phoneNumber ??
                                                          "",
                                                    ),
                                                    Text(
                                                      "Earned: RM" +
                                                          (StringUtil
                                                              .castToString(
                                                            item?.commission
                                                                    ?.earned ??
                                                                0,
                                                          )),
                                                    ),
                                                    Text(
                                                      "Potential: RM" +
                                                          (StringUtil
                                                              .castToString(
                                                            item?.commission
                                                                    ?.potential ??
                                                                0,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                CupertinoIcons.chevron_forward,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return Container();
                              },
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
