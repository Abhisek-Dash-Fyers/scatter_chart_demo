import 'package:flutter/material.dart';
import 'package:highcharts_flutter/highcharts.dart';
import '../../main.dart';
import 'dart:math' as math;

class HighchartsParabolicChart extends StatefulWidget {
  final List<PayoffData> payoffData;
  final double currentPrice;
  final double maxPain;

  const HighchartsParabolicChart({
    super.key,
    required this.payoffData,
    required this.currentPrice,
    required this.maxPain,
  });

  @override
  State<HighchartsParabolicChart> createState() =>
      _HighchartsParabolicChartState();
}

class _HighchartsParabolicChartState extends State<HighchartsParabolicChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Strategy Payoff Chart'),
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
                          'NIFTY Strategy Payoff',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Current: ₹${widget.currentPrice.toStringAsFixed(2)} | Max Pain: ₹${widget.maxPain.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildLegendItem('Call', Color(0xFF22C55E)),
                        SizedBox(width: 16),
                        _buildLegendItem('Put', Color(0xFFEF4444)),
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
                      tickInterval: 200, // Smaller intervals for more detail
                      gridLineWidth: 1,
                      gridLineColor: '#e0e0e0',
                      lineColor: '#cccccc',
                      plotLines: [
                        HighchartsXAxisPlotLinesOptions(
                          value: widget.currentPrice,
                          color: '#1976d2',
                          width: 2,
                          dashStyle: 'Dash',
                        ),
                        HighchartsXAxisPlotLinesOptions(
                          value: widget.maxPain,
                          color: '#ff9800',
                          width: 2,
                          dashStyle: 'Dash',
                        ),
                      ],
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
                        text: 'Call Frequency',
                        style: HighchartsXAxisTitleStyleOptions(
                          fontSize: '12px',
                          color: '#666666',
                        ),
                      ),
                      // Let chart auto-scale from data, starting from 0
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
                      groupPadding: 0.1, // Small group padding
                      pointPadding: 0.1, // Small padding for thin bars
                      borderWidth: 0,
                      maxPointWidth: 8, // Limit bar width to make them thin
                    ),
                  ),
                  tooltip: HighchartsTooltipOptions(
                    shared: true,
                    backgroundColor: '#ffffff',
                    borderColor: '#cccccc',
                    borderRadius: 8,
                  ),
                  series: _buildSeries(),
                ),
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
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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

  List<HighchartsSeries> _buildSeries() {
    // Combine all data and start from bottom (no negative values)
    final allData = [...widget.payoffData];

    // Generate parabolic curve data
    final parabolicData = _generateParabolicData();

    return [
      // All bars starting from bottom with clipping to parabolic curve
      HighchartsColumnSeries(
        name: 'Options',
        dataPoints: allData.map((d) {
          // Clip the bar height to the parabolic curve value
          double parabolicValue = _getParabolicValueAtX(
            d.strikePrice,
            parabolicData,
          );
          double clippedValue = math.min(d.payoff, parabolicValue);

          // Color based on type
          String color = d.type == 'call' ? '#22C55E' : '#EF4444';

          return HighchartsColumnSeriesDataOptions(
            x: d.strikePrice,
            y: clippedValue, // All positive values from bottom
            color: color,
          );
        }).toList(),
      ),

      // Parabolic curve overlay
      HighchartsSplineSeries(
        name: 'Payoff Curve',
        dataPoints: parabolicData
            .map(
              (d) => HighchartsSplineSeriesDataOptions(
                x: d.strikePrice,
                y: d.payoff,
                color: '#6366F1', // Blue-purple to match design
              ),
            )
            .toList(),
      ),
    ];
  }

  List<PayoffData> _generateParabolicData() {
    List<PayoffData> parabolicData = [];

    // Generate parabolic curve data points that match the bar data
    for (double strike = 22400; strike <= 26000; strike += 25) {
      // Create a parabolic shape with minimum at max pain point
      double distance = (strike - widget.maxPain).abs();
      double minValue = 5000;
      double a = 0.015; // Same formula as main data
      double payoff = (a * distance * distance) + minValue;

      parabolicData.add(
        PayoffData(strikePrice: strike, payoff: payoff, type: 'curve'),
      );
    }

    return parabolicData;
  }

  double _getParabolicValueAtX(double x, List<PayoffData> parabolicData) {
    // Find the closest parabolic data point
    PayoffData? closest;
    double minDistance = double.infinity;

    for (PayoffData data in parabolicData) {
      double distance = (data.strikePrice - x).abs();
      if (distance < minDistance) {
        minDistance = distance;
        closest = data;
      }
    }

    return closest?.payoff ?? 20000;
  }
}
