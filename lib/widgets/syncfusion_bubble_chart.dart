import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../main.dart';

class BubbleChartPage extends StatefulWidget {
  final List<StockData> stockData;

  const BubbleChartPage({super.key, required this.stockData});

  @override
  State<BubbleChartPage> createState() => _BubbleChartPageState();
}

class _BubbleChartPageState extends State<BubbleChartPage> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: '{point.x}\nOI: {point.x}%\nPrice: {point.y}%',
      canShowMarker: false,
      header: '',
      shadowColor: Colors.black26,
      elevation: 8,
      animationDuration: 300,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Syncfusion Bubble Chart")),
      body: SfCartesianChart(
        plotAreaBorderWidth: 1,
        title: const ChartTitle(text: 'OI vs Price Change'),
        tooltipBehavior: _tooltipBehavior,
        primaryXAxis: NumericAxis(
          title: AxisTitle(text: '% Change in OI'),
          minimum: -50,
          maximum: 50,
          majorGridLines: const MajorGridLines(width: 0),
          plotBands: [
            PlotBand(
              start: 0,
              end: 0,
              borderWidth: 2,
              borderColor: Colors.black,
            ),
          ],
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: '% Change in Price'),
          minimum: -4,
          maximum: 4,
          majorGridLines: const MajorGridLines(width: 0),
          plotBands: [
            PlotBand(
              start: 0,
              end: 0,
              borderWidth: 2,
              borderColor: Colors.black,
            ),
          ],
        ),
        series: <BubbleSeries<StockData, double>>[
          BubbleSeries<StockData, double>(
            dataSource: widget.stockData,
            xValueMapper: (d, _) => d.oiChange,
            yValueMapper: (d, _) => d.priceChange,
            sizeValueMapper: (d, _) => 80, // constant bubble size
            dataLabelMapper: (d, _) => d.symbol,
            // gradient: StockData(
            //   data[0].symbol,
            //   data[0].oiChange,
            //   data[0].priceChange,
            // ).getQuadrantGradient(),
            pointColorMapper: (d, _) {
              return d.getSyncfusionGradient().colors.first;
            },
            // *** MARKER SETTINGS WITH PLACEHOLDER IMAGE ***
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.none,
              height: 25,
              width: 25,
            ),
          ),
        ],
      ),
    );
  }
}
