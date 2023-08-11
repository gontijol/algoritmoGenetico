
import './style.css'
import { createApp } from 'vue';
import App from './App.vue';
import axios from 'axios';

const app = createApp(App);
app.config.globalProperties.$axios = axios; // Adicione o Vue Axios como uma propriedade global

app.mount('#app');
