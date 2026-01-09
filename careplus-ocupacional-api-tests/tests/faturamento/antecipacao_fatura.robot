*** Settings ***
Documentation     Testes - GetInvoiceAdvanceById
Resource          ../../resources/keywords.robot
Resource          ../../variables/variables.robot

*** Variables ***
${ID_ANTECIPACAO_VALIDO}        11819
${ID_ANTECIPACAO_INEXISTENTE}   999999999
${ID_ANTECIPACAO_INVALIDO}      abc

*** Test Cases ***
Cenario: Buscar antecipação de fatura por ID válido
    Criar Sessão API
    Realizar Login
    Buscar Antecipacao Por Id (GetInvoiceAdvanceById)    ${ID_ANTECIPACAO_VALIDO}
    Verificar Status Code    400

Cenario: Buscar antecipação de fatura por ID inexistente
    Criar Sessão API
    Realizar Login
    Buscar Antecipacao Por Id (GetInvoiceAdvanceById)    ${ID_ANTECIPACAO_INEXISTENTE}
    Verificar Status Code    400

Cenario: Buscar antecipação de fatura com ID inválido
    Criar Sessão API
    Realizar Login
    Buscar Antecipacao Por Id (GetInvoiceAdvanceById)    ${ID_ANTECIPACAO_INVALIDO}
    Verificar Status Code    400