*** Settings ***
Documentation    Teste de Cancelamento de fatura
Resource         ../../resources/keywords.robot
Resource         ../../variables/variables.robot
Test Setup       Preparar Contexto Para Liberar Fatura

*** Variables ***
${FATURA_ID_LIBERADA}    12506
${FATURA_ID_CANCELADO}   11946
${FATURA_ID_AGUARDANDO}  4041
${FATURA_ID_ANALISE}     11819
${FATURA_ID_INVALIDO}    abc123

*** Test Cases ***
Cenario: Cancelar fatura com status AGUARDANDO_RESPOSTA
    Set Suite Variable    ${FATURA_ID}    ${FATURA_ID_AGUARDANDO}
    Executar Ação na Fatura    C
    Verificar Status Code    400

Cenario: Cancelar fatura com status LIBERADO
    Set Suite Variable    ${FATURA_ID}    ${FATURA_ID_LIBERADA}
    Executar Ação na Fatura    C
    Verificar Status Code    200

Cenario: Cancelar fatura com status ANALISE
    Set Suite Variable    ${FATURA_ID}    ${FATURA_ID_ANALISE}
    Executar Ação na Fatura    C
    Verificar Status Code    200

Cenario: Tentar cancelar fatura com ID invalido (string)
    Set Suite Variable    ${FATURA_ID}    ${FATURA_ID_INVALIDO}
    Executar Ação na Fatura    C
    Verificar Status Code    400

Cenario: Tentar cancelar fatura ja cancelada
    Set Suite Variable    ${FATURA_ID}    ${FATURA_ID_CANCELADO} 
    Executar Ação na Fatura    C
    Verificar Status Code    400