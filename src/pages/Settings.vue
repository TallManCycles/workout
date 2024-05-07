//add some basic user settings including name, age, and weight, and a button to save the settings

<template>
    <v-main>
        <h1 class="text-center">Settings</h1>
        <v-container>
            <v-row>
                <v-col cols="12">
                    <v-text-field v-model="name" label="Name"></v-text-field>
                </v-col>
                <v-col cols="12">
                    <v-text-field v-model="age" label="Age"></v-text-field>
                </v-col>
                <v-col cols="12">
                    <v-text-field v-model="weight" label="Weight"></v-text-field>
                </v-col>
                <v-col cols="12">
                    <v-btn @click="saveSettings">Save</v-btn>
                </v-col>
            </v-row>
        </v-container>
    </v-main>
</template>