# CRM de Prospecção PCBH

Kanban para as vendedoras da PCBH Informática ligarem para a lista de prospecção (pizzarias, hamburguerias, lanchonetes, restaurantes e farmácias de BH e região) e marcarem cada lead como **Novo lead**, **Interesse futuro**, **Interesse real** ou **Não tem interesse**.

Site estático (`public/index.html`) na Vercel; login e banco no Supabase. A lista de 439 leads (telefone, endereço, Google, site, Instagram e horário de funcionamento) vem embutida na página; o banco guarda só as marcações, observações e tentativas.

## Montagem (uma vez)

1. **Supabase**: crie um projeto novo. Em *Authentication > Sign In / Providers > Email*, desligue **Allow new users to sign up**.
2. Em *Authentication > Users > Add user*, crie um usuário (e-mail + senha, com *Auto Confirm User*) para cada pessoa: Filipe, Flávia e Yasmin.
3. Edite `supabase/schema.sql` (e-mails e nomes no final) e rode no *SQL Editor*.
4. Em *Project Settings > API*, copie **Project URL** e a chave **anon public**.
5. **Vercel**: *Add New > Project*, importe este repositório (Framework Preset: Other). Em *Environment Variables* crie `SUPABASE_URL` e `SUPABASE_ANON_KEY`. Faça o deploy.

Para liberar uma pessoa nova depois: crie o usuário no Supabase e acrescente o e-mail na tabela `allowed_users`.

## Segurança

- A chave `anon` é pública por desenho. Quem protege os dados é a política de acesso (RLS) do `schema.sql`: só e-mails da tabela `allowed_users` leem ou gravam.
- Cadastro público desligado: ninguém cria conta sozinho.
- A página tem `noindex` e não aparece no Google.

## Dados

Tabela `docs (collection, id, data jsonb)`. Cada marcação fica em `collection = 'estado'`, `id` = código do lead no Google Maps, com `st` (novo, futuro, real, nao), data, quem moveu, observações, tentativas e histórico.
Backup: *Table Editor > docs > Export*. As exportações para Meta Ads e para o CRM saem pelo botão **Exportar leads** do próprio site.
