*** Settings ***
Documentation     Testes de reemissão de fatura
Resource          ../../resources/keywords.robot
Resource          ../../variables/variables.robot

*** Variables ***
${FATURA_ANALISE}           11804
${FATURA_LIBERADA}          9625
${FATURA_LIBERADA_DUPL}     9625
${FATURA_AGUARDANDO_RESP}   9588
${FATURA_INEXISTENTE}       0000
${FATURA_ID_CANCELADO}      9211

*** Test Cases ***
Cenario: Reemitir fatura com status Análise
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    Reemitir Fatura    ${FATURA_ANALISE}
    Verificar Status Code    400

Cenario: Reemitir fatura com status Cancelado
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    Reemitir Fatura    ${FATURA_ID_CANCELADO}
    Verificar Status Code    400

Cenario: Reemitir fatura com status Liberado
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    Reemitir Fatura    ${FATURA_LIBERADA}
    Verificar Status Code    400

Cenario: Tentar reemitir fatura já reemitida
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    Reemitir Fatura    ${FATURA_LIBERADA_DUPL}
    Verificar Status Code    400

Cenario: Tentar reemitir fatura com status Aguardando Resposta
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    Reemitir Fatura    ${FATURA_AGUARDANDO_RESP}
    Verificar Status Code    400

Cenario: Reemitir fatura com ID inexistente
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento
    Reemitir Fatura    ${FATURA_INEXISTENTE}
    Verificar Status Code    400
