*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    BuiltIn
Library    DateTime
Library    json
Resource   ../variables/variables.robot

*** Keywords ***

Preparar Contexto Para Liberar Fatura
    Criar Sessões Base
    Autenticar E Preparar Sessão Faturamento

Criar Sessões Base
    Delete All Sessions

    # AUTH (onde seu login retorna 200)
    Create Session    auth_v1      ${AUTH_API_V1}       verify=${False}

    # FATURAMENTO (onde existe UpdateStatusInvoiceReleased)
    Create Session    invoice_v1   ${INVOICE_API_V1}    verify=${False}

Autenticar E Preparar Sessão Faturamento
    ${body}=    Create Dictionary
    ...    login=${LOGIN}
    ...    orgApplicationId=${orgApplicationId}
    ...    environment=${environment}

    &{headers}=    Create Dictionary
    ...    accept=*/*
    ...    Content-Type=application/json

    ${response}=    POST On Session
    ...    auth_v1
    ...    /Authentication/identity/developertokenauthenticate
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=ANY

    Log    [AUTH] status=${response.status_code}    console=True
    Log    [AUTH] body=${response.text}            console=True
    Should Be Equal As Integers    ${response.status_code}    200

    ${token}=    Set Variable    ${response.json()['data']['token']}
    Should Not Be Empty    ${token}    Token veio vazio no response de autenticação.

    # IMPORTANTE: essa API espera Authorization: <token> (SEM Bearer)
    &{invoice_headers}=    Create Dictionary
    ...    accept=*/*
    ...    Content-Type=application/json
    ...    Authorization=${token}

    # Recria a sessão invoice_v1 com o header autenticado
    Create Session    invoice_v1    ${INVOICE_API_V1}    headers=${invoice_headers}    verify=${False}

    Set Suite Variable    ${TOKEN}    ${token}

Executar Ação na Fatura
    [Arguments]    ${status}    ${fatura_id}=${FATURA_ID}

    ${params}=    Create Dictionary
    ...    status=${status}
    ...    usuario=${LOGIN}

    ${body}=    Create List    ${fatura_id}

    Log    URL=${INVOICE_API_V1}/Invoice/UpdateStatusInvoiceReleased?status=${status}&usuario=${LOGIN}    console=True
    Log    BODY=${body}    console=True

    ${response}=    PUT On Session
    ...    invoice_v1
    ...    /Invoice/UpdateStatusInvoiceReleased
    ...    params=${params}
    ...    json=${body}
    ...    expected_status=ANY

    Set Suite Variable    ${RESPONSE}    ${response}

    Log    [STATUS FATURA] status=${response.status_code}    console=True
    Log    [STATUS FATURA] body=${response.text}            console=True


Cancelar Fatura (UpdateStatusInvoiceCancel)
    [Arguments]    ${fatura_id}=${FATURA_ID}    ${user_login}=${LOGIN}

    ${ids}=    Create List    ${fatura_id}
    ${payload}=    Create Dictionary
    ...    idsInvoice=${ids}
    ...    userLogin=${user_login}

    Log    URL=${INVOICE_API_V1}/Invoice/UpdateStatusInvoiceCancel    console=True
    Log    BODY=${payload}    console=True

    ${response}=    PUT On Session
    ...    invoice_v1
    ...    /Invoice/UpdateStatusInvoiceCancel
    ...    json=${payload}
    ...    expected_status=ANY

    Set Suite Variable    ${RESPONSE}    ${response}

    Log    [CANCEL FATURA] status=${response.status_code}    console=True
    Log    [CANCEL FATURA] body=${response.text}            console=True


Consultar Fatura Por Parâmetros
    [Arguments]    ${inicio}=${EMPTY}    ${fim}=${EMPTY}

    &{params}=    Create Dictionary

    Run Keyword If    '${inicio}' != '${EMPTY}'
    ...    Set To Dictionary    ${params}    DataInicial=${inicio}

    Run Keyword If    '${fim}' != '${EMPTY}'
    ...    Set To Dictionary    ${params}    DataFinal=${fim}

    Log    URL=${INVOICE_API_V1}/Invoice/GetInvoiceByParameters    console=True
    Log    PARAMS=${params}    console=True

    ${response}=    POST On Session
    ...    invoice_v1
    ...    /Invoice/GetInvoiceByParameters
    ...    params=${params}
    ...    data=
    ...    expected_status=ANY

    Set Suite Variable    ${RESPONSE}    ${response}
    Log    [CONSULTA] status=${response.status_code}    console=True
    Log    [CONSULTA] body=${response.text}            console=True


Reemitir Fatura
    [Arguments]    ${fatura_id}    ${usuario}=${LOGIN}    ${novo_vencimento}=${EMPTY}

    ${ids}=    Create List    ${fatura_id}

    &{params}=    Create Dictionary
    ...    usuario=${usuario}
    ...    lstIdFaturamento=${ids}

    Run Keyword If    '${novo_vencimento}' != ''    Set To Dictionary    ${params}    novoVencimento=${novo_vencimento}

    Log    URL=${INVOICE_API_V1}/Invoice/IssueListInvoiceAgainAsync    console=True
    Log    PARAMS=${params}    console=True

    ${response}=    POST On Session
    ...    invoice_v1
    ...    /Invoice/IssueListInvoiceAgainAsync
    ...    params=${params}
    ...    expected_status=ANY

    Set Suite Variable    ${RESPONSE}    ${response}
    Log    [REEMISSAO] status=${response.status_code}    console=True
    Log    [REEMISSAO] body=${response.text}            console=True


*** Keywords ***

Gerar Payload Ajuste
    [Arguments]    ${cod_empresa}    ${competencia}    ${juros_multa}    ${acerto}
    ...            ${descricao}      ${cod_unidade}   ${status}=A

    ${data_acerto}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%fZ

    &{payload}=    Create Dictionary
    ...    id=0
    ...    codEmpresa=${cod_empresa}
    ...    competencia=${competencia}
    ...    jurosMulta=${juros_multa}
    ...    acerto=${acerto}
    ...    descricao=${descricao}
    ...    dataAcerto=${data_acerto}
    ...    status=${status}
    ...    codUnidade=${cod_unidade}

    [Return]    ${payload}


Inserir Ajuste na Fatura
    [Arguments]    ${payload}

    Log    URL=${INVOICE_API_V1}/InvoiceAdjust/InsertInvoiceAdjust    console=True
    Log    BODY=${payload}                                          console=True

    ${response}=    POST On Session
    ...    invoice_v1
    ...    /InvoiceAdjust/InsertInvoiceAdjust
    ...    json=${payload}
    ...    expected_status=ANY

    Set Suite Variable    ${RESPONSE}    ${response}

    Log    [AJUSTE FATURA] status=${response.status_code}    console=True
    Log    [AJUSTE FATURA] body=${response.text}             console=True


*** Keywords ***

Criar Sessão API
    [Documentation]    Alias compatível com os testes.
    Criar Sessões Base

Realizar Login
    [Documentation]    Alias compatível com os testes.
    Autenticar E Preparar Sessão Faturamento


Manter Fatura
    [Arguments]    ${payload}    ${expected_status}=${EMPTY}
    [Documentation]    POST /Invoice/InvoiceMaintenance com wrapper invoiceMaintenanceDto.

    Log    URL=${INVOICE_API_V1}/Invoice/InvoiceMaintenance    console=True
    Log    BODY=${payload}                                 console=True

    ${response}=    POST On Session
    ...    invoice_v1
    ...    /Invoice/InvoiceMaintenance
    ...    json=${payload}
    ...    expected_status=ANY

    Set Suite Variable    ${RESPONSE}    ${response}

    Log    [MAINTENANCE] status=${response.status_code}    console=True
    Log    [MAINTENANCE] body=${response.text}            console=True

    Run Keyword If    '${expected_status}' != '${EMPTY}'
    ...    Should Be Equal As Integers    ${response.status_code}    ${expected_status}


Calcular Totais da Fatura
    [Arguments]    ${payload}
    Log    URL=${INVOICE_API_V1}/Invoice/InvoiceCalculateTotals    console=True
    Log    BODY=${payload}    console=True

    ${response}=    POST On Session
    ...    invoice_v1
    ...    /Invoice/InvoiceCalculateTotals
    ...    json=${payload}
    ...    expected_status=ANY

    Set Suite Variable    ${RESPONSE}    ${response}

    Log    [CALC TOT] status=${response.status_code}    console=True
    Log    [CALC TOT] body=${response.text}            console=True

Get Payload Calculo Totais Valido
    [Arguments]    ${id_faturamento}
    ${payload}=    Create Dictionary
    ...    idFaturamento=${id_faturamento}
    [Return]    ${payload}

Get Payload Calculo Totais Sem Id
    ${payload}=    Create Dictionary
    ...    competencia=01/2026
    ...    codEmpresa=1
    ...    codUnidade=1
    ...    totalProdutos=100.50
    [Return]    ${payload}

Get Payload Calculo Totais Id Invalido String
    ${payload}=    Create Dictionary
    ...    idFaturamento=abc123
    [Return]    ${payload}

Get Payload Calculo Totais TotalProdutos Negativo
    [Arguments]    ${id_faturamento}
    ${payload}=    Create Dictionary
    ...    idFaturamento=${id_faturamento}
    ...    totalProdutos=-10.00
    [Return]    ${payload}

Get Payload Calculo Totais Completo
    [Arguments]    ${id_faturamento}
    ${payload}=    Create Dictionary
    ...    idFaturamento=${id_faturamento}
    ...    codEmpresa=1
    ...    codUnidade=1
    ...    competencia=01/2026
    ...    totalProdutos=250.75
    [Return]    ${payload}

Verificar Mensagem de Erro Contem
    [Arguments]    ${texto}
    Should Contain    ${RESPONSE.text}    ${texto}


Buscar Antecipacao Por Id (GetInvoiceAdvanceById)
    [Arguments]    ${id_invoice_advance}

    &{params}=    Create Dictionary
    ...    idInvoiceAdvance=${id_invoice_advance}

    Log    URL=${INVOICE_API_V1}/InvoiceAdvance/GetInvoiceAdvanceById    console=True
    Log    PARAMS=${params}    console=True

    ${response}=    GET On Session
    ...    invoice_v1
    ...    /InvoiceAdvance/GetInvoiceAdvanceById
    ...    params=${params}
    ...    expected_status=ANY

    Set Suite Variable    ${RESPONSE}    ${response}

    Log    [GET INVOICE ADVANCE] status=${response.status_code}    console=True
    Log    [GET INVOICE ADVANCE] body=${response.text}            console=True


Verificar Status Code
    [Arguments]    ${expected}
    Should Be Equal As Integers    ${RESPONSE.status_code}    ${expected}

Liberar Fatura
    [Arguments]    ${fatura_id}=${FATURA_ID}
    [Documentation]  Atalho para liberar fatura (status L).
    Executar Ação na Fatura    L    ${fatura_id}

Criar Fatura Em Status
    [Arguments]    ${status_inicial}
    [Documentation]  

    ${payload}=    Create Dictionary
    ...    id=0
    ...    nomeEmpresa=Empresa Teste
    ...    status=${status_inicial}

    ${response}=    POST On Session
    ...    invoice_v1
    ...    /InvoiceDataLoad
    ...    json=${payload}
    ...    expected_status=ANY

    Log    [CRIAR FATURA] status=${response.status_code}    console=True
    Log    [CRIAR FATURA] body=${response.text}            console=True

    Should Be Equal As Integers    ${response.status_code}    201

    ${id}=    Evaluate    ${response.json().get("id")}
    Should Not Be Empty    ${id}    ID da fatura não retornou no response.

    Set Suite Variable    ${FATURA_ID}    ${id}

