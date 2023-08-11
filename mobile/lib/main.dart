import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobilega/graph_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends GetView {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(GeneticAlgorithmController());

    return GetMaterialApp(
      title: 'Genetic Algorithm App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: AppBindings(),
      getPages: AppPages.pages,
      home: HomePage(),
    );
  }
}

class HomePage extends GetView {
  @override
  final GeneticAlgorithmController controller = Get.find();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genetic Algorithm'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Set Variables',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Population Size'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          controller.populationSize.value = int.parse(value),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Mutation Rate'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          controller.mutationRate.value = double.parse(value),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Generations'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          controller.generations.value = int.parse(value),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.setVariables();
                      },
                      child: const Text('Set'),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => controller.getStatus(),
              child: const Text('Show Status'),
            ),
            Obx(() => Text(controller.status.value)),
            const Divider(),
            Container(
              color: Colors.white,
              width: Get.width * 1,
              height: 400,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        controller.runGeneticAlgorithm();
                      },
                      child: const Text('Run Genetic Algorithm'),
                    ),
                  ),
                  Obx(
                    () => controller.loading.value
                        ? const CircularProgressIndicator()
                        : controller.bestGlobalIndividual.value.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Best Global Individual: ${controller.bestGlobalIndividual.value}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              )
                            : Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      clipBehavior: Clip.hardEdge,
                      onPressed: () {
                        Get.snackbar('Funcionalidade Desabilitada',
                            'Desabilitado provisóriamente');
                      },
                      child: const Text('Run Best Global'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        elevation: 10,
                        shadowColor: Colors.black,
                      ),
                      onPressed: () {
                        Get.toNamed('/graph');
                      },
                      child: const Text('Show Graph'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GeneticAlgorithmController extends GetxController {
  final populationSize = 100.obs;
  final mutationRate = 0.008.obs;
  final status = 'Sem status'.obs;
  final generations = 10000.obs;
  final loading = false.obs;
  final bestGlobalIndividual = ''.obs;
  final apiUrl = 'http://18.188.214.10:8080';

  Future<void> runBestGlobal() async {
    loading.value = true;

    final response = await http.get(
      Uri.parse('$apiUrl/best-global-individual'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['bestGlobalIndividual'] != null) {
        bestGlobalIndividual.value = jsonResponse['bestGlobalIndividual'];
      } else {
        bestGlobalIndividual.value = '';
      }
    } else {
      bestGlobalIndividual.value = '';
    }

    loading.value = false;
  }

  Future<void> runGeneticAlgorithm() async {
    loading.value = true;
    final response = await http.get(
      Uri.parse('$apiUrl/individuals'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['bestGlobalIndividual'] != null) {
        bestGlobalIndividual.value = jsonResponse['bestGlobalIndividual'];
      } else {
        bestGlobalIndividual.value = '';
      }
    } else {
      bestGlobalIndividual.value = '';
    }

    loading.value = false;
  }

  Future<void> getStatus() async {
    loading.value = true;

    final response = await http.get(
      Uri.parse('$apiUrl/status'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      status.value = 'Status: ${response.body}';
    }
  }

  Future<void> setVariables() async {
    final response = await http.post(
      Uri.parse('$apiUrl/set-variables'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'populationSize': populationSize.value,
          'mutationRate': mutationRate.value,
          'generations': generations.value,
        },
      ),
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Variables Set',
        'Variables updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to set variables',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class GenerationData {
  final int generation;
  final double fitness;

  GenerationData(this.generation, this.fitness);
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<GeneticAlgorithmController>(GeneticAlgorithmController());
  }
}

class AppPages {
  static final pages = [
    GetPage(name: '/', page: () => HomePage(), binding: AppBindings()),
    GetPage(
        name: '/graph', page: () => const GraphPage(), binding: AppBindings()),
  ];
}
