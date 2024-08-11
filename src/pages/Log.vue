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

<script lang="ts">
import { ref, onMounted } from 'vue';
import { supabase } from '../data/supabase';
import { Log } from '../types/Log';

export default {
  name: 'Log',
  setup() {
    const log = ref<Log[]>([]);

    const fetchLogs = async () => {
      const { data, error } = await supabase
        .from('workout')
        .select('date, description');

      if (error) {
        console.error('Error fetching logs:', error);
      } else {
        log.value = data;
      }
    };

    const formatDate = (timestamp: number) => {
      const date = new Date(timestamp);
      const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
      const day = date.getDate();
      const monthIndex = date.getMonth();
      const monthName = monthNames[monthIndex];
      return `${monthName} ${day}`;
    };

    onMounted(fetchLogs);

    return {
      log,
      formatDate,
    };
  },
};
</script>