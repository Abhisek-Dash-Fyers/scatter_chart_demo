import 'package:flutter/material.dart';
import 'package:highcharts_flutter/highcharts.dart';
import '../../main.dart';

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
                      groupPadding: 0.1, // Small padding to see individual bars
                      pointPadding: 0.05, // Small padding between bars
                      borderWidth: 0,
                      maxPointWidth: 12, // Limit bar width for thin appearance
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

    return [
      // Column bars at full height (will be visually cut by overlay)
      HighchartsColumnSeries(
        name: 'Call Options',
        dataPoints: allData.where((d) => d.type == 'call').map((d) {
          return HighchartsColumnSeriesDataOptions(
            x: d.strikePrice,
            y: d.payoff, // Use full original height
            color: '#22C55E',
          );
        }).toList(),
      ),
      HighchartsColumnSeries(
        name: 'Put Options',
        dataPoints: allData.where((d) => d.type == 'put').map((d) {
          return HighchartsColumnSeriesDataOptions(
            x: d.strikePrice,
            y: d.payoff, // Use full original height
            color: '#EF4444',
          );
        }).toList(),
      ),
      // Parabolic line that goes exactly through the column data points
      HighchartsLineSeries(
        name: 'Parabolic Cut Line',
        dataPoints: _buildLineDataPoints(),
        options: HighchartsLineSeriesOptions(
          color:
              'rgba(255, 255, 255, 0.8)', // Semi-transparent white for cutting effect
          lineWidth: 4, // Thick line to create cutting appearance
          enableMouseTracking: false, // Disable hover/tooltip
          showInLegend: false, // Hide from legend
          zIndex: 10, // Render above columns
        ),
      ),
    ];
  }

  List<HighchartsLineSeriesDataOptions> _buildLineDataPoints() {
    // Use the exact same data points as the columns to ensure the line touches the tops
    final allData = [...widget.payoffData];

    // Create a map to store the maximum payoff at each strike price
    Map<double, double> maxPayoffAtStrike = {};

    // Find the maximum payoff at each strike (considering both call and put)
    for (PayoffData data in allData) {
      if (!maxPayoffAtStrike.containsKey(data.strikePrice) ||
          maxPayoffAtStrike[data.strikePrice]! < data.payoff) {
        maxPayoffAtStrike[data.strikePrice] = data.payoff;
      }
    }

    // Convert to line data points, sorted by strike price
    List<HighchartsLineSeriesDataOptions> linePoints = [];
    List<double> sortedStrikes = maxPayoffAtStrike.keys.toList()..sort();

    for (double strike in sortedStrikes) {
      linePoints.add(
        HighchartsLineSeriesDataOptions(
          x: strike,
          y: maxPayoffAtStrike[strike]!,
        ),
      );
    }

    return linePoints;
  }
}
