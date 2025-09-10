import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

class SyncfusionStripedBarChart extends StatefulWidget {
  final double currentPrice;

  const SyncfusionStripedBarChart({super.key, required this.currentPrice});

  @override
  State<SyncfusionStripedBarChart> createState() =>
      _SyncfusionStripedBarChartState();
}

class _SyncfusionStripedBarChartState extends State<SyncfusionStripedBarChart> {
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
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SfCartesianChart(
                  backgroundColor: Colors.white,
                  plotAreaBorderWidth: 0,
                  title: ChartTitle(text: ''),
                  legend: Legend(isVisible: false),
                  primaryXAxis: NumericAxis(
                    title: AxisTitle(
                      text: 'Strike Price',
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    minimum: 22400,
                    maximum: 26000,
                    interval: 200,
                    majorGridLines: MajorGridLines(
                      width: 1,
                      color: Colors.grey.shade200,
                    ),
                    axisLine: AxisLine(color: Colors.grey.shade300),
                    labelStyle: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                    plotBands: [
                      PlotBand(
                        start: widget.currentPrice,
                        end: widget.currentPrice,
                        borderColor: Colors.blue,
                        borderWidth: 2,
                        dashArray: [5, 5],
                      ),
                    ],
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(
                      text: 'Open Interest',
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    minimum: 0,
                    majorGridLines: MajorGridLines(
                      width: 1,
                      color: Colors.grey.shade200,
                    ),
                    axisLine: AxisLine(color: Colors.grey.shade300),
                    labelStyle: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
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

  List<CartesianSeries> _buildSeries() {
    // Generate option chain data that matches the design
    final optionChainData = _generateOptionChainData();

    return [
      // Call OI Base (solid green)
      StackedColumnSeries<OptionData, double>(
        name: 'Call OI Base',
        dataSource: optionChainData.where((d) => d.type == 'call').toList(),
        xValueMapper: (OptionData data, _) => data.strikePrice,
        yValueMapper: (OptionData data, _) => data.baseOI,
        color: Color(0xFF22C55E), // Solid green for base OI
        width: 0.7,
        spacing: 0.05,
        groupName: 'call',
      ),
      // Call OI Change (different shade for change portion)
      StackedColumnSeries<OptionData, double>(
        name: 'Call OI Change',
        dataSource: optionChainData.where((d) => d.type == 'call').toList(),
        xValueMapper: (OptionData data, _) => data.strikePrice,
        yValueMapper: (OptionData data, _) => data.changeAmount,
        // Different color based on positive/negative change
        pointColorMapper: (OptionData data, _) => data.hasPositiveChange
            ? Color(0xFF16A34A) // Darker green for positive change
            : Color(0xFF15803D), // Even darker green for negative change
        width: 0.7,
        spacing: 0.05,
        groupName: 'call',
      ),
      // Put OI Base (solid red)
      StackedColumnSeries<OptionData, double>(
        name: 'Put OI Base',
        dataSource: optionChainData.where((d) => d.type == 'put').toList(),
        xValueMapper: (OptionData data, _) => data.strikePrice,
        yValueMapper: (OptionData data, _) => data.baseOI,
        color: Color(0xFFEF4444), // Solid red for base OI
        width: 0.7,
        spacing: 0.05,
        groupName: 'put',
      ),
      // Put OI Change (different shade for change portion)
      StackedColumnSeries<OptionData, double>(
        name: 'Put OI Change',
        dataSource: optionChainData.where((d) => d.type == 'put').toList(),
        xValueMapper: (OptionData data, _) => data.strikePrice,
        yValueMapper: (OptionData data, _) => data.changeAmount,
        // Different color based on positive/negative change
        pointColorMapper: (OptionData data, _) => data.hasPositiveChange
            ? Color(0xFFDC2626) // Darker red for positive change
            : Color(0xFFB91C1C), // Even darker red for negative change
        width: 0.7,
        spacing: 0.05,
        groupName: 'put',
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
