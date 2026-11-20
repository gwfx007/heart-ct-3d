<template>
  <div class="login-wrap">
    <div class="bg-grid" aria-hidden="true"></div>
    <div class="halo" aria-hidden="true">
      <span class="ring r1"></span>
      <span class="ring r2"></span>
      <span class="pulse"></span>
    </div>
    <div class="scan" aria-hidden="true"></div>

    <div class="login-card">
      <i class="corner tl" aria-hidden="true"></i>
      <i class="corner tr" aria-hidden="true"></i>
      <i class="corner bl" aria-hidden="true"></i>
      <i class="corner br" aria-hidden="true"></i>

      <div class="logo" aria-hidden="true">
        <svg viewBox="0 0 24 24" width="20" height="20">
          <rect x="10" y="5" width="4" height="14" rx="1" />
          <rect x="5" y="10" width="14" height="4" rx="1" />
        </svg>
      </div>
      <h1>心脏CT 3D可视化医疗辅助系统</h1>
      <p class="sub">HEART CT · 3D VISUALIZATION &amp; AI DIAGNOSIS</p>
      <form @submit.prevent="doLogin">
        <div class="field">
          <label>用户名<span>ACCESS ID</span></label>
          <input v-model="username" placeholder="请输入用户名" />
        </div>
        <div class="field">
          <label>密码<span>PASSPHRASE</span></label>
          <input v-model="password" type="password" placeholder="请输入密码" />
        </div>
        <p v-if="error" class="error">{{ error }}</p>
        <button class="submit" :disabled="loading">{{ loading ? '登录中...' : '登 录' }}</button>
      </form>
      <p class="tip">演示账号 root / root</p>
      <a class="intro" href="/landing/index.html">了解本系统 · 查看介绍页 →</a>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { api } from '../api'

const router = useRouter()
const username = ref('root')
const password = ref('root')
const error = ref('')
const loading = ref(false)

async function doLogin() {
  error.value = ''
  loading.value = true
  try {
    const res = await api.login(username.value, password.value)
    localStorage.setItem('token', res.token)
    localStorage.setItem('user', JSON.stringify(res.user))
    router.push('/')
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-wrap {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
  color-scheme: dark;
  background:
    radial-gradient(circle at 50% 34%, #10395b 0%, #0a2038 26%, #061222 52%, #03070e 100%);
  font-family: 'Microsoft YaHei UI', 'Microsoft YaHei', system-ui, sans-serif;
}
.login-wrap::after {
  content: '';
  position: absolute; inset: 0; pointer-events: none;
  background:
    radial-gradient(circle at 50% 118%, rgba(122, 92, 240, .26), transparent 48%),
    radial-gradient(circle at 8% 92%, rgba(41, 224, 255, .1), transparent 34%);
}

/* 点阵 + 网格 */
.bg-grid {
  position: absolute; inset: 0; pointer-events: none;
  background-image:
    linear-gradient(rgba(88, 196, 255, .13) 1px, transparent 1px),
    linear-gradient(90deg, rgba(88, 196, 255, .13) 1px, transparent 1px),
    radial-gradient(rgba(150, 235, 255, .2) 1px, transparent 1px);
  background-size: 58px 58px, 58px 58px, 14px 14px;
  mask-image: radial-gradient(circle at 50% 46%, #000 0%, rgba(0, 0, 0, .8) 40%, rgba(0, 0, 0, .3) 66%, transparent 88%);
  -webkit-mask-image: radial-gradient(circle at 50% 46%, #000 0%, rgba(0, 0, 0, .8) 40%, rgba(0, 0, 0, .3) 66%, transparent 88%);
}

/* 全息双环 */
.halo {
  position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%);
  width: 700px; height: 700px; pointer-events: none;
  display: flex; align-items: center; justify-content: center;
}
.halo::before {
  content: '';
  position: absolute; width: 600px; height: 600px; border-radius: 50%;
  background: repeating-conic-gradient(from 0deg, rgba(41, 224, 255, .3) 0 .7deg, transparent .7deg 5deg);
  mask-image: radial-gradient(circle, transparent 0 294px, #000 295px 297px, transparent 298px);
  -webkit-mask-image: radial-gradient(circle, transparent 0 294px, #000 295px 297px, transparent 298px);
  opacity: .55;
  animation: spin 40s linear infinite reverse;
}
.halo::after {
  content: '';
  position: absolute; width: 620px; height: 620px; border-radius: 50%;
  border: 1px solid rgba(41, 224, 255, .1);
  box-shadow: inset 0 0 60px rgba(41, 224, 255, .06);
}
.ring { position: absolute; border-radius: 50%; }
.ring.r1 {
  width: 640px; height: 640px;
  background: conic-gradient(from 0deg, transparent 0deg, rgba(41, 224, 255, .55) 30deg, transparent 96deg,
    transparent 180deg, rgba(139, 124, 246, .45) 214deg, transparent 280deg);
  mask-image: radial-gradient(circle at 50% 50%, transparent 0 309px, #000 310px 318px, transparent 319px);
  -webkit-mask-image: radial-gradient(circle at 50% 50%, transparent 0 309px, #000 310px 318px, transparent 319px);
  animation: spin 22s linear infinite;
}
.ring.r2 {
  width: 500px; height: 500px;
  background: conic-gradient(from 0deg, transparent 0deg, rgba(46, 230, 168, .45) 22deg, transparent 86deg,
    transparent 190deg, rgba(41, 224, 255, .3) 216deg, transparent 262deg);
  mask-image: radial-gradient(circle at 50% 50%, transparent 0 241px, #000 242px 249px, transparent 250px);
  -webkit-mask-image: radial-gradient(circle at 50% 50%, transparent 0 241px, #000 242px 249px, transparent 250px);
  animation: spin 13s linear infinite reverse;
}
.pulse {
  position: absolute; width: 96px; height: 96px; border-radius: 50%;
  border: 1px solid rgba(41, 224, 255, .5);
  animation: pulseRing 3.6s ease-out infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }
@keyframes pulseRing {
  0% { transform: scale(.55); opacity: .5; }
  70% { opacity: 0; }
  100% { transform: scale(2.4); opacity: 0; }
}

/* 扫描光带 */
.scan {
  position: absolute; left: 0; right: 0; height: 120px; pointer-events: none;
  background: linear-gradient(180deg, transparent, rgba(41, 224, 255, .1), transparent);
  animation: scanMove 9s linear infinite;
}
@keyframes scanMove {
  0% { transform: translateY(-140px); }
  100% { transform: translateY(110vh); }
}

/* 卡片 */
.login-card {
  position: relative;
  width: 404px;
  padding: 40px 34px 28px;
  border-radius: 5px;
  background: linear-gradient(165deg, rgba(17, 40, 63, .9), rgba(7, 15, 26, .96));
  box-shadow:
    0 0 0 1px rgba(41, 224, 255, .2),
    0 34px 90px rgba(0, 0, 0, .74),
    0 0 74px rgba(30, 140, 220, .13),
    inset 0 1px 0 rgba(168, 228, 255, .14);
  backdrop-filter: blur(16px) saturate(125%);
}
.login-card::before {
  content: '';
  position: absolute; left: 0; right: 0; top: 0; height: 1px;
  background: linear-gradient(90deg, transparent, rgba(41, 224, 255, .85), rgba(139, 124, 246, .7), transparent);
}
.login-card::after {
  content: '';
  position: absolute; left: 0; right: 0; bottom: 0; height: 1px;
  background: linear-gradient(90deg, transparent, rgba(41, 224, 255, .22), transparent);
}

/* 四角 HUD 角标 */
.corner { position: absolute; width: 18px; height: 18px; }
.corner.tl { left: -1px; top: -1px; border-left: 1.5px solid rgba(41, 224, 255, .95); border-top: 1.5px solid rgba(41, 224, 255, .95); box-shadow: -2px -2px 12px rgba(41, 224, 255, .18); }
.corner.tr { right: -1px; top: -1px; border-right: 1.5px solid rgba(139, 124, 246, .9); border-top: 1.5px solid rgba(139, 124, 246, .9); }
.corner.bl { left: -1px; bottom: -1px; border-left: 1.5px solid rgba(139, 124, 246, .6); border-bottom: 1.5px solid rgba(139, 124, 246, .6); }
.corner.br { right: -1px; bottom: -1px; border-right: 1.5px solid rgba(41, 224, 255, .6); border-bottom: 1.5px solid rgba(41, 224, 255, .6); }

.logo {
  width: 48px; height: 48px; margin: 0 auto 18px;
  display: flex; align-items: center; justify-content: center;
  background: linear-gradient(150deg, #22d7ff, #7b5cf0);
  clip-path: polygon(11px 0, 100% 0, 100% calc(100% - 11px), calc(100% - 11px) 100%, 0 100%, 0 11px);
  box-shadow: 0 0 26px rgba(41, 224, 255, .4);
}
.logo svg { fill: #04101c; }

h1 {
  margin: 0 0 9px;
  text-align: center;
  font-size: 19px;
  font-weight: 700;
  letter-spacing: .05em;
  background: linear-gradient(100deg, #eaf7ff 12%, #8fe3ff 62%, #b6a9ff 100%);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}
.sub {
  margin: 0 0 30px;
  text-align: center;
  font-family: 'Bahnschrift', 'DIN Alternate', 'Segoe UI', sans-serif;
  font-size: 9px;
  letter-spacing: .3em;
  color: #5d86a4;
}
.field { margin-bottom: 16px; }
.field label {
  display: flex; align-items: baseline; gap: 8px;
  margin-bottom: 8px;
  font-size: 11.5px; color: #9fb8d0; letter-spacing: .06em;
}
.field label span {
  font-family: 'Bahnschrift', 'Consolas', monospace;
  font-size: 8.5px; letter-spacing: .22em;
  color: #4a7799;
}
.field input {
  width: 100%; box-sizing: border-box; height: 40px; padding: 0 14px;
  border: 1px solid rgba(110, 196, 255, .18);
  border-radius: 3px;
  background: rgba(4, 13, 22, .78);
  color: #dcefff; font-size: 13px; letter-spacing: .02em;
  outline: none; transition: border-color .18s, box-shadow .18s, background .18s;
}
.field input::placeholder { color: #41607a; }
.field input:focus {
  border-color: rgba(41, 224, 255, .62);
  background: rgba(6, 19, 32, .92);
  box-shadow: 0 0 0 3px rgba(41, 224, 255, .1), inset 0 0 18px rgba(41, 224, 255, .08);
}

.error {
  margin: 0 0 12px; padding: 8px 11px;
  font-size: 12px; color: #ffb3b3;
  background: rgba(224, 90, 90, .1);
  border: 1px solid rgba(255, 120, 120, .32);
  border-left: 2px solid rgba(255, 120, 120, .8);
  border-radius: 3px;
}

.submit {
  width: 100%; height: 42px; border: none; cursor: pointer;
  position: relative;
  clip-path: polygon(13px 0, 100% 0, 100% calc(100% - 13px), calc(100% - 13px) 100%, 0 100%, 0 13px);
  background: linear-gradient(100deg, #0fbcdf 0%, #3c8af0 46%, #6a4fe0 100%);
  color: #021018;
  font-size: 14px; font-weight: 700; letter-spacing: .32em;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, .35);
  transition: filter .18s, box-shadow .18s, transform .12s;
}
.submit:hover:not(:disabled) { filter: brightness(1.1) saturate(1.05); box-shadow: inset 0 1px 0 rgba(255, 255, 255, .4), 0 0 30px rgba(41, 224, 255, .35); }
.submit:active:not(:disabled) { transform: translateY(1px); }
.submit:disabled { background: #1b2b3d; color: #62809a; cursor: not-allowed; }

.tip {
  margin: 18px 0 0; text-align: center;
  font-family: 'Bahnschrift', 'Microsoft YaHei UI', sans-serif;
  font-size: 10.5px; letter-spacing: .12em; color: #6d92b3;
}

.intro {
  display: block; margin: 12px 0 0; text-align: center;
  font-family: 'Bahnschrift', 'Microsoft YaHei UI', sans-serif;
  font-size: 10.5px; letter-spacing: .12em;
  color: #7fb2d6; text-decoration: none;
  transition: color .18s, text-shadow .18s;
}
.intro:hover { color: #41e0ff; text-shadow: 0 0 12px rgba(41, 224, 255, .5); }
</style>
