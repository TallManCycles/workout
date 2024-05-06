import { createRouter } from 'vue-router'
import { createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'log',
    component: () => import('../pages/Log.vue')
  },
  {
    path: '/workouts',
    name: 'workouts',
    component: () => import('../pages/Workouts.vue')
  },
  {
    path: '/workouts/:id',
    name: 'workout',
    component: () => import('../pages/Workout.vue'),
    props: true
  },
  {
    path: '/exercise/:description',
    name: 'exercise',
    component: () => import('../pages/Exercise.vue'),
    props: true
  }
]



const router = createRouter({
  history: createWebHistory(),
  routes: routes
})

export default router
