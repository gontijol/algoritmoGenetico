<template>
    <div id="app">
        <nav>
            <button @click="showComponent('status')">API Status</button>
            <button @click="showComponent('individuals')">Individuals</button>
            <button @click="showComponent('variables')">Variables</button>
        </nav>

        <div v-if="currentComponent === 'status'">
            <ApiStatus />
        </div>
        <div v-if="currentComponent === 'individuals'">
            <GeneticAlgorithmIndividuals />
        </div>
        <div v-if="currentComponent === 'variables'">
            <GeneticAlgorithmVariables />
        </div>
    </div>
</template>

<script>
import ApiStatus from "./components/Status.vue";
import GeneticAlgorithmIndividuals from "./components/Individuals.vue";
import GeneticAlgorithmVariables from "./components/Variables.vue";

export default {
    name: "App",
    components: {
        ApiStatus,
        GeneticAlgorithmIndividuals,
        GeneticAlgorithmVariables,
    },
    data() {
        return {
            currentComponent: "",
        };
    },
    methods: {
        showComponent(componentName) {
            this.currentComponent = componentName;
        },
    },
};
</script>

<style>
/* Estilos */
</style>
