import { defineStore } from 'pinia';

/**
 * Store for managing the active workout state.
 */
export const activeWorkoutStore = defineStore('workout', {
  state: () => ({
    /**
     * The ID of the current workout.
     * @type {number | null}
     */
    workoutid: null,

    /**
     * Indicates whether the workout has started.
     * @type {boolean}
     */
    workoutStarted: false,

    /**
     * The current exercises in the workout.
     */
    currentExercises: []
  }),
  actions: {
    /**
     * Sets the ID of the current workout.
     * @param {number} id - The ID of the workout.
     */
    setWorkoutId(id: number) {
      this.workoutid = id;
    },

    /**
     * Gets the ID of the current workout.
     * @returns {number | null} The ID of the workout.
     */
    getWorkoutId() {
      return this.workoutid;
    },

    /**
     * Updates the workout started state.
     * @param {boolean} value - The new state of the workout.
     */
    updateWorkout(value: boolean) {
      this.workoutStarted = value;
    },

    /**
     * Gets the current workout started state.
     * @returns {boolean} The current state of the workout.
     */
    workoutState() {
      return this.workoutStarted;
    },

    /**
     * Sets the current exercises in the workout.
     * @param {Array} exercises - The exercises in the workout.
     */
    setCurrentExercises(exercises: Array<any>) {
      this.currentExercises = exercises;
    },

    /**
     * Adds an exercise to the workout.
     * @param {Object} exercise - The exercise to add.
     */
    addExercise(exercise: any) {
      this.currentExercises.push(exercise);
    },

    /**
     * Gets the current exercises in the workout.
     * @returns {Array} The exercises in the workout.
     */
    getCurrentExercises() {
      return this.currentExercises;
    },

    clearWorkout() {
      this.workoutid = null;
      this.workoutStarted = false;
      this.currentExercises = [];
    }
  },
});