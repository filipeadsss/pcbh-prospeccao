# CRM de Prospecção PCBH

Kanban para as vendedoras da PCBH Informática ligarem para a lista de prospecção (pizzarias, hamburguerias, lanchonetes, restaurantes e farmácias de BH e região) e marcarem cada lead como **Novo lead**, **Interesse futuro**, **Interesse real** ou **Não tem interesse**.

Site estático (`public/index.html`) na Vercel + Firebase (Firestore e Authentication). A lista de 439 leads (telefone, endereço, Google, site, Instagram e horário de funcionamento) vem embutida na página; o Firestore guarda só as marcações, observações e tentativas, e atualiza em tempo real para toda a equipe.

## Configuração (uma vez)

### 1. Firebase (gratuito, plano Spark)
1. Em <https://console.firebase.google.com> crie um projeto.
2. **Firestore Database** → criar banco (modo produção, região `southamerica-east1`).
3. **Authentication** → Método de login → ative **E-mail/senha** (e **Google**, se quiserem entrar com a conta Google).
4. **Authentication → Usuários → Adicionar usuário**: crie e-mail e senha do Filipe, da Flávia e da Yasmin.
5. **Authentication → Configurações → Ações do usuário**: desmarque **Ativar criação (inscrição)**, para ninguém criar conta sozinho.
6. **Configurações do projeto → Seus apps → Web (`</>`)** → registre o app e copie `apiKey`, `authDomain`, `projectId` e `appId`.
7. **Firestore → Regras**: cole o conteúdo de `firestore.rules`, **troque os três e-mails de exemplo pelos reais** e publique.

### 2. Vercel
1. Importe este repositório (Framework Preset: Other). A configuração do Firebase já está em `public/config.js`; variáveis `FIREBASE_*` na Vercel são opcionais e, se existirem, substituem o arquivo.
2. No Firebase, em *Authentication → Configurações → Domínios autorizados*, adicione o domínio da Vercel (ex.: `pcbh-prospeccao.vercel.app`).

Para liberar uma pessoa nova depois: crie o usuário no Authentication e acrescente o e-mail na lista de `firestore.rules`.

## Dados

Coleção `estado`, um documento por lead (id = código do lead no Google Maps): lista (`novo`, `futuro`, `real`, `nao`), data, quem moveu, observações, tentativas sem resposta e histórico.
As exportações para Meta Ads, para o CRM da PCBH e a planilha completa saem pelo botão **Exportar leads** do próprio site.
