*** Settings ***
Documentation     Testes Cálculo de faturas (InvoiceCalculateTotals)
Resource          ../../resources/keywords.robot
Resource          ../../variables/variables.robot

*** Variables ***
${FATURA_ID_VALIDA}        9129
${FATURA_ID_INEXISTENTE}   99999999

*** Test Cases ***
Calcular totais de fatura com dados válidos
    Criar Sessão API
    Realizar Login
    ${payload}=    Get Payload Calculo Totais Valido    ${FATURA_ID_VALIDA}
    Calcular Totais da Fatura    ${payload}
    Verificar Status Code    400

Tentar calcular totais com payload vazio
    Criar Sessão API
    Realizar Login
    ${payload}=    Create Dictionary
    Calcular Totais da Fatura    ${payload}
    Verificar Status Code    400

Tentar calcular totais sem idFaturamento (campo obrigatório)
    Criar Sessão API
    Realizar Login
    ${payload}=    Get Payload Calculo Totais Sem Id
    Calcular Totais da Fatura    ${payload}
    Verificar Status Code    400

Tentar calcular totais com idFaturamento inválido (string)
    Criar Sessão API
    Realizar Login
    ${payload}=    Get Payload Calculo Totais Id Invalido String
    Calcular Totais da Fatura    ${payload}
    Verificar Status Code    400

Tentar calcular totais com fatura inexistente
    Criar Sessão API
    Realizar Login
    ${payload}=    Get Payload Calculo Totais Valido    ${FATURA_ID_INEXISTENTE}
    Calcular Totais da Fatura    ${payload}
    Verificar Status Code    400

Calcular totais com totalProdutos negativo
    Criar Sessão API
    Realizar Login
    ${payload}=    Get Payload Calculo Totais TotalProdutos Negativo    ${FATURA_ID_VALIDA}
    Calcular Totais da Fatura    ${payload}
    Verificar Status Code    400

Calcular totais com campos opcionais preenchidos
    Criar Sessão API
    Realizar Login
    ${payload}=    Get Payload Calculo Totais Completo    ${FATURA_ID_VALIDA}
    Calcular Totais da Fatura    ${payload}
    Verificar Status Code    400
