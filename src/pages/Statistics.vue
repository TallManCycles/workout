<template>
    <v-main>
        <h1 class="text-center">Statistics</h1>
        <v-container>
            <v-row justify="center">
                <v-col cols="12" md="8">
                    <v-card class="pa-4">
                        <v-card-title class="headline">Sets Per Muscle Group</v-card-title>
                        <v-card-text>
                            <v-list>
                                <v-list-item v-for="setPerMuscleGroup in setsPerMuscleGroup" :key="setPerMuscleGroup.muscleGroup">
                                    <v-list-item-content class="d-flex justify-space-between">
                                        <v-list-item-title>{{ setPerMuscleGroup.muscleGroup }}</v-list-item-title>
                                        <v-list-item-subtitle>{{ setPerMuscleGroup.sets }}</v-list-item-subtitle>
                                    </v-list-item-content>
                                    <v-divider v-if="setPerMuscleGroup !== setsPerMuscleGroup[setsPerMuscleGroup.length - 1]"></v-divider>
                                </v-list-item>
                            </v-list>
                        </v-card-text>
                    </v-card>
                </v-col>
            </v-row>
        </v-container>
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
                <v-col cols="12" md="6">
                    <v-card>
                        <v-card-title>Summary</v-card-title>
                        <v-card-text>
                            <p>Exercises: {{ descriptionOfExercisesPerformed }}</p>
                            <p>Total Sets: {{ totalSets }}</p>
                            <p>Total Reps: {{ totalReps }}</p>
                            <p>Total Weight: {{ totalWeight }} kg</p>                            
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
            exerciseLogs: [] as Array<{ id: string, description: string, reps: number, weight: number}>,
            setsPerMuscleGroup: [] as Array<{muscleGroup: string, sets: number}>
        };
    },
    computed: {
        totalSets() {
            return this.exerciseLogs.length;
        },
        totalReps() {
            return this.exerciseLogs.reduce((total, log) => total + log.reps, 0);
        },
        totalWeight() {
            return this.exerciseLogs.reduce((total, log) => total + log.weight, 0);
        },
        descriptionOfExercisesPerformed() {
            const exerciseDescriptions = this.exerciseLogs.map(log => log.exercises.description);
            return [...new Set(exerciseDescriptions)].join(', ');
        }
    },
    methods: {
        async fetchWorkoutDescriptions() {
            const { data, error } = await supabase
                .from('workout')
                .select('id, description, date')
                .order('date', { ascending: false });


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
        },
        async getNumberOfSetsPerMuscleGroup() {
            //returns sets, exerciseid, and musclegroup_description
            const {data,error} = await supabase.rpc('get_last_week_exercise_with_description');

            if (error) {
                console.error(error);
                return;
            }

            this.setsPerMuscleGroup = data.map((d: any) => ({
                muscleGroup: d.musclegroup_description,
                sets: d.sets
            }));
        }
    },
    async created() {
        await this.fetchWorkoutDescriptions();
        await this.getNumberOfSetsPerMuscleGroup();
    }
});
</script>

<style scoped>
.text-center {
    text-align: center;
}
</style>