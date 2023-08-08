import 'dart:math';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

class Individual {
  final String chromosome;
  late double fitness;

  Individual(this.chromosome) {
    fitness = calculateFitness();
  }

  double calculateFitness() {
    int ki = 22; // número de bits da seção
    String seccao1 = chromosome.substring(0, ki);
    String seccao2 = chromosome.substring(ki);
    double xi = calculateRealValue(seccao1);
    double yi = calculateRealValue(seccao2);

    double fitness = 0.5 -
        ((pow(sin(sqrt(pow(xi, 2) + pow(yi, 2))), 2) - 0.5) /
            pow((1 + (pow(xi, 2) + pow(yi, 2)) * 0.001), 2));

    return fitness;
  }

  double calculateRealValue(String seccao) {
    int ki = 22; // número de bits da seção
    double real = 0;
    int xibin = int.parse(seccao, radix: 2);
    real = ((200 * xibin) / (pow(2, ki) - 1)) - 100;
    return real;
  }
}

class GeneticAlgorithm {
  int populationSize;
  double mutationRate;
  int generations;
  List<Individual> population;
  Individual? bestGlobalIndividual;

  GeneticAlgorithm(this.populationSize, this.mutationRate, this.generations)
      : population = [],
        bestGlobalIndividual = null {
    initializePopulation();
  }

  void initializePopulation() {
    for (int i = 0; i < populationSize; i++) {
      String chromosome = generateRandomChromosome();
      population.add(Individual(chromosome));
    }
  }

  String generateRandomChromosome() {
    String chromosome = '';
    for (int i = 0; i < 44; i++) {
      chromosome += (Random().nextBool()) ? '1' : '0';
    }
    return chromosome;
  }

  void runGeneticAlgorithm() {
    for (int i = 0; i < generations; i++) {
      selectBestIndividuals();
      replicateBestIndividuals();
      crossover();
      mutate();
      printBestIndividualOfGeneration(i + 1);
    }

    print(
        'Best Global Individual: Chromosome: ${bestGlobalIndividual!.chromosome} Fitness: ${bestGlobalIndividual!.fitness}');
  }

  void selectBestIndividuals() {
    population.sort((a, b) => b.fitness.compareTo(a.fitness));
    int halfPopulationSize = (populationSize ~/ 2).toInt();
    int endIndex = min(halfPopulationSize, population.length);
    population = population.sublist(0, endIndex);
    updateBestGlobalIndividual(population.first);
  }

  void updateBestGlobalIndividual(Individual individual) {
    if (bestGlobalIndividual == null ||
        individual.fitness > bestGlobalIndividual!.fitness) {
      bestGlobalIndividual = individual;
    }
  }

  void replicateBestIndividuals() {
    int populationSizeDiff = populationSize - population.length;
    for (int i = 0; i < populationSizeDiff; i++) {
      Individual individual = population[i % population.length];
      population.add(Individual(individual.chromosome));
    }
  }

  void crossover() {
    List<Individual> offspring = [];
    for (int i = 0; i < population.length - 1; i += 2) {
      Individual parent1 = population[i];
      Individual parent2 = population[i + 1];
      String offspringChromosome = parent1.chromosome.substring(0, 22) +
          parent2.chromosome.substring(22);
      offspring.add(Individual(offspringChromosome));
    }
    population = offspring;
  }

  void mutate() {
    List<Individual> mutatedPopulation = [];
    for (Individual individual in population) {
      String mutatedChromosome = '';
      for (int i = 0; i < individual.chromosome.length; i++) {
        double randomValue = Random().nextDouble();
        if (randomValue <= mutationRate) {
          String bit = individual.chromosome[i];
          mutatedChromosome += (bit == '0') ? '1' : '0';
        } else {
          mutatedChromosome += individual.chromosome[i];
        }
      }
      mutatedPopulation.add(Individual(mutatedChromosome));
    }
    population = mutatedPopulation;
  }

  void printBestIndividualOfGeneration(int generation) {
    Individual bestIndividual = population.first;
    String seccao1 = bestIndividual.chromosome.substring(0, 22);
    String seccao2 = bestIndividual.chromosome.substring(22);
    double xi = bestIndividual.calculateRealValue(seccao1);
    double yi = bestIndividual.calculateRealValue(seccao2);
    String metadeSeccao1 = seccao1.substring(0, seccao1.length ~/ 2);
    String metadeSeccao2 = seccao2.substring(0, seccao2.length ~/ 2);
    print(
        'Generation $generation: Best Individual - Chromosome: ${bestIndividual.chromosome.substring(0, 22)}...${bestIndividual.chromosome.substring(22)} Fitness: ${bestIndividual.fitness} xi: $xi (Half: $metadeSeccao1) yi: $yi (Half: $metadeSeccao2)');
  }
}

class GeneticAlgorithmController {
  GeneticAlgorithm? geneticAlgorithm;

  GeneticAlgorithmController() {
    int populationSize = 100;
    double mutationRate = 0.008;
    int generations = 120;
    geneticAlgorithm =
        GeneticAlgorithm(populationSize, mutationRate, generations);
  }

  Response getAllIndividuals(Request request) {
    List<Map<String, dynamic>> individualsData = [];
    for (Individual individual in geneticAlgorithm!.population) {
      String chromosome = individual.chromosome;
      double fitness = individual.fitness;
      String seccao1 = chromosome.substring(0, 22);
      String seccao2 = chromosome.substring(22);
      double xi = individual.calculateRealValue(seccao1);
      double yi = individual.calculateRealValue(seccao2);

      Map<String, dynamic> individualData = {
        'chromosome': chromosome,
        'fitness': fitness,
        'x1': xi,
        'y1': yi,
      };

      individualsData.add(individualData);
    }

    final responseJson = {
      'individuals': individualsData,
    };

    return Response.ok(jsonEncode(responseJson),
        headers: {'content-type': 'application/json'});
  }

  Response getBestGlobalIndividual(Request request) {
    Individual? bestGlobalIndividual = geneticAlgorithm!.bestGlobalIndividual;

    if (bestGlobalIndividual != null) {
      String chromosome = bestGlobalIndividual.chromosome;
      double fitness = bestGlobalIndividual.fitness;
      String seccao1 = chromosome.substring(0, 22);
      String seccao2 = chromosome.substring(22);
      double xi = bestGlobalIndividual.calculateRealValue(seccao1);
      double yi = bestGlobalIndividual.calculateRealValue(seccao2);

      Map<String, dynamic> individualData = {
        'chromosome': chromosome,
        'fitness': fitness,
        'x1': xi,
        'y1': yi,
      };

      final responseJson = {'bestGlobalIndividual': individualData};

      return Response.ok(jsonEncode(responseJson),
          headers: {'content-type': 'application/json'});
    } else {
      final responseJson = {'bestGlobalIndividual': null};

      return Response.ok(jsonEncode(responseJson),
          headers: {'content-type': 'application/json'});
    }
  }

  runGeneticAlgorithm(Request request) {
    int populationSize = 100;
    double mutationRate = 0.008;
    int generations = 10000;

    geneticAlgorithm!.populationSize = populationSize;
    geneticAlgorithm!.mutationRate = mutationRate;
    geneticAlgorithm!.generations = generations;
    geneticAlgorithm!.runGeneticAlgorithm();

    final router = createRouter();
    final cascade = Cascade().add(router);
    final handler = cascade.handler;

    return handler(request);
  }

  Future<Response> setVariables(Request request) async {
    final body = await request.readAsString();
    final jsonData = jsonDecode(body);

    int? populationSize = jsonData['populationSize'];
    double? mutationRate = jsonData['mutationRate'];
    int? generations = jsonData['generations'];

    if (populationSize != null && mutationRate != null && generations != null) {
      geneticAlgorithm =
          GeneticAlgorithm(populationSize, mutationRate, generations);
      final responseJson = {
        'message': 'Variables updated successfully',
      };
      return Response.ok(jsonEncode(responseJson),
          headers: {'content-type': 'application/json'});
    } else {
      final responseJson = {
        'message': 'Invalid variables',
      };
      return Response.badRequest(
          body: jsonEncode(responseJson),
          headers: {'content-type': 'application/json'});
    }
  }

  Response getVariables(Request request) {
    int? populationSize = geneticAlgorithm!.populationSize;
    double? mutationRate = geneticAlgorithm!.mutationRate;
    int? generations = geneticAlgorithm!.generations;

    if (mutationRate != null) {
      final responseJson = {
        'populationSize': populationSize,
        'mutationRate': mutationRate,
        'generations': generations,
      };
      return Response.ok(jsonEncode(responseJson),
          headers: {'content-type': 'application/json'});
    } else {
      final responseJson = {
        'message': 'Genetic algorithm has not been initialized',
      };
      return Response.badRequest(
          body: jsonEncode(responseJson),
          headers: {'content-type': 'application/json'});
    }
  }

  Router createRouter() {
    final router = Router();
    router.get('/status', (Request request) => getStatus(request));
    router.get('/individuals', getAllIndividuals);
    router.get('/best-global-individual', getBestGlobalIndividual);
    router.post('/set-variables', setVariables);
    router.get('/get-variables', getVariables);
    return router;
  }

  Response getStatus(Request request) {
    final responseJson = {'status': 'API is running'};
    return Response.ok(jsonEncode(responseJson),
        headers: {'content-type': 'application/json'});
  }
}

void main() async {
  final geneticAlgorithmController = GeneticAlgorithmController();

  final router = geneticAlgorithmController.createRouter();

  // Rota para obter o status (não executa o algoritmo genético)
  router.get('/status',
      (Request request) => geneticAlgorithmController.getStatus(request));

  // Rota para obter todos os indivíduos (não executa o algoritmo genético)
  router.get(
      '/individuals',
      (Request request) =>
          geneticAlgorithmController.getAllIndividuals(request));

  // Rota para obter o melhor indivíduo global (não executa o algoritmo genético)
  router.get(
      '/best-global-individual',
      (Request request) =>
          geneticAlgorithmController.getBestGlobalIndividual(request));

  // Rota para atualizar as variáveis do algoritmo genético (não executa o algoritmo genético)
  router.post('/set-variables',
      (Request request) => geneticAlgorithmController.setVariables(request));

  // Rota para obter as variáveis do algoritmo genético (não executa o algoritmo genético)
  router.get('/get-variables',
      (Request request) => geneticAlgorithmController.getVariables(request));

  // Crie o handler usando o router
  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(router);

  final server = await io.serve(handler, '192.168.1.15', 8080);
  print('Server running on ${server.address}:${server.port}');
}
//http://18.188.214.10:8080/ -- servidor da amazon -- https publico
//http://172.31.14.197:8080/ -- servidor da amazon local ipv4 -- http privado