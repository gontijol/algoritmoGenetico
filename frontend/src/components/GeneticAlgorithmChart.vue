<template>
    <div>
        <h1>Genetic Algorithm Fitness Chart</h1>
        <GeneticAlgorithmChart :data="fitnessData" />
    </div>
</template>

<script>
import axios from "axios";
import GeneticAlgorithmChart from "./GeneticAlgorithmChart.vue";

export default {
    components: {
        GeneticAlgorithmChart,
    },
    data() {
        return {
            fitnessData: [],
        };
    },
    async created() {
        try {
            const response = await axios.get("/individuals"); // Fazer chamada à rota correta
            this.fitnessData = response.data.individuals.map(
                (individual) => individual.fitness
            );
        } catch (error) {
            console.error("Error fetching data:", error);
        }
    },
};
</script>

<style></style>
