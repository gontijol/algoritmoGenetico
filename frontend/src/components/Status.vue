<template>
    <div>
        <h1>API Status</h1>
        <p>{{ apiStatus }}</p>
    </div>
</template>

<script>
export default {
    data() {
        return {
            apiStatus: "",
        };
    },
    mounted() {
        this.fetchApiStatus();
    },
    methods: {
        async fetchApiStatus() {
            try {
                const response = await this.$axios.get(
                    "192.168.1.15:8080/status"
                );
                this.apiStatus = response.data.status;
            } catch (error) {
                console.error("Error fetching API status:", error);
            }
        },
    },
};
</script>
