*** Settings *** 
Library    RequestsLibrary                                                                        
Library    String
Library    Collections



*** Keywords ***
Criar um usuário novo
    ${PALAVRA_ALEATORIA}    Generate Random String     length=4  chars=[LETTERS]
    ${PALAVRA_ALEATORIA}    Convert To Lower Case   ${PALAVRA_ALEATORIA} 
    Set Test Variable    ${EMAIL}    ${PALAVRA_ALEATORIA}@emailteste.com
    Log    ${EMAIL}

Cadastrar o novo usuário na ServeRest
    [Arguments]  ${email}  ${status_code_desejado}
    ${BODY}    Create Dictionary  
    ...  nome=Fulano da Silva    
    ...  email=${email}    
    ...  password=1234    
    ...  administrador=true
    Log    ${BODY}
    Criar Sessão na ServeRest
    ${resposta}    POST On Session
    ...            alias=ServeRest
    ...            url=/usuarios
    ...            json=${BODY}
    ...            expected_status=${status_code_desejado}   
     
    Log  ${resposta.json()}
    
    IF  ${status_code_desejado} == 201
     Set Test Variable    ${ID_USUARIO}  ${resposta.json()["_id"]}   
    END
   
    Set Test Variable    ${RESPOSTA}    ${resposta.json()}  


Criar Sessão na ServeRest
   ${HEADER}    Create Dictionary    accept=application/json    Content-Type=application/json
   Create Session   alias=ServeRest    url=https://serverest.dev    headers=${HEADER}  
    
Conferir se o usuário foi cadastrado corretamente
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}  message  Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${RESPOSTA}    _id

Vou repetir o cadastro do usuário
    Cadastrar o novo usuário na ServeRest    ${EMAIL}    status_code_desejado=400

Verificar se API não permitiu o cadastro repetido
    Dictionary Should Contain Item    ${RESPOSTA}    message     Este email já está sendo usado

Consultar os dados do novo usuário
    ${resposta_consulta}    GET On Session     alias=ServeRest    url=/usuarios/${ID_USUARIO} 
    Log    ${resposta_consulta.headers}
    Log    ${resposta_consulta.status_code}
    Set Test Variable    ${RESP_CONSULTA}    ${resposta_consulta.json()}


Conferir os dados retornados
    Log    ${RESP_CONSULTA}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    nome            Fulano da Silva
    Dictionary Should Contain Item    ${RESP_CONSULTA}    email           ${EMAIL}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    password       1234
    Dictionary Should Contain Item    ${RESP_CONSULTA}    administrador   true
    Dictionary Should Contain Item    ${RESP_CONSULTA}    _id             ${ID_USUARIO}
    
Realizar login com usuário
    ${BODY_Login}    Create Dictionary
    ...              email=${EMAIL}  
    ...              password=1234
    ${RESP_Login}    POST On Session    
    ...              alias=ServeRest    
    ...              url=/Login        
    ...              json=${BODY_Login}
    Set Test Variable    ${RESPOSTA}    ${RESP_Login.json()}  
    
          
Conferir se Login ocorreu com sucesso
    Dictionary Should Contain Item    ${RESPOSTA}    message     Login realizado com sucesso

    
    

    