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
    <div>
        <v-label class="pb-3">Approx time: {{ internalWorkoutMinutes }} minutes</v-label>
    </div>
    <!-- create a dropdown that contains the workout description and workout id -->
    <v-btn color="secondary" v-if="workoutStarted" class="mb-5" @click="addExercise">{{addExerciseLabel}}    
    </v-btn>
    <v-btn color="success" block class="mb-5" @click="toggleWorkout">{{ workoutStarted ? 'Finish Workout' : ' Start Workout'
        }}</v-btn>
    <v-btn color="outline" v-if="!workoutStarted" block @click="back">Back</v-btn>
    <v-btn append-icon="mdi-delete" v-if="workoutStarted" block @click="deteleDialog = true">Delete Workout</v-btn>
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
            dialog: false,
            deteleDialog: false,
            workoutStarted: false,
            isLoading: false,
            addingExercise: false,
            selectedAdditionalExercise: null,
            additionalExercises: [],
            internalWorkoutMinutes: 0
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
        await this.workoutMinutes();
        if (workoutStore !== null) {
            this.workoutStarted = workoutStore.workoutState();
        }
        this.isLoading = false;
    },
    methods: {
        openExercise(id) {
            this.$router.push({ name: 'exercise', params: { id: id } });
        },
        async workoutMinutes() {
            //foreach exercise in the workout, calculate the time it will take to complete the workout based on the sets and reps

            const { data, error } = await supabase
                .from('usersettings')
                .select('restInterval')
                .single();

            if (error) {
                console.error(error);
                return;
            }

            const restSeconds = data.restInterval;

            let totalMinutes = 0;

            this.exercises.forEach(exercise => {
                totalMinutes += exercise.sets + ((exercise.sets * restSeconds)/60);
            });

            this.internalWorkoutMinutes = totalMinutes;
        },
        async toggleWorkout() {

            const workoutStore = activeWorkoutStore();

            if (!this.workoutStarted) {
                this.workoutStarted = !this.workoutStarted;

                workoutStore.updateWorkout(this.workoutStarted);

                //supabase set the workout description, and set the date to now.
                const { data, error } = await supabase
                    .from('workout')
                    .insert({
                        description: this.workoutDescription,
                        date: new Date()
                    })
                    .select();

                if (error) {
                    console.error(error);
                    return;
                }

                workoutStore.setWorkoutId(data[0].id);

                workoutStore.setCurrentExercises(this.exercises);

                return;
            }

            this.dialog = true;
        },
        finishWorkout() {
            this.dialog = false;
            this.$router.push({ name: 'finish' });
        },
        async deleteWorkout() {
            //delete all items from exerciselog that have this workout id.
            const workoutStore = activeWorkoutStore();

            const {data , error} = await supabase
                .from('exerciselog')
                .delete()
                .eq('workoutid', workoutStore.getWorkoutId());

            if (error) {
                alert(error);
                return;
            }

            //delete the workout from the wporkout table
            const {data: workoutData, error: workoutError} = await supabase
                .from('workout')
                .delete()
                .eq('id', workoutStore.getWorkoutId());

            if (workoutError) {
                alert(workoutError);
                return;
            }

            workoutStore.clearWorkout();

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

            if (workoutStore.workoutState()) {
                this.exercises = workoutStore.getCurrentExercises();
                return;
            }

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
                    const workoutStore = activeWorkoutStore();

                    const newExericse = {
                        id: this.selectedAdditionalExercise.id,
                        exercises: {
                            description: this.selectedAdditionalExercise.description,
                        },
                        sets: 3,
                        repsinreserve: 2,
                        order: this.exercises.length + 1
                    }

                    workoutStore.addExercise(newExericse);
                    this.addingExercise = false;


                    //add this exercise into the exerciselog so that the next screen can pull the details

                    const { data, error } = await supabase
                        .from('exerciselog')
                        .insert({
                            workoutid: workoutStore.getWorkoutId(),
                            exerciseid: newExericse.id,
                            reps: 0,
                            repsinreserve: 0,
                            weight: 0,
                            complete: false
                        })
                        .select();

                    if (error) {
                        console.error(error);
                        return;
                    }

                    return;
                }
            }

            // if we are not adding an exercise, then we need to show the dropdown
            this.addingExercise = true;

            const { data, error } = await supabase
                .from('exercises')
                .select('*');

            if (error) {
                console.error(error);
                return;
            }
            
            this.additionalExercises = data;

        }
    }
}
</script>