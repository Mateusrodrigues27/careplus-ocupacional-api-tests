*** Settings ***
Documentation     Testes de consulta de faturas por parâmetros
Resource          ../../resources/keywords.robot
Resource          ../../variables/variables.robot
Test Setup        Preparar Contexto Para Liberar Fatura

*** Variables ***
${DATA_VALIDA_INICIO}    2024-01-01
${DATA_VALIDA_FIM}       2024-12-31
${DATA_INVALIDA_INICIO}  2025-13-01
${DATA_INVALIDA_FIM}     2025-31-02

*** Test Cases ***
Cenario: Buscar faturas com datas válidas
    Consultar Fatura Por Parâmetros    ${DATA_VALIDA_INICIO}    ${DATA_VALIDA_FIM}
    Verificar Status Code    200

Cenario: Buscar faturas com datas inválidas
    Consultar Fatura Por Parâmetros    ${DATA_INVALIDA_INICIO}    ${DATA_INVALIDA_FIM}
    Verificar Status Code    200

Cenario: Tentar consulta sem parâmetros obrigatórios
    Consultar Fatura Por Parâmetros 
    Verificar Status Code    200

Cenario: Buscar fatura com intervalo de mais de 1 ano
    Consultar Fatura Por Parâmetros    2020-01-01    2025-01-01
    Verificar Status Code    200