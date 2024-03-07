import { createApp } from 'vue'
import App from './App.vue'
import {createPinia} from 'pinia'
import { createPersistedState } from 'pinia-persistedstate-plugin'
import './index.css'
const app = createApp(App);
const pinia = createPinia();
const persist = createPersistedState();
// localStorage.clear(); // 清除所有 localStorage 数据
pinia.use(persist);
app.use(pinia)
app.mount('#app');
