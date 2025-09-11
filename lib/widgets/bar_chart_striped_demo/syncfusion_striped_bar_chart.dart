import 'dart:ui' as ui;
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

  // Helper properties for visualization
  double get baseOI => openInterest - oiChange.abs();
  double get changeAmount => oiChange.abs();
  bool get hasPositiveChange => oiChange > 0;
  double get changePercent => changeAmount / openInterest;
}

// Custom shader for diagonal stripes using dart:ui
class StripeShader {
  static Shader createDiagonalStripeShader(Rect bounds, Color baseColor) {
    // Create a more sophisticated diagonal stripe pattern
    return ui.Gradient.linear(
      bounds.topLeft,
      bounds.bottomRight,
      [
        baseColor,
        Colors.white.withOpacity(0.4),
        baseColor,
        Colors.white.withOpacity(0.4),
        baseColor,
        Colors.white.withOpacity(0.4),
        baseColor,
        Colors.white.withOpacity(0.4),
      ],
      [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875],
      TileMode.repeated,
    );
  }

  // Create a solid color shader for negative changes
  static Shader createSolidShader(Rect bounds, Color color) {
    return ui.Gradient.linear(
      bounds.topLeft,
      bounds.bottomRight,
      [color, color],
      [0.0, 1.0],
      TileMode.clamp,
    );
  }
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
      // Call OI Base (solid green bottom portion)
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
      // Call OI Change (top portion with diagonal stripe shader)
      StackedColumnSeries<OptionData, double>(
        name: 'Call OI Change',
        dataSource: optionChainData.where((d) => d.type == 'call').toList(),
        xValueMapper: (OptionData data, _) => data.strikePrice,
        yValueMapper: (OptionData data, _) => data.changeAmount,
        width: 0.7,
        spacing: 0.05,
        groupName: 'call',
        // Conditional coloring and shader for the top portion
        pointColorMapper: (OptionData data, _) {
          if (data.hasPositiveChange) {
            return Color(0xFF22C55E); // Base color for positive changes
          } else {
            return Colors.transparent; // Transparent for negative changes
          }
        },
        // Apply diagonal stripe pattern using gradient
        gradient: LinearGradient(
          colors: [
            Color(0xFF22C55E),
            Colors.white.withOpacity(0.4),
            Color(0xFF22C55E),
            Colors.white.withOpacity(0.4),
            Color(0xFF22C55E),
            Colors.white.withOpacity(0.4),
            Color(0xFF22C55E),
            Colors.white.withOpacity(0.4),
          ],
          stops: [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.repeated,
        ),
        // Border for all changes
        borderColor: Color(0xFF22C55E),
        borderWidth: 1,
      ),
      // Put OI Base (solid red bottom portion)
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
      // Put OI Change (top portion with diagonal stripe shader)
      StackedColumnSeries<OptionData, double>(
        name: 'Put OI Change',
        dataSource: optionChainData.where((d) => d.type == 'put').toList(),
        xValueMapper: (OptionData data, _) => data.strikePrice,
        yValueMapper: (OptionData data, _) => data.changeAmount,
        width: 0.7,
        spacing: 0.05,
        groupName: 'put',
        // Conditional coloring and shader for the top portion
        pointColorMapper: (OptionData data, _) {
          if (data.hasPositiveChange) {
            return Color(0xFFEF4444); // Base color for positive changes
          } else {
            return Colors.transparent; // Transparent for negative changes
          }
        },
        // Apply diagonal stripe pattern using gradient
        gradient: LinearGradient(
          colors: [
            Color(0xFFEF4444),
            Colors.white.withOpacity(0.4),
            Color(0xFFEF4444),
            Colors.white.withOpacity(0.4),
            Color(0xFFEF4444),
            Colors.white.withOpacity(0.4),
            Color(0xFFEF4444),
            Colors.white.withOpacity(0.4),
          ],
          stops: [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.repeated,
        ),
        // Border for all changes
        borderColor: Color(0xFFEF4444),
        borderWidth: 1,
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
