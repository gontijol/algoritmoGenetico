import 'dart:convert';
import 'package:shelf_router/shelf_router.dart';
import 'package:projetinho/controller.dart';
import 'package:projetinho/individual.dart';
import 'package:shelf/shelf.dart';

class GeneticAlgoritmApi {
  GeneticAlgorithmController? geneticAlgorithm;

  GeneticAlgorithm() {
    int populationSize = 100;
    double mutationRate = 0.008;
    int generations = 120;
    geneticAlgorithm =
        GeneticAlgorithmController(populationSize, mutationRate, generations);
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
          GeneticAlgorithmController(populationSize, mutationRate, generations);
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
