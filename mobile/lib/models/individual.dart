class Individual {
  final String chromosome;
  final double fitness;
  final double xi;
  final double yi;

  Individual({
    required this.chromosome,
    required this.fitness,
    required this.xi,
    required this.yi,
  });

  factory Individual.fromJson(Map<String, dynamic> json) {
    return Individual(
      chromosome: json['chromosome'],
      fitness: json['fitness'].toDouble(),
      xi: json['x1'].toDouble(),
      yi: json['y1'].toDouble(),
    );
  }
}
