import { defineStore } from 'pinia';

export const userWorkoutStore = defineStore('workout', {
  state: () => ({
    workoutid: null,
  }),
  actions: {
    setWorkoutId(id: number) {
      this.workoutid = id;
    },
    getWorkoutId() {
      return this.workoutid;
    },
  },
});