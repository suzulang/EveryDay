import {defineStore} from 'pinia'
import {ref} from 'vue'
export const useTokenStore = defineStore('token',()=>{
    const token = ref('')
    const setToken = (newToken)=> {
        token.value = newToken
    }
    const getToken = () => {
        return token.value
    }
    const clearToken = ()=> {
        token.value = ''
    }
    return {token, setToken, getToken, clearToken}
})