<template>
    <v-main>
        <h1 class="text-center">Statistics</h1>
        <v-container>
            <v-row>
                <v-col cols="12" md="6">
                    <v-select
                        v-model="selectedWorkout"
                        :items="workoutDescriptions"
                        item-title="description"
                        item-value="id"
                        label="Select Workout"
                        @update:modelValue="fetchExerciseLogs"
                    ></v-select>
                </v-col>
            </v-row>
            <v-row v-if="exerciseLogs.length">
                <v-col cols="12" v-for="log in exerciseLogs" :key="log.id">
                    <v-card>
                        <v-card-title>{{ log.exercises.description }}</v-card-title>
                        <v-card-text>
                            <v-row>
                                <v-col cols="6">
                                    <v-list>
                                        <v-list-item>
                                            <v-list-item-content>
                                                <v-list-item-title>Reps</v-list-item-title>
                                                <v-list-item-subtitle>{{ log.reps }}</v-list-item-subtitle>
                                            </v-list-item-content>
                                        </v-list-item>
                                        <v-list-item>
                                            <v-list-item-content>
                                                <v-list-item-title>Weight</v-list-item-title>
                                                <v-list-item-subtitle>{{ log.weight }}</v-list-item-subtitle>
                                            </v-list-item-content>
                                        </v-list-item>
                                    </v-list>
                                </v-col>
                                <v-col cols="6">
                                    <v-list>
                                        <v-list-item>
                                            <v-list-item-content>
                                                <v-list-item-title>Total Volume</v-list-item-title>
                                                <v-list-item-subtitle>{{ calculateTotalVolume(log) }}</v-list-item-subtitle>
                                            </v-list-item-content>
                                        </v-list-item>
                                    </v-list>
                                </v-col>
                            </v-row>
                        </v-card-text>
                    </v-card>
                </v-col>
            </v-row>
        </v-container>
    </v-main>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import { supabase } from '../data/supabase';

export default defineComponent({
    name: 'Statistics',
    data() {
        return {
            workoutDescriptions: [] as Array<{ id: string, description: string }>,
            selectedWorkout: null as string | null,
            exerciseLogs: [] as Array<{ id: string, description: string, reps: number, weight: number}>
        };
    },
    methods: {
        async fetchWorkoutDescriptions() {
            const { data, error } = await supabase
                .from('workout')
                .select('id, description, date');

            if (error) {
                console.error(error);
                return;
            }

            const workoutDescriptions = data.map((workout: any) => ({
                id: workout.id,
                description: workout.description + ' - ' + new Date(workout.date).toLocaleDateString()
            }));

            this.workoutDescriptions = workoutDescriptions;
        },
        async fetchExerciseLogs() {
            if (!this.selectedWorkout) return;

            const { data, error } = await supabase
                .from('exerciselog')
                .select('id, exerciseid, exercises (description), reps, weight')
                .eq('workoutid', this.selectedWorkout);

            if (error) {
                console.error(error);
                return;
            }        

            this.exerciseLogs = data;
        },
        calculateTotalVolume(log: any) {
            return parseInt(log.reps) * parseInt(log.weight);
            //return log.reduce((total, set) => total + (set.reps * set.weight), 0);
        }
    },
    async created() {
        await this.fetchWorkoutDescriptions();
    }
});
</script>

<style scoped>
.text-center {
    text-align: center;
}
</style>