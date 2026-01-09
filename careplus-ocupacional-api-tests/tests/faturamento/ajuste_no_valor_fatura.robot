*** Settings ***
Documentation    Testes de Ajuste no Valor da Fatura
Resource         ../../resources/keywords.robot
Resource         ../../variables/variables.robot

*** Test Cases ***

Inserir ajuste com dados válidos
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    ${payload}=    Gerar Payload Ajuste    1    202509    10    5    Descrição válida    1
    Inserir Ajuste na Fatura    ${payload}
    Verificar Status Code    400


Tentar inserir ajuste com fatura inexistente
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    ${payload}=    Gerar Payload Ajuste    999999    202509    10    5    Fatura inválida    1
    Inserir Ajuste na Fatura    ${payload}
    Verificar Status Code    400


Inserir ajuste com valor negativo
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    ${payload}=    Gerar Payload Ajuste    1    202509    -10    -5    Valores negativos    1
    Inserir Ajuste na Fatura    ${payload}
    Verificar Status Code    400


Inserir ajuste com tipo inválido
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    ${payload}=    Gerar Payload Ajuste    1    202509    10    5    Tipo inválido    1    INVALIDO
    Inserir Ajuste na Fatura    ${payload}
    Verificar Status Code    400


Inserir ajuste com valor zero
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    ${payload}=    Gerar Payload Ajuste    1    202509    0    0    Valor zero    1
    Inserir Ajuste na Fatura    ${payload}
    Verificar Status Code    400


Inserir ajuste tipo DÉBITO
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    ${payload}=    Gerar Payload Ajuste    1    202509    15    0    Débito válido    1    DEBITO
    Inserir Ajuste na Fatura    ${payload}
    Verificar Status Code    400


Inserir ajuste tipo CRÉDITO
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    ${payload}=    Gerar Payload Ajuste    1    202509    0    15    Crédito válido    1    CREDITO
    Inserir Ajuste na Fatura    ${payload}
    Verificar Status Code    400

Inserir ajuste com data futura
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    ${payload}=    Gerar Payload Ajuste    1    209912    10    5    Data futura    1
    Inserir Ajuste na Fatura    ${payload}
    Verificar Status Code    400


Inserir ajuste com campos vazios
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    ${payload}=    Create Dictionary
    Inserir Ajuste na Fatura    ${payload}
    Verificar Status Code    400