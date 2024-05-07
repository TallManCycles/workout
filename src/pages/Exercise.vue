<template>
    <v-main>
        <h1 class="text-center">{{ description }}</h1>
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
        <v-bottom-sheet v-model="showTimer">
            <v-card class="text-center">
                <v-card-text>
                    <v-btn variant="text" @click="showTimer = !showTimer">
                        close
                    </v-btn>
                    <div>Rest: {{ restTimer }} secs</div>
                </v-card-text>
            </v-card>
        </v-bottom-sheet>
    </v-main>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
    props: {
        description: {
            type: String,
            required: true
        }
    },
    data() {
        return {
            sets: [
                {
                    complete: true,
                    reps: 10,
                    weight: 100,
                    rir: 2
                },
                {
                    complete: false,
                    reps: 8,
                    weight: 120,
                    rir: 2
                },
                {
                    complete: false,
                    reps: 8,
                    weight: 120,
                    rir: 2
                },
                {
                    complete: false,
                    reps: 8,
                    weight: 120,
                    rir: 2
                },
                {
                    complete: false,
                    reps: 8,
                    weight: 120,
                    rir: 2
                }
            ],
            showTimer: false,
            restTimer: 30,
            timerInterval: 1000
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
    }
});
</script>