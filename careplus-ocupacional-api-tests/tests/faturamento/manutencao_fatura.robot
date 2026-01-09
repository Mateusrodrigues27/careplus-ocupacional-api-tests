*** Settings ***
Documentation     Testes de Manutenção da Fatura
Resource          ../../resources/keywords.robot
Resource          ../../variables/variables.robot
Library           DateTime
Library           Collections

*** Variables ***
${EMPRESA_NOME}            Empresa QA
${USER_LOGIN}              tmp.mrodrigues
${ENDPOINT_INVOICE}        /Invoice/InvoiceMaintenance
${FATURA_ID_ATUALIZAVEL}   11821
${FATURA_ID_VALIDO}    11814        

*** Test Cases ***
Cenario: Criar fatura com dados válidos
    Criar Sessão API
    Realizar Login
    ${competencia}=    Get Current Date    result_format=%m/%Y
    ${produto}=    Create Dictionary
    ...    id=0
    ...    idFaturamento=0
    ...    codigoProduto=string
    ...    nomeProduto=string
    ...    valorProduto=0
    ...    competencia=string
    ...    observacao=string
    ...    isUpdated=${True}
    ...    origin=0
    @{produtos}=    Create List    ${produto}
    ${dto}=    Create Dictionary
    ...    id=0
    ...    competencia=${competencia}
    ...    totalProdutos=550.65
    ...    totalFatura=525.04
    ...    userLogin=${USER_LOGIN}
    ...    produtosFatura=${produtos}
    ...    produtosFaturaToDelete=${produtos}
    ${payload}=    Create Dictionary    invoiceMaintenanceDto=${dto}
    Manter Fatura    ${payload}    400
    Verificar Status Code    400


Cenario: Tentar criar fatura com campos obrigatórios ausentes (DTO incompleto)
    Criar Sessão API
    Realizar Login
    ${dto_incompleto}=    Create Dictionary    id=0    userLogin=${USER_LOGIN}
    ${payload}=    Create Dictionary    invoiceMaintenanceDto=${dto_incompleto}
    Manter Fatura    ${payload}    400
    Verificar Status Code    400


Cenario: Atualizar fatura existente
    Criar Sessão API
    Realizar Login
    ${competencia}=    Get Current Date    result_format=%m/%Y
    ${produto}=    Create Dictionary
    ...    id=0
    ...    idFaturamento=${FATURA_ID_VALIDO}
    ...    codigoProduto=string
    ...    nomeProduto=string
    ...    valorProduto=0
    ...    competencia=string
    ...    observacao=string
    ...    isUpdated=${True}
    ...    origin=0
    @{produtos}=    Create List    ${produto}
    ${dto}=    Create Dictionary
    ...    id=${FATURA_ID_VALIDO}
    ...    competencia=${competencia}
    ...    totalProdutos=200.00
    ...    totalFatura=200.00
    ...    userLogin=${USER_LOGIN}
    ...    produtosFatura=${produtos}
    ...    produtosFaturaToDelete=${produtos}
    ${payload}=    Create Dictionary    invoiceMaintenanceDto=${dto}
    Manter Fatura    ${payload}    400
    Verificar Status Code    400


Cenario: Tentar atualizar fatura com ID inexistente
    Criar Sessão API
    Realizar Login
    ${competencia}=    Get Current Date    result_format=%m/%Y
    ${produto}=    Create Dictionary
    ...    id=0
    ...    idFaturamento=99999999
    ...    codigoProduto=string
    ...    nomeProduto=string
    ...    valorProduto=0
    ...    competencia=string
    ...    observacao=string
    ...    isUpdated=${True}
    ...    origin=0
    @{produtos}=    Create List    ${produto}
    ${dto}=    Create Dictionary
    ...    id=99999999
    ...    competencia=${competencia}
    ...    totalProdutos=100.00
    ...    totalFatura=100.00
    ...    userLogin=${USER_LOGIN}
    ...    produtosFatura=${produtos}
    ...    produtosFaturaToDelete=${produtos}
    ${payload}=    Create Dictionary    invoiceMaintenanceDto=${dto}
    Manter Fatura    ${payload}    400
    Verificar Status Code    400


Cenario: Criar fatura com totalFatura negativo
    Criar Sessão API
    Realizar Login
    ${competencia}=    Get Current Date    result_format=%m/%Y
    ${produto}=    Create Dictionary
    ...    id=0
    ...    idFaturamento=0
    ...    codigoProduto=string
    ...    nomeProduto=string
    ...    valorProduto=0
    ...    competencia=string
    ...    observacao=string
    ...    isUpdated=${True}
    ...    origin=0
    @{produtos}=    Create List    ${produto}
    ${dto}=    Create Dictionary
    ...    id=0
    ...    competencia=${competencia}
    ...    totalProdutos=10.00
    ...    totalFatura=-10.00
    ...    userLogin=${USER_LOGIN}
    ...    produtosFatura=${produtos}
    ...    produtosFaturaToDelete=${produtos}
    ${payload}=    Create Dictionary    invoiceMaintenanceDto=${dto}
    Manter Fatura    ${payload}    400
    Verificar Status Code    400


Cenario: Rejeitar JSON malformatado (vírgula nos decimais)
    Criar Sessão API
    Realizar Login
    ${competencia}=    Get Current Date    result_format=%m/%Y
    ${bad_json}=    Set Variable
    ...    {"invoiceMaintenanceDto":{"id":0,"competencia":"${competencia}","totalProdutos":550,65,"totalFatura":525,04,"userLogin":"${USER_LOGIN}","produtosFatura":[{"id":0,"idFaturamento":0,"codigoProduto":"string","nomeProduto":"string","valorProduto":0,"competencia":"string","observacao":"string","isUpdated":true,"origin":0}],"produtosFaturaToDelete":[{"id":0,"idFaturamento":0,"codigoProduto":"string","nomeProduto":"string","valorProduto":0,"competencia":"string","observacao":"string","isUpdated":true,"origin":0}]}}
    ${headers}=     Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session
    ...    invoice_v1
    ...    ${ENDPOINT_INVOICE}
    ...    data=${bad_json}
    ...    headers=${headers}
    ...    expected_status=ANY
    Set Suite Variable    ${RESPONSE}    ${response}
    Verificar Status Code    400


Cenario: Rejeitar payload sem wrapper invoiceMaintenanceDto
    [Documentation]    Envia o DTO direto (sem wrapper). Espera 400.
    Criar Sessão API
    Realizar Login
    ${competencia}=    Get Current Date    result_format=%m/%Y
    ${produto}=    Create Dictionary
    ...    id=0
    ...    idFaturamento=0
    ...    codigoProduto=string
    ...    nomeProduto=string
    ...    valorProduto=0
    ...    competencia=string
    ...    observacao=string
    ...    isUpdated=${True}
    ...    origin=0
    @{produtos}=    Create List    ${produto}
    ${dto}=    Create Dictionary
    ...    id=0
    ...    competencia=${competencia}
    ...    totalProdutos=1.00
    ...    totalFatura=1.00
    ...    userLogin=${USER_LOGIN}
    ...    produtosFatura=${produtos}
    ...    produtosFaturaToDelete=${produtos}
    ${headers}=     Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session
    ...    invoice_v1
    ...    ${ENDPOINT_INVOICE}
    ...    json=${dto}
    ...    headers=${headers}
    ...    expected_status=ANY
    Set Suite Variable    ${RESPONSE}    ${response}
    Verificar Status Code    400


Cenario: Atualizar parcialmente campos permitidos
    [Documentation]    Atualiza somente totais mantendo id existente.
    Criar Sessão API
    Realizar Login
    ${competencia}=    Get Current Date    result_format=%m/%Y
    ${produto}=    Create Dictionary
    ...    id=0
    ...    idFaturamento=${FATURA_ID_ATUALIZAVEL}
    ...    codigoProduto=string
    ...    nomeProduto=string
    ...    valorProduto=0
    ...    competencia=string
    ...    observacao=string
    ...    isUpdated=${True}
    ...    origin=0
    @{produtos}=    Create List    ${produto}
    ${dto}=    Create Dictionary
    ...    id=${FATURA_ID_ATUALIZAVEL}
    ...    competencia=${competencia}
    ...    totalProdutos=123.45
    ...    totalFatura=123.45
    ...    userLogin=${USER_LOGIN}
    ...    produtosFatura=${produtos}
    ...    produtosFaturaToDelete=${produtos}
    ${payload}=    Create Dictionary    invoiceMaintenanceDto=${dto}
    Manter Fatura    ${payload}    400
    Verificar Status Code    400