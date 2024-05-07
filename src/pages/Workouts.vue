<template>
    <h1 class="text-center">Start A Workout</h1>
    <h2 class="pt-3">Select a workout</h2>
    <v-select :items="workouts" label="Workout" v-model="selectedWorkout"></v-select>
    <v-alert v-if="alert" type="error" class="mt-3" closable="true" @click.close="this.alert = false">
        Please select a workout before starting.
    </v-alert>
    <v-btn color="success" large block class="mt-5" @click="start">
        Start
    </v-btn>
    <v-btn color="secondary" large block class="mt-5">
        Create New Workout
    </v-btn>
</template>

<script lang="ts">
import { supabase } from '../data/supabase';

export default {
    data() {
        return {
            selectedWorkout: null,
            workouts: ['Workout 1', 'Workout 2', 'Workout 3'],
            alert: false
        }
    },
    async mounted() {
        const { data, error } = await supabase
            .from('savedworkout')
            .select('*');

        if (error) {
            console.error(error);
            return;
        }

        this.workouts = data.map((workout: any) => workout.description);
    },
    methods: {
        start() {
            if (!this.selectedWorkout) {
                this.alert = true;
                return;
            }
            this.$router.push({ name: 'workout', params: { id: this.selectedWorkout } });
        }
    }
}
</script>