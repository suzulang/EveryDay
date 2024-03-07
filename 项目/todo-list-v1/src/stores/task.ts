import {defineStore} from 'pinia'

interface Task {
    id: number;
    description: string;
    isCompleted: boolean;
}

export const useTaskStore = defineStore('task', {
    state: () => ({
        tasks: [] as Task[],
        nextId: 1,
    }),
    actions: {
        addTask(description: string) {
            this.tasks.push({
                id: this.nextId++,
                description,
                isCompleted: false,
            });
        },
        toggleTaskCompletion(taskId: number) {
            const task = this.tasks.find(task => task.id===taskId);
            if (task) {
                task.isCompleted = !task.isCompleted;
            }
        }
    }
});