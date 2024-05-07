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
  },
  {
    path: '/settings',
    name: 'settings',
    component: () => import('../pages/Settings.vue')
  },
  {
    path: '/finish',
    name: 'finish',
    component: () => import('../pages/FinishWorkout.vue')
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: () => import('../pages/NotFound.vue')
  }
]



const router = createRouter({
  history: createWebHistory(),
  routes: routes
})

export default router
