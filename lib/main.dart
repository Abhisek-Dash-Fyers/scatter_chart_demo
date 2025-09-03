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

  // Get color with gradient effect based on price change intensity
  String get pointColor {
    if (priceChange >= 0) {
      // Green gradients for positive changes
      if (priceChange > 3.0) {
        return 'radial-gradient(circle, #1B5E20 0%, #2E7D32 50%, #4CAF50 100%)';
      } else if (priceChange > 2.0) {
        return 'radial-gradient(circle, #2E7D32 0%, #388E3C 50%, #66BB6A 100%)';
      } else if (priceChange > 1.0) {
        return 'radial-gradient(circle, #388E3C 0%, #4CAF50 50%, #81C784 100%)';
      } else {
        return 'radial-gradient(circle, #4CAF50 0%, #66BB6A 50%, #A5D6A7 100%)';
      }
    } else {
      // Red/Orange gradients for negative changes
      if (priceChange < -3.0) {
        return 'radial-gradient(circle, #B71C1C 0%, #D32F2F 50%, #F44336 100%)';
      } else if (priceChange < -2.0) {
        return 'radial-gradient(circle, #D32F2F 0%, #F44336 50%, #EF5350 100%)';
      } else if (priceChange < -1.0) {
        return 'radial-gradient(circle, #F44336 0%, #FF5722 50%, #FF7043 100%)';
      } else {
        return 'radial-gradient(circle, #FF5722 0%, #FF7043 50%, #FFAB91 100%)';
      }
    }
  }

  // Get solid color fallback for better compatibility
  String get solidColor {
    if (priceChange >= 0) {
      if (priceChange > 3.0) return '#1B5E20';
      if (priceChange > 2.0) return '#2E7D32';
      if (priceChange > 1.0) return '#388E3C';
      return '#4CAF50';
    } else {
      if (priceChange < -3.0) return '#B71C1C';
      if (priceChange < -2.0) return '#D32F2F';
      if (priceChange < -1.0) return '#F44336';
      return '#FF5722';
    }
  }

  // Get bubble size based on market cap
  double get bubbleSize {
    return (marketCap / 1.5).clamp(20.0, 40.0);
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
    StockData(symbol: 'ABB', oiChange: -10, priceChange: 0.8, marketCap: 35),

    // Upper right quadrant (Long buildup - positive OI, positive price)
    StockData(symbol: 'TORRENT', oiChange: 45, priceChange: 3.5, marketCap: 55),
    StockData(symbol: 'ABB', oiChange: 35, priceChange: 2.6, marketCap: 48),
    StockData(symbol: 'ABB', oiChange: 25, priceChange: 2.2, marketCap: 46),
    StockData(symbol: 'HIMAT', oiChange: 15, priceChange: 1.8, marketCap: 40),
    StockData(symbol: 'AIA', oiChange: 20, priceChange: 1.4, marketCap: 42),
    StockData(symbol: 'ABB', oiChange: 40, priceChange: 1.1, marketCap: 44),
    StockData(symbol: 'ABB', oiChange: 30, priceChange: 0.9, marketCap: 41),

    // Lower left quadrant (Short covering - negative OI, negative price)
    StockData(symbol: 'AIA', oiChange: -45, priceChange: -1.2, marketCap: 38),
    StockData(symbol: 'HIMAT', oiChange: -35, priceChange: -1.8, marketCap: 40),
    StockData(symbol: 'ABB', oiChange: -25, priceChange: -2.8, marketCap: 45),
    StockData(symbol: 'HIMAT', oiChange: -15, priceChange: -2.2, marketCap: 42),
    StockData(symbol: 'L&T', oiChange: -10, priceChange: -1.5, marketCap: 39),
    StockData(
      symbol: 'TORRENT',
      oiChange: -20,
      priceChange: -2.9,
      marketCap: 43,
    ),

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
    StockData(symbol: 'ABB', oiChange: 50, priceChange: -3.2, marketCap: 47),
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
                    type: 'bubble',
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
                        style: HighchartsXAxisTitleStyleOptions(
                          fontSize: '12px',
                          color: '#666666',
                        ),
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
                        style: HighchartsXAxisTitleStyleOptions(
                          fontSize: '12px',
                          color: '#666666',
                        ),
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
                    bubble: HighchartsBubbleSeriesOptions(
                      minSize: 20,
                      maxSize: 40,
                      dataLabels: HighchartsBubbleSeriesDataLabelsOptions(
                        enabled: true,
                        format: '{point.name}',
                        style: {
                          'fontSize': '10px',
                          'fontWeight': 'bold',
                          'color': '#ffffff',
                          'textOutline': '1px contrast',
                        },
                      ),
                      tooltip: HighchartsBubbleSeriesTooltipOptions(
                        pointFormat:
                            '{point.name}<br/>OI Change: {point.x}%<br/>Price Change: {point.y}%<br/>Market Cap: {point.z}',
                      ),
                    ),
                  ),

                  series: [
                    HighchartsBubbleSeries(
                      name: 'Stocks',
                      dataPoints: stockData
                          .map(
                            (stock) => HighchartsBubbleSeriesDataOptions(
                              x: stock.oiChange,
                              y: stock.priceChange,
                              z: stock.marketCap,
                              name: stock.symbol,
                              color: stock
                                  .solidColor, // Using solid color for better compatibility
                            ),
                          )
                          .toList(),
                    ),
                  ],
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
}
