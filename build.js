// public/config.js já traz a configuração do app da Web do Firebase (valores públicos; a proteção está em firestore.rules).
// Se as variáveis FIREBASE_* existirem na Vercel, elas substituem o arquivo no build.
const fs = require('fs');
const cfg = {
  apiKey: process.env.FIREBASE_API_KEY || '',
  authDomain: process.env.FIREBASE_AUTH_DOMAIN || '',
  projectId: process.env.FIREBASE_PROJECT_ID || '',
  appId: process.env.FIREBASE_APP_ID || '',
};
if (cfg.apiKey && cfg.projectId && cfg.appId) {
  fs.writeFileSync('public/config.js', 'window.PCBH_CONFIG=' + JSON.stringify(cfg) + ';\n');
  console.log('config.js gerado a partir das variáveis da Vercel.');
} else {
  console.log('Usando public/config.js do repositório.');
}
