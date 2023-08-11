import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphPage extends GetView<GraphController> {
  const GraphPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(GraphController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'Algorítmo Genético'),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    elevation: 10,
                    color: Colors.black,
                  ),
                  series: <ChartSeries<IndividualData, String>>[
                    BubbleSeries<IndividualData, String>(
                      legendIconType: LegendIconType.circle,
                      yValueMapper: (datum, index) =>
                          double.parse(datum.fitness.toStringAsFixed(5)),
                      // highValueMapper: (datum, index) => datum.y1,
                      animationDuration: 2,
                      gradient: const LinearGradient(colors: [
                        Colors.tealAccent,
                        Colors.blue,
                      ]),
                      // lowValueMapper: (datum, index) => datum.y1,
                      sizeValueMapper: (datum, index) =>
                          double.parse(datum.x1.toStringAsFixed(5)),
                      color: Colors.tealAccent,
                      opacity: 0.5,
                      animationDelay: 2,
                      xValueMapper: (IndividualData data, _) =>
                          data.fitness.toString(),
                      dataSource: controller.data.toList(),
                      name: 'Fitness',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                    ),
                    // BubbleSeries<IndividualData, String>(
                    //     yValueMapper: (datum, index) =>
                    //         double.parse(datum.fitness.toStringAsFixed(5)),
                    //     color: Colors.purpleAccent,
                    //     // highValueMapper: (datum, index) => datum.y1,

                    //     // lowValueMapper: (datum, index) => datum.y1,
                    //     sizeValueMapper: (datum, index) =>
                    //         double.parse(datum.y1.toStringAsFixed(5)),
                    //     opacity: 0.3,
                    //     animationDelay: 2,
                    //     xValueMapper: (IndividualData data, _) =>
                    //         data.fitness.toString(),
                    //     dataSource: controller.data.toList(),
                    //     name: 'Y1',
                    //     // Enable data label
                    //     dataLabelSettings:
                    //         const DataLabelSettings(isVisible: true)),
                    // BubbleSeries<IndividualData, String>(
                    //     animationDelay: 5,
                    //     xValueMapper: (IndividualData data, _) =>
                    //         data.fitness.toString(),
                    //     dataSource: controller.data.toList(),
                    //     yValueMapper: (IndividualData data, _) => data.y1,
                    //     name: 'X1',
                    //     // Enable data label
                    //     dataLabelSettings:
                    //         const DataLabelSettings(isVisible: true)),
                    // BubbleSeries<IndividualData, String>(
                    //     animationDelay: 5,
                    //     xValueMapper: (IndividualData data, _) =>
                    //         data.x1.toString(),
                    //     dataSource: controller.data.toList(),
                    //     yValueMapper: (IndividualData data, _) =>
                    //         data.fitness,
                    //     name: 'X1',
                    //     // Enable data label
                    //     dataLabelSettings:
                    //         const DataLabelSettings(isVisible: true)),
                  ],
                );

                // return charts.ScatterPlotChart(
                //   [
                //     charts.Series<IndividualData, double>(
                //       id: 'Fitness',
                //       domainFn: (IndividualData data, _) => data.x1,
                //       measureFn: (IndividualData data, _) => data.fitness,
                //       colorFn: (IndividualData data, _) =>
                //           charts.ColorUtil.fromDartColor(
                //               Colors.red), // Cor para y1
                //       data: controller.data.toList(),
                //     ),
                //     charts.Series<IndividualData, double>(
                //       id: 'Fitness',
                //       domainFn: (IndividualData data, _) => data.y1,
                //       measureFn: (IndividualData data, _) => data.fitness,
                //       colorFn: (IndividualData data, _) =>
                //           charts.ColorUtil.fromDartColor(
                //               Colors.blue), // Cor para x1
                //       data: controller.data.toList(),
                //     ),
                //   ],
                //   animate: true,
                //   behaviors: [
                //     charts.ChartTitle(
                //       'X1',
                //       behaviorPosition: charts.BehaviorPosition.bottom,
                //     ),
                //     charts.ChartTitle(
                //       'Y1',
                //       behaviorPosition: charts.BehaviorPosition.start,
                //     ),
                //   ],
                // );
              }),
            ),
            const SizedBox(height: 16.0),
            Obx(() {
              if (controller.data.isEmpty) {
                return const SizedBox.shrink();
              } else {
                final populationSize = controller.populationSize.value;
                final mutationRate = controller.mutationRate.value;
                final generations = controller.generations.value;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Maior Fitness Global: ${controller.maiorGlobalFitness.value}'),
                    Text('Population Size: $populationSize'),
                    Text('Mutation Rate: $mutationRate'),
                    Text('Generations: $generations'),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class GraphController extends GetxController {
  final data = <IndividualData>[].obs;
  final dataStatus = <IndividualData>[].obs;
  final populationSize = 0.obs;
  final mutationRate = 0.0.obs;
  final generations = 0.obs;
  final maiorGlobalFitness = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const apiUrl = 'http://18.188.214.10:8080';

    final response = await http.get(
      Uri.parse('$apiUrl/individuals'),
      headers: {'Content-Type': 'application/json'},
    );
    final response2 = await http.get(
      Uri.parse('$apiUrl/get-variables'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response2.statusCode == 200) {
      final jsonResponse = jsonDecode(response2.body);
      populationSize.value = jsonResponse['populationSize'];
      mutationRate.value = jsonResponse['mutationRate'];
      generations.value = jsonResponse['generations'];
    }

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> individuals = jsonResponse['individuals'];

      print(response.body);

      final List<IndividualData> fetchedData = individuals.map((item) {
        final String chromosome = item['chromosome'];
        final double fitness = item['fitness'];
        final double x1 = item['x1'];
        final double y1 = item['y1'];

        return IndividualData(chromosome, fitness, x1, y1);
      }).toList();

      data.assignAll(fetchedData);
      // populationSize.value = jsonResponse['populationSize'];
      // mutationRate.value = jsonResponse['mutationRate'];
      // generations.value = jsonResponse['generations'];
      //// Encontrar o maior valor de fitness
      double maxFitness = findMaxFitness(fetchedData);
      maiorGlobalFitness.value = maxFitness;
    }
  }

  double findMaxFitness(List<IndividualData> data) {
    double maxFitness = double.negativeInfinity;

    for (var individual in data) {
      if (individual.fitness > maxFitness) {
        maxFitness = individual.fitness;
      }
    }

    return maxFitness;
  }
}

class IndividualData {
  final String chromosome;
  final double fitness;
  final double x1;
  final double y1;

  IndividualData(this.chromosome, this.fitness, this.x1, this.y1);
}
