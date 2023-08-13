<template>
    <div>
        <h1>Genetic Algorithm Individuals</h1>
        <div v-if="bestIndividual">
            <p>Best Individual: {{ bestIndividual.chromosome }}</p>
            <button @click="showFitnessChart">Show Fitness Chart</button>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            bestIndividual: null,
        };
    },
    mounted() {
        this.fetchBestIndividual();
    },
    methods: {
        async fetchBestIndividual() {
            try {
                const response = await this.$axios.get(
                    "192.168.1.15:8080/individuals"
                );
                this.bestIndividual = response.data.bestGlobalIndividual;
            } catch (error) {
                console.error("Error fetching best individual:", error);
            }
        },
        showFitnessChart() {
            // Implementar lógica para mostrar o gráfico de fitness aqui
        },
    },
};
</script>
