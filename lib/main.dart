import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';

import 'api/api.dart';

void main() async {
  final geneticAlgorithmController = GeneticAlgoritmApi();

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(
      (Request request) =>
          geneticAlgorithmController.runGeneticAlgorithm(request));

  final server = await io.serve(handler, '192.168.1.12', 8080);
  print('Server running on ${server.address}:${server.port}');
}
