# CarePlus – Automação de Testes API Faturamento Ocupacional

Projeto de automação de testes da **API de Faturamento Ocupacional da CarePlus**, desenvolvido em **Robot Framework**, com foco em garantir a qualidade dos principais fluxos de faturamento.

## Tecnologias
- Robot Framework
- Python 3
- RequestsLibrary


## Estrutura do Projeto
careplus-ocupacional-api-tests
├── resources
│ └── keywords.robot
├── variables
│ └── variables.robot
└── tests
└── faturamento

## Autenticação
Os testes utilizam **Developer Token**.
Authorization: <token>

## Execução dos Testes

Executar todos os testes:
robot .
Executar um módulo específico:
robot tests/faturamento
