# Scripts de Desenvolvimento e Deploy

Esta pasta contém todos os scripts utilizados no projeto, organizados nas seguintes categorias:

## Estrutura de Diretórios

```
scripts/
├── setup/           # Scripts de configuração inicial
│   ├── setup-node16.sh
│   ├── setup-node18.sh
│   └── setup-server.sh
├── dev/             # Scripts de desenvolvimento
│   ├── dev.sh
│   └── build.sh
├── deploy/          # Scripts de deploy
│   ├── deploy-canary.sh
│   ├── promote-to-stable.sh
│   └── create-repository.sh
└── utils/           # Scripts utilitários
    ├── test-docker-login.sh
    └── init-scripts/
        ├── init_script_canary.sh
        └── init_script_stable.sh
```

## Como Usar

1. Todos os scripts devem ser executados da raiz do projeto
2. Certifique-se de que os scripts têm permissão de execução:
   ```bash
   chmod +x scripts/**/*.sh
   ```