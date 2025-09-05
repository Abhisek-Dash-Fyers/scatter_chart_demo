import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../main.dart';

class SyncfusionParabolicChart extends StatefulWidget {
  final List<PayoffData> payoffData;
  final double currentPrice;
  final double maxPain;

  const SyncfusionParabolicChart({
    super.key,
    required this.payoffData,
    required this.currentPrice,
    required this.maxPain,
  });

  @override
  State<SyncfusionParabolicChart> createState() =>
      _SyncfusionParabolicChartState();
}

class _SyncfusionParabolicChartState extends State<SyncfusionParabolicChart> {
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      header: '',
      shadowColor: Colors.black26,
      elevation: 8,
      animationDuration: 200,
    );

    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      enableDoubleTapZooming: true,
    );
    super.initState();
  }

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
                        _buildLegendItem('Call', Color(0xFF4CAF50)),
                        SizedBox(width: 16),
                        _buildLegendItem('Put', Color(0xFFFF5722)),
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
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                tooltipBehavior: _tooltipBehavior,
                zoomPanBehavior: _zoomPanBehavior,
                margin: EdgeInsets.fromLTRB(40, 20, 40, 60),
                primaryXAxis: NumericAxis(
                  title: AxisTitle(
                    text: 'Strike Price',
                    textStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  minimum: 22400,
                  maximum: 26000,
                  interval: 400,
                  majorGridLines: MajorGridLines(
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  axisLine: AxisLine(width: 1, color: Colors.grey.shade300),
                  labelStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                  plotBands: [
                    // Current price line
                    PlotBand(
                      start: widget.currentPrice,
                      end: widget.currentPrice,
                      borderWidth: 2,
                      borderColor: Colors.blue.shade600,
                      dashArray: [5, 5],
                    ),
                    // Max pain line
                    PlotBand(
                      start: widget.maxPain,
                      end: widget.maxPain,
                      borderWidth: 2,
                      borderColor: Colors.orange.shade600,
                      dashArray: [5, 5],
                    ),
                  ],
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(
                    text: 'Call Frequency',
                    textStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  minimum: 0,
                  maximum: 140000,
                  interval: 20000,
                  majorGridLines: MajorGridLines(
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  axisLine: AxisLine(width: 1, color: Colors.grey.shade300),
                  labelStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                  labelFormat: '{value}',
                ),
                series: _buildSeries(),
                annotations: _buildAnnotations(),
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

  List<CartesianSeries> _buildSeries() {
    // Separate call and put data
    final callData = widget.payoffData.where((d) => d.type == 'call').toList();
    final putData = widget.payoffData.where((d) => d.type == 'put').toList();

    return [
      // Call options (green bars)
      ColumnSeries<PayoffData, double>(
        dataSource: callData,
        xValueMapper: (data, _) => data.strikePrice,
        yValueMapper: (data, _) => data.payoff,
        name: 'Call',
        color: Color(0xFF4CAF50),
        width: 0.8,
        spacing: 0.1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(2),
        ),
      ),

      // Put options (red bars, negative values)
      ColumnSeries<PayoffData, double>(
        dataSource: putData,
        xValueMapper: (data, _) => data.strikePrice,
        yValueMapper: (data, _) => -data.payoff, // Negative for downward bars
        name: 'Put',
        color: Color(0xFFFF5722),
        width: 0.8,
        spacing: 0.1,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
        ),
      ),

      // Parabolic curve overlay
      SplineSeries<PayoffData, double>(
        dataSource: _generateParabolicData(),
        xValueMapper: (data, _) => data.strikePrice,
        yValueMapper: (data, _) => data.payoff,
        name: 'Payoff Curve',
        color: Colors.purple.shade600,
        width: 3,
        splineType: SplineType.cardinal,
        cardinalSplineTension: 0.2,
      ),
    ];
  }

  List<PayoffData> _generateParabolicData() {
    List<PayoffData> parabolicData = [];

    // Generate parabolic curve data points
    for (double strike = 22400; strike <= 26000; strike += 50) {
      // Create a parabolic shape with minimum at max pain point
      double distance = (strike - widget.maxPain).abs();
      double payoff = (distance * distance) / 1000 + 20000; // Parabolic formula

      parabolicData.add(
        PayoffData(strikePrice: strike, payoff: payoff, type: 'curve'),
      );
    }

    return parabolicData;
  }

  List<CartesianChartAnnotation> _buildAnnotations() {
    return [
      // Current price annotation
      CartesianChartAnnotation(
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Current\n₹${widget.currentPrice.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        coordinateUnit: CoordinateUnit.point,
        region: AnnotationRegion.chart,
        x: widget.currentPrice,
        y: 120000,
      ),

      // Max pain annotation
      CartesianChartAnnotation(
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange.shade600,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Max Pain\n₹${widget.maxPain.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        coordinateUnit: CoordinateUnit.point,
        region: AnnotationRegion.chart,
        x: widget.maxPain,
        y: 120000,
      ),
    ];
  }
}
