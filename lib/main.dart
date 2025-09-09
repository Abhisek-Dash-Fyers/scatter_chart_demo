import 'package:flutter/material.dart';
import 'widgets/bubble_chart_demo/highcharts_bubble_chart.dart' as highcharts;
import 'widgets/bubble_chart_demo/fl_chart_bubble_chart.dart' as fl_chart;
import 'widgets/bubble_chart_demo/syncfusion_bubble_chart.dart' as syncfusion;
import 'widgets/parabolic_chart_demo/syncfusion_parabolic_chart.dart'
    as syncfusion_parabolic;
import 'widgets/parabolic_chart_demo/highcharts_parabolic_chart.dart'
    as highcharts_parabolic;

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
  final double currentPrice; // Current stock price

  StockData({
    required this.symbol,
    required this.oiChange,
    required this.priceChange,
    required this.marketCap,
    required this.imageUrl,
    required this.currentPrice,
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
        return '''   {
     'radialGradient': {'cx': 0.4, 'cy': 0.3, 'r': 0.7},
     'stops': [
       [0, 'rgba(28,2,255,0.5)'],  // White center with 50% opacity
       [1, 'rgba(4,2,138,0.5)']                  // Quadrant color at edges
     ]
   }''';
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

// Data model for parabolic chart
class PayoffData {
  final double strikePrice;
  final double payoff;
  final String type; // 'call' or 'put'

  PayoffData({
    required this.strikePrice,
    required this.payoff,
    required this.type,
  });
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
  int _selectedBottomNavIndex = 0;

  // Centralized stock data - single source of truth
  final List<StockData> stockData = [
    // Upper left quadrant (Long unwinding - negative OI, positive price)
    StockData(
      symbol: 'UNION',
      oiChange: -40,
      priceChange: 3.2,
      marketCap: 50,
      imageUrl: 'https://logo.clearbit.com/unionbank.com',
      currentPrice: 125.45,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: -30,
      priceChange: 2.8,
      marketCap: 45,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),
    StockData(
      symbol: 'PAYTM',
      oiChange: -35,
      priceChange: 2.1,
      marketCap: 40,
      imageUrl: 'https://logo.clearbit.com/paytm.com',
      currentPrice: 900.95,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: -25,
      priceChange: 1.8,
      marketCap: 42,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),
    StockData(
      symbol: 'PAYTM',
      oiChange: -15,
      priceChange: 1.2,
      marketCap: 38,
      imageUrl: 'https://logo.clearbit.com/paytm.com',
      currentPrice: 900.95,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: -10,
      priceChange: 0.8,
      marketCap: 35,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),

    // Upper right quadrant (Long buildup - positive OI, positive price)
    StockData(
      symbol: 'TORRENT',
      oiChange: 45,
      priceChange: 3.5,
      marketCap: 55,
      imageUrl: 'https://logo.clearbit.com/torrentpower.com',
      currentPrice: 1450.75,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 35,
      priceChange: 2.6,
      marketCap: 48,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 25,
      priceChange: 2.2,
      marketCap: 46,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),
    StockData(
      symbol: 'HIMAT',
      oiChange: 15,
      priceChange: 1.8,
      marketCap: 40,
      imageUrl: 'https://logo.clearbit.com/himatsyngka.com',
      currentPrice: 320.85,
    ),
    StockData(
      symbol: 'AIA',
      oiChange: 20,
      priceChange: 1.4,
      marketCap: 42,
      imageUrl: 'https://logo.clearbit.com/aia.com',
      currentPrice: 85.60,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 40,
      priceChange: 1.1,
      marketCap: 44,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 30,
      priceChange: 0.9,
      marketCap: 41,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),

    // Lower left quadrant (Short covering - negative OI, negative price)
    StockData(
      symbol: 'AIA',
      oiChange: -45,
      priceChange: -1.2,
      marketCap: 38,
      imageUrl: 'https://logo.clearbit.com/aia.com',
      currentPrice: 85.60,
    ),
    StockData(
      symbol: 'HIMAT',
      oiChange: -35,
      priceChange: -1.8,
      marketCap: 40,
      imageUrl: 'https://logo.clearbit.com/himatsyngka.com',
      currentPrice: 320.85,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: -25,
      priceChange: -2.8,
      marketCap: 45,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),
    StockData(
      symbol: 'HIMAT',
      oiChange: -15,
      priceChange: -2.2,
      marketCap: 42,
      imageUrl: 'https://logo.clearbit.com/himatsyngka.com',
      currentPrice: 320.85,
    ),
    StockData(
      symbol: 'L&T',
      oiChange: -10,
      priceChange: -1.5,
      marketCap: 39,
      imageUrl: 'https://logo.clearbit.com/larsentoubro.com',
      currentPrice: 3650.25,
    ),
    StockData(
      symbol: 'TORRENT',
      oiChange: -20,
      priceChange: -2.9,
      marketCap: 43,
      imageUrl: 'https://logo.clearbit.com/torrentpower.com',
      currentPrice: 1450.75,
    ),

    // Lower right quadrant (Short buildup - positive OI, negative price)
    StockData(
      symbol: 'HIMAT',
      oiChange: 15,
      priceChange: -1.1,
      marketCap: 38,
      imageUrl: 'https://logo.clearbit.com/himatsyngka.com',
      currentPrice: 320.85,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 25,
      priceChange: -2.1,
      marketCap: 44,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),
    StockData(
      symbol: 'TORRENT',
      oiChange: 35,
      priceChange: -2.6,
      marketCap: 48,
      imageUrl: 'https://logo.clearbit.com/torrentpower.com',
      currentPrice: 1450.75,
    ),
    StockData(
      symbol: 'AIA',
      oiChange: 45,
      priceChange: -2.9,
      marketCap: 42,
      imageUrl: 'https://logo.clearbit.com/aia.com',
      currentPrice: 85.60,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 20,
      priceChange: -1.8,
      marketCap: 40,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),
    StockData(
      symbol: 'TORRENT',
      oiChange: 10,
      priceChange: -2.8,
      marketCap: 46,
      imageUrl: 'https://logo.clearbit.com/torrentpower.com',
      currentPrice: 1450.75,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 40,
      priceChange: -1.5,
      marketCap: 44,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),
    StockData(
      symbol: 'ABB',
      oiChange: 50,
      priceChange: -3.2,
      marketCap: 47,
      imageUrl: 'https://logo.clearbit.com/abb.com',
      currentPrice: 4250.30,
    ),
  ];

  // Generate proper parabolic data that matches the Figma design
  List<PayoffData> _generateParabolicPayoffData() {
    List<PayoffData> data = [];

    // Create many more data points for smoother parabolic curve (every 25 points)
    for (double strike = 22400; strike <= 26000; strike += 25) {
      // Calculate distance from max pain point (24600)
      double distance = (strike - maxPain).abs();

      // Create parabolic formula: y = a(x - h)² + k
      // Where h = maxPain (24600), k = minimum value (around 5000)
      double minValue = 5000;
      double a = 0.015; // Controls the steepness of parabola
      double payoff = (a * distance * distance) + minValue;

      // Determine type based on position relative to current price
      String type = strike < currentPrice ? 'put' : 'call';

      data.add(PayoffData(strikePrice: strike, payoff: payoff, type: type));
    }

    return data;
  }

  // Use the generated parabolic data
  late final List<PayoffData> payoffData = _generateParabolicPayoffData();

  final double currentPrice = 25354.15;
  final double maxPain = 24600.0;

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
        title: Text(
          _selectedBottomNavIndex == 0 ? 'Bubble Charts' : 'Parabolic Charts',
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: _selectedBottomNavIndex == 0
            ? TabBar(
                controller: _tabController,
                labelColor: Colors.blue.shade700,
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: Colors.blue.shade700,
                tabs: [
                  Tab(text: 'Highcharts'),
                  Tab(text: 'FL Chart'),
                  Tab(text: 'Syncfusion'),
                ],
              )
            : TabBar(
                controller: _tabController,
                labelColor: Colors.blue.shade700,
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: Colors.blue.shade700,
                tabs: [
                  Tab(text: 'Syncfusion'),
                  Tab(text: 'Highcharts'),
                  Tab(text: 'Comparison'),
                ],
              ),
      ),
      body: _selectedBottomNavIndex == 0
          ? TabBarView(
              controller: _tabController,
              children: [
                highcharts.StockHeatmapChart(stockData: stockData),
                fl_chart.StockHeatmapChart(stockData: stockData),
                syncfusion.BubbleChartPage(stockData: stockData),
              ],
            )
          : TabBarView(
              controller: _tabController,
              children: [
                syncfusion_parabolic.SyncfusionParabolicChart(
                  payoffData: payoffData,
                  currentPrice: currentPrice,
                  maxPain: maxPain,
                ),
                highcharts_parabolic.HighchartsParabolicChart(
                  payoffData: payoffData,
                  currentPrice: currentPrice,
                  maxPain: maxPain,
                ),
                // Comparison view showing both charts side by side
                Row(
                  children: [
                    Expanded(
                      child: syncfusion_parabolic.SyncfusionParabolicChart(
                        payoffData: payoffData,
                        currentPrice: currentPrice,
                        maxPain: maxPain,
                      ),
                    ),
                    Expanded(
                      child: highcharts_parabolic.HighchartsParabolicChart(
                        payoffData: payoffData,
                        currentPrice: currentPrice,
                        maxPain: maxPain,
                      ),
                    ),
                  ],
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            label: 'Bubble Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Parabolic Charts',
          ),
        ],
      ),
    );
  }
}
