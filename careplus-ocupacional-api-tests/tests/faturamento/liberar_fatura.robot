*** Settings ***
Documentation     Teste de liberação de fatura
Resource          ../../resources/keywords.robot
Test Setup        Preparar Contexto Para Liberar Fatura

*** Variables ***
${FATURA_ID_ANALISE}     11809
${FATURA_ID_CANCELADO}   12187
${FATURA_ID_LIBERADA}    12526
${FATURA_ID_INVALIDO}    abcfsd

*** Test Cases ***
Cenario: Liberar fatura com status ANALISE
    Set Suite Variable    ${FATURA_ID}    ${FATURA_ID_ANALISE}
    Executar Ação na Fatura    L
    Verificar Status Code    200

Cenario: Tentar liberar fatura com status LIBERADO
    Set Suite Variable    ${FATURA_ID}    ${FATURA_ID_LIBERADA}
    Executar Ação na Fatura    L
    Verificar Status Code    200  # Precisa ser criado na regra uma validação de erro

Cenario: Tentar liberar fatura com status CANCELADO
    Set Suite Variable    ${FATURA_ID}    ${FATURA_ID_CANCELADO}
    Executar Ação na Fatura    L
    Verificar Status Code    200  # Precisa ser criado na regra uma validação de erro

Cenario: Liberar fatura com status inválido
    Set Suite Variable    ${FATURA_ID}    ${FATURA_ID_ANALISE}
    Executar Ação na Fatura    X
    Verificar Status Code    400

Cenario: Tentar liberar fatura com ID inválido
    Set Suite Variable    ${FATURA_ID}    ${FATURA_ID_INVALIDO}
    Executar Ação na Fatura    L
    Verificar Status Code    400  # Precisa ser criado na regra uma validação de erro