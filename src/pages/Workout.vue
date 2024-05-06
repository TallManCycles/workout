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
            ]
        }
    },
    methods: {
        openExercise(name) {
            this.$router.push({ name: 'exercise', params: { description: name } });
        }
    }
}
</script>