<template>
  <div class="viewer-page">
    <header class="topbar">
      <button class="back" @click="$router.push('/')">
        <span class="arrow">←</span> 返回病例列表
      </button>
      <div class="case-info">
        <span v-if="caseInfo" class="p-name">{{ caseInfo.patient_name }}</span>
        <span v-if="caseInfo" class="p-meta">{{ caseInfo.gender }} · {{ caseInfo.age }} 岁</span>
        <span v-if="caseInfo" class="p-sep"></span>
        <span v-if="caseInfo" class="p-meta">检查号 {{ caseInfo.patient_id }}</span>
        <span v-if="caseInfo" class="p-desc">{{ caseInfo.study_desc }}</span>
      </div>
      <div class="env-tag"><i class="env-dot"></i>本地演示环境</div>
    </header>
    <div class="body">
      <VolumeViewer :case-id="caseId" />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import VolumeViewer from '../components/VolumeViewer.vue'
import { api } from '../api'

const route = useRoute()
const caseId = computed(() => route.params.caseId)
const caseInfo = ref(null)

onMounted(async () => {
  try {
    caseInfo.value = await api.getCase(caseId.value)
  } catch (e) {
    /* 继续，查看页不阻塞 */
  }
})
</script>

<style scoped>
.viewer-page {
  height: 100%;
  display: flex;
  flex-direction: column;
  background: #04090f;
  color: #dceefc;
  font-family: 'Microsoft YaHei UI', 'Microsoft YaHei', system-ui, sans-serif;
  color-scheme: dark;
}
.topbar {
  position: relative;
  display: flex; align-items: center; gap: 16px;
  min-height: 50px; padding: 8px 16px;
  background: linear-gradient(180deg, rgba(9, 22, 36, .96), rgba(6, 13, 22, .9));
  backdrop-filter: blur(14px);
  border-bottom: 1px solid rgba(60, 170, 240, .13);
  box-shadow: 0 12px 30px rgba(2, 6, 12, .58);
}
.topbar::after {
  content: '';
  position: absolute; left: 0; right: 0; bottom: -1px; height: 1px;
  background: linear-gradient(90deg, rgba(41, 224, 255, .5), rgba(139, 124, 246, .4) 55%, transparent 88%);
}
.back {
  display: flex; align-items: center; gap: 6px;
  height: 30px; padding: 0 13px 0 10px; cursor: pointer;
  border: 1px solid rgba(90, 180, 240, .28);
  border-radius: 3px;
  background: rgba(10, 24, 40, .6);
  color: #a8c4da; font-size: 12px; letter-spacing: .02em;
  transition: .16s;
}
.back:hover {
  border-color: rgba(41, 224, 255, .62); color: #eafaff;
  background: rgba(41, 224, 255, .08);
  box-shadow: 0 0 20px rgba(41, 224, 255, .2);
}
.back .arrow { font-size: 13px; line-height: 1; color: #6fd6f5; }

.case-info { flex: 1; display: flex; align-items: center; gap: 11px; min-width: 0; }
.p-name {
  font-size: 15px; font-weight: 700; letter-spacing: .05em;
  background: linear-gradient(100deg, #f4fdff 18%, #96e6ff 100%);
  -webkit-background-clip: text; background-clip: text; color: transparent;
}
.p-meta { font-size: 11.5px; color: #93b4cd; letter-spacing: .03em; }
.p-sep { width: 1px; height: 15px; background: linear-gradient(180deg, transparent, rgba(90, 180, 240, .5), transparent); }
.p-desc {
  padding: 2px 9px; border-radius: 3px;
  font-size: 11px; letter-spacing: .03em; color: #a5e8ff;
  background: rgba(41, 224, 255, .08);
  box-shadow: inset 0 0 0 1px rgba(41, 224, 255, .28);
  white-space: nowrap;
}
.env-tag {
  display: flex; align-items: center; gap: 7px;
  padding: 4px 11px; border-radius: 999px;
  font-size: 10.5px; letter-spacing: .06em; color: #85b8a8;
  background: rgba(11, 26, 42, .62);
  border: 1px solid rgba(90, 180, 240, .14);
  white-space: nowrap;
}
.env-dot {
  width: 5px; height: 5px; border-radius: 50%;
  background: #2ee6a8; box-shadow: 0 0 8px rgba(46, 230, 168, .8);
  animation: envPulse 2.4s ease-in-out infinite;
}
@keyframes envPulse { 0%, 100% { opacity: .35; } 50% { opacity: 1; } }

.dim { font-size: 12px; color: #7e93a8; font-weight: 400; }
.body { flex: 1; min-height: 0; }
</style>
