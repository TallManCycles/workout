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
                <v-list-item-subtitle>Sets: {{ exercise.sets }} RIR: {{ exercise.repsinreserve }}</v-list-item-subtitle>
            </v-list-item-content>
        </v-list-item>
    </v-list>
    <v-select v-if="addingExercise"
        v-model="selectedAdditionalExercise"
        :items="additionalExercises"
        item-title="description"
        label="Select Exercise"
        return-object
    ></v-select>
    <template v-if="addingExercise">
        <div class="d-flex">
            <v-text-field v-model="sets" label="Sets" type="number"></v-text-field>
            <v-text-field class="pl-2" v-model="weight" label="Weight" type="number"></v-text-field>
            <v-text-field class="pl-2" v-model="repsinreserve" label="Reps in Reserve" type="number" max="5"></v-text-field>
        </div>
    </template>
    <v-btn color="secondary" class="mb-5" @click="addExercise">{{addExerciseLabel}}    
    </v-btn>
    <v-btn color="success" block class="mb-5" @click="saveDialog = true">Save Workout</v-btn>
    <v-btn color="red" append-icon="mdi-delete" class="mb-5" block @click="deteleDialog = true">Delete Workout</v-btn>
    <v-btn color="outline" block @click="back">Back</v-btn>
    <v-dialog v-model="saveDialog" width="auto">
        <v-card max-width="400" prepend-icon="mdi-update"
            text="Are you sure you want to save the workout? You will not be able to make any more changes after this point"
            title="Save Workout">
            <template v-slot:actions>
                <v-btn text="Cancel" @click="dialog = false"></v-btn>
                <v-btn text="Ok" @click="saveWorkout"></v-btn>
            </template>
        </v-card>
    </v-dialog>
    <v-dialog v-model="deteleDialog" width="auto">
        <v-card max-width="400" prepend-icon="mdi-delete-alert"
            text="Are you sure you want to delete this workout? You will not be able to recover your changes"
            title="Delete Workout">
            <template v-slot:actions>
                <v-btn text="Cancel" @click="deteleDialog = false"></v-btn>
                <v-btn text="Ok" @click="deleteWorkout"></v-btn>
            </template>
        </v-card>
    </v-dialog>
</template>

<script lang="ts">
import { supabase } from '../data/supabase';
import { activeWorkoutStore } from '../stores/activeWorkout';

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
            saveDialog: false,
            deteleDialog: false,
            isLoading: false,
            addingExercise: false,
            selectedAdditionalExercise: null,
            additionalExercises: [],
            sets: 3,
            weight: 0,
            repsinreserve: 2
        }
    },
    computed: {
        addExerciseLabel() {
            if (this.addingExercise) {
                return 'Add';
            } else {
                return '+ Exercise';
            }
        }
    },
    async mounted() {
        const workoutStore = activeWorkoutStore();
        this.isLoading = true;
        
        await this.getWorkout();
        await this.getWorkoutDetails();
        this.isLoading = false;
    },
    methods: {
        openExercise(id) {
            this.$router.push({ name: 'exercise', params: { id: id } });
        },
        saveWorkout() {
            this.saveDialog = false;
            this.$router.push({ name: 'workouts' });
        },
        async deleteWorkout() {
            //delete all items from exerciselog that have this workout id.
            const {data , error} = await supabase
                .from('savedworkoutdetail')
                .delete()
                .eq('savedworkoutid', this.id);

            if (error) {
                alert(error);
                return;
            }

            //delete the workout from the wporkout table
            const {data: workoutData, error: workoutError} = await supabase
                .from('savedworkout')
                .delete()
                .eq('id', this.id);

            if (workoutError) {
                alert(workoutError);
                return;
            }

            this.$router.back();
        },
        async getWorkout() {
            const { data, error } = await supabase
                .from('savedworkout')
                .select('*')
                .eq('id', this.id)

            if (error) {
                console.error(error);
                return;
            }

            this.workoutDescription = data[0].description;
        },
        back() {
            this.$router.back();
        },
        async getWorkoutDetails() {
            const workoutStore = activeWorkoutStore();

            const { data, error } = await supabase
                .from('savedworkoutdetail')
                .select(`
                    id,
                    exercises (description),
                    sets,
                    repsinreserve`)
                .eq('savedworkoutid', this.id)
                .order('order', { ascending: true });

            if (error) {
                console.error(error);
                return;
            }

            this.exercises = data;
        },
        async addExercise() {
            // if we are adding an exercise, then we need to add the exercise to the workout
            if (this.addingExercise) {
                if (this.selectedAdditionalExercise) {
                    //save the workout in the workoutdetail table

                    const {data, error} = await supabase
                        .from('savedworkoutdetail')
                        .insert({
                            savedworkoutid: this.id,
                            exerciseid: this.selectedAdditionalExercise.id,
                            sets: this.sets ? this.sets : null,
                            repsinreserve: this.repsinreserve ? this.repsinreserve : null,
                            weight: this.weight ? this.weight : null,
                            order: this.exercises.length + 1
                        })
                        .select();

                    if (error) {
                        console.error(error);
                        return;
                    }

                    if (data) {
                        await this.getWorkoutDetails();
                    }

                    this.addingExercise = false;

                    return;
                }
            }

            // if we are not adding an exercise, then we need to show the dropdown
            this.addingExercise = true;

            const { data, error } = await supabase
                .from('exercises')
                .select('*')
                .order('description', { ascending: true });

            if (error) {
                console.error(error);
                return;
            }
            
            this.additionalExercises = data;

        }
    }
}
</script>