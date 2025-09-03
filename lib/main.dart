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

  // Get CSS gradient color based on quadrant and intensity
  String get gradientColor {
    double intensity = priceChange.abs();

    switch (quadrant) {
      case 'long_buildup': // Upper right - Green gradients
        if (intensity > 3.0) {
          return 'radial-gradient(circle, #1B5E20 0%, #2E7D32 40%, #4CAF50 70%, #81C784 100%)';
        } else if (intensity > 2.0) {
          return 'radial-gradient(circle, #2E7D32 0%, #388E3C 40%, #66BB6A 70%, #A5D6A7 100%)';
        } else if (intensity > 1.0) {
          return 'radial-gradient(circle, #388E3C 0%, #4CAF50 40%, #81C784 70%, #C8E6C9 100%)';
        } else {
          return 'radial-gradient(circle, #4CAF50 0%, #66BB6A 40%, #A5D6A7 70%, #DCEDC8 100%)';
        }

      case 'long_unwinding': // Upper left - Light green gradients
        if (intensity > 3.0) {
          return 'radial-gradient(circle, #388E3C 0%, #4CAF50 40%, #81C784 70%, #C8E6C9 100%)';
        } else if (intensity > 2.0) {
          return 'radial-gradient(circle, #4CAF50 0%, #66BB6A 40%, #A5D6A7 70%, #DCEDC8 100%)';
        } else if (intensity > 1.0) {
          return 'radial-gradient(circle, #66BB6A 0%, #81C784 40%, #C8E6C9 70%, #E8F5E8 100%)';
        } else {
          return 'radial-gradient(circle, #81C784 0%, #A5D6A7 40%, #C8E6C9 70%, #F1F8E9 100%)';
        }

      case 'short_covering': // Lower left - Light red/orange gradients
        if (intensity > 3.0) {
          return 'radial-gradient(circle, #FF7043 0%, #FFAB91 40%, #FFCCBC 70%, #FFF3E0 100%)';
        } else if (intensity > 2.0) {
          return 'radial-gradient(circle, #FFAB91 0%, #FFCCBC 40%, #FFE0B2 70%, #FFF8E1 100%)';
        } else if (intensity > 1.0) {
          return 'radial-gradient(circle, #FFCCBC 0%, #FFE0B2 40%, #FFF3E0 70%, #FFFDE7 100%)';
        } else {
          return 'radial-gradient(circle, #FFE0B2 0%, #FFF3E0 40%, #FFF8E1 70%, #FFFDE7 100%)';
        }

      case 'short_buildup': // Lower right - Red/orange gradients
        if (intensity > 3.0) {
          return 'radial-gradient(circle, #B71C1C 0%, #D32F2F 40%, #F44336 70%, #FF7043 100%)';
        } else if (intensity > 2.0) {
          return 'radial-gradient(circle, #D32F2F 0%, #F44336 40%, #FF5722 70%, #FFAB91 100%)';
        } else if (intensity > 1.0) {
          return 'radial-gradient(circle, #F44336 0%, #FF5722 40%, #FF7043 70%, #FFCCBC 100%)';
        } else {
          return 'radial-gradient(circle, #FF5722 0%, #FF7043 40%, #FFAB91 70%, #FFE0B2 100%)';
        }

      default:
        return '#9E9E9E';
    }
  }

  // Get solid color fallback for better compatibility
  String get solidColor {
    double intensity = priceChange.abs();

    switch (quadrant) {
      case 'long_buildup': // Upper right - Green shades
        if (intensity > 3.0) return '#1B5E20';
        if (intensity > 2.0) return '#2E7D32';
        if (intensity > 1.0) return '#388E3C';
        return '#4CAF50';

      case 'long_unwinding': // Upper left - Light green shades
        if (intensity > 3.0) return '#388E3C';
        if (intensity > 2.0) return '#4CAF50';
        if (intensity > 1.0) return '#66BB6A';
        return '#81C784';

      case 'short_covering': // Lower left - Light red/orange shades
        if (intensity > 3.0) return '#FF7043';
        if (intensity > 2.0) return '#FFAB91';
        if (intensity > 1.0) return '#FFCCBC';
        return '#FFE0B2';

      case 'short_buildup': // Lower right - Red/orange shades
        if (intensity > 3.0) return '#B71C1C';
        if (intensity > 2.0) return '#D32F2F';
        if (intensity > 1.0) return '#F44336';
        return '#FF5722';

      default:
        return '#9E9E9E';
    }
  }

  // Get hover color (slightly brighter)
  String get hoverColor {
    switch (quadrant) {
      case 'long_buildup':
        return '#66BB6A';
      case 'long_unwinding':
        return '#A5D6A7';
      case 'short_covering':
        return '#FFCCBC';
      case 'short_buildup':
        return '#FF7043';
      default:
        return '#BDBDBD';
    }
  }

  // Get bubble size based on market cap with better scaling
  double get bubbleSize {
    return (marketCap * 0.8).clamp(25.0, 45.0);
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
                      labels: HighchartsXAxisLabelsOptions(
                        style: HighchartsXAxisLabelsStyleOptions(
                          fontSize: '11px',
                          color: '#666666',
                        ),
                      ),
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
                      labels: HighchartsYAxisLabelsOptions(
                        style: HighchartsXAxisLabelsStyleOptions(
                          fontSize: '11px',
                          color: '#666666',
                        ),
                      ),
                    ),
                  ],

                  plotOptions: HighchartsPlotOptions(
                    bubble: HighchartsBubbleSeriesOptions(
                      minSize: 25,
                      maxSize: 45,
                      sizeBy: 'area',
                      zMin: 30,
                      zMax: 60,
                      displayNegative: true,
                      sizeByAbsoluteValue: false,
                      opacity: 0.8,
                      dataLabels: HighchartsBubbleSeriesDataLabelsOptions(
                        enabled: true,
                        format: '{point.name}',
                        style: {
                          'fontSize': '10px',
                          'fontWeight': 'bold',
                          'color': '#ffffff',
                          'textOutline': '2px contrast',
                        },
                        shadow: {
                          'color': 'rgba(0,0,0,0.3)',
                          'offsetX': 1,
                          'offsetY': 1,
                          'opacity': 0.5,
                          'width': 2,
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
                              color: stock.solidColor,
                              marker: HighchartsBubbleSeriesDataMarkerOptions(
                                fillColor: stock.solidColor,
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
