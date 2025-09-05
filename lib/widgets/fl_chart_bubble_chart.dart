import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui' as ui;
import '../main.dart';

class StockHeatmapChart extends StatefulWidget {
  final List<StockData> stockData;

  const StockHeatmapChart({super.key, required this.stockData});

  @override
  State<StockHeatmapChart> createState() => _StockHeatmapChartState();
}

class _StockHeatmapChartState extends State<StockHeatmapChart> {
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
            // Main chart with fl_chart
            Expanded(
              child: Stack(
                children: [
                  // Main scatter chart
                  ScatterChart(
                    ScatterChartData(
                      minX: -50,
                      maxX: 50,
                      minY: -4,
                      maxY: 4,
                      backgroundColor: Colors.white,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        drawHorizontalLine: true,
                        verticalInterval: 10,
                        horizontalInterval: 1,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: value == 0
                                ? Colors.black87
                                : Colors.transparent,
                            strokeWidth: value == 0 ? 1.5 : 0,
                          );
                        },
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: value == 0
                                ? Colors.black87
                                : Colors.transparent,
                            strokeWidth: value == 0 ? 1.5 : 0,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: false, // No border as per design
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text(
                                  '${value.toInt()}%',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          ),
                          axisNameWidget: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Transform.rotate(
                              angle: -1.5708, // -90 degrees in radians
                              child: Text(
                                '% change in price',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          axisNameSize: 25,
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 10,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  '${value.toInt()}%',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          ),
                          axisNameWidget: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              '% change in OI',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          axisNameSize: 25,
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      scatterSpots: widget.stockData
                          .map(
                            (stock) => ScatterSpot(
                              stock.oiChange,
                              stock.priceChange,
                              dotPainter: GradientBubblePainter(stock),
                            ),
                          )
                          .toList(),
                      scatterTouchData: ScatterTouchData(
                        enabled: true,
                        touchCallback:
                            (
                              FlTouchEvent event,
                              ScatterTouchResponse? touchResponse,
                            ) {
                              // Handle touch events if needed
                            },
                        touchTooltipData: ScatterTouchTooltipData(
                          getTooltipItems: (ScatterSpot touchedSpot) {
                            final stock = widget.stockData.firstWhere(
                              (s) =>
                                  s.oiChange == touchedSpot.x &&
                                  s.priceChange == touchedSpot.y,
                            );
                            return ScatterTooltipItem(
                              _buildTooltipContent(stock),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.black87,
                              ),
                              textAlign: TextAlign.left,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Quadrant labels
                  Positioned(
                    left: 50,
                    top: 50,
                    child: Text(
                      'Short covering',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 50,
                    top: 50,
                    child: Text(
                      'Long buildup',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    bottom: 100,
                    child: Text(
                      'Long unwinding',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 50,
                    bottom: 100,
                    child: Text(
                      'Short buildup',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
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

  String _buildTooltipContent(StockData stock) {
    return '''${stock.symbol} ${stock.currentPrice.toStringAsFixed(2)} ↗

Price chg%: ${stock.priceChange.toStringAsFixed(1)}(${stock.priceChange >= 0 ? '+' : ''}${stock.priceChange.toStringAsFixed(1)}%)
OI chg%: ${stock.oiChange.abs().toStringAsFixed(2)}L(${stock.oiChange >= 0 ? '+' : ''}${stock.oiChange.toStringAsFixed(2)}%)

[B] [S] [⫿] [⊞] [📈]''';
  }
}

// Custom dot painter for gradient bubbles with images and text
class GradientBubblePainter extends FlDotPainter {
  final StockData stock;
  ui.Image? _image;

  GradientBubblePainter(this.stock) {
    _loadImage();
  }

  // Load image from URL
  void _loadImage() async {
    try {
      final NetworkImage networkImage = NetworkImage(stock.imageUrl);
      final ImageStream stream = networkImage.resolve(ImageConfiguration.empty);
      stream.addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          _image = info.image;
        }),
      );
    } catch (e) {
      // If image loading fails, _image remains null and we'll use fallback
    }
  }

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    // Draw gradient bubble
    final paint = Paint()
      ..shader = RadialGradient(
        colors: stock.gradientColors,
        stops: [0.0, 0.4, 0.7, 1.0],
        center: Alignment.topLeft,
      ).createShader(Rect.fromCircle(center: offsetInCanvas, radius: 40));

    // Draw bubble circle
    canvas.drawCircle(offsetInCanvas, 40, paint);

    // Draw subtle white border
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(offsetInCanvas, 40, borderPaint);

    // Draw image container (white circle with subtle border)
    final imagePaint = Paint()..color = Colors.white.withValues(alpha: 0.95);
    canvas.drawCircle(
      Offset(offsetInCanvas.dx, offsetInCanvas.dy - 6),
      10,
      imagePaint,
    );

    // Draw image border
    final imageBorderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawCircle(
      Offset(offsetInCanvas.dx, offsetInCanvas.dy - 6),
      10,
      imageBorderPaint,
    );

    // Draw company logo (actual image or fallback)
    if (_image != null) {
      // Draw actual loaded image
      final imageRect = Rect.fromCenter(
        center: Offset(offsetInCanvas.dx, offsetInCanvas.dy - 6),
        width: 16,
        height: 16,
      );
      canvas.drawImageRect(
        _image!,
        Rect.fromLTWH(
          0,
          0,
          _image!.width.toDouble(),
          _image!.height.toDouble(),
        ),
        imageRect,
        Paint(),
      );
    } else {
      // Fallback: Draw company initials
      final logoPainter = TextPainter(
        text: TextSpan(
          text: stock.symbol.length >= 2
              ? stock.symbol.substring(0, 2)
              : stock.symbol,
          style: TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      logoPainter.layout();
      logoPainter.paint(
        canvas,
        Offset(
          offsetInCanvas.dx - logoPainter.width / 2,
          offsetInCanvas.dy - 10,
        ),
      );
    }

    // Draw text (stock symbol) below image
    final textPainter = TextPainter(
      text: TextSpan(
        text: stock.symbol,
        style: TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.7),
              offset: Offset(0.5, 0.5),
              blurRadius: 1,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(offsetInCanvas.dx - textPainter.width / 2, offsetInCanvas.dy + 15),
    );
  }

  @override
  Size getSize(FlSpot spot) {
    return Size(80, 80); // Fixed bubble size
  }

  @override
  Color get mainColor => stock.gradientColors.first;

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    return this; // Simple implementation
  }

  @override
  List<Object?> get props => [stock.symbol, stock.oiChange, stock.priceChange];
}
