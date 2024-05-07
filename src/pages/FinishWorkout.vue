<template>
    <h1 class="text-center">Finish Workout</h1>
    <h2 class="pt-3 text-center">Workout Summary</h2>
    <v-label class="mt-3">How difficult was this workout?</v-label>
    <v-slider variant="primary" :max="4" :ticks="workoutRating" show-ticks="always" step="1" tick-size="5"></v-slider>
    <v-label class="mt-3">How recovered are you feeling after this workout?</v-label>
    <v-slider variant="primary" :max="4" :ticks="recoveryRating" show-ticks="always" step="1" tick-size="5"></v-slider>
    <v-container>
        <v-textarea label="Workout Notes" variant="outlined"></v-textarea>
    </v-container>
    <v-alert type="info" class="mt-3">
        Great job! You've completed your workout. You can now view your progress and make any changes to your workout
        plan.
    </v-alert>
    <v-btn color="success" large block class="mt-5" @click="finish">
        Finish
    </v-btn>
</template>

<script lang="ts">
export default {
    methods: {
        finish() {
            this.$router.push({ name: 'workouts' });
        }
    },
    data() {
        return {
            workoutRating: {
                0: 'Easy',
                1: '',
                2: 'Moderate',
                3: '',
                4: 'Very Hard'
            },
            recoveryRating: {
                0: 'Low',
                1: '',
                2: 'Moderately',
                3: '',
                4: 'Fully'
            }
        };
    }
}
</script>