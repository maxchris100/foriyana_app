import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/core/util/date_format.dart';
import 'package:foriyana_app/data/models/user/commission_transactions_response_model.dart';
import 'package:foriyana_app/data/models/user/paging.dart';
import 'package:foriyana_app/data/models/user/statistic_response_model.dart';
import 'package:foriyana_app/generated/l10n.dart';
import 'package:foriyana_app/presentation/blocs/cubit/auth_cubit.dart';
import 'package:foriyana_app/presentation/notused/comission_transactions_cubit.dart';
import 'package:foriyana_app/presentation/notused/statistic_cubit.dart';
import 'package:foriyana_app/presentation/views/login/login_page.dart';
import 'package:foriyana_app/presentation/widgets/filter_date.dart';
import 'package:foriyana_app/presentation/widgets/metric_card.dart';
import 'package:foriyana_app/presentation/widgets/on_tap_text.dart';

class GWPTeamDetailPage extends StatefulWidget {
  const GWPTeamDetailPage({super.key});

  @override
  State<GWPTeamDetailPage> createState() => _GWPTeamDetailPageState();
}

class _GWPTeamDetailPageState extends State<GWPTeamDetailPage> {
  late ScrollController _scrollController;
  DateTime selectedDate = DateTime.now();
  DateTime? selectedDate2;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
          commisionTransactionsCubit.fetchCommisionTransactions(
            DateUtil.formatQuery(selectedDate),
            DateUtil.formatQuery(selectedDate2 ?? selectedDate),
            loadMore: commisionTransactionsCubit.paging.isCanNext,
          );
        }
      });
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

  CommisionTransactionsCubit commisionTransactionsCubit =
      CommisionTransactionsCubit();
  void getData() async {
    try {
      commisionTransactionsCubit.fetchCommisionTransactions(
        DateUtil.formatQuery(selectedDate),
        DateUtil.formatQuery(selectedDate2 ?? selectedDate),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => commisionTransactionsCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("GWP Team Details"),
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
                    commisionTransactionsCubit.fetchCommisionTransactions(
                      DateUtil.formatQuery(selectedDate),
                      DateUtil.formatQuery(selectedDate2 ?? selectedDate),
                    );
                  }
                },
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      "RM 0",
                      style: TextStyle(
                        color: Color(0xff0D4290),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Total GWP ${DateUtil.formatDateIndonesian(selectedDate, selectedDate2)}",
                      style: TextStyle(color: Color(0xff0D4290)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder(
                  bloc: commisionTransactionsCubit,
                  builder: (context, state) {
                    if (state is CommisionTransactionsLoaded) {
                      List<CommisionTransactionsResponseModelData> items =
                          state.commisions;
                      if (items.isEmpty) {
                        return Center(
                          child: Text("There is no data available"),
                        );
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              controller: _scrollController,
                              itemCount: items.length,
                              separatorBuilder: (context, index) {
                                return Divider(height: 2);
                              },
                              itemBuilder: (context, index) {
                                CommisionTransactionsResponseModelData item =
                                    items[index];
                                String createdAt = '';
                                try {
                                  DateTime? m = DateTime.tryParse(
                                    item?.createdAt ?? "",
                                  );
                                  if (m != null) {
                                    createdAt = DateUtil.formatQuery(
                                      m,
                                      dateFormat: "MMMM d, yyyy",
                                    );
                                  }
                                } catch (e) {}
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/transaction-detail",
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
                                                item.transaction?.insurance
                                                        ?.product?.name ??
                                                    "-",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                item?.transaction?.insurance
                                                        ?.plan?.name ??
                                                    "-",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              Text(createdAt),
                                              Text(
                                                "Premium: +RM${item?.transaction?.insurance?.premium ?? 0}",
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "Total Commission: ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "OpenSans",
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "+RM${item?.commissions?.total ?? 0}",
                                                      style: TextStyle(
                                                        fontFamily: "OpenSans",
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(CupertinoIcons.chevron_forward),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Visibility(
                          //     visible: commisionTransactionsCubit
                          //         .paging.isCanNext,
                          //     child: GestureDetector(
                          //         onTap: () {
                          //           commisionTransactionsCubit.paging
                          //               .setPage(
                          //                   commisionTransactionsCubit
                          //                           .paging.page +
                          //                       1);
                          //           getData();
                          //         },
                          //         child: Text("See More")))
                        ],
                      );
                    }
                    return Container();
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
