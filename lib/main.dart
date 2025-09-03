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
  final double size; // bubble size (can map to volume)
  StockData(this.symbol, this.oiChange, this.priceChange, this.size);
}

class BubbleChartPage extends StatelessWidget {
  const BubbleChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<StockData> data = [
      StockData("UNION", -10, 3.2, 50),
      StockData("PAYTM", -20, 2.1, 40),
      StockData("ABB", 15, 2.8, 60),
      StockData("TORRENT", 30, 1.5, 55),
      StockData("AIA", -25, -1.8, 45),
      StockData("HIMAT", 5, -1.2, 35),
      StockData("L&T", -10, -0.8, 40),
      StockData("ABB", 40, -3.0, 65),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Syncfusion Bubble Chart")),
      body: SfCartesianChart(
        plotAreaBorderWidth: 1,
        title: const ChartTitle(text: 'OI vs Price Change'),
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
            sizeValueMapper: (d, _) => d.size,
            dataLabelMapper: (d, _) => d.symbol,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            pointColorMapper: (d, _) {
              if (d.priceChange >= 0) {
                // Green gradient intensity
                final intensity = (d.priceChange / 4)
                    .clamp(0.2, 1.0)
                    .toDouble();
                return Colors.green.withOpacity(intensity);
              } else {
                // Red gradient intensity
                final intensity = (d.priceChange.abs() / 4)
                    .clamp(0.2, 1.0)
                    .toDouble();
                return Colors.red.withOpacity(intensity);
              }
            },
          ),
        ],
      ),
    );
  }
}
