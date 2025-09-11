import 'package:flutter/material.dart';
import 'package:highcharts_flutter/highcharts.dart';

// Option chain data model
class OptionData {
  final double strikePrice;
  final double openInterest;
  final double oiChange; // Can be positive or negative
  final String type; // 'call' or 'put'

  OptionData({
    required this.strikePrice,
    required this.openInterest,
    required this.oiChange,
    required this.type,
  });

  // Helper properties for stacked visualization
  double get baseOI => openInterest - oiChange.abs();
  double get changeAmount => oiChange.abs();
  bool get hasPositiveChange => oiChange > 0;
}

class HighchartsStripedBarChart extends StatefulWidget {
  final double currentPrice;

  const HighchartsStripedBarChart({super.key, required this.currentPrice});

  @override
  State<HighchartsStripedBarChart> createState() =>
      _HighchartsStripedBarChartState();
}

class _HighchartsStripedBarChartState extends State<HighchartsStripedBarChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Open Interest Chart'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Top controls
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Strategy info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NIFTY Open Interest',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Current: ₹${widget.currentPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildLegendItem('Call OI', Color(0xFF22C55E)),
                        SizedBox(width: 16),
                        _buildLegendItem('Put OI', Color(0xFFEF4444)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Time controls
                Row(
                  children: [
                    Text('Expiry:', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 8),
                    _buildTimeButton('4 Aug 2025', true),
                    _buildTimeButton('16 Jul 2025', false),
                    Spacer(),
                    Text(
                      'As on 4 Aug 2025',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Chart area
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: HighchartsChart(
                HighchartsOptions(
                  chart: HighchartsChartOptions(
                    type: 'column',
                    backgroundColor: '#ffffff',
                    height: 400,
                  ),
                  title: HighchartsTitleOptions(text: ''),
                  legend: HighchartsLegendOptions(enabled: false),
                  credits: HighchartsCreditsOptions(enabled: false),
                  xAxis: [
                    HighchartsXAxisOptions(
                      title: HighchartsXAxisTitleOptions(
                        text: 'Strike Price',
                        style: HighchartsXAxisTitleStyleOptions(
                          fontSize: '12px',
                          color: '#666666',
                        ),
                      ),
                      min: 22400,
                      max: 26000,
                      tickInterval: 200,
                      gridLineWidth: 1,
                      gridLineColor: '#e0e0e0',
                      lineColor: '#cccccc',
                      // plotLines: [], // Removed current price line
                      labels: HighchartsXAxisLabelsOptions(
                        style: HighchartsXAxisLabelsStyleOptions(
                          fontSize: '10px',
                          color: '#666666',
                        ),
                      ),
                    ),
                  ],
                  yAxis: [
                    HighchartsYAxisOptions(
                      title: HighchartsYAxisTitleOptions(
                        text: 'Open Interest',
                        style: HighchartsXAxisTitleStyleOptions(
                          fontSize: '12px',
                          color: '#666666',
                        ),
                      ),
                      min: 0,
                      gridLineWidth: 1,
                      gridLineColor: '#e0e0e0',
                      lineColor: '#cccccc',
                      labels: HighchartsYAxisLabelsOptions(
                        style: HighchartsXAxisLabelsStyleOptions(
                          fontSize: '10px',
                          color: '#666666',
                        ),
                      ),
                    ),
                  ],
                  plotOptions: HighchartsPlotOptions(
                    column: HighchartsColumnSeriesOptions(
                      stacking: 'normal',
                      pointPadding: 0.02, // Reduced padding for wider columns
                      groupPadding:
                          0.05, // Reduced group padding for wider columns
                      borderWidth: 0,
                      maxPointWidth:
                          60, // Set maximum column width to match design
                    ),
                  ),
                  tooltip: HighchartsTooltipOptions(
                    shared: true,
                    backgroundColor: '#ffffff',
                    borderColor: '#cccccc',
                    borderRadius: 8,
                  ),
                  series: _buildSeriesWithPatterns(),
                ),
                javaScriptModules: [
                  'https://code.highcharts.com/highcharts.js',
                  'https://code.highcharts.com/highcharts-more.js',
                  'https://code.highcharts.com/highcharts-3d.js',
                  'https://code.highcharts.com/modules/solid-gauge.js',
                  'https://code.highcharts.com/modules/annotations.js',
                  'https://code.highcharts.com/modules/boost.js',
                  'https://code.highcharts.com/modules/broken-axis.js',
                  'https://code.highcharts.com/modules/data.js',
                  'https://code.highcharts.com/modules/exporting.js',
                  'https://code.highcharts.com/modules/offline-exporting.js',
                  'https://code.highcharts.com/modules/accessibility.js',
                  'https://code.highcharts.com/modules/pattern-fill.js',
                ],
                javaScript: _buildPatternFillJS(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildTimeButton(String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: isSelected
            ? Border.all(color: Colors.blue.shade200)
            : Border.all(color: Colors.grey.shade300),
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

  String _buildPatternFillJS() {
    // Build JavaScript to modify series colors with pattern fills after chart creation
    return '''
      // Wait for chart to be created, then modify series colors with patterns
      setTimeout(function() {
        if (window.highcharts_flutter && window.highcharts_flutter.chart) {
          var chart = window.highcharts_flutter.chart;
          
          // Apply pattern fills to Call OI Change series (index 0)
          var callChangeSeries = chart.series[0];
          if (callChangeSeries && callChangeSeries.name === 'Call OI Change') {
            callChangeSeries.data.forEach(function(point, index) {
              // Check if this point represents a positive OI change
              if (point.color !== 'transparent' && point.y > 0) {
                // Apply pattern fill for positive changes only
                point.update({
                  color: {
                    pattern: {
                      path: {
                        d: 'M 0 8 L 8 0',
                        strokeWidth: 2
                      },
                      width: 8,
                      height: 8,
                      color: '#22C55E'
                    }
                  },
                  borderColor: '#22C55E',
                  borderWidth: 1
                }, false);
              } else if (point.color === 'transparent' && point.y > 0) {
                // Apply border for negative changes (transparent with border)
                point.update({
                  color: 'transparent',
                  borderColor: '#22C55E',
                  borderWidth: 1
                }, false);
              }
            });
          }
          
          // Apply pattern fills to Put OI Change series (index 2)
          var putChangeSeries = chart.series[2];
          if (putChangeSeries && putChangeSeries.name === 'Put OI Change') {
            putChangeSeries.data.forEach(function(point, index) {
              // Check if this point represents a positive OI change
              if (point.color !== 'transparent' && point.y > 0) {
                // Apply pattern fill for positive changes only
                point.update({
                  color: {
                    pattern: {
                      path: {
                        d: 'M 0 8 L 8 0',
                        strokeWidth: 2
                      },
                      width: 8,
                      height: 8,
                      color: '#EF4444'
                    }
                  },
                  borderColor: '#EF4444',
                  borderWidth: 1
                }, false);
              } else if (point.color === 'transparent' && point.y > 0) {
                // Apply border for negative changes (transparent with border)
                point.update({
                  color: 'transparent',
                  borderColor: '#EF4444',
                  borderWidth: 1
                }, false);
              }
            });
          }
          
          // Redraw chart with pattern fills
          chart.redraw();
        }
      }, 100);
    ''';
  }

  List<HighchartsSeries> _buildSeriesWithPatterns() {
    final optionChainData = _generateOptionChainData();

    return [
      // Call OI Change (top portion - will be modified by JS for pattern fills)
      HighchartsColumnSeries(
        name: 'Call OI Change',
        dataPoints: optionChainData.where((d) => d.type == 'call').map((d) {
          return HighchartsColumnSeriesDataOptions(
            x: d.strikePrice,
            y: d.changeAmount,
            // Initial color - will be replaced by JS pattern for positive changes
            color: d.hasPositiveChange
                ? '#22C55E' // Temporary solid color (will be replaced with pattern)
                : 'transparent', // Transparent for negative (hollow effect)
          );
        }).toList(),
        options: HighchartsColumnSeriesOptions(stack: 'call'),
      ),
      // Call OI Base (bottom portion - solid green)
      HighchartsColumnSeries(
        name: 'Call OI Base',
        dataPoints: optionChainData.where((d) => d.type == 'call').map((d) {
          return HighchartsColumnSeriesDataOptions(
            x: d.strikePrice,
            y: d.baseOI,
            color: '#22C55E',
          );
        }).toList(),
        options: HighchartsColumnSeriesOptions(stack: 'call'),
      ),
      // Put OI Change (top portion - will be modified by JS for pattern fills)
      HighchartsColumnSeries(
        name: 'Put OI Change',
        dataPoints: optionChainData.where((d) => d.type == 'put').map((d) {
          return HighchartsColumnSeriesDataOptions(
            x: d.strikePrice,
            y: d.changeAmount,
            // Initial color - will be replaced by JS pattern for positive changes
            color: d.hasPositiveChange
                ? '#EF4444' // Temporary solid color (will be replaced with pattern)
                : 'transparent', // Transparent for negative (hollow effect)
          );
        }).toList(),
        options: HighchartsColumnSeriesOptions(stack: 'put'),
      ),
      // Put OI Base (bottom portion - solid red)
      HighchartsColumnSeries(
        name: 'Put OI Base',
        dataPoints: optionChainData.where((d) => d.type == 'put').map((d) {
          return HighchartsColumnSeriesDataOptions(
            x: d.strikePrice,
            y: d.baseOI,
            color: '#EF4444',
          );
        }).toList(),
        options: HighchartsColumnSeriesOptions(stack: 'put'),
      ),
    ];
  }

  List<OptionData> _generateOptionChainData() {
    List<OptionData> data = [];

    // Generate option chain data similar to the design image
    List<double> strikes = [
      22400,
      22630,
      22850,
      23070,
      23300,
      23530,
      23760,
      23990,
      24220,
      24450,
      24600,
      25000,
      25500,
      25600,
      25650,
      25800,
    ];

    for (double strike in strikes) {
      // Generate Call OI for each strike (higher for ITM calls)
      double callOI = strike < widget.currentPrice
          ? _generateRandomOI(strike, 'call')
          : _generateRandomOI(strike, 'call') * 0.3; // Lower OI for OTM calls

      double callOIChange = _generateOIChange(callOI);

      data.add(
        OptionData(
          strikePrice: strike,
          openInterest: callOI,
          oiChange: callOIChange,
          type: 'call',
        ),
      );

      // Generate Put OI for each strike (higher for ITM puts)
      double putOI = strike > widget.currentPrice
          ? _generateRandomOI(strike, 'put')
          : _generateRandomOI(strike, 'put') * 0.3; // Lower OI for OTM puts

      double putOIChange = _generateOIChange(putOI);

      data.add(
        OptionData(
          strikePrice: strike,
          openInterest: putOI,
          oiChange: putOIChange,
          type: 'put',
        ),
      );
    }

    return data;
  }

  double _generateRandomOI(double strike, String type) {
    // Generate realistic OI values based on distance from current price
    double distance = (strike - widget.currentPrice).abs();
    double baseOI = 80000 - (distance * 15); // Higher OI closer to ATM

    // Add some randomness
    baseOI += (baseOI * 0.3 * (0.5 - (strike % 100) / 200));

    return baseOI.clamp(10000, 160000);
  }

  double _generateOIChange(double oi) {
    // Generate OI change as percentage of total OI (can be positive or negative)
    // 60% chance of positive change, 40% chance of negative change
    bool isPositive = (oi.toInt() % 10) > 4;
    double changePercent = (oi.toInt() % 4) * 0.05 + 0.1; // 10% to 25% of OI

    return isPositive ? oi * changePercent : -oi * changePercent;
  }
}
