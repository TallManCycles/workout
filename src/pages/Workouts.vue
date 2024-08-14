<template>
    <h1 class="text-center">Start A Workout</h1>
    <h2 class="pt-3">Select a workout</h2>
    <v-select :items="workouts" label="Workouts" item-title="description" item-value="id"
        v-model="selectedWorkout"></v-select>
    <v-alert v-if="alert" type="error" class="mt-3" closable="true" @click.close="this.alert = false">
        Please select a workout before starting.
    </v-alert>
    <v-btn color="success" large block class="mt-5" @click="start">
        View Workout
    </v-btn>
    <v-btn color="secondary" large block class="mt-5" @click="createDescription = true">
        Create New Workout
    </v-btn>
    <v-dialog v-model="createDescription" width="auto">
        <v-card max-width="400" prepend-icon="mdi-plus"
            text="Please enter a description for the workout"
            title="Create Workout">
            <v-text-field v-model="description" class="px-4" label="Description"></v-text-field>
            <template v-slot:actions>
                <v-btn text="Cancel" @click="createDescription = false"></v-btn>
                <v-btn text="Ok" @click="createWorkout"></v-btn>
            </template>
        </v-card>
    </v-dialog>
</template>

<script lang="ts">
import { supabase } from '../data/supabase';

export default {
    data() {
        return {
            selectedWorkout: null,
            workouts: [] as [],
            alert: false,
            createDescription: false,
            description: ''
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

        this.workouts = data;
    },
    methods: {
        start() {
            if (!this.selectedWorkout) {
                this.alert = true;
                return;
            }
            this.$router.push({ name: 'workout', params: { id: this.selectedWorkout } });
        },
        async startCreateWorkout() {
            this.createDescription = true;
        },
        async createWorkout() {
            const { data, error } = await supabase
                .from('savedworkout')
                .insert({ description: this.description })
                .select('*');

            if (error) {
                console.error(error);
                return;
            }

            this.$router.push({ name: 'newworkout', params: { id: data[0].id } });
    }
    },
}
</script>