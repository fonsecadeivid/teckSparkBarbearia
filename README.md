# 🏪 Tech Spark Barbearia

> **📋 Documentação Completa:** [PROJETO_COMPLETO.md](./PROJETO_COMPLETO.md)

## 🎯 Visão Geral

Sistema completo de gestão para barbearias, desenvolvido em Flutter com Firebase. Permite gerenciar clientes, serviços, agendamentos e fornece dashboard analytics para donos de barbearias.

## ✅ **Status do Projeto**

**IMPLEMENTAÇÃO PRINCIPAL CONCLUÍDA COM SUCESSO!**

- ✅ Estrutura de barbearias implementada
- ✅ Dashboard analytics funcionando
- ✅ Controle de acesso robusto
- ✅ Interface adaptativa por tipo de usuário
- ✅ Fluxo de cadastro completo
- ✅ Gestão de clientes e serviços
- ✅ Sistema de agendamentos

## 🏗️ **Arquitetura**

### **Estrutura de Pastas**
```
lib/
├── core/                    # Constantes, temas, utilitários
├── features/               # Funcionalidades organizadas
│   ├── auth/              # Autenticação
│   ├── barbershop/        # Gestão de barbearias
│   ├── clients/           # Gestão de clientes
│   ├── services/          # Gestão de serviços
│   ├── appointments/      # Agendamentos
│   ├── dashboard/         # Dashboard analytics
│   ├── home/              # Página inicial
│   └── profile/           # Perfil do usuário
├── shared/                # Recursos compartilhados
│   ├── models/           # Modelos de dados
│   ├── services/         # Serviços Firebase
│   ├── stores/           # Stores MobX
│   └── widgets/          # Widgets reutilizáveis
└── main.dart             # Ponto de entrada
```

## 🎨 **Interface por Tipo de Usuário**

### **Dono (`owner`)**
- 🏠 **Dashboard** - Métricas e análises
- 🏪 **Nova Barbearia** - Cadastrar barbearias
- 📅 **Agendar** - Gerenciar agendamentos
- 👥 **Clientes** - Gerenciar clientes
- ✂️ **Serviços** - Gerenciar serviços

### **Barbeiro (`barber`)**
- 📅 **Agendar** - Gerenciar agendamentos
- 👥 **Clientes** - Gerenciar clientes
- ✂️ **Serviços** - Gerenciar serviços

### **Cliente (`client`)**
- 📅 **Agendar** - Agendar serviços

## 🚀 **Como Executar**

### **Pré-requisitos**
- Flutter SDK 3.0+
- Dart 3.0+
- Firebase project configurado

### **Instalação**
```bash
# Clone o repositório
git clone https://github.com/seu-usuario/teckSparkBarbearia.git

# Entre no diretório
cd teckSparkBarbearia

# Instale as dependências
flutter pub get

# Execute o projeto
flutter run
```

### **Configuração do Firebase**
1. Crie um projeto no Firebase Console
2. Adicione as configurações do Firebase
3. Configure as regras do Firestore
4. Ative Authentication e Firestore

## 📊 **Funcionalidades Implementadas**

### ✅ **Core**
- [x] Autenticação de usuários
- [x] Controle de acesso por tipo
- [x] Gestão de barbearias
- [x] Gestão de clientes
- [x] Gestão de serviços
- [x] Sistema de agendamentos
- [x] Dashboard analytics
- [x] Interface adaptativa

### 🎯 **Em Desenvolvimento**
- [ ] Gestão de barbeiros por barbearia
- [ ] Seleção de barbearia
- [ ] Configurações de horários

### 📋 **Planejado**
- [ ] Sistema de pagamentos
- [ ] Notificações push
- [ ] Sistema de avaliações
- [ ] Promoções e cupons
- [ ] Chat interno

## 🔐 **Controle de Acesso**

O sistema implementa controle de acesso baseado em tipos de usuário:

- **Dono:** Acesso total ao sistema
- **Barbeiro:** Gestão de clientes, serviços e agendamentos
- **Cliente:** Apenas agendamentos

## 📁 **Documentação**

### **Arquivos Principais**
- [📋 PROJETO_COMPLETO.md](./PROJETO_COMPLETO.md) - **Documentação completa e atualizada**
- [🏪 ESTRUTURA_BARBEARIA.md](./ESTRUTURA_BARBEARIA.md) - Estrutura de barbearias
- [🔐 CONTROLE_ACESSO.md](./CONTROLE_ACESSO.md) - Sistema de controle de acesso
- [🎯 RESUMO_IMPLEMENTACAO.md](./RESUMO_IMPLEMENTACAO.md) - Resumo da implementação
- [🗺️ ROADMAP.md](./ROADMAP.md) - Roadmap e cronograma

## 🛠️ **Tecnologias Utilizadas**

- **Frontend:** Flutter 3.0+
- **Backend:** Firebase (Auth, Firestore, Storage)
- **State Management:** MobX
- **Dependency Injection:** Provider
- **UI/UX:** Material Design 3
- **Versionamento:** Git

## 📈 **Métricas de Progresso**

### **Funcionalidades Core (100% Concluído)**
- ✅ Autenticação
- ✅ Gestão de Barbearias
- ✅ Gestão de Clientes
- ✅ Gestão de Serviços
- ✅ Agendamentos
- ✅ Dashboard
- ✅ Controle de Acesso

### **Funcionalidades Avançadas (25% Concluído)**
- 🎯 Gestão de Barbeiros
- 📋 Sistema de Pagamentos
- 📋 Notificações
- 📋 Avaliações
- 📋 Promoções

## 🎯 **Próximos Passos**

### **Imediatos (1-2 semanas)**
1. Implementar gestão de barbeiros por barbearia
2. Criar página de listagem de barbearias
3. Implementar seleção de barbearia
4. Configurar horários de funcionamento

### **Médio Prazo (3-4 semanas)**
1. Sistema de pagamentos
2. Notificações push
3. Sistema de avaliações
4. Promoções e cupons

## 🤝 **Contribuição**

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 **Licença**

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 **Suporte**

Para suporte e dúvidas:
- 📧 Email: suporte@techspark.com
- 📱 WhatsApp: (11) 99999-9999
- 🌐 Website: https://techspark.com

---

**📋 Para informações completas e atualizadas, consulte o [PROJETO_COMPLETO.md](./PROJETO_COMPLETO.md)**

*Desenvolvido com ❤️ pela equipe Tech Spark*
