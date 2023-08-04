import 'dart:math';

import 'package:projetinho/individual.dart';

class GeneticAlgorithmController {
  int populationSize;
  double mutationRate;
  int generations;
  List<Individual> population;
  Individual? bestGlobalIndividual;

  GeneticAlgorithmController(
      this.populationSize, this.mutationRate, this.generations)
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
