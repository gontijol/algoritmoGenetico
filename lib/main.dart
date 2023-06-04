import 'dart:math';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

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
  final int populationSize;
  final double mutationRate;
  final int generations;
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

Response runGeneticAlgorithm(Request request) {
  int populationSize = 100;
  double mutationRate = 0.008;
  int generations = 10000;

  GeneticAlgorithm geneticAlgorithm =
      GeneticAlgorithm(populationSize, mutationRate, generations);
  geneticAlgorithm.runGeneticAlgorithm();

  final responseJson = {
    'message': 'Genetic algorithm executed successfully',
    'bestIndividualChromosome':
        geneticAlgorithm.bestGlobalIndividual!.chromosome,
    'bestIndividualFitness': geneticAlgorithm.bestGlobalIndividual!.fitness,
  };

  return Response.ok(jsonEncode(responseJson),
      headers: {'content-type': 'application/json'});
}

void main() async {
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(runGeneticAlgorithm);

  final server = await io.serve(handler, 'localhost', 5432);
  print('Server listening on ${server.address.host}:${server.port}');
}
