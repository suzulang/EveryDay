# pinia的最佳实践

## 安装

1. 安装pinia

   ```shell
   npm install pinia
   ```

2. 使用pinia

   ```ts
   import { createApp } from 'vue'
   import { createPinia } from 'pinia'
   import App from './App.vue'
   
   const pinia = createPinia()
   const app = createApp(App)
   
   app.use(pinia)
   app.mount('#app')
   ```

## 定义store

组合式API写法

```ts
export const useCounterStore = defineStore('counter', () => {
  const count = ref(0)
  const doubleCount = computed(() => count.value * 2)
  function increment() {
    count.value++
  }

  return { count, doubleCount, increment }
})
```

