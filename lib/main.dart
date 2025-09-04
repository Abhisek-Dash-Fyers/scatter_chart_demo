import 'package:flutter/material.dart';
import 'widgets/highcharts_bubble_chart.dart' as highcharts;
import 'widgets/fl_chart_bubble_chart.dart' as fl_chart;
import 'widgets/syncfusion_bubble_chart.dart' as syncfusion;

void main() {
  runApp(MaterialApp(home: ChartDemoApp()));
}

// Centralized StockData model
class StockData {
  final String symbol;
  final double oiChange; // x-axis
  final double priceChange; // y-axis
  final double marketCap; // for bubble radius
  final String imageUrl; // URL for company logo

  StockData({
    required this.symbol,
    required this.oiChange,
    required this.priceChange,
    required this.marketCap,
    required this.imageUrl,
  });

  // Get quadrant based on position
  String get quadrant {
    if (oiChange >= 0 && priceChange >= 0) return 'long_buildup';
    if (oiChange < 0 && priceChange >= 0) return 'long_unwinding';
    if (oiChange < 0 && priceChange < 0) return 'short_covering';
    return 'short_buildup'; // oiChange >= 0 && priceChange < 0
  }

  // Get CSS gradient color based on quadrant and intensity (simplified for Highcharts compatibility)
  String get gradientColor {
    // For now, return the primary color from each gradient as Highcharts may not support CSS gradients directly
    return solidColor;
  }

  // Get solid color based on quadrant only (ignoring intensity)
  String get solidColor {
    switch (quadrant) {
      case 'long_buildup': // Upper right - Dark green
        return '#1B5E20';
      case 'long_unwinding': // Upper left - Light green
        return '#4CAF50';
      case 'short_covering': // Lower left - Light orange
        return '#FF7043';
      case 'short_buildup': // Lower right - Dark red
        return '#B71C1C';
      default:
        return '#9E9E9E';
    }
  }

  // Get hover color (slightly brighter)
  String get hoverColor {
    switch (quadrant) {
      case 'long_buildup':
        return '#4CAF50'; // Brighter green
      case 'long_unwinding':
        return '#81C784'; // Brighter light green
      case 'short_covering':
        return '#FFAB91'; // Brighter orange
      case 'short_buildup':
        return '#F44336'; // Brighter red
      default:
        return '#BDBDBD';
    }
  }

  // Get bubble size based on market cap with better scaling
  double get bubbleSize {
    return (marketCap * 0.8).clamp(25.0, 45.0);
  }

  // Get simplified gradient for each quadrant (ignoring intensity)
  String get quadrantGradient {
    switch (quadrant) {
      case 'long_buildup': // Upper right - Dark green gradient
        return 'radial-gradient(circle, #1B5E20 0%, #2E7D32 40%, #4CAF50 70%, #81C784 100%)';
      case 'long_unwinding': // Upper left - Light green gradient
        return 'radial-gradient(circle, #4CAF50 0%, #66BB6A 40%, #81C784 70%, #C8E6C9 100%)';
      case 'short_covering': // Lower left - Orange gradient
        return 'radial-gradient(circle, #FF7043 0%, #FFAB91 40%, #FFCCBC 70%, #FFF3E0 100%)';
      case 'short_buildup': // Lower right - Red gradient
        return 'radial-gradient(circle, #B71C1C 0%, #D32F2F 40%, #F44336 70%, #FF7043 100%)';
      default:
        return 'radial-gradient(circle, #9E9E9E 0%, #E0E0E0 100%)';
    }
  }

  // Get gradient colors for FL Chart
  List<Color> get gradientColors {
    switch (quadrant) {
      case 'long_buildup': // Upper right - Dark green gradient
        return [
          Color(0xFF1B5E20),
          Color(0xFF2E7D32),
          Color(0xFF4CAF50),
          Color(0xFF81C784),
        ];
      case 'long_unwinding': // Upper left - Light green gradient
        return [
          Color(0xFF4CAF50),
          Color(0xFF66BB6A),
          Color(0xFF81C784),
          Color(0xFFC8E6C9),
        ];
      case 'short_covering': // Lower left - Orange gradient
        return [
          Color(0xFFFF7043),
          Color(0xFFFFAB91),
          Color(0xFFFFCCBC),
          Color(0xFFFFF3E0),
        ];
      case 'short_buildup': // Lower right - Red gradient
        return [
          Color(0xFFB71C1C),
          Color(0xFFD32F2F),
          Color(0xFFF44336),
          Color(0xFFFF7043),
        ];
      default:
        return [Color(0xFF9E9E9E), Color(0xFFE0E0E0)];
    }
  }

  // Get solid color for fallback (Flutter Color)
  Color get quadrantColor {
    switch (quadrant) {
      case 'long_buildup':
        return Color(0xFF1B5E20);
      case 'long_unwinding':
        return Color(0xFF4CAF50);
      case 'short_covering':
        return Color(0xFFFF7043);
      case 'short_buildup':
        return Color(0xFFB71C1C);
      default:
        return Color(0xFF9E9E9E);
    }
  }

  // Helper to get Syncfusion gradient
  LinearGradient getSyncfusionGradient() {
    if (oiChange >= 0 && priceChange >= 0) {
      // Long buildup (upper right) - Dark green gradient
      return const LinearGradient(
        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (oiChange < 0 && priceChange >= 0) {
      // Long unwinding (upper left) - Light green gradient
      return const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF66BB6A), Color(0xFF81C784)],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (oiChange < 0 && priceChange < 0) {
      // Short covering (lower left) - Light red/orange gradient
      return const LinearGradient(
        colors: [Color(0xFFFF7043), Color(0xFFFF8A65), Color(0xFFFFAB91)],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      // Short buildup (lower right) - Dark red gradient
      return const LinearGradient(
        colors: [Color(0xFFB71C1C), Color(0xFFD32F2F), Color(0xFFE57373)],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }
}

// Main app with TabController
class ChartDemoApp extends StatefulWidget {
  const ChartDemoApp({super.key});

  @override
  State<ChartDemoApp> createState() => _ChartDemoAppState();
}

class _ChartDemoAppState extends State<ChartDemoApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Centralized stock data - single source of truth
  final List<StockData> stockData = [
    // Upper left quadrant (Long unwinding - negative OI, positive price)
    StockData(
      symbol: 'UNION',
      oiChange: -40,
      priceChange: 3.2,
      marketCap: 50,
      imageUrl: 'https://logo.clearbit.com/unionbank.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: -30,
      priceChange: 2.8,
      marketCap: 45,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),
    StockData(
      symbol: 'PAYTM',
      oiChange: -35,
      priceChange: 2.1,
      marketCap: 40,
      imageUrl: 'https://logo.clearbit.com/paytm.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: -25,
      priceChange: 1.8,
      marketCap: 42,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),
    StockData(
      symbol: 'PAYTM',
      oiChange: -15,
      priceChange: 1.2,
      marketCap: 38,
      imageUrl: 'https://logo.clearbit.com/paytm.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: -10,
      priceChange: 0.8,
      marketCap: 35,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),

    // Upper right quadrant (Long buildup - positive OI, positive price)
    StockData(
      symbol: 'TORRENT',
      oiChange: 45,
      priceChange: 3.5,
      marketCap: 55,
      imageUrl: 'https://logo.clearbit.com/torrentpower.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 35,
      priceChange: 2.6,
      marketCap: 48,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 25,
      priceChange: 2.2,
      marketCap: 46,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),
    StockData(
      symbol: 'HIMAT',
      oiChange: 15,
      priceChange: 1.8,
      marketCap: 40,
      imageUrl: 'https://logo.clearbit.com/himatsyngka.com',
    ),
    StockData(
      symbol: 'AIA',
      oiChange: 20,
      priceChange: 1.4,
      marketCap: 42,
      imageUrl: 'https://logo.clearbit.com/aia.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 40,
      priceChange: 1.1,
      marketCap: 44,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 30,
      priceChange: 0.9,
      marketCap: 41,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),

    // Lower left quadrant (Short covering - negative OI, negative price)
    StockData(
      symbol: 'AIA',
      oiChange: -45,
      priceChange: -1.2,
      marketCap: 38,
      imageUrl: 'https://logo.clearbit.com/aia.com',
    ),
    StockData(
      symbol: 'HIMAT',
      oiChange: -35,
      priceChange: -1.8,
      marketCap: 40,
      imageUrl: 'https://logo.clearbit.com/himatsyngka.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: -25,
      priceChange: -2.8,
      marketCap: 45,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),
    StockData(
      symbol: 'HIMAT',
      oiChange: -15,
      priceChange: -2.2,
      marketCap: 42,
      imageUrl: 'https://logo.clearbit.com/himatsyngka.com',
    ),
    StockData(
      symbol: 'L&T',
      oiChange: -10,
      priceChange: -1.5,
      marketCap: 39,
      imageUrl: 'https://logo.clearbit.com/larsentoubro.com',
    ),
    StockData(
      symbol: 'TORRENT',
      oiChange: -20,
      priceChange: -2.9,
      marketCap: 43,
      imageUrl: 'https://logo.clearbit.com/torrentpower.com',
    ),

    // Lower right quadrant (Short buildup - positive OI, negative price)
    StockData(
      symbol: 'HIMAT',
      oiChange: 15,
      priceChange: -1.1,
      marketCap: 38,
      imageUrl: 'https://logo.clearbit.com/himatsyngka.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 25,
      priceChange: -2.1,
      marketCap: 44,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),
    StockData(
      symbol: 'TORRENT',
      oiChange: 35,
      priceChange: -2.6,
      marketCap: 48,
      imageUrl: 'https://logo.clearbit.com/torrentpower.com',
    ),
    StockData(
      symbol: 'AIA',
      oiChange: 45,
      priceChange: -2.9,
      marketCap: 42,
      imageUrl: 'https://logo.clearbit.com/aia.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 20,
      priceChange: -1.8,
      marketCap: 40,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),
    StockData(
      symbol: 'TORRENT',
      oiChange: 10,
      priceChange: -2.8,
      marketCap: 46,
      imageUrl: 'https://logo.clearbit.com/torrentpower.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 40,
      priceChange: -1.5,
      marketCap: 44,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 50,
      priceChange: -3.2,
      marketCap: 47,
      imageUrl: 'https://logo.clearbit.com/abb.com',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chart Library Comparison'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue.shade700,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: Colors.blue.shade700,
          tabs: [
            Tab(text: 'Highcharts'),
            Tab(text: 'FL Chart'),
            Tab(text: 'Syncfusion'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          highcharts.StockHeatmapChart(stockData: stockData),
          fl_chart.StockHeatmapChart(stockData: stockData),
          syncfusion.BubbleChartPage(stockData: stockData),
        ],
      ),
    );
  }
}
