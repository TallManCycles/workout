//add some basic user settings including name, age, and weight, and a button to save the settings

<template>
    <v-main>
        <v-alert v-if="error" type="error" closable>{{ error }}</v-alert>
        <v-alert v-if="success" type="success" closable>{{ success }}</v-alert>
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
                    <v-text-field v-model="restInterval" label="Rest Interval"></v-text-field>
                </v-col>
                <v-col cols="12">
                    <v-btn @click="saveSettings">Save</v-btn>
                </v-col>
            </v-row>
        </v-container>
    </v-main>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import { supabase } from '../data/supabase';

export default defineComponent({
    data() {
        return {
            id: '',
            name: '',
            age: '',
            weight: '',
            restInterval: 60,
            error: '',
            success: ''
        }
    },
    methods: {
        async saveSettings() {
            if (this.id === '') {
                await supabase
                    .from('usersettings')
                    .insert(
                        {
                            name: this.name,
                            age: this.age,
                            weight: this.weight,
                            restInterval: this.restInterval
                        }
                    );
            } else {
                await supabase
                    .from('usersettings')
                    .update({
                        name: this.name,
                        age: this.age,
                        weight: this.weight,
                        restInterval: this.restInterval
                    })
                    .eq('id', this.id);
            }

            // Show a confirmation that the settings have been saved
            this.success = 'Settings saved successfully';
        },
        async loadSettings() {
            const {data, error} = await supabase
                .from('usersettings')
                .select('*')
                .single();
        
            if (error) {
                this.error = 'An error occurred while loading the settings';
                console.error(error);
            } else {
                if (data === null) {
                    return;
                }

                this.id = data.id;
                this.name = data.name;
                this.age = data.age;
                this.weight = data.weight;
                this.restInterval = data.restInterval;
            }
        }
    },
    async mounted() {
        await this.loadSettings();
    }
});
</script>