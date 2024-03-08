# vitest前端单元测试

## 初体验

1. 安装vitest

   ```shell
   npm install -D vitest
   ```

2. 修改package.json，在"scripts"中添加"vitest"

   ```json
     "scripts": {
       "test": "vitest",
       "dev": "vite",
       "build": "vue-tsc && vite build",
       "preview": "vite preview"
     },
   ```

3. 编写.spec.ts文件

   ```ts
   import {test,expect} from "vitest"
   
   test('first test',()=>{
       expect(1+1).toBe(2);
   })
   ```

4. 执行`pnpm test`命令

## 最佳实践，全局配置

1. 在vite.config.ts中加入下面代码

   ```ts
   /// <reference types="vitest" />
   import { defineConfig } from 'vite'
   import vue from '@vitejs/plugin-vue'
   
   // https://vitejs.dev/config/
   export default defineConfig({
     test: {
       globals: true,
     },
     plugins: [vue()],
   })
   
   ```

2. 在tsconfig.json中加入以下代码

   ```json
   {
     "compilerOptions": {
       "types": [
         "vitest/globals"
       ],
       "target": "ES2020",
       "useDefineForClassFields": true,
       "module": "ESNext",
       "lib": ["ES2020", "DOM", "DOM.Iterable"],
       "skipLibCheck": true,
   
       /* Bundler mode */
       "moduleResolution": "bundler",
       "allowImportingTsExtensions": true,
       "resolveJsonModule": true,
       "isolatedModules": true,
       "noEmit": true,
       "jsx": "preserve",
   
       /* Linting */
       "strict": true,
       "noUnusedLocals": true,
       "noUnusedParameters": true,
       "noFallthroughCasesInSwitch": true,
   
     },
     "include": ["src/**/*.ts", "src/**/*.tsx", "src/**/*.vue"],
     "references": [{ "path": "./tsconfig.node.json" }]
   }
   
   ```

3. 执行`pnpm test`测试配置是否生效

## 如果要用pinia的话，要激活pinia

```ts
import {useTaskStore} from './task'
import { setActivePinia } from 'pinia';
import { createPinia } from 'pinia';
// 创建一个新的 Pinia 实例
const pinia = createPinia();
// 在测试开始之前设置活动的 Pinia 实例
setActivePinia(pinia);
const taskStore = useTaskStore()
test('test addTask', () => {
    const task = {
      id: 1,
      description: 'test',
      done: false
    };
  
    // 调用 addTask 方法添加任务
    taskStore.addTask(task);
  
    // 使用 find 方法检查 tasks 数组中是否包含新添加的任务
    const taskAdded = taskStore.tasks.find(t => t.id === task.id);
  
    // 断言任务已成功添加
    expect(taskAdded).toBeDefined();
    expect(taskAdded).toEqual(task);
  });
  
```

这里创建一个新的pinia实例的目的是：保证单元测试的隔离性