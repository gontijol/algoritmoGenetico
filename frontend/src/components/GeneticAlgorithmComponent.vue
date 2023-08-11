<template>
    <div>
        <h1>Algoritmo Genético</h1>
        <p>Status: {{ status }}</p>
        <button @click="fetchVariables">Obter Variáveis</button>
        <button @click="fetchIndividuals">Obter Indivíduos</button>
        <button @click="fetchBestIndividual">
            Obter Melhor Indivíduo Global
        </button>
        <button @click="updateVariables">Atualizar Variáveis</button>

        <div v-if="variables">
            <h2>Variáveis do Algoritmo</h2>
            <p>Population Size: {{ variables.populationSize }}</p>
            <p>Mutation Rate: {{ variables.mutationRate }}</p>
            <p>Generations: {{ variables.generations }}</p>
        </div>

        <div v-if="individuals.length > 0">
            <h2>Indivíduos</h2>
            <ul>
                <li
                    v-for="individual in individuals"
                    :key="individual.chromosome"
                >
                    Chromosome: {{ individual.chromosome }}<br />
                    Fitness: {{ individual.fitness }}<br />
                    X1: {{ individual.x1 }}<br />
                    Y1: {{ individual.y1 }}<br />
                </li>
            </ul>
        </div>

        <div v-if="bestIndividual">
            <h2>Melhor Indivíduo Global</h2>
            <p>Chromosome: {{ bestIndividual.chromosome }}</p>
            <p>Fitness: {{ bestIndividual.fitness }}</p>
            <p>X1: {{ bestIndividual.x1 }}</p>
            <p>Y1: {{ bestIndividual.y1 }}</p>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            status: "",
            variables: null,
            individuals: [],
            bestIndividual: null,
        };
    },
    methods: {
        async fetchStatus() {
            const response = await fetch("http://18.188.214.10:8080/status");
            const data = await response.json();
            this.status = data.status;
        },
        async fetchVariables() {
            const response = await fetch(
                "http://18.188.214.10:8080/get-variables"
            );
            const data = await response.json();
            this.variables = data;
        },
        async fetchIndividuals() {
            const response = await fetch(
                "http://18.188.214.10:8080/individuals"
            );
            const data = await response.json();
            this.individuals = data.individuals;
        },
        async fetchBestIndividual() {
            const response = await fetch(
                "http://18.188.214.10:8080/best-global-individual"
            );
            const data = await response.json();
            this.bestIndividual = data.bestGlobalIndividual;
        },
        async updateVariables() {
            const newVariables = {
                populationSize: 150,
                mutationRate: 0.01,
                generations: 200,
            };
            const response = await fetch(
                "http://18.188.214.10:8080/set-variables",
                {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify(newVariables),
                }
            );
            const data = await response.json();
            console.log(data.message);
        },
    },
    mounted() {
        this.fetchStatus();
    },
};
</script>

<style scoped>
/* Estilos específicos para o componente */
</style>
