/// SPDX-License-Identifier: AGPL-3.0-or-later

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:core/util/get_it_instance.dart';
import 'package:core/util/haptic_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:aeuniverse/appstate_container.dart';
import 'package:aeuniverse/ui/util/styles.dart';
import 'package:aeuniverse/ui/widgets/components/dialog.dart';
import 'package:aeuniverse/ui/widgets/components/icon_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:core/localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class ChartSheet extends StatefulWidget {
  const ChartSheet(
      {Key? key, required this.optionChartList, required this.optionChart})
      : super(key: key);

  final List<OptionChart> optionChartList;
  final OptionChart? optionChart;
  @override
  _ChartSheetState createState() => _ChartSheetState();
}

class _ChartSheetState extends State<ChartSheet> {
  OptionChart? optionChartSelected;

  @override
  void initState() {
    optionChartSelected = widget.optionChart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // A row for the address text and close button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Empty SizedBox
            const SizedBox(
              width: 60,
              height: 40,
            ),
            Column(
              children: <Widget>[
                // Sheet handle
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 5,
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    color: StateContainer.of(context).curTheme.primary10,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              ],
            ),
            if (kIsWeb || Platform.isMacOS || Platform.isWindows)
              Stack(
                children: <Widget>[
                  const SizedBox(
                    width: 60,
                    height: 40,
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 10, right: 0),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: <Widget>[
                              buildIconDataWidget(
                                  context, Icons.close_outlined, 30, 30),
                            ],
                          ))),
                ],
              )
            else
              const SizedBox(
                width: 60,
                height: 40,
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
              child: AutoSizeText(
                AppLocalization.of(context)!.chart,
                style: AppStyles.textStyleSize24W700Primary(context),
              ),
            ),
          ],
        ),

        FadeIn(
          duration: const Duration(milliseconds: 1000),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 0.0, left: 0.0, right: 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 5.0, left: 5.0, top: 0.0, bottom: 0.0),
              child: StateContainer.of(context).chartInfos != null
                  ? LineChart(
                      mainData(context),
                      swapAnimationCurve: Curves.decelerate,
                      swapAnimationDuration: const Duration(milliseconds: 1000),
                    )
                  : const SizedBox(),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        if (StateContainer.of(context).chartInfos != null)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: StateContainer.of(context)
                        .chartInfos!
                        .getPriceChangePercentage(
                            StateContainer.of(context).idChartOption!)! >=
                    0
                ? FadeIn(
                    duration: const Duration(milliseconds: 1000),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        AutoSizeText(
                          StateContainer.of(context)
                                      .wallet!
                                      .accountBalance
                                      .uco ==
                                  0
                              ? '1 ' +
                                  StateContainer.of(context)
                                      .curNetwork
                                      .getNetworkCryptoCurrencyLabel() +
                                  ' = ' +
                                  StateContainer.of(context)
                                      .localWallet!
                                      .getLocalPrice(
                                          StateContainer.of(context)
                                              .curCurrency,
                                          locale: StateContainer.of(context)
                                              .currencyLocale!)
                              : '1 ' +
                                  StateContainer.of(context)
                                      .curNetwork
                                      .getNetworkCryptoCurrencyLabel() +
                                  ' = ' +
                                  StateContainer.of(context)
                                      .wallet!
                                      .getLocalPrice(
                                          StateContainer.of(context)
                                              .curCurrency,
                                          locale: StateContainer.of(context)
                                              .currencyLocale!),
                          style: AppStyles.textStyleSize16W700Primary(context),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AutoSizeText(
                          StateContainer.of(context)
                                  .chartInfos!
                                  .getPriceChangePercentage(
                                      StateContainer.of(context)
                                          .idChartOption!)!
                                  .toStringAsFixed(2) +
                              '%',
                          style: AppStyles.textStyleSize16W100PositiveValue(
                              context),
                        ),
                        const SizedBox(width: 5),
                        FaIcon(FontAwesomeIcons.caretUp,
                            color: StateContainer.of(context)
                                .curTheme
                                .positiveValue),
                        const SizedBox(
                          width: 10,
                        ),
                        StateContainer.of(context).useOracleUcoPrice
                            ? InkWell(
                                onTap: () {
                                  sl
                                      .get<HapticUtil>()
                                      .feedback(FeedbackType.light);
                                  AppDialogs.showInfoDialog(
                                    context,
                                    AppLocalization.of(context)!.informations,
                                    AppLocalization.of(context)!
                                        .currencyOracleInfo,
                                  );
                                },
                                child: buildIconWidget(
                                  context,
                                  'packages/aewallet/assets/icons/oracle.png',
                                  20,
                                  20,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  )
                : FadeIn(
                    duration: const Duration(milliseconds: 1000),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        AutoSizeText(
                          StateContainer.of(context)
                                      .wallet!
                                      .accountBalance
                                      .uco ==
                                  0
                              ? '1 ' +
                                  StateContainer.of(context)
                                      .curNetwork
                                      .getNetworkCryptoCurrencyLabel() +
                                  ' = ' +
                                  StateContainer.of(context)
                                      .localWallet!
                                      .getLocalPrice(
                                          StateContainer.of(context)
                                              .curCurrency,
                                          locale: StateContainer.of(context)
                                              .currencyLocale!)
                              : '1 ' +
                                  StateContainer.of(context)
                                      .curNetwork
                                      .getNetworkCryptoCurrencyLabel() +
                                  ' = ' +
                                  StateContainer.of(context)
                                      .wallet!
                                      .getLocalPrice(
                                          StateContainer.of(context)
                                              .curCurrency,
                                          locale: StateContainer.of(context)
                                              .currencyLocale!),
                          style: AppStyles.textStyleSize16W700Primary(context),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AutoSizeText(
                          StateContainer.of(context)
                                  .chartInfos!
                                  .getPriceChangePercentage(
                                      StateContainer.of(context)
                                          .idChartOption!)!
                                  .toStringAsFixed(2) +
                              '%',
                          style: AppStyles.textStyleSize16W100NegativeValue(
                              context),
                        ),
                        const SizedBox(width: 5),
                        FaIcon(FontAwesomeIcons.caretDown,
                            color: StateContainer.of(context)
                                .curTheme
                                .negativeValue),
                        const SizedBox(
                          width: 10,
                        ),
                        StateContainer.of(context).useOracleUcoPrice
                            ? InkWell(
                                onTap: () {
                                  sl
                                      .get<HapticUtil>()
                                      .feedback(FeedbackType.light);
                                  AppDialogs.showInfoDialog(
                                    context,
                                    AppLocalization.of(context)!.informations,
                                    AppLocalization.of(context)!
                                        .currencyOracleInfo,
                                  );
                                },
                                child: buildIconWidget(
                                  context,
                                  'packages/aewallet/assets/icons/oracle.png',
                                  20,
                                  20,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
          )
        else
          const SizedBox(),

        Expanded(
          child: Center(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: SafeArea(
                  minimum: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.035,
                    top: 50,
                  ),
                  child: Column(
                    children: <Widget>[
                      Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: StateContainer.of(context)
                                .curTheme
                                .backgroundDarkest),
                        child: DropdownButton<OptionChart>(
                          elevation: 2,
                          focusColor: Colors.white,
                          isExpanded: false,
                          value: optionChartSelected,
                          style: TextStyle(
                            color: StateContainer.of(context).curTheme.primary,
                          ),
                          underline: const SizedBox(),
                          iconEnabledColor: StateContainer.of(context)
                              .curTheme
                              .backgroundDarkest!,
                          isDense: true,
                          items: widget.optionChartList
                              .map((OptionChart optionChart) {
                            return DropdownMenuItem<OptionChart>(
                              value: optionChart,
                              child: Text(
                                optionChart.label,
                                style: AppStyles.textStyleSize20W700Primary(
                                    context),
                              ),
                            );
                          }).toList(),
                          onChanged: (OptionChart? optionChart) async {
                            sl.get<HapticUtil>().feedback(FeedbackType.light);
                            await StateContainer.of(context)
                                .requestUpdateCoinsChart(
                                    option: optionChart!.id);
                            setState(() {
                              optionChartSelected = optionChart;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(BuildContext context) {
    final Gradient gradientColors = LinearGradient(colors: <Color>[
      StateContainer.of(context).curTheme.backgroundDarkest!,
      StateContainer.of(context).curTheme.backgroundDarkest!,
    ]);
    final Gradient gradientColorsBar = LinearGradient(
      colors: <Color>[
        StateContainer.of(context).curTheme.backgroundDarkest!.withOpacity(0.9),
        StateContainer.of(context).curTheme.backgroundDarkest!.withOpacity(0.0),
      ],
      begin: const Alignment(0.0, 0.0),
      end: const Alignment(0.0, 1.0),
    );

    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: StateContainer.of(context).chartInfos!.minX,
      maxX: StateContainer.of(context).chartInfos!.maxX,
      minY: StateContainer.of(context).chartInfos!.minY,
      maxY: StateContainer.of(context).chartInfos!.maxY,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipPadding: const EdgeInsets.all(8),
          tooltipBgColor: const Color(0xff2e3747).withOpacity(0.8),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              return LineTooltipItem(
                '${touchedSpot.y}',
                const TextStyle(color: Colors.white, fontSize: 12.0),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
        enabled: true,
      ),
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: StateContainer.of(context).chartInfos!.data,
          isCurved: true,
          gradient: gradientColors,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: gradientColorsBar,
          ),
        ),
      ],
    );
  }
}

class OptionChart {
  const OptionChart(this.id, this.label);

  final String label;
  final String id;
}
