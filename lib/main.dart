import 'package:flutter/material.dart';
import 'package:highcharts_flutter/highcharts.dart';

void main() {
  runApp(MaterialApp(home: StockHeatmapChart()));
}

class StockData {
  final String symbol;
  final double oiChange; // x-axis
  final double priceChange; // y-axis
  final double marketCap; // for bubble radius

  StockData({
    required this.symbol,
    required this.oiChange,
    required this.priceChange,
    required this.marketCap,
  });

  // Get color based on price change intensity
  String get pointColor {
    if (priceChange >= 0) {
      // Green shades for positive changes
      if (priceChange > 2.5) return '#2E7D32';
      if (priceChange > 1.5) return '#388E3C';
      if (priceChange > 0.5) return '#4CAF50';
      return '#66BB6A';
    } else {
      // Red/Orange shades for negative changes
      if (priceChange < -2.5) return '#D32F2F';
      if (priceChange < -1.5) return '#F44336';
      if (priceChange < -0.5) return '#FF5722';
      return '#FF7043';
    }
  }

  // Get bubble radius based on market cap
  double get bubbleRadius {
    return (marketCap / 2).clamp(15.0, 35.0);
  }
}

class StockHeatmapChart extends StatelessWidget {
  StockHeatmapChart({super.key});

  final List<StockData> stockData = [
    // Upper left quadrant (Long unwinding - negative OI, positive price)
    StockData(symbol: 'UNION', oiChange: -40, priceChange: 3.2, marketCap: 50),
    StockData(symbol: 'ABB', oiChange: -30, priceChange: 2.8, marketCap: 45),
    StockData(symbol: 'PAYTM', oiChange: -35, priceChange: 2.1, marketCap: 40),
    StockData(symbol: 'ABB', oiChange: -25, priceChange: 1.8, marketCap: 42),
    StockData(symbol: 'PAYTM', oiChange: -15, priceChange: 1.2, marketCap: 38),

    // Upper right quadrant (Long buildup - positive OI, positive price)
    StockData(symbol: 'TORRENT', oiChange: 45, priceChange: 1.9, marketCap: 55),
    StockData(symbol: 'ABB', oiChange: 35, priceChange: 2.6, marketCap: 48),
    StockData(symbol: 'ABB', oiChange: 25, priceChange: 2.2, marketCap: 46),
    StockData(symbol: 'HIMAT', oiChange: 15, priceChange: 1.8, marketCap: 40),
    StockData(symbol: 'AIA', oiChange: 20, priceChange: 1.4, marketCap: 42),
    StockData(symbol: 'ABB', oiChange: 40, priceChange: 1.1, marketCap: 44),

    // Lower left quadrant (Short covering - negative OI, negative price)
    StockData(symbol: 'AIA', oiChange: -45, priceChange: -1.2, marketCap: 38),
    StockData(symbol: 'HIMAT', oiChange: -35, priceChange: -1.8, marketCap: 40),
    StockData(symbol: 'ABB', oiChange: -25, priceChange: -2.8, marketCap: 45),
    StockData(symbol: 'HIMAT', oiChange: -15, priceChange: -2.2, marketCap: 42),

    // Lower right quadrant (Short buildup - positive OI, negative price)
    StockData(symbol: 'HIMAT', oiChange: 15, priceChange: -1.1, marketCap: 38),
    StockData(symbol: 'ABB', oiChange: 25, priceChange: -2.1, marketCap: 44),
    StockData(
      symbol: 'TORRENT',
      oiChange: 35,
      priceChange: -2.6,
      marketCap: 48,
    ),
    StockData(symbol: 'AIA', oiChange: 45, priceChange: -2.9, marketCap: 42),
    StockData(symbol: 'ABB', oiChange: 20, priceChange: -1.8, marketCap: 40),
    StockData(
      symbol: 'TORRENT',
      oiChange: 10,
      priceChange: -2.8,
      marketCap: 46,
    ),
    StockData(symbol: 'ABB', oiChange: 40, priceChange: -1.5, marketCap: 44),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Stock Heatmap Chart'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Chart labels
            Row(
              children: [
                Text(
                  'Short covering',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
                Spacer(),
                Text(
                  'Long buildup',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Main chart
            Expanded(
              child: HighchartsChart(
                HighchartsOptions(
                  chart: HighchartsChartOptions(
                    type: 'scatter',
                    backgroundColor: '#ffffff',
                    plotBackgroundColor: '#ffffff',
                    height: 500,
                  ),
                  title: HighchartsTitleOptions(text: ''),
                  legend: HighchartsLegendOptions(enabled: false),
                  credits: HighchartsCreditsOptions(enabled: false),

                  xAxis: [
                    HighchartsXAxisOptions(
                      title: HighchartsXAxisTitleOptions(
                        text: '% change in OI',
                        enabled: true,
                      ),
                      min: -50,
                      max: 50,
                      tickInterval: 10,
                      lineWidth: 2,
                      lineColor: '#333333',
                      gridLineWidth: 1,
                      gridLineColor: '#e6e6e6',
                      plotLines: [
                        HighchartsXAxisPlotLinesOptions(
                          value: 0,
                          color: '#333333',
                          width: 2,
                          zIndex: 3,
                        ),
                      ],
                    ),
                  ],

                  yAxis: [
                    HighchartsYAxisOptions(
                      title: HighchartsYAxisTitleOptions(
                        text: '% change in price',
                      ),
                      min: -4,
                      max: 4,
                      tickInterval: 1,
                      lineWidth: 2,
                      lineColor: '#333333',
                      gridLineWidth: 1,
                      gridLineColor: '#e6e6e6',
                      plotLines: [
                        HighchartsYAxisPlotLinesOptions(
                          value: 0,
                          color: '#333333',
                          width: 2,
                          zIndex: 3,
                        ),
                      ],
                    ),
                  ],

                  plotOptions: HighchartsPlotOptions(
                    scatter: HighchartsScatterSeriesOptions(
                      marker: HighchartsScatterSeriesMarkerOptions(
                        symbol: 'circle',
                        radius: 25,
                        lineWidth: 2,
                        lineColor: '#ffffff',
                        states: HighchartsSeriesMarkerStatesOptions(
                          hover: HighchartsSeriesMarkerStatesHoverOptions(
                            enabled: true,
                            radiusPlus: 5,
                          ),
                        ),
                      ),
                      dataLabels: [
                        HighchartsSeriesDataLabelsOptions(
                          enabled: true,
                          format: '{point.name}',
                        ),
                      ],
                      tooltip: HighchartsScatterSeriesTooltipOptions(
                        pointFormat:
                            '{point.name}<br/>OI Change: {point.x}%<br/>Price Change: {point.y}%',
                      ),
                    ),
                  ),

                  // Create multiple series for different colors
                  series: _createColoredSeries(),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Bottom labels
            Row(
              children: [
                Text(
                  'Long unwinding',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
                Spacer(),
                Text(
                  'Short buildup',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Create separate series for different colors to achieve individual point coloring
  List<HighchartsScatterSeries> _createColoredSeries() {
    // Group stocks by color
    Map<String, List<StockData>> colorGroups = {};

    for (var stock in stockData) {
      String color = stock.pointColor;
      if (!colorGroups.containsKey(color)) {
        colorGroups[color] = [];
      }
      colorGroups[color]!.add(stock);
    }

    // Create a series for each color group
    List<HighchartsScatterSeries> series = [];
    int seriesIndex = 0;

    colorGroups.forEach((color, stocks) {
      series.add(
        HighchartsScatterSeries(
          name: 'Group${seriesIndex++}',
          data: stocks
              .map((stock) => [stock.oiChange, stock.priceChange])
              .toList(),
          options: HighchartsScatterSeriesOptions(
            color: color,
            marker: HighchartsScatterSeriesMarkerOptions(
              symbol: 'circle',
              radius: 25,
              lineWidth: 2,
              lineColor: '#ffffff',
              fillColor: color,
            ),
          ),
        ),
      );
    });

    return series;
  }
}
