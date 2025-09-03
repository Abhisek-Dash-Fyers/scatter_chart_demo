import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion Bubble Chart Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const BubbleChartPage(),
    );
  }
}

class StockData {
  final String symbol;
  final double oiChange; // X-axis (% change in OI)
  final double priceChange; // Y-axis (% change in price)
  StockData(this.symbol, this.oiChange, this.priceChange);

  // Helper to get gradient based on quadrant
  LinearGradient getQuadrantGradient() {
    if (oiChange >= 0 && priceChange >= 0) {
      // Long buildup (upper right) - Dark green gradient
      return const LinearGradient(
        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (oiChange < 0 && priceChange >= 0) {
      // Long unwinding (upper left) - Light green gradient
      return const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF66BB6A), Color(0xFF81C784)],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (oiChange < 0 && priceChange < 0) {
      // Short covering (lower left) - Light red/orange gradient
      return const LinearGradient(
        colors: [Color(0xFFFF7043), Color(0xFFFF8A65), Color(0xFFFFAB91)],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      // Short buildup (lower right) - Dark red gradient
      return const LinearGradient(
        colors: [Color(0xFFB71C1C), Color(0xFFD32F2F), Color(0xFFE57373)],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }
}

class BubbleChartPage extends StatefulWidget {
  const BubbleChartPage({super.key});

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
    final List<StockData> data = [
      StockData("UNION", -10, 3.2),
      StockData("PAYTM", -20, 2.1),
      StockData("ABB", 15, 2.8),
      StockData("TORRENT", 30, 1.5),
      StockData("AIA", -25, -1.8),
      StockData("HIMAT", 5, -1.2),
      StockData("L&T", -10, -0.8),
      StockData("ABB", 40, -3.0),
    ];

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
            dataSource: data,
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
              return StockData(
                d.symbol,
                d.oiChange,
                d.priceChange,
              ).getQuadrantGradient().colors.first;
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
