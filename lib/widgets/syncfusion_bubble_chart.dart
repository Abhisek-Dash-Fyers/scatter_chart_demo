import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../main.dart';

class BubbleChartPage extends StatefulWidget {
  final List<StockData> stockData;

  const BubbleChartPage({super.key, required this.stockData});

  @override
  State<BubbleChartPage> createState() => _BubbleChartPageState();
}

class _BubbleChartPageState extends State<BubbleChartPage> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      duration: 10000,
      enable: true,
      canShowMarker: false,
      header: '',
      shadowColor: Colors.black26,
      elevation: 8,
      animationDuration: 200,
      builder:
          (
            dynamic data,
            dynamic point,
            dynamic series,
            int pointIndex,
            int seriesIndex,
          ) {
            final StockData stock = data as StockData;
            return CustomSyncfusionTooltip(stock: stock);
          },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Syncfusion Bubble Chart")),
      body: SfCartesianChart(
        plotAreaBorderWidth: 1,
        title: const ChartTitle(text: 'OI vs Price Change'),
        tooltipBehavior: _tooltipBehavior,
        primaryXAxis: NumericAxis(
          title: AxisTitle(text: '% Change in OI'),
          minimum: -50,
          maximum: 50,
          majorGridLines: const MajorGridLines(width: 0),
          plotBands: [
            PlotBand(
              start: 0,
              end: 0,
              borderWidth: 2,
              borderColor: Colors.black,
            ),
          ],
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: '% Change in Price'),
          minimum: -4,
          maximum: 4,
          majorGridLines: const MajorGridLines(width: 0),
          plotBands: [
            PlotBand(
              start: 0,
              end: 0,
              borderWidth: 2,
              borderColor: Colors.black,
            ),
          ],
        ),
        series: _buildBubbleSeries(),
      ),
    );
  }

  // Build separate bubble series for each quadrant with individual gradients
  List<BubbleSeries<StockData, double>> _buildBubbleSeries() {
    // Filter data by quadrant
    final longBuildupData = widget.stockData
        .where((stock) => stock.quadrant == 'long_buildup')
        .toList();
    final longUnwindingData = widget.stockData
        .where((stock) => stock.quadrant == 'long_unwinding')
        .toList();
    final shortCoveringData = widget.stockData
        .where((stock) => stock.quadrant == 'short_covering')
        .toList();
    final shortBuildupData = widget.stockData
        .where((stock) => stock.quadrant == 'short_buildup')
        .toList();

    return [
      // Long Buildup Series (Upper Right - Dark Green Gradient)
      if (longBuildupData.isNotEmpty)
        _createBubbleSeries(
          longBuildupData,
          LinearGradient(
            colors: [
              Color(0xFF1B5E20),
              Color(0xFF2E7D32),
              Color(0xFF4CAF50),
              Color(0xFF81C784),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

      // Long Unwinding Series (Upper Left - Light Green Gradient)
      if (longUnwindingData.isNotEmpty)
        _createBubbleSeries(
          longUnwindingData,
          LinearGradient(
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF66BB6A),
              Color(0xFF81C784),
              Color(0xFFC8E6C9),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

      // Short Covering Series (Lower Left - Orange Gradient)
      if (shortCoveringData.isNotEmpty)
        _createBubbleSeries(
          shortCoveringData,
          LinearGradient(
            colors: [
              Color(0xFFFF7043),
              Color(0xFFFFAB91),
              Color(0xFFFFCCBC),
              Color(0xFFFFF3E0),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

      // Short Buildup Series (Lower Right - Red Gradient)
      if (shortBuildupData.isNotEmpty)
        _createBubbleSeries(
          shortBuildupData,
          LinearGradient(
            colors: [
              Color(0xFFB71C1C),
              Color(0xFFD32F2F),
              Color(0xFFF44336),
              Color(0xFFFF7043),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
    ];
  }

  // Create a bubble series with gradient
  BubbleSeries<StockData, double> _createBubbleSeries(
    List<StockData> data,
    LinearGradient gradient,
  ) {
    return BubbleSeries<StockData, double>(
      dataSource: data,
      xValueMapper: (d, _) => d.oiChange,
      yValueMapper: (d, _) => d.priceChange,
      sizeValueMapper: (d, _) => 80,
      minimumRadius: 20,
      maximumRadius: 20,
      // Apply gradient to entire series
      gradient: gradient,
      // Set opacity for better visibility
      opacity: 0.9,
      // Add border for better definition
      borderColor: Colors.white,
      borderWidth: 2,
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        labelAlignment: ChartDataLabelAlignment.middle,
        builder:
            (
              dynamic data,
              dynamic point,
              dynamic series,
              int pointIndex,
              int seriesIndex,
            ) {
              final StockData stock = data as StockData;
              return SizedBox(
                width: 70,
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Company logo container
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          stock.imageUrl,
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback: Show company initials
                            return Center(
                              child: Text(
                                stock.symbol.length >= 2
                                    ? stock.symbol.substring(0, 2)
                                    : stock.symbol,
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    // Company symbol text
                    Text(
                      stock.symbol,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            offset: Offset(0.5, 0.5),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
      ),
    );
  }
}

// Custom Syncfusion Tooltip Widget matching Figma design
class CustomSyncfusionTooltip extends StatelessWidget {
  final StockData stock;

  const CustomSyncfusionTooltip({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Company logo + name with price
          Row(
            children: [
              // Company logo
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFE9ECEF)),
                ),
                child: Center(
                  child: Text(
                    stock.symbol.length >= 2
                        ? stock.symbol.substring(0, 2)
                        : stock.symbol,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Company name and price
              Expanded(
                child: Text(
                  '${stock.symbol} ${stock.currentPrice.toStringAsFixed(2)} ↗',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212529),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Row 2: Price change and OI change side by side
          Row(
            children: [
              // Price change
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price chg%',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6C757D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: stock.priceChange.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF212529),
                            ),
                          ),
                          TextSpan(
                            text:
                                '(${stock.priceChange >= 0 ? '+' : ''}${stock.priceChange.toStringAsFixed(1)}%)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: stock.priceChange >= 0
                                  ? Color(0xFF28A745)
                                  : Color(0xFFDC3545),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              // OI change
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OI chg%',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6C757D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${stock.oiChange.abs().toStringAsFixed(2)}L',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF212529),
                            ),
                          ),
                          TextSpan(
                            text:
                                '(${stock.oiChange >= 0 ? '+' : ''}${stock.oiChange.toStringAsFixed(2)}%)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: stock.oiChange >= 0
                                  ? Color(0xFF28A745)
                                  : Color(0xFFDC3545),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Row 3: 5 Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Buy button
              _buildActionButton('B', Color(0xFF28A745), Colors.white),
              // Sell button
              _buildActionButton('S', Color(0xFFDC3545), Colors.white),
              // Chart button
              _buildActionButton(
                '⫿',
                Color(0xFFF8F9FA),
                Color(0xFF495057),
                borderColor: Color(0xFFDEE2E6),
              ),
              // Portfolio button
              _buildActionButton(
                '⊞',
                Color(0xFFF8F9FA),
                Color(0xFF495057),
                borderColor: Color(0xFFDEE2E6),
              ),
              // Trend button
              _buildActionButton(
                '📈',
                Color(0xFFF8F9FA),
                Color(0xFF495057),
                borderColor: Color(0xFFDEE2E6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color backgroundColor,
    Color textColor, {
    Color? borderColor,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: text == 'B' || text == 'S' ? 16 : 18,
            fontWeight: text == 'B' || text == 'S'
                ? FontWeight.bold
                : FontWeight.normal,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
