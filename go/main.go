package main

import (
	"encoding/json"
	"fmt"
	"math"
	"math/rand"
	"net/http"
	"strconv"
	"time"
)

type Individual struct {
	Chromosome string  `json:"chromosome"`
	Fitness    float64 `json:"fitness"`
}

func NewIndividual(chromosome string) *Individual {
	individual := &Individual{Chromosome: chromosome}
	individual.CalculateFitness()
	return individual
}

func (ind *Individual) CalculateFitness() {
	ki := 22
	seccao1 := ind.Chromosome[:ki]
	seccao2 := ind.Chromosome[ki:]
	xi := calculateRealValue(seccao1)
	yi := calculateRealValue(seccao2)

	ind.Fitness = 0.5 - ((math.Pow(math.Sin(math.Sqrt(math.Pow(xi, 2)+math.Pow(yi, 2))), 2)-0.5)/math.Pow((1+(math.Pow(xi, 2)+math.Pow(yi, 2))*0.001), 2))
}

func calculateRealValue(seccao string) float64 {
	ki := 22
	var real float64
	xibin := binaryStringToInt(seccao)
	real = (200*float64(xibin))/(math.Pow(2, float64(ki))-1) - 100
	return real
}

func binaryStringToInt(binary string) int {
	val, _ := strconv.ParseInt(binary, 2, 64)
	return int(val)
}

type GeneticAlgorithm struct {
	PopulationSize       int
	MutationRate         float64
	Generations          int
	Population           []*Individual
	BestGlobalIndividual *Individual
}

func NewGeneticAlgorithm(populationSize int, mutationRate float64, generations int) *GeneticAlgorithm {
	ga := &GeneticAlgorithm{
		PopulationSize: populationSize,
		MutationRate:   mutationRate,
		Generations:    generations,
		Population:     []*Individual{},
	}
	ga.InitializePopulation()
	return ga
}

func (ga *GeneticAlgorithm) InitializePopulation() {
	for i := 0; i < ga.PopulationSize; i++ {
		chromosome := generateRandomChromosome()
		individual := NewIndividual(chromosome)
		ga.Population = append(ga.Population, individual)
	}
}

func generateRandomChromosome() string {
	chromosome := ""
	for i := 0; i < 44; i++ {
		if rand.Intn(2) == 0 {
			chromosome += "0"
		} else {
			chromosome += "1"
		}
	}
	return chromosome
}

func main() {
	rand.Seed(time.Now().UnixNano())

	populationSize := 100
	mutationRate := 0.008
	generations := 120

	geneticAlgorithm := NewGeneticAlgorithm(populationSize, mutationRate, generations)

	http.HandleFunc("/go/status", func(w http.ResponseWriter, r *http.Request) {
		response := map[string]string{"status": "API is running"}
		writeJSONResponse(w, response)
	})

	http.HandleFunc("/go/individuals", func(w http.ResponseWriter, r *http.Request) {
		individualsData := make([]map[string]interface{}, 0)
		for _, individual := range geneticAlgorithm.Population {
			chromosome := individual.Chromosome
			fitness := individual.Fitness
			seccao1 := chromosome[:22]
			seccao2 := chromosome[22:]
			xi := calculateRealValue(seccao1)
			yi := calculateRealValue(seccao2)

			individualData := map[string]interface{}{
				"chromosome": chromosome,
				"fitness":    fitness,
				"x1":         xi,
				"y1":         yi,
			}

			individualsData = append(individualsData, individualData)
		}

		response := map[string]interface{}{
			"individuals": individualsData,
		}

		writeJSONResponse(w, response)
	})

	http.HandleFunc("/go/best-global-individual", func(w http.ResponseWriter, r *http.Request) {
		geneticAlgorithm.RunGeneticAlgorithm()

		bestGlobalIndividual := geneticAlgorithm.BestGlobalIndividual
		if bestGlobalIndividual != nil {
			chromosome := bestGlobalIndividual.Chromosome
			fitness := bestGlobalIndividual.Fitness
			seccao1 := chromosome[:22]
			seccao2 := chromosome[22:]
			xi := calculateRealValue(seccao1)
			yi := calculateRealValue(seccao2)

			individualData := map[string]interface{}{
				"chromosome": chromosome,
				"fitness":    fitness,
				"x1":         xi,
				"y1":         yi,
			}

			response := map[string]interface{}{
				"bestGlobalIndividual": individualData,
			}

			writeJSONResponse(w, response)
		} else {
			response := map[string]interface{}{
				"bestGlobalIndividual": nil,
			}

			writeJSONResponse(w, response)
		}
	})

	// ... Define other handlers for set-variables and get-variables

	serverAddr := "localhost:8080"
	fmt.Printf("Server running on %s\n", serverAddr)
	http.ListenAndServe(serverAddr, nil)
}

func writeJSONResponse(w http.ResponseWriter, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(data)
}

func (ga *GeneticAlgorithm) RunGeneticAlgorithm() {
	// ... Implement the rest of the algorithm
}
