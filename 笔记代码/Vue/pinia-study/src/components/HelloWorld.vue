<script setup lang='ts'>
import {useTokenStore} from '../stores/token'
const tokenStore= useTokenStore()
const changeToken = () => {
  const newToken = Math.floor(Math.random() * 101)
  tokenStore.setToken(newToken)
  console.log(tokenStore.getToken());
}
</script>

<template>
  <div>
    <button @click="changeToken">点我设置token</button>
  </div>
</template>

<style scoped>

</style>