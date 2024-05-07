<template>
    <h1 class="text-center">{{ id }}</h1>
    <v-list lines="two">
        <v-list-item v-for="(exercise, index) in exercises" :key="index">

            <template v-slot:prepend>
                <v-avatar color="grey-lighten-1">
                    <v-icon color="white">mdi-dumbbell</v-icon>
                </v-avatar>
            </template>

            <template v-slot:append>
                <v-btn color="grey-lighten-1" icon="mdi-chevron-right" variant="text"></v-btn>
            </template>


            <v-list-item-content @click="openExercise(exercise.name)">
                <v-list-item-title>{{ exercise.name }}</v-list-item-title>
                <v-list-item-subtitle>Sets: {{ exercise.sets }} RIR: {{ exercise.rir }}</v-list-item-subtitle>
            </v-list-item-content>
        </v-list-item>
    </v-list>
    <v-btn color="success" block @click="dialog = true">Finish workout</v-btn>
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

<script>
export default {
    props: {
        id: {
            type: String,
            required: true
        }
    },
    data() {
        return {
            exercises: [
                { id: 1, name: 'Bench Press', sets: 5, rir: 2 },
                { id: 2, name: 'Shoulder Press', sets: 3, rir: 3 },
                { id: 3, name: 'Squat', sets: 4, rir: 1 },
                { id: 4, name: 'Deadlift', sets: 3, rir: 2 },
                { id: 5, name: 'Pull-up', sets: 3, rir: 3 },
                { id: 6, name: 'Dumbbell Curl', sets: 4, rir: 2 }
            ],
            dialog: false
        }
    },
    methods: {
        openExercise(name) {
            this.$router.push({ name: 'exercise', params: { description: name } });
        },
        finishWorkout() {
            this.dialog = false;
            this.$router.push({ name: 'finish' });
        }
    }
}
</script>