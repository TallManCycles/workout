<template>
<v-bottom-navigation grow>
    <v-btn value="log" to="/">
      <v-icon>mdi-history</v-icon>
  
      <span>Log</span>
    </v-btn>
  
    <v-btn value="workout" to="/workouts">
      <v-icon>mdi-dumbbell</v-icon>
  
      <span>Workouts</span>
    </v-btn>
  
    <v-btn value="settings" to="/settings">
      <v-icon>mdi-cog</v-icon>
  
      <span>Settings</span>
    </v-btn>
  </v-bottom-navigation>
</template>
