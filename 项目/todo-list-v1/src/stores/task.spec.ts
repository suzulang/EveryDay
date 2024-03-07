import { describe, it, expect, beforeEach } from 'vitest';
import { setActivePinia, createPinia } from 'pinia';
import { useTaskStore } from './task'; // 请确保这里的路径与您的 store 文件匹配

describe('Task Store', () => {
  beforeEach(() => {
    // 重置 Pinia 实例以清空状态
    setActivePinia(createPinia());
  });

  it('adds a task correctly', () => {
    const taskStore = useTaskStore();
    expect(taskStore.tasks.length).toBe(0); // 初始状态下任务列表为空

    // 添加任务并验证
    taskStore.addTask('Test task');
    expect(taskStore.tasks.length).toBe(1);
    expect(taskStore.tasks[0].description).toBe('Test task');
    expect(taskStore.tasks[0].isCompleted).toBe(false);
  });

  it('toggles task completion correctly', () => {
    const taskStore = useTaskStore();
    
    // 先添加一个任务
    taskStore.addTask('Test task');
    expect(taskStore.tasks[0].isCompleted).toBe(false); // 确认任务初始状态为未完成

    // 切换任务完成状态并验证
    taskStore.toggleTaskCompletion(taskStore.tasks[0].id);
    expect(taskStore.tasks[0].isCompleted).toBe(true); // 确认任务状态被正确切换为已完成
  });
});
