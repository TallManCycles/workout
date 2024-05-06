<template>
        <h1 class="text-center">Workout Log</h1>
        <v-timeline align="start" side="end" density="comfortable">
                <v-timeline-item v-for="(item, index) in log" :key="index" dot-color="primary" class="pa-3">
                        <div>
                                <strong>{{ formatDate(item.date) }}</strong>
                                <div class="text-caption">
                                        {{ item.description }}
                                </div>
                        </div>
                </v-timeline-item>
        </v-timeline>
</template>

<script lang="ts" setup>
import { ref, Ref } from 'vue'
import { Log } from '../types/Log'

const log: Ref<Log[]> = ref([
        {
                date: Date.now(),
                description: 'Upper Workout #2'
        },
        {
                date: Date.now() - 2 * 24 * 60 * 60 * 1000,
                description: 'Lower Workout #1'
        },
        {
                date: Date.now() - 4 * 24 * 60 * 60 * 1000,
                description: 'Cardio Workout #1'
        },
        {
                date: Date.now() - 6 * 24 * 60 * 60 * 1000,
                description: 'Upper Workout #1'
        },
        {
                date: Date.now() - 8 * 24 * 60 * 60 * 1000,
                description: 'Lower Workout #2'
        },
        {
                date: Date.now() - 10 * 24 * 60 * 60 * 1000,
                description: 'Cardio Workout #2'
        },
        {
                date: Date.now() - 12 * 24 * 60 * 60 * 1000,
                description: 'Upper Workout #2'
        },
        {
                date: Date.now() - 14 * 24 * 60 * 60 * 1000,
                description: 'Lower Workout #1'
        },
        {
                date: Date.now() - 16 * 24 * 60 * 60 * 1000,
                description: 'Cardio Workout #1'
        },
        {
                date: Date.now() - 18 * 24 * 60 * 60 * 1000,
                description: 'Upper Workout #1'
        },
        {
                date: Date.now() - 20 * 24 * 60 * 60 * 1000,
                description: 'Lower Workout #2'
        },
        {
                date: Date.now() - 22 * 24 * 60 * 60 * 1000,
                description: 'Cardio Workout #2'
        },
        {
                date: Date.now() - 24 * 24 * 60 * 60 * 1000,
                description: 'Upper Workout #2'
        },
        {
                date: Date.now() - 26 * 24 * 60 * 60 * 1000,
                description: 'Lower Workout #1'
        },
        {
                date: Date.now() - 28 * 24 * 60 * 60 * 1000,
                description: 'Cardio Workout #1'
        },
        {
                date: Date.now() - 30 * 24 * 60 * 60 * 1000,
                description: 'Upper Workout #1'
        },
        {
                date: Date.now() - 32 * 24 * 60 * 60 * 1000,
                description: 'Lower Workout #2'
        },
])

const formatDate = (timestamp) => {
        const date = new Date(timestamp)
        const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        const day = date.getDate()
        const monthIndex = date.getMonth()
        const monthName = monthNames[monthIndex]
        return `${monthName} ${day}`
}
</script>