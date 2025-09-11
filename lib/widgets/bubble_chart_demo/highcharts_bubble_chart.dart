import 'package:flutter/material.dart';
import 'package:highcharts_flutter/highcharts.dart';
import '../../main.dart';

class StockHeatmapChart extends StatelessWidget {
  final List<StockData> stockData;
  final Widget Function(StockData)? customTooltipBuilder;
  final bool useFlutterWidgetTooltip;

  const StockHeatmapChart({
    super.key,
    required this.stockData,
    this.customTooltipBuilder,
    this.useFlutterWidgetTooltip = false,
  });

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
            // Main chart with integrated quadrant labels
            Expanded(
              child: HighchartsChart(
                HighchartsOptions(
                  tooltip: HighchartsTooltipOptions(
                    useHTML: true,
                    backgroundColor: 'transparent',
                    borderWidth: 0,
                    hideDelay: 500,
                    distance: 30,
                    stickOnContact: true,
                  ),
                  chart: HighchartsChartOptions(
                    type: 'bubble',
                    backgroundColor: '#ffffff',
                    plotBackgroundColor: '#ffffff',
                    height: 500,
                  ),
                  title: HighchartsTitleOptions(text: ''),
                  legend: HighchartsLegendOptions(enabled: false),
                  credits: HighchartsCreditsOptions(enabled: false),

                  xAxis: [
                    HighchartsXAxisOptions(
                      title: HighchartsXAxisTitleOptions(
                        text: '% change in OI',
                        enabled: true,
                        style: HighchartsXAxisTitleStyleOptions(
                          fontSize: '11px',
                          color: '#888888',
                        ),
                        margin: 15,
                      ),
                      min: -50,
                      max: 50,
                      tickInterval: 10,
                      lineWidth: 1,
                      lineColor: '#d0d0d0',
                      gridLineWidth: 0,
                      gridLineColor: '#f0f0f0',
                      plotLines: [
                        HighchartsXAxisPlotLinesOptions(
                          value: 0,
                          color: '#666666',
                          width: 1,
                          zIndex: 3,
                        ),
                      ],
                      labels: HighchartsXAxisLabelsOptions(
                        style: HighchartsXAxisLabelsStyleOptions(
                          fontSize: '10px',
                          color: '#999999',
                        ),
                        format: '{value}%',
                      ),
                    ),
                  ],

                  yAxis: [
                    HighchartsYAxisOptions(
                      title: HighchartsYAxisTitleOptions(
                        text: '% change in price',
                        style: HighchartsXAxisTitleStyleOptions(
                          fontSize: '11px',
                          color: '#888888',
                        ),
                        margin: 15,
                      ),
                      min: -4,
                      max: 4,
                      tickInterval: 1,
                      lineWidth: 1,
                      lineColor: '#d0d0d0',
                      gridLineWidth: 0,
                      gridLineColor: '#f0f0f0',
                      plotLines: [
                        HighchartsYAxisPlotLinesOptions(
                          value: 0,
                          color: '#666666',
                          width: 1,
                          zIndex: 3,
                        ),
                      ],
                      labels: HighchartsYAxisLabelsOptions(
                        style: HighchartsXAxisLabelsStyleOptions(
                          fontSize: '10px',
                          color: '#999999',
                        ),
                        format: '{value}%',
                      ),
                    ),
                  ],

                  plotOptions: HighchartsPlotOptions(
                    bubble: HighchartsBubbleSeriesOptions(
                      minSize: 80,
                      maxSize: 80,
                      sizeBy: 'area',
                      zMin: 80,
                      zMax: 5000,
                      displayNegative: true,
                      sizeByAbsoluteValue: false,
                      opacity: 0.9,
                      dataLabels: HighchartsBubbleSeriesDataLabelsOptions(
                        enabled: true,
                        useHTML: true,
                        format:
                            '<div style="text-align: center; color: white; font-weight: bold;"><div style="width: 16px; height: 16px; background: rgba(255,255,255,0.9); border-radius: 50%; margin: 0 auto 2px; display: flex; align-items: center; justify-content: center; font-size: 8px; color: #333;">📊</div><div style="font-size: 9px; text-shadow: 1px 1px 2px rgba(0,0,0,0.8);">{point.name}</div></div>',
                        style: {
                          'fontSize': '9px',
                          'fontWeight': 'bold',
                          'color': '#ffffff',
                          'textOutline': 'none',
                        },
                      ),
                      tooltip: HighchartsBubbleSeriesTooltipOptions(
                        pointFormat: _getTooltipHTML(),
                      ),
                      // marker: HighchartsBubbleSeriesMarkerOptions(
                      //   lineWidth: 2,
                      //   // lineColor: '#ffffff',
                      //   // fillColor: ,
                      //   fillOpacity: 0.8,
                      //   states: HighchartsBubbleSeriesMarkerStatesOptions(
                      //     hover: HighchartsBubbleSeriesMarkerStatesHoverOptions(
                      //       enabled: true,
                      //       radiusPlus: 5,
                      //       lineWidthPlus: 1,
                      //       fillColor: null,
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),

                  series: [
                    // Main stock data series
                    HighchartsBubbleSeries(
                      name: 'Stocks',
                      dataPoints: stockData
                          .map(
                            (stock) => HighchartsBubbleSeriesDataOptions(
                              x: stock.oiChange,
                              y: stock.priceChange,
                              z: stock.currentPrice,
                              name: stock.symbol,
                              color: "#ffffff",
                              // color:
                              //     stock.solidColor, // Use solid color for base
                              marker: HighchartsBubbleSeriesDataMarkerOptions(
                                // fillColor:
                                //     "{'radialGradient': {'cx': 0.4, 'cy': 0.3, 'r': 0.7}, 'stops': [[0, '#801C02FF'], [1, '#8004028A']]}", // Use solid color for marker
                                // lineColor: '#ffffff',
                                lineWidth: 2,

                                // states: HighchartsSeriesMarkerStatesOptions(
                                //   hover:
                                //       HighchartsSeriesMarkerStatesHoverOptions(
                                //         fillColor: stock.hoverColor,
                                //         lineColor: '#ffffff',
                                //         lineWidth: 3,
                                //         radiusPlus: 5,
                                //       ),
                                // ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    // Quadrant labels series (using scatter with invisible markers)
                    HighchartsScatterSeries(
                      name: 'Quadrant Labels',
                      options: HighchartsScatterSeriesOptions(
                        enableMouseTracking:
                            false, // Disable mouse interactions
                        showInLegend: false, // Hide from legend
                        allowPointSelect: false, // Disable point selection
                        marker: HighchartsScatterSeriesMarkerOptions(
                          enabled: false, // Hide markers completely
                          radius: 0,
                          fillColor: 'transparent',
                          lineColor: 'transparent',
                        ),
                        dataLabels: [
                          HighchartsSeriesDataLabelsOptions(
                            enabled: true,
                            format: '{point.name}',
                            style: {
                              'fontSize': '13px',
                              'fontWeight': '500',
                              'color': '#666666',
                              'textOutline': 'none',
                              'cursor': 'default',
                            },
                            useHTML: false,
                            allowOverlap: true,
                          ),
                        ],
                        tooltip: HighchartsScatterSeriesTooltipOptions(
                          pointFormat: '', // Empty tooltip content
                        ),
                      ),
                      dataPoints: [
                        // Upper left quadrant - Long unwinding (positioned more towards corner)
                        HighchartsScatterSeriesDataOptions(
                          x: -40,
                          y: 3.5,
                          name: 'Long unwinding',
                        ),
                        // Upper right quadrant - Long buildup (positioned more towards corner)
                        HighchartsScatterSeriesDataOptions(
                          x: 40,
                          y: 3.5,
                          name: 'Long buildup',
                        ),
                        // Lower left quadrant - Short covering (positioned more towards corner)
                        HighchartsScatterSeriesDataOptions(
                          x: -40,
                          y: -3.5,
                          name: 'Short covering',
                        ),
                        // Lower right quadrant - Short buildup (positioned more towards corner)
                        HighchartsScatterSeriesDataOptions(
                          x: 40,
                          y: -3.5,
                          name: 'Short buildup',
                        ),
                      ],
                    ),
                  ],
                ),
                // Enhanced JavaScript with tooltip interactions and gradients
                javaScript: '''
                  // Global action handler
                  window.handleAction = function(action, symbol) {
                    console.log('Action triggered:', action, 'for symbol:', symbol);
                    
                    // Prevent tooltip from hiding immediately
                    if (window.highcharts_flutter && window.highcharts_flutter.chart) {
                      var chart = window.highcharts_flutter.chart;
                      var originalHide = chart.tooltip.hide;
                      chart.tooltip.hide = function() {}; // Temporarily disable hide
                      
                      setTimeout(function() {
                        chart.tooltip.hide = originalHide; // Re-enable after action
                      }, 100);
                    }
                  };
                  
                  setTimeout(function() {
                    if (window.highcharts_flutter && window.highcharts_flutter.chart) {
                      var chart = window.highcharts_flutter.chart;
                      var series = chart.series[0];
                      
                      // Apply gradients
                      if (series && series.data) {
                        series.data.forEach(function(point, index) {
                          var oiChange = point.x;
                          var priceChange = point.y;
                          var baseColor;
                          
                          if (oiChange > 0 && priceChange > 0) {
                            baseColor = '#22c55e';
                          } else if (oiChange < 0 && priceChange > 0) {
                            baseColor = '#3b82f6';
                          } else if (oiChange < 0 && priceChange < 0) {
                            baseColor = '#f97316';
                          } else {
                            baseColor = '#ef4444';
                          }
                          
                          point.update({
                            marker: {
                              fillColor: {
                                radialGradient: { cx: 0.4, cy: 0.3, r: 0.7 },
                                stops: [
                                  [0, 'rgba(255,255,255,0.5)'],
                                  [1, baseColor]
                                ]
                              },
                              lineColor: '#ffffff',
                              lineWidth: 2
                            }
                          }, false);
                        });
                        
                        chart.redraw();
                      }
                      
                      // Enhanced tooltip positioning
                      chart.update({
                        tooltip: {
                          positioner: function(labelWidth, labelHeight, point) {
                            var chart = this.chart;
                            var plotX = point.plotX + chart.plotLeft;
                            var plotY = point.plotY + chart.plotTop;
                            
                            var tooltipX = plotX + 20;
                            var tooltipY = plotY - labelHeight / 2;
                            
                            // Keep tooltip within chart bounds
                            if (tooltipX + labelWidth > chart.chartWidth) {
                              tooltipX = plotX - labelWidth - 20;
                            }
                            
                            if (tooltipY < 0) {
                              tooltipY = 10;
                            } else if (tooltipY + labelHeight > chart.chartHeight) {
                              tooltipY = chart.chartHeight - labelHeight - 10;
                            }
                            
                            return { x: tooltipX, y: tooltipY };
                          }
                        }
                      });
                      
                      // Prevent tooltip from hiding when hovering over buttons
                      document.addEventListener('mouseover', function(e) {
                        if (e.target.classList.contains('action-btn')) {
                          chart.pointer.reset = function() {};
                        }
                      });
                      
                      document.addEventListener('mouseout', function(e) {
                        if (e.target.classList.contains('action-btn')) {
                          chart.pointer.reset = Highcharts.Pointer.prototype.reset;
                        }
                      });
                    }
                  }, 100);
                ''',
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

  // Generate tooltip HTML based on configuration
  String _getTooltipHTML() {
    if (useFlutterWidgetTooltip && customTooltipBuilder != null) {
      // Use Flutter widget converter (example with first stock)
      if (stockData.isNotEmpty) {
        Widget customWidget = customTooltipBuilder!(stockData.first);
        return FlutterToHtmlConverter.convertWidget(customWidget);
      }
    }

    // Default Figma design tooltip
    return '''
      <div class="figma-tooltip">
        <style>
          .figma-tooltip {
            display: inline-flex;
            padding: 8px;
            align-items: center;
            gap: 2px;
            border-radius: 8px;
            border: 1px solid #DCE3E5;
            background: #FFF;
            box-shadow: 0 2px 8px 0 #DCE3E5;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            min-width: 280px;
            flex-direction: column;
          }
          
          .tooltip-header {
            display: flex;
            align-items: center;
            width: 100%;
            margin-bottom: 12px;
          }
          
          .company-logo {
            width: 24px;
            height: 24px;
            background: #F0F4F7;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 8px;
            font-size: 10px;
            font-weight: 600;
            color: #6B7280;
          }
          
          .company-info {
            flex: 1;
          }
          
          .company-name {
            font-size: 14px;
            font-weight: 600;
            color: #1F2937;
            margin: 0;
            line-height: 1.2;
          }
          
          .company-price {
            font-size: 14px;
            font-weight: 600;
            color: #1F2937;
            margin: 2px 0 0 0;
            display: flex;
            align-items: center;
            gap: 4px;
          }
          
          .price-arrow {
            color: #10B981;
            font-size: 12px;
          }
          
          .metrics-row {
            display: flex;
            width: 100%;
            gap: 16px;
            margin-bottom: 12px;
          }
          
          .metric-item {
            flex: 1;
          }
          
          .metric-label {
            font-size: 12px;
            color: #9CA3AF;
            margin-bottom: 2px;
            font-weight: 400;
          }
          
          .metric-value {
            font-size: 14px;
            font-weight: 600;
            color: #1F2937;
          }
          
          .metric-percentage {
            font-size: 12px;
            margin-left: 2px;
          }
          
          .positive {
            color: #10B981;
          }
          
          .negative {
            color: #EF4444;
          }
          
          .action-buttons {
            display: flex;
            width: 100%;
            gap: 8px;
          }
          
          .action-btn {
            flex: 1;
            height: 32px;
            border-radius: 6px;
            border: 1px solid #DCE3E5;
            background: #FFF;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
          }
          
          .btn-buy {
            background: #10B981;
            color: white;
            border-color: #10B981;
          }
          
          .btn-sell {
            background: #EF4444;
            color: white;
            border-color: #EF4444;
          }
          
          .btn-secondary {
            color: #6B7280;
          }
          
          .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          }
          
          .btn-buy:hover {
            background: #059669;
          }
          
          .btn-sell:hover {
            background: #DC2626;
          }
          
          .btn-secondary:hover {
            background: #F9FAFB;
          }
        </style>
        
        <div class="tooltip-header">
          <div class="company-logo">
            {point.name}
          </div>
          <div class="company-info">
            <div class="company-name">{point.name}</div>
            <div class="company-price">
              {point.z}
              <span class="price-arrow">↗</span>
            </div>
          </div>
        </div>
        
        <div class="metrics-row">
          <div class="metric-item">
            <div class="metric-label">Price chg%</div>
            <div class="metric-value">
              {point.y}<span class="metric-percentage positive">({point.y}%)</span>
            </div>
          </div>
          <div class="metric-item">
            <div class="metric-label">OI chg%</div>
            <div class="metric-value">
              {point.x}L<span class="metric-percentage negative">({point.x}%)</span>
            </div>
          </div>
        </div>
        
        <div class="action-buttons">
          <button class="action-btn btn-buy" onclick="handleAction('buy', '{point.name}'); event.stopPropagation();">B</button>
          <button class="action-btn btn-sell" onclick="handleAction('sell', '{point.name}'); event.stopPropagation();">S</button>
          <button class="action-btn btn-secondary" onclick="handleAction('watchlist', '{point.name}'); event.stopPropagation();">⫿</button>
          <button class="action-btn btn-secondary" onclick="handleAction('add', '{point.name}'); event.stopPropagation();">⊞</button>
          <button class="action-btn btn-secondary" onclick="handleAction('chart', '{point.name}'); event.stopPropagation();">📈</button>
        </div>
      </div>
    ''';
  }

  // Flutter Widget to HTML Converter System (for future use)
  // String _buildTooltipFromWidget(Widget tooltipWidget) {
  //   return FlutterToHtmlConverter.convertWidget(tooltipWidget);
  // }

  // Example usage method for custom tooltip (for future use)
  /*
  Widget _buildCustomTooltip(StockData stock) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFDCE3E5)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFDCE3E5),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(0xFFF0F4F7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    stock.symbol,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock.symbol,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          stock.currentPrice.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '↗',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Metrics
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price chg%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${stock.priceChange}(${stock.priceChange}%)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OI chg%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${stock.oiChange}L(${stock.oiChange}%)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: Size(0, 32),
                  ),
                  child: Text('B', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: Size(0, 32),
                  ),
                  child: Text('S', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF6B7280),
                    side: BorderSide(color: Color(0xFFDCE3E5)),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: Size(0, 32),
                  ),
                  child: Text('⫿', style: TextStyle(fontSize: 12)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF6B7280),
                    side: BorderSide(color: Color(0xFFDCE3E5)),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: Size(0, 32),
                  ),
                  child: Text('⊞', style: TextStyle(fontSize: 12)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF6B7280),
                    side: BorderSide(color: Color(0xFFDCE3E5)),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: Size(0, 32),
                  ),
                  child: Text('📈', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  */
}

// Flutter Widget to HTML Converter
class FlutterToHtmlConverter {
  static String convertWidget(Widget widget) {
    if (widget is Container) {
      return _convertContainer(widget);
    } else if (widget is Text) {
      return _convertText(widget);
    } else if (widget is Row) {
      return _convertRow(widget);
    } else if (widget is Column) {
      return _convertColumn(widget);
    } else if (widget is ElevatedButton) {
      return _convertElevatedButton(widget);
    } else if (widget is OutlinedButton) {
      return _convertOutlinedButton(widget);
    } else if (widget is SizedBox) {
      return _convertSizedBox(widget);
    } else if (widget is Expanded) {
      return _convertExpanded(widget);
    }
    return '<div>Unsupported widget: ${widget.runtimeType}</div>';
  }

  static String _convertContainer(Container container) {
    String styles = '';
    String classes = 'flutter-container';

    // Handle padding
    if (container.padding != null) {
      if (container.padding is EdgeInsets) {
        EdgeInsets padding = container.padding as EdgeInsets;
        styles +=
            'padding: ${padding.top}px ${padding.right}px ${padding.bottom}px ${padding.left}px;';
      }
    }

    // Handle decoration
    if (container.decoration is BoxDecoration) {
      BoxDecoration decoration = container.decoration as BoxDecoration;

      if (decoration.color != null) {
        styles += 'background-color: ${_colorToHex(decoration.color!)};';
      }

      if (decoration.borderRadius != null &&
          decoration.borderRadius is BorderRadius) {
        BorderRadius borderRadius = decoration.borderRadius as BorderRadius;
        styles += 'border-radius: ${borderRadius.topLeft.x}px;';
      }

      if (decoration.border != null && decoration.border is Border) {
        Border border = decoration.border as Border;
        if (border.top.width > 0) {
          styles +=
              'border: ${border.top.width}px solid ${_colorToHex(border.top.color)};';
        }
      }

      if (decoration.boxShadow != null && decoration.boxShadow!.isNotEmpty) {
        BoxShadow shadow = decoration.boxShadow!.first;
        styles +=
            'box-shadow: ${shadow.offset.dx}px ${shadow.offset.dy}px ${shadow.blurRadius}px ${_colorToHex(shadow.color)};';
      }
    }

    // Handle width and height
    if (container.constraints != null) {
      if (container.constraints!.maxWidth != double.infinity) {
        styles += 'max-width: ${container.constraints!.maxWidth}px;';
      }
      if (container.constraints!.maxHeight != double.infinity) {
        styles += 'max-height: ${container.constraints!.maxHeight}px;';
      }
    }

    String childHtml = '';
    if (container.child != null) {
      childHtml = convertWidget(container.child!);
    }

    return '<div class="$classes" style="$styles">$childHtml</div>';
  }

  static String _convertText(Text text) {
    String styles = '';

    if (text.style != null) {
      if (text.style!.fontSize != null) {
        styles += 'font-size: ${text.style!.fontSize}px;';
      }
      if (text.style!.color != null) {
        styles += 'color: ${_colorToHex(text.style!.color!)};';
      }
      if (text.style!.fontWeight != null) {
        int weight = _fontWeightToNumber(text.style!.fontWeight!);
        styles += 'font-weight: $weight;';
      }
    }

    return '<span style="$styles">${text.data ?? ''}</span>';
  }

  static String _convertRow(Row row) {
    String styles = 'display: flex; flex-direction: row;';

    // Handle mainAxisAlignment
    switch (row.mainAxisAlignment) {
      case MainAxisAlignment.center:
        styles += 'justify-content: center;';
        break;
      case MainAxisAlignment.spaceBetween:
        styles += 'justify-content: space-between;';
        break;
      case MainAxisAlignment.spaceAround:
        styles += 'justify-content: space-around;';
        break;
      case MainAxisAlignment.spaceEvenly:
        styles += 'justify-content: space-evenly;';
        break;
      case MainAxisAlignment.end:
        styles += 'justify-content: flex-end;';
        break;
      default:
        styles += 'justify-content: flex-start;';
    }

    // Handle crossAxisAlignment
    switch (row.crossAxisAlignment) {
      case CrossAxisAlignment.center:
        styles += 'align-items: center;';
        break;
      case CrossAxisAlignment.start:
        styles += 'align-items: flex-start;';
        break;
      case CrossAxisAlignment.end:
        styles += 'align-items: flex-end;';
        break;
      case CrossAxisAlignment.stretch:
        styles += 'align-items: stretch;';
        break;
      default:
        styles += 'align-items: flex-start;';
    }

    String childrenHtml = '';
    for (Widget child in row.children) {
      childrenHtml += convertWidget(child);
    }

    return '<div style="$styles">$childrenHtml</div>';
  }

  static String _convertColumn(Column column) {
    String styles = 'display: flex; flex-direction: column;';

    // Handle mainAxisAlignment
    switch (column.mainAxisAlignment) {
      case MainAxisAlignment.center:
        styles += 'justify-content: center;';
        break;
      case MainAxisAlignment.spaceBetween:
        styles += 'justify-content: space-between;';
        break;
      case MainAxisAlignment.spaceAround:
        styles += 'justify-content: space-around;';
        break;
      case MainAxisAlignment.spaceEvenly:
        styles += 'justify-content: space-evenly;';
        break;
      case MainAxisAlignment.end:
        styles += 'justify-content: flex-end;';
        break;
      default:
        styles += 'justify-content: flex-start;';
    }

    // Handle crossAxisAlignment
    switch (column.crossAxisAlignment) {
      case CrossAxisAlignment.center:
        styles += 'align-items: center;';
        break;
      case CrossAxisAlignment.start:
        styles += 'align-items: flex-start;';
        break;
      case CrossAxisAlignment.end:
        styles += 'align-items: flex-end;';
        break;
      case CrossAxisAlignment.stretch:
        styles += 'align-items: stretch;';
        break;
      default:
        styles += 'align-items: flex-start;';
    }

    // Handle mainAxisSize
    if (column.mainAxisSize == MainAxisSize.min) {
      styles += 'align-self: flex-start;';
    }

    String childrenHtml = '';
    for (Widget child in column.children) {
      childrenHtml += convertWidget(child);
    }

    return '<div style="$styles">$childrenHtml</div>';
  }

  static String _convertElevatedButton(ElevatedButton button) {
    String styles =
        'border: none; cursor: pointer; display: flex; align-items: center; justify-content: center;';
    String classes = 'flutter-elevated-button';

    if (button.style != null) {
      // Handle background color
      if (button.style!.backgroundColor != null) {
        Color? bgColor = button.style!.backgroundColor!.resolve({});
        if (bgColor != null) {
          styles += 'background-color: ${_colorToHex(bgColor)};';
        }
      }

      // Handle foreground color
      if (button.style!.foregroundColor != null) {
        Color? fgColor = button.style!.foregroundColor!.resolve({});
        if (fgColor != null) {
          styles += 'color: ${_colorToHex(fgColor)};';
        }
      }

      // Handle shape
      if (button.style!.shape != null) {
        OutlinedBorder? shape = button.style!.shape!.resolve({});
        if (shape is RoundedRectangleBorder) {
          styles +=
              'border-radius: ${shape.borderRadius.resolve(TextDirection.ltr).topLeft.x}px;';
        }
      }

      // Handle minimum size
      if (button.style!.minimumSize != null) {
        Size? minSize = button.style!.minimumSize!.resolve({});
        if (minSize != null) {
          if (minSize.width > 0) styles += 'min-width: ${minSize.width}px;';
          if (minSize.height > 0) styles += 'min-height: ${minSize.height}px;';
        }
      }
    }

    String childHtml = '';
    if (button.child != null) {
      childHtml = convertWidget(button.child!);
    }

    return '<button class="$classes" style="$styles" onclick="handleButtonClick(\"elevated\");">$childHtml</button>';
  }

  static String _convertOutlinedButton(OutlinedButton button) {
    String styles =
        'background: transparent; cursor: pointer; display: flex; align-items: center; justify-content: center;';
    String classes = 'flutter-outlined-button';

    if (button.style != null) {
      // Handle foreground color
      if (button.style!.foregroundColor != null) {
        Color? fgColor = button.style!.foregroundColor!.resolve({});
        if (fgColor != null) {
          styles += 'color: ${_colorToHex(fgColor)};';
        }
      }

      // Handle side (border)
      if (button.style!.side != null) {
        BorderSide? side = button.style!.side!.resolve({});
        if (side != null) {
          styles += 'border: ${side.width}px solid ${_colorToHex(side.color)};';
        }
      }

      // Handle shape
      if (button.style!.shape != null) {
        OutlinedBorder? shape = button.style!.shape!.resolve({});
        if (shape is RoundedRectangleBorder) {
          styles +=
              'border-radius: ${shape.borderRadius.resolve(TextDirection.ltr).topLeft.x}px;';
        }
      }

      // Handle minimum size
      if (button.style!.minimumSize != null) {
        Size? minSize = button.style!.minimumSize!.resolve({});
        if (minSize != null) {
          if (minSize.width > 0) styles += 'min-width: ${minSize.width}px;';
          if (minSize.height > 0) styles += 'min-height: ${minSize.height}px;';
        }
      }
    }

    String childHtml = '';
    if (button.child != null) {
      childHtml = convertWidget(button.child!);
    }

    return '<button class="$classes" style="$styles" onclick="handleButtonClick(\"outlined\");">$childHtml</button>';
  }

  static String _convertSizedBox(SizedBox sizedBox) {
    String styles = '';

    if (sizedBox.width != null) {
      styles += 'width: ${sizedBox.width}px;';
    }
    if (sizedBox.height != null) {
      styles += 'height: ${sizedBox.height}px;';
    }

    String childHtml = '';
    if (sizedBox.child != null) {
      childHtml = convertWidget(sizedBox.child!);
    }

    return '<div style="$styles">$childHtml</div>';
  }

  static String _convertExpanded(Expanded expanded) {
    String styles = 'flex: ${expanded.flex};';

    String childHtml = '';
    childHtml = convertWidget(expanded.child);

    return '<div style="$styles">$childHtml</div>';
  }

  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  static int _fontWeightToNumber(FontWeight fontWeight) {
    switch (fontWeight) {
      case FontWeight.w100:
        return 100;
      case FontWeight.w200:
        return 200;
      case FontWeight.w300:
        return 300;
      case FontWeight.w400:
        return 400;
      case FontWeight.w500:
        return 500;
      case FontWeight.w600:
        return 600;
      case FontWeight.w700:
        return 700;
      case FontWeight.w800:
        return 800;
      case FontWeight.w900:
        return 900;
      default:
        return 400;
    }
  }
}
