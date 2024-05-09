<template>
    <h1 class="text-center">{{ workoutDescription }}</h1>
    <v-skeleton-loader v-if="isLoading" type="list-item-two-line"></v-skeleton-loader>
    <v-list lines="two" v-else>
        <v-list-item v-for="(exercise, index) in exercises" :key="index">

            <template v-slot:prepend>
                <v-avatar color="grey-lighten-1">
                    <v-icon color="white">mdi-dumbbell</v-icon>
                </v-avatar>
            </template>

            <template v-slot:append>
                <v-btn color="grey-lighten-1" icon="mdi-chevron-right" variant="text"></v-btn>
            </template>


            <v-list-item-content @click="openExercise(exercise.id)">
                <v-list-item-title>{{ exercise.exercises.description }}</v-list-item-title>
                <v-list-item-subtitle>Sets: {{ exercise.sets }} RIR: {{ exercise.rir }}</v-list-item-subtitle>
            </v-list-item-content>
        </v-list-item>
    </v-list>
    <v-btn color="success" block @click="toggleWorkout">{{ workoutStarted ? 'Finish Workout' : ' Start Workout'
        }}</v-btn>
    <v-dialog v-model="dialog" width="auto">
        <v-card max-width="400" prepend-icon="mdi-update"
            text="Are you sure you want to finish the workout? You will not be able to make any more changes after this point"
            title="Finish Workout">
            <template v-slot:actions>
                <v-btn text="Cancel" @click="dialog = false"></v-btn>
                <v-btn text="Ok" @click="finishWorkout"></v-btn>
            </template>
        </v-card>
    </v-dialog>
</template>

<script lang="ts">
import { supabase } from '../data/supabase';

export default {
    props: {
        id: {
            type: String,
            required: true
        }
    },
    data() {
        return {
            workoutDescription: '',
            exercises: [] as [],
            dialog: false,
            workoutStarted: false,
            isLoading: false
        }
    },
    async mounted() {
        this.isLoading = true;
        await this.getWorkout();
        await this.getWorkoutDetails();
        this.isLoading = false;
    },
    unmounted() {
        //warn the user if they try to leave the page without finishing the workout

        if (this.workoutStarted) {
            alert('are you sure you want to leave?')
        }

    },
    methods: {
        openExercise(id) {
            this.$router.push({ name: 'exercise', params: { id: id } });
        },
        toggleWorkout() {
            if (!this.workoutStarted) {
                this.workoutStarted = !this.workoutStarted;
                return;
            }

            this.dialog = true;
        },
        finishWorkout() {
            this.dialog = false;
            this.$router.push({ name: 'finish' });
        },
        async getWorkout() {
            const { data, error } = await supabase
                .from('savedworkout')
                .select('*')
                .eq('id', this.id);

            if (error) {
                console.error(error);
                return;
            }

            this.workoutDescription = data[0].description;
        },
        async getWorkoutDetails() {
            const { data, error } = await supabase
                .from('savedworkoutdetail')
                .select(`
                    id,
                    exercises (description),
                    sets,
                    repsinreserve`)
                .eq('savedworkoutid', this.id);

            if (error) {
                console.error(error);
                return;
            }

            this.exercises = data;
        }
    }
}
</script>