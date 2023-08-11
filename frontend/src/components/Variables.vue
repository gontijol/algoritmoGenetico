<template>
    <div>
        <h1>Genetic Algorithm Variables</h1>
        <div>
            <label>Population Size:</label>
            <input v-model="populationSize" type="number" />
        </div>
        <div>
            <label>Mutation Rate:</label>
            <input v-model="mutationRate" type="number" step="0.001" />
        </div>
        <div>
            <label>Generations:</label>
            <input v-model="generations" type="number" />
        </div>
        <button @click="setVariables">Set Variables</button>
        <button @click="fetchVariables">Get Variables</button>
        <div v-if="variables">
            <p>Population Size: {{ variables.populationSize }}</p>
            <p>Mutation Rate: {{ variables.mutationRate }}</p>
            <p>Generations: {{ variables.generations }}</p>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            populationSize: "",
            mutationRate: "",
            generations: "",
            variables: null,
        };
    },
    methods: {
        async setVariables() {
            const data = {
                populationSize: this.populationSize,
                mutationRate: this.mutationRate,
                generations: this.generations,
            };
            try {
                await this.$axios.post("192.168.1.15:8080/set-variables", data);
                console.log("Variables set successfully");
            } catch (error) {
                console.error("Error setting variables:", error);
            }
        },
        async fetchVariables() {
            try {
                const response = await this.$axios.get("/get-variables");
                this.variables = response.data;
            } catch (error) {
                console.error("Error fetching variables:", error);
            }
        },
    },
};
</script>
