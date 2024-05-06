<template>
    <v-app>
        <v-main class="pa-4">
        <router-view />
        </v-main>
        <bottom-navigation />
    </v-app>
</template>

<script setup>
import BottomNavigation from '../components/BottomNavigation.vue'
</script>