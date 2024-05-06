<template>
    <div>
        <h1 class="text-center">{{ description }}</h1>
        <v-list lines="two">
            <v-list-item>
                <v-list-item-content>
                    <v-row>
                        <v-col cols="3"><strong>Done</strong></v-col>
                        <v-col cols="3"><strong>Reps</strong></v-col>
                        <v-col cols="3"><strong>Weight</strong></v-col>
                        <v-col cols="3"><strong>RIR</strong></v-col>
                    </v-row>
                </v-list-item-content>
            </v-list-item>
            <v-list-item v-for="(set, index) in sets" :key="index">
                <v-list-item-content>
                    <v-list-item-title>Set {{ index + 1 }}</v-list-item-title>
                    <v-list-item-subtitle>
                        <v-row>
                            <v-col cols="3"><input type="checkbox" v-model="set.complete" name="complete"
                                    aria-label="" />
                            </v-col>
                            <v-col cols="3"><input type="number" v-model="set.reps" name="reps" aria-label=""></v-col>
                            <v-col cols="3"><input type="number" v-model="set.weight" name="weight"
                                    aria-label=""></v-col>
                            <v-col cols="3">
                                <select v-model="set.rir" name="rir">
                                    <option v-for="rir in [5, 4, 3, 2, 1, 0]" :key="rir" :value="rir">{{ 'RIR ' + rir }}
                                    </option>
                                </select>
                            </v-col>
                        </v-row>
                    </v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>
        </v-list>
    </div>
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
                }
            ]
        }
    }
});
</script>