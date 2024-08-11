import { ActiveExercise } from '../types/ActiveExercise';
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
     * The exercises in the current workout.
     * @type {Array<ActiveExercise>}
     */
    activeExercises: [] as Array<ActiveExercise>,
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
     * Adds an active exercise with reps, weight, and RIR.
     * @param {ActiveExercise} exercise - The exercise to add.
     */
    addActiveExercise(exercise: ActiveExercise) {
      this.activeExercises.push(exercise);
    },

    /**
     * Updates the exercise from the current workout.
     * @param {ActiveExercise} exercise - The exercise to update.
     */
    updateActiveExercise(exercise: ActiveExercise) {
      const index = this.activeExercises.findIndex((item) => item.exerciseid === exercise.exerciseid);
      if (index !== -1) {
        this.activeExercises[index] = exercise;
      }
    },

    /**
     * Get the active exercises in the current workout by exercise ID.
     * @param {number} exerciseid - The ID of the exercise to get.
     * @returns {ActiveExercise | null} The exercise with the given ID.
     */
    getActiveExercise(exerciseid: number) : ActiveExercise | null {
      return this.activeExercises.find((exercise) => exercise.exerciseid === exerciseid);
    },

    /**
     * Get all active exercises in the current workout.
     * @returns {Array<ActiveExercise>} The active exercises in the current workout.
     */
    getAllActiveExercises() : Array<ActiveExercise> | null {
      return this.activeExercises;
    },
  },
});