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

  // Get quadrant based on position
  String get quadrant {
    if (oiChange >= 0 && priceChange >= 0) return 'long_buildup';
    if (oiChange < 0 && priceChange >= 0) return 'long_unwinding';
    if (oiChange < 0 && priceChange < 0) return 'short_covering';
    return 'short_buildup'; // oiChange >= 0 && priceChange < 0
  }

  // Get CSS gradient color based on quadrant and intensity (simplified for Highcharts compatibility)
  String get gradientColor {
    // For now, return the primary color from each gradient as Highcharts may not support CSS gradients directly
    return solidColor;
  }

  // Get solid color based on quadrant only (ignoring intensity)
  String get solidColor {
    switch (quadrant) {
      case 'long_buildup': // Upper right - Dark green
        return '#1B5E20';
      case 'long_unwinding': // Upper left - Light green
        return '#4CAF50';
      case 'short_covering': // Lower left - Light orange
        return '#FF7043';
      case 'short_buildup': // Lower right - Dark red
        return '#B71C1C';
      default:
        return '#9E9E9E';
    }
  }

  // Get hover color (slightly brighter)
  String get hoverColor {
    switch (quadrant) {
      case 'long_buildup':
        return '#4CAF50'; // Brighter green
      case 'long_unwinding':
        return '#81C784'; // Brighter light green
      case 'short_covering':
        return '#FFAB91'; // Brighter orange
      case 'short_buildup':
        return '#F44336'; // Brighter red
      default:
        return '#BDBDBD';
    }
  }

  // Get bubble size based on market cap with better scaling
  double get bubbleSize {
    return (marketCap * 0.8).clamp(25.0, 45.0);
  }

  // Get simplified gradient for each quadrant (ignoring intensity)
  String get quadrantGradient {
    switch (quadrant) {
      case 'long_buildup': // Upper right - Dark green gradient
        return 'radial-gradient(circle, #1B5E20 0%, #2E7D32 40%, #4CAF50 70%, #81C784 100%)';
      case 'long_unwinding': // Upper left - Light green gradient
        return 'radial-gradient(circle, #4CAF50 0%, #66BB6A 40%, #81C784 70%, #C8E6C9 100%)';
      case 'short_covering': // Lower left - Orange gradient
        return 'radial-gradient(circle, #FF7043 0%, #FFAB91 40%, #FFCCBC 70%, #FFF3E0 100%)';
      case 'short_buildup': // Lower right - Red gradient
        return 'radial-gradient(circle, #B71C1C 0%, #D32F2F 40%, #F44336 70%, #FF7043 100%)';
      default:
        return 'radial-gradient(circle, #9E9E9E 0%, #E0E0E0 100%)';
    }
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
            // Time frequency selector (as shown in image)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildTab('All', true),
                    _buildTab('Indices', false),
                    _buildTab('Commodities', false),
                    _buildTab('Stocks', false),
                  ],
                ),
                Row(
                  children: [
                    Text('Time frequency:', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 8),
                    _buildTimeButton('1d', true),
                    _buildTimeButton('1h', false),
                    _buildTimeButton('30m', false),
                    _buildTimeButton('15m', false),
                    _buildTimeButton('5m', false),
                    _buildTimeButton('3m', false),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            // Secondary tabs
            Row(
              children: [
                _buildSecondaryTab('Heatmap', true),
                _buildSecondaryTab('Top gainers and losers', false),
                _buildSecondaryTab('Expiring soon', false),
              ],
            ),
            SizedBox(height: 16),
            // Main chart with integrated quadrant labels
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
                          fontSize: '11px',
                          color: '#888888',
                        ),
                        margin: 15,
                      ),
                      min: -50,
                      max: 50,
                      tickInterval: 10,
                      lineWidth: 1,
                      lineColor: '#d0d0d0',
                      gridLineWidth: 1,
                      gridLineColor: '#f0f0f0',
                      plotLines: [
                        HighchartsXAxisPlotLinesOptions(
                          value: 0,
                          color: '#666666',
                          width: 1,
                          zIndex: 3,
                        ),
                      ],
                      labels: HighchartsXAxisLabelsOptions(
                        style: HighchartsXAxisLabelsStyleOptions(
                          fontSize: '10px',
                          color: '#999999',
                        ),
                        format: '{value}%',
                      ),
                    ),
                  ],

                  yAxis: [
                    HighchartsYAxisOptions(
                      title: HighchartsYAxisTitleOptions(
                        text: '% change in price',
                        style: HighchartsXAxisTitleStyleOptions(
                          fontSize: '11px',
                          color: '#888888',
                        ),
                        margin: 15,
                      ),
                      min: -4,
                      max: 4,
                      tickInterval: 1,
                      lineWidth: 1,
                      lineColor: '#d0d0d0',
                      gridLineWidth: 1,
                      gridLineColor: '#f0f0f0',
                      plotLines: [
                        HighchartsYAxisPlotLinesOptions(
                          value: 0,
                          color: '#666666',
                          width: 1,
                          zIndex: 3,
                        ),
                      ],
                      labels: HighchartsYAxisLabelsOptions(
                        style: HighchartsXAxisLabelsStyleOptions(
                          fontSize: '10px',
                          color: '#999999',
                        ),
                        format: '{value}%',
                      ),
                    ),
                  ],

                  plotOptions: HighchartsPlotOptions(
                    bubble: HighchartsBubbleSeriesOptions(
                      minSize: 80,
                      maxSize: 80,
                      sizeBy: 'area',
                      zMin: 30,
                      zMax: 60,
                      displayNegative: true,
                      sizeByAbsoluteValue: false,
                      opacity: 0.9,
                      dataLabels: HighchartsBubbleSeriesDataLabelsOptions(
                        enabled: true,
                        useHTML: true,
                        format:
                            '<div style="text-align: center; color: white; font-weight: bold;"><div style="width: 16px; height: 16px; background: rgba(255,255,255,0.9); border-radius: 50%; margin: 0 auto 2px; display: flex; align-items: center; justify-content: center; font-size: 8px; color: #333;">📊</div><div style="font-size: 9px; text-shadow: 1px 1px 2px rgba(0,0,0,0.8);">{point.name}</div></div>',
                        style: {
                          'fontSize': '9px',
                          'fontWeight': 'bold',
                          'color': '#ffffff',
                          'textOutline': 'none',
                        },
                      ),
                      tooltip: HighchartsBubbleSeriesTooltipOptions(
                        pointFormat:
                            '<b>{point.name}</b><br/>OI Change: {point.x}%<br/>Price Change: {point.y}%<br/>Market Cap: {point.z}',
                      ),
                      marker: HighchartsBubbleSeriesMarkerOptions(
                        lineWidth: 2,
                        lineColor: '#ffffff',
                        fillOpacity: 0.8,
                        states: HighchartsBubbleSeriesMarkerStatesOptions(
                          hover: HighchartsBubbleSeriesMarkerStatesHoverOptions(
                            enabled: true,
                            radiusPlus: 5,
                            lineWidthPlus: 1,
                            fillColor: null,
                          ),
                        ),
                      ),
                    ),
                  ),

                  series: [
                    // Main stock data series
                    HighchartsBubbleSeries(
                      name: 'Stocks',
                      dataPoints: stockData
                          .map(
                            (stock) => HighchartsBubbleSeriesDataOptions(
                              x: stock.oiChange,
                              y: stock.priceChange,
                              z: stock.marketCap,
                              name: stock.symbol,
                              color:
                                  stock.solidColor, // Use solid color for base
                              marker: HighchartsBubbleSeriesDataMarkerOptions(
                                fillColor: stock
                                    .solidColor, // Use solid color for marker
                                lineColor: '#ffffff',
                                lineWidth: 2,
                                states: HighchartsSeriesMarkerStatesOptions(
                                  hover:
                                      HighchartsSeriesMarkerStatesHoverOptions(
                                        fillColor: stock.hoverColor,
                                        lineColor: '#ffffff',
                                        lineWidth: 3,
                                        radiusPlus: 5,
                                      ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    // Quadrant labels series (using scatter with invisible markers)
                    HighchartsScatterSeries(
                      name: 'Quadrant Labels',
                      options: HighchartsScatterSeriesOptions(
                        enableMouseTracking:
                            false, // Disable mouse interactions
                        showInLegend: false, // Hide from legend
                        allowPointSelect: false, // Disable point selection
                        marker: HighchartsScatterSeriesMarkerOptions(
                          enabled: false, // Hide markers completely
                          radius: 0,
                          fillColor: 'transparent',
                          lineColor: 'transparent',
                        ),
                        dataLabels: [
                          HighchartsSeriesDataLabelsOptions(
                            enabled: true,
                            format: '{point.name}',
                            style: {
                              'fontSize': '13px',
                              'fontWeight': '500',
                              'color': '#666666',
                              'textOutline': 'none',
                              'cursor': 'default',
                            },
                            useHTML: false,
                            allowOverlap: true,
                          ),
                        ],
                        tooltip: HighchartsScatterSeriesTooltipOptions(
                          pointFormat: '', // Empty tooltip content
                        ),
                      ),
                      dataPoints: [
                        // Upper left quadrant - Long unwinding (positioned more towards corner)
                        HighchartsScatterSeriesDataOptions(
                          x: -40,
                          y: 3.5,
                          name: 'Long unwinding',
                        ),
                        // Upper right quadrant - Long buildup (positioned more towards corner)
                        HighchartsScatterSeriesDataOptions(
                          x: 40,
                          y: 3.5,
                          name: 'Long buildup',
                        ),
                        // Lower left quadrant - Short covering (positioned more towards corner)
                        HighchartsScatterSeriesDataOptions(
                          x: -40,
                          y: -3.5,
                          name: 'Short covering',
                        ),
                        // Lower right quadrant - Short buildup (positioned more towards corner)
                        HighchartsScatterSeriesDataOptions(
                          x: 40,
                          y: -3.5,
                          name: 'Short buildup',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: isSelected ? Border.all(color: Colors.blue.shade200) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSecondaryTab(String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: isSelected ? Border.all(color: Colors.blue.shade200) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTimeButton(String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey.shade800 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade600,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
