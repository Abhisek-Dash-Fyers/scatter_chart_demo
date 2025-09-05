import 'package:flutter/material.dart';
import 'package:highcharts_flutter/highcharts.dart';
import '../../main.dart';

class StockHeatmapChart extends StatelessWidget {
  final List<StockData> stockData;

  const StockHeatmapChart({super.key, required this.stockData});

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
                        pointFormat: '''
                          <table style="background: white; border-radius: 16px; padding: 20px; box-shadow: 0 8px 32px rgba(0,0,0,0.12); border: 1px solid #e5e7eb; min-width: 280px; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; border-collapse: collapse;">
                            
                            <!-- Row 1: Company logo + name with price -->
                            <tr>
                              <td colspan="2" style="padding-bottom: 16px;">
                                <table style="width: 100%; border-collapse: collapse;">
                                  <tr>
                                    <td style="width: 50px; vertical-align: middle;">
                                      <div style="width: 40px; height: 40px; background: #f8f9fa; border-radius: 50%; display: inline-block; text-align: center; line-height: 40px; border: 1px solid #e9ecef; font-size: 12px; font-weight: bold; color: #6c757d;">
                                        {point.name}
                                      </div>
                                    </td>
                                    <td style="vertical-align: middle; padding-left: 12px;">
                                      <div style="font-weight: 600; font-size: 18px; color: #212529;">
                                        {point.name} {point.z} <span style="color: #28a745; font-size: 16px;">↗</span>
                                      </div>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            
                            <!-- Row 2: Price change and OI change side by side -->
                            <tr>
                              <td style="width: 50%; padding-right: 20px; padding-bottom: 20px; vertical-align: top;">
                                <div style="font-size: 14px; color: #6c757d; margin-bottom: 6px; font-weight: 500;">
                                  Price chg%
                                </div>
                                <div style="font-size: 16px; font-weight: 600; color: #212529;">
                                  {point.y}<span style="color: #28a745;">({point.y}%)</span>
                                </div>
                              </td>
                              <td style="width: 50%; padding-bottom: 20px; vertical-align: top;">
                                <div style="font-size: 14px; color: #6c757d; margin-bottom: 6px; font-weight: 500;">
                                  OI chg%
                                </div>
                                <div style="font-size: 16px; font-weight: 600; color: #212529;">
                                  {point.x}L<span style="color: #dc3545;">({point.x}%)</span>
                                </div>
                              </td>
                            </tr>
                            
                            <!-- Row 3: 5 Action buttons -->
                            <tr>
                              <td colspan="2">
                                <table style="width: 100%; border-collapse: collapse;">
                                  <tr>
                                    <td style="width: 20%; text-align: center;">
                                      <button style="background: #28a745; color: white; border: none; border-radius: 8px; width: 44px; height: 44px; font-weight: bold; font-size: 16px; cursor: pointer;">
                                        B
                                      </button>
                                    </td>
                                    <td style="width: 20%; text-align: center;">
                                      <button style="background: #dc3545; color: white; border: none; border-radius: 8px; width: 44px; height: 44px; font-weight: bold; font-size: 16px; cursor: pointer;">
                                        S
                                      </button>
                                    </td>
                                    <td style="width: 20%; text-align: center;">
                                      <button style="background: #f8f9fa; color: #495057; border: 1px solid #dee2e6; border-radius: 8px; width: 44px; height: 44px; cursor: pointer; font-size: 18px;">
                                        ⫿
                                      </button>
                                    </td>
                                    <td style="width: 20%; text-align: center;">
                                      <button style="background: #f8f9fa; color: #495057; border: 1px solid #dee2e6; border-radius: 8px; width: 44px; height: 44px; cursor: pointer; font-size: 18px;">
                                        ⊞
                                      </button>
                                    </td>
                                    <td style="width: 20%; text-align: center;">
                                      <button style="background: #f8f9fa; color: #495057; border: 1px solid #dee2e6; border-radius: 8px; width: 44px; height: 44px; cursor: pointer; font-size: 18px;">
                                        📈
                                      </button>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                        ''',
                      ),
                      marker: HighchartsBubbleSeriesMarkerOptions(
                        lineWidth: 2,
                        lineColor: '#ffffff',
                        fillOpacity: 0.8,
                        states: HighchartsBubbleSeriesMarkerStatesOptions(
                          hover: HighchartsBubbleSeriesMarkerStatesHoverOptions(
                            enabled: true,
                            radiusPlus: 5,
                            lineWidthPlus: 1,
                            fillColor: null,
                          ),
                        ),
                      ),
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
                              color:
                                  stock.solidColor, // Use solid color for base
                              marker: HighchartsBubbleSeriesDataMarkerOptions(
                                fillColor: stock
                                    .solidColor, // Use solid color for marker
                                lineColor: '#ffffff',
                                lineWidth: 2,
                                states: HighchartsSeriesMarkerStatesOptions(
                                  hover:
                                      HighchartsSeriesMarkerStatesHoverOptions(
                                        fillColor: stock.hoverColor,
                                        lineColor: '#ffffff',
                                        lineWidth: 3,
                                        radiusPlus: 5,
                                      ),
                                ),
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
}
