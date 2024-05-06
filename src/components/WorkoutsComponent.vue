<template>
    <h1 class="text-center">Start A Workout</h1>
    <h2 class="pt-3">Select a workout</h2>
    <v-select
        :items="workouts"
        label="Workout"
        v-model="selectedWorkout"
    ></v-select>
    <v-btn
    color="primary"
    large block
    class="mt-5">
    Start
  </v-btn>
  <v-btn
    color="success"
    large block
    class="mt-5">
    Create New Workout
  </v-btn>
</template>

<script>
export default {
    data() {
        return {
            selectedWorkout: null,
            workouts: ['Workout 1', 'Workout 2', 'Workout 3']
        }
    }
}
</script>