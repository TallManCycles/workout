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
            restTimer: 30,
            timerInterval: 1000,
            isLoading: true
        }
    },
    methods: {
        saveSet() {
            this.$router.back()
        },
        startTimer() {
            this.showTimer = true;
            this.restTimer = 30;
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
        async loadExercise() {
            const { data, error } = await supabase
                .from('savedworkoutdetail')
                .select(`
                    id,
                    exercises (description),
                    sets,
                    weight,
                    repsinreserve`)
                .eq('id', this.id);

            if (error || data.length === 0) {
                console.error(error);
                return;
            }

            //for the number of sets in the exercise, create a new set object.

            for (let i = 0; i < data[0].sets; i++) {
                this.sets.push({
                    complete: false,
                    reps: null,
                    weight: data[0].weight,
                    rir: data[0].repsinreserve
                });
            }

            console.log(this.sets);



            this.workoutDescription = data[0].exercises.description;
        }
    },
    watch: {
        showTimer: {
            handler(value) {
                if (value) {
                    this.timerInterval = setInterval(() => {
                        if (this.restTimer > 0)
                            this.restTimer--;
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
        this.isLoading = false;
    }
});
</script>