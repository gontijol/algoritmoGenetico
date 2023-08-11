import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobilega/models/individual.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.3:8080';

  Future<List<Individual>> getIndividuals() async {
    final response = await http.get(Uri.parse('$baseUrl/individuals'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Individual> individuals = [];
      for (var individualData in data['individuals']) {
        individuals.add(Individual.fromJson(individualData));
      }
      return individuals;
    } else {
      throw Exception('Failed to load individuals');
    }
  }

  Future<Individual?> getBestGlobalIndividual() async {
    final response =
        await http.get(Uri.parse('$baseUrl/best-global-individual'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['bestGlobalIndividual'] != null) {
        return Individual.fromJson(data['bestGlobalIndividual']);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load best global individual');
    }
  }
}
