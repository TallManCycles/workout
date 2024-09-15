<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title>
            <h1>Add Exercise</h1>
          </v-card-title>
          <v-card-text>
            <v-form @submit.prevent="addExercise">
              <v-text-field
                v-model="description"
                label="Description"
                required
              ></v-text-field>
              <v-select
                v-model="selectedPrimaryMuscleGroup"
                :items="primaryMuscleGroups"
                item-title="description"
                label="Select Muslce Group"
                return-object
              ></v-select>
              <v-progress-circular v-if="loading"
                indeterminate
                ></v-progress-circular>
              <v-btn v-else type="submit" color="primary">Add Exercise 
                <v-icon v-if="success"
                    icon="mdi-checkbox-marked-circle"
                    end
              ></v-icon>
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { defineComponent } from 'vue';
import { supabase } from '../data/supabase';

export default {
  data() {
    return {
      description: '',
      primaryMuscleGroups: [],
      selectedPrimaryMuscleGroup: null,
      loading: false,
        success: false
    }
  },
  methods: {
    async addExercise() {
        this.loading = true;
        const { data, error } = await supabase
            .from('exercises')
            .insert({
                description: this.description,
                primary_muscle_group: this.selectedPrimaryMuscleGroup.id
            })
            .select()
            
        if (!error && data) {
            this.success = true;
            setTimeout(() => {
               this.success = false; 
            }, 10000);
        } else {
            alert('There was an error adding the exercise');
        } 
        
        this.loading = false;
    },
    async loadPrimaryMuscleGroups() {        
        const { data, error } = await supabase
        .from('musclegroup')
        .select()
        .order('description', { ascending: true });
        
        this.primaryMuscleGroups = data;
    }
  },
    mounted() {
        this.loading = true;
        this.loadPrimaryMuscleGroups();
        this.loading = false;
    }
}
</script>

<style scoped>
.v-card {
  margin-top: 20px;
}
</style>