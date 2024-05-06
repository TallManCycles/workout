import { createRouter } from 'vue-router'
import { createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'log',
    component: () => import('../components/LogComponent.vue')
  },
  {
    path: '/workouts',
    name: 'workouts',
    component: () => import('../components/WorkoutsComponent.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes: routes
})

export default router
