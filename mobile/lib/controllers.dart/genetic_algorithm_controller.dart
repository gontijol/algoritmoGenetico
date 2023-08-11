import 'package:get/get.dart';
import 'package:mobilega/models/individual.dart';
import 'package:mobilega/services/api_service.dart';

class GeneticAlgorithmController extends GetxController {
  final ApiService _apiService = ApiService();
  final individuals = <Individual>[].obs;
  final bestGlobalIndividual = Rxn<Individual>();

  @override
  void onInit() {
    super.onInit();
    fetchIndividuals();
    fetchBestGlobalIndividual();
  }

  Future<void> fetchIndividuals() async {
    try {
      final fetchedIndividuals = await _apiService.getIndividuals();
      individuals.value = fetchedIndividuals;
    } catch (e) {
      print('Error fetching individuals: $e');
    }
  }

  Future<void> fetchBestGlobalIndividual() async {
    try {
      final fetchedBestGlobalIndividual =
          await _apiService.getBestGlobalIndividual();
      bestGlobalIndividual.value = fetchedBestGlobalIndividual;
    } catch (e) {
      print('Error fetching best global individual: $e');
    }
  }
}
