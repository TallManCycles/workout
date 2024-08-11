<template>
    <h1 class="text-center">Finish Workout</h1>
    <h2 class="pt-3 text-center">Workout Summary</h2>
    <v-label class="mt-3">How difficult was this workout?</v-label>
    <v-slider variant="primary" :max="4" :ticks="workoutRating" v-model="workoutRatingValue" show-ticks="always" step="1" tick-size="5"></v-slider>
    <v-label class="mt-3">How recovered are you feeling after this workout?</v-label>
    <v-slider variant="primary" :max="4" :ticks="recoveryRating" v-model="recoveryRatingValue" show-ticks="always" step="1" tick-size="5"></v-slider>
    <v-container>
        <v-textarea label="Workout Notes" v-model="notes" variant="outlined"></v-textarea>
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
import { activeWorkoutStore } from '../stores/activeWorkout';
import {supabase } from '../data/supabase';
export default {
    methods: {
        async finish() {

            const workoutStore = activeWorkoutStore();

            // save the workout data to the database
            const { error } = await supabase.from('workout').update({
                perceivedeffort: this.workoutRatingValue,
                fatigue_rating: this.recoveryRatingValue,
                notes: this.notes
            })
            .eq('id', workoutStore.getWorkoutId());

            if (error) {
                alert('There was an error saving your workout data. Please try again.');
                console.error('Error saving workout data:', error);
            } else {
                //set the workout state to false
                workoutStore.updateWorkout(false);
                
                this.$router.push({ name: 'workouts' });
            }
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
            workoutRatingValue: 0,
            recoveryRating: {
                0: 'Low',
                1: '',
                2: 'Moderately',
                3: '',
                4: 'Fully'
            },
            recoveryRatingValue: 0,
            notes: ''
        };
    }
}
</script>