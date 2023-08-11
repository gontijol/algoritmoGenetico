// import 'dart:math';

// class Individual {
//   final String chromosome;
//   late double fitness;

//   Individual(this.chromosome) {
//     fitness = calculateFitness();
//   }

//   double calculateFitness() {
//     int ki = 22; // número de bits da seção
//     String seccao1 = chromosome.substring(0, ki);
//     String seccao2 = chromosome.substring(ki);
//     double xi = calculateRealValue(seccao1);
//     double yi = calculateRealValue(seccao2);

//     double fitness = 0.5 -
//         ((pow(sin(sqrt(pow(xi, 2) + pow(yi, 2))), 2) - 0.5) /
//             pow((1 + (pow(xi, 2) + pow(yi, 2)) * 0.001), 2));

//     return fitness;
//   }

//   double calculateRealValue(String seccao) {
//     int ki = 22; // número de bits da seção
//     double real = 0;
//     int xibin = int.parse(seccao, radix: 2);
//     real = ((200 * xibin) / (pow(2, ki) - 1)) - 100;
//     return real;
//   }
// }
