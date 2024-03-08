<template>
    <div class="flex items-center justify-center w-screen h-screen font-medium">
        <div class="flex flex-grow items-center justify-center bg-gray-900 h-full">
            <!-- Component Start -->
            <div class="max-w-full p-8 bg-gray-800 rounded-lg shadow-lg w-96 text-gray-200">
                <div class="flex items-center mb-6">
                    <svg class="h-8 w-8 text-indigo-500 stroke-current" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                    </svg>
                    <h4 class="font-semibold ml-3 text-lg">todo-list</h4>
			    </div>
                <div class="mb-4">
                    <!-- 任务列表 -->
                    <div v-for="task in taskStore.tasks" :key="task.id" class="flex items-center h-10 px-2 rounded cursor-pointer hover:bg-gray-900" @click="toggleCompletion(task.id)">
                        <!-- 切换图标的点击区域 -->
                        <span class="flex items-center justify-center w-5 h-5 cursor-pointer">
                            <!-- 空心圆 SVG，未完成时显示 -->
                            <svg v-if="!task.isCompleted" class="w-4 h-4 border-2 border-current rounded-full" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"></svg>
                            <!-- 绿色勾的 SVG，完成时显示 -->
                            <svg v-else class="w-4 h-4 fill-current text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586 16.293 4.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                            </svg>
                        </span>
                        <!-- 根据 isCompleted 状态动态添加删除线 -->
                        <span :class="{'line-through': task.isCompleted, 'text-gray-200': !task.isCompleted, 'text-green-500': task.isCompleted}" class="ml-4 text-sm">
                            {{ task.description }}
                        </span>
                    </div>
                </div>

                <!-- 添加任务按钮 -->
                <button  class="flex items-center w-full h-8 px-2 mt-2 text-sm font-medium rounded">
                    <svg @click="addNewTask" class="w-5 h-5 text-gray-400 fill-current" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                    </svg>
                    <input v-model=description class="flex-grow h-8 ml-4 bg-transparent focus:outline-none font-medium"></input>
                </button>
            </div>
            <!-- Component End -->
        </div>
    </div>
</template>

<script setup lang='ts'>
import { useTaskStore } from '../stores/task.ts'
import { ref } from 'vue';

const taskStore = useTaskStore();
const description = ref('');
const addNewTask = () => {
    if (description.value.trim()) {
        taskStore.addTask(description.value);
        description.value = ''; // 清空输入框
    }
};

const toggleCompletion = (taskId:number) => {
    taskStore.toggleTaskCompletion(taskId);
}
</script>

<style scoped>
/* CSS 样式 */
.line-through {
  text-decoration: line-through;
  color: #9CA3AF; /* 删除线的颜色 */
}
</style>
