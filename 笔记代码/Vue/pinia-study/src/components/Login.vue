<script setup lang='ts'>
import { useTokenStore} from '../stores/token'
const tokenStore = useTokenStore()
const getToken = () => {
    console.log(tokenStore.getToken())
}
</script>

<template>
<button @click="getToken">点我获取token</button>
</template>

<style scoped>

</style>