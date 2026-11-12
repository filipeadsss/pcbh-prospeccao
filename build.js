// Gera public/config.js a partir das variáveis de ambiente da Vercel.
// São os valores públicos do app da Web do Firebase (não são segredos); a proteção está em firestore.rules.
const fs = require('fs');
const cfg = {
  apiKey: process.env.FIREBASE_API_KEY || '',
  authDomain: process.env.FIREBASE_AUTH_DOMAIN || '',
  projectId: process.env.FIREBASE_PROJECT_ID || '',
  appId: process.env.FIREBASE_APP_ID || '',
};
fs.writeFileSync('public/config.js', 'window.PCBH_CONFIG=' + JSON.stringify(cfg) + ';\n');
console.log(cfg.apiKey ? 'config.js gerado.' : 'AVISO: variáveis do Firebase não definidas; o site vai mostrar "configuração pendente".');
