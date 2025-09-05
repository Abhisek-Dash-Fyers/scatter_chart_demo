import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../main.dart';

// Custom Column Series Renderer for angled cut-off bars
class CustomParabolicColumnRenderer<T, D> extends ColumnSeriesRenderer<T, D> {
  final List<PayoffData> parabolicData;
  final double maxPain;

  CustomParabolicColumnRenderer(this.parabolicData, this.maxPain);

  @override
  ColumnSegment<T, D> createSegment() {
    return CustomParabolicColumnSegment<T, D>(parabolicData, maxPain);
  }
}

class CustomParabolicColumnSegment<T, D> extends ColumnSegment<T, D> {
  final List<PayoffData> parabolicData;
  final double maxPain;

  CustomParabolicColumnSegment(this.parabolicData, this.maxPain);

  @override
  void onPaint(Canvas canvas) {
    final Paint fillPaint = getFillPaint();
    final Paint strokePaint = getStrokePaint();
    final RRect rect = segmentRect!;

    // Get the current data point
    final double xValue = series.xValues[currentSegmentIndex].toDouble();
    final double yValue = series.yValues[currentSegmentIndex].toDouble();

    // Calculate parabolic curve value at this x position
    double parabolicY = _getParabolicValueAtX(xValue);

    // Calculate the cut-off height based on parabolic curve
    // The parabolic curve determines where to cut the bar from the top
    double barHeight = rect.outerRect.height;

    // Since we're using the actual parabolic data, the bars should be cut to match the curve
    // Calculate the ratio of parabolic value to current bar value
    double cutRatio = parabolicY / yValue;
    if (cutRatio > 1.0) cutRatio = 1.0; // Don't extend bars beyond their height

    // Calculate where to cut the bar
    double cutOffY = rect.outerRect.bottom - (barHeight * cutRatio);

    // Create angled clipping path
    Path clipPath = Path();

    // Create angled cut at the top following parabolic curve direction
    double leftCutY = cutOffY;
    double rightCutY = cutOffY;

    // Calculate angle based on position relative to max pain and neighboring points
    double angleOffset = 5.0; // Pixels for angle

    if (xValue < maxPain) {
      // Left side of max pain - angle slopes down to the right
      rightCutY = cutOffY + angleOffset;
    } else if (xValue > maxPain) {
      // Right side of max pain - angle slopes down to the left
      leftCutY = cutOffY + angleOffset;
    }
    // At max pain, keep it flat (no angle)

    // Create the clipping path with angled top
    clipPath.moveTo(rect.outerRect.left, rect.outerRect.bottom);
    clipPath.lineTo(rect.outerRect.left, leftCutY);
    clipPath.lineTo(rect.outerRect.right, rightCutY);
    clipPath.lineTo(rect.outerRect.right, rect.outerRect.bottom);
    clipPath.close();

    // Apply clipping and draw the bar
    canvas.save();
    canvas.clipPath(clipPath);

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect.outerRect,
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
        bottomLeft: Radius.circular(1),
        bottomRight: Radius.circular(1),
      ),
      fillPaint,
    );

    if (strokePaint.color != Colors.transparent) {
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect.outerRect,
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(1),
          bottomRight: Radius.circular(1),
        ),
        strokePaint,
      );
    }

    canvas.restore();
  }

  double _getParabolicValueAtX(double x) {
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
                  interval: 200, // Smaller intervals for more detail
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
                  // Let the chart auto-scale based on data
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
    // Combine all data and start from bottom (no negative values)
    final allData = [...widget.payoffData];
    final parabolicData = _generateParabolicData();

    return [
      // All bars (both Call and Put) starting from bottom with different colors
      ColumnSeries<PayoffData, double>(
        dataSource: allData,
        xValueMapper: (data, _) => data.strikePrice,
        yValueMapper: (data, _) =>
            data.payoff, // All positive values from bottom
        name: 'Options',
        // Color based on type and position
        pointColorMapper: (data, _) {
          if (data.type == 'call') {
            return Color(0xFF22C55E); // Green for calls
          } else {
            return Color(0xFFEF4444); // Red for puts
          }
        },
        width: 0.3, // Very thin bars like in Figma design
        spacing: 0.1, // Small spacing to see individual bars
        onCreateRenderer: (ChartSeries<PayoffData, double> series) {
          return CustomParabolicColumnRenderer<PayoffData, double>(
            parabolicData,
            widget.maxPain,
          );
        },
      ),

      // Parabolic curve overlay
      SplineSeries<PayoffData, double>(
        dataSource: parabolicData,
        xValueMapper: (data, _) => data.strikePrice,
        yValueMapper: (data, _) => data.payoff,
        name: 'Payoff Curve',
        color: Color(0xFF6366F1), // Blue-purple to match design
        width: 2,
        splineType: SplineType.cardinal,
        cardinalSplineTension: 0.2,
        markerSettings: MarkerSettings(isVisible: false),
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
        y: 30000, // Adjust for new parabolic scale
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
        y: 30000, // Adjust for new parabolic scale
      ),
    ];
  }
}
