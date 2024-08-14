<template>
    <v-main>
        <v-skeleton-loader v-if="isLoading" type="list-item-two-line"></v-skeleton-loader>
        <div v-else>
            <h1 class="text-center">{{ workoutDescription }}</h1>
            <v-list :style="{ maxHeight: '80vh' }">
                <v-list-item v-for="(set, index) in sets" :key="index">
                    <v-list-item-content>
                        <v-list-item-title>
                            <h2>Set # {{ index + 1 }}</h2>
                        </v-list-item-title>
                        <v-list-item-subtitle>
                            <v-row>
                                <v-col cols="3">
                                    <v-checkbox v-model="set.complete" @click="startTimer"></v-checkbox>
                                </v-col>
                                <v-col cols="3">
                                    <v-text-field v-model="set.reps" label="Reps" type="number"></v-text-field>
                                </v-col>
                                <v-col cols="3">
                                    <v-text-field v-model="set.weight" label="Weight" type="number"></v-text-field>
                                </v-col>
                                <v-col cols="3">
                                    <v-select v-model="set.rir" :items="[5, 4, 3, 2, 1, 0]" label="RIR"></v-select>
                                </v-col>
                            </v-row>
                        </v-list-item-subtitle>
                    </v-list-item-content>
                </v-list-item>
                <v-list-item>
                    <v-btn color="secondary" class="mt-5" @click="addSet">+ Set</v-btn>
                </v-list-item>
            </v-list>

            <v-btn color="success" large block class="mt-5" @click="saveSet">
                Save and Continue
            </v-btn>
            <v-btn color="outline" large block class="mt-5" @click="back">
                Back
            </v-btn>
            <v-bottom-sheet v-model="showTimer">
                <v-card class="text-center" @click="showTimer = !showTimer" link>
                    <v-card-text>
                        <h1>Rest Timer</h1>
                        <h2>Remaining: {{ restTimer }} secs</h2>
                    </v-card-text>
                </v-card>
            </v-bottom-sheet>
        </div>
    </v-main>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import { supabase } from '../data/supabase';
import { activeWorkoutStore } from '../stores/activeWorkout';

export default defineComponent({
    props: {
        id: {
            type: String,
            required: true
        }
    },
    data() {
        return {
            workoutDescription: '',
            sets: [] as [],
            showTimer: false,
            restTimer: 90,
            timerInterval: 1000,
            isLoading: true
        }
    },
    methods: {
        async saveSet() {

            const workoutStore = activeWorkoutStore();

            const workoutId = workoutStore.getWorkoutId();

            //if the sets have ids, update the existing sets

            for (let i = 0; i < this.sets.length; i++) {
                if (this.sets[i].id) {
                    const {error} = await supabase
                        .from('exerciselog')
                        .update({
                            reps: this.sets[i].reps,
                            weight: this.sets[i].weight,
                            repsinreserve: this.sets[i].rir,
                            complete: this.sets[i].complete
                        })
                        .eq('id', this.sets[i].id);

                    if (error) {
                        alert('An error occurred while saving the set');
                        console.error(error);
                        return;
                    }
                    continue;
                } else {
                    //save the set to the database
                    const {error} = await supabase
                    .from('exerciselog')
                    .insert({
                        workoutid: workoutId,
                        exerciseid: this.id,
                        reps: this.sets[i].reps,
                        weight: this.sets[i].weight,
                        repsinreserve: this.sets[i].rir,
                        complete: this.sets[i].complete
                    });

                    if (error) {
                        alert('An error occurred while saving the set');
                        console.error(error);
                        return;
                    }
                }
            }            
            

            //navigate back to the previous page
            this.$router.back()
        },
        startTimer() {
            this.showTimer = true;
        },
        addSet() {
            //add a new set that contains the same reps, weight, and rir as the last set
            const lastSet = this.sets[this.sets.length - 1];
            this.sets.push({
                complete: false,
                reps: lastSet.reps,
                weight: lastSet.weight,
                rir: lastSet.rir
            });
        },
        back() {
            this.$router.back();
        },
        async loadRestInterval() {

            const { data, error } = await supabase
                .from('usersettings')
                .select('restInterval')
                .single();

            if (error) {
                console.error(error);
                return;
            }

            this.restTimer = data.restInterval;
        },
        async loadExercise() {

            const workoutStore = activeWorkoutStore();

            // workout has started, so load the saved sets
            if (workoutStore.workoutState()) {              
                const { data: saved, error: saveError } = await supabase
                    .from('exerciselog')
                    .select(`
                        id,
                        workoutid,
                        exerciseid,
                        reps,
                        repsinreserve,
                        weight,
                        complete`)
                    .eq('exerciseid', this.id)
                    .eq('workoutid', workoutStore.getWorkoutId());

                if (saveError) {
                    console.error(saveError);
                    return;
                }

                if (saved.length > 0) {
                    for (let i = 0; i < saved.length; i++) {
                        this.sets.push({
                            id: saved[i].id,
                            complete: saved[i].complete,
                            reps: saved[i].reps,
                            weight: saved[i].weight,
                            rir: saved[i].repsinreserve
                        });
                    }

                    const {data: exercise, error} = await supabase
                        .from('exercises')
                        .select('description')
                        .eq('id', this.id);

                    if (error) {
                        console.error(error);
                        return;
                    }

                    this.workoutDescription = exercise[0].description;
                    
                    return;                
                }
            }

            //none exist, so load the template          

            const { data: template, error } = await supabase
                .from('savedworkoutdetail')
                .select(`
                    id,
                    exercises (description),
                    sets,
                    weight,
                    repsinreserve`)
                .eq('id', this.id);

            if (error) {
                console.error(error);
                return;
            }

            //for the number of sets in the exercise, create a new set object.

            for (let i = 0; i < template[0].sets; i++) {
                this.sets.push({
                    complete: false,
                    reps: null,
                    weight: template[0].weight,
                    rir: template[0].repsinreserve
                });
            }


            this.workoutDescription = template[0].exercises.description;
        }
    },
    watch: {
        showTimer: {
            handler(value) {
                if (value) {
                    this.timerInterval = setInterval(() => {
                        if (this.restTimer > 0) {
                            this.restTimer--;
                        } else {
                            clearInterval(this.timerInterval);
                            this.showTimer = false;
                        }
                    }, 1000);
                } else {
                    clearInterval(this.timerInterval);
                }
            },
            immediate: true
        }
    },
    async created() {
        this.isLoading = true;
        await this.loadExercise();
        await this.loadRestInterval();
        this.isLoading = false;
    }
});
</script>