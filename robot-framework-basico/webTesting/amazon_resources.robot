*** Settings ***
Library      SeleniumLibrary
Library    XML


*** Variables ***
${URL}                  https://www.amazon.com.br/
${MENU_ELETRONICOS}    //a[@href='/Eletronicos-e-Tecnologia/b/?ie=UTF8&node=16209062011&ref_=nav_cs_electronics'][contains(.,'Eletrônicos')]
${HEADER_ELETRONICOS}      //h1[contains(.,'Eletrônicos e Tecnologia')] 
${INPUT_BUSCA}    //input[@id="twotabsearchtextbox"] 
${BUTTON_PESQUISA}    //input[@id="nav-search-submit-button"]
${TEXTO_RESULTADO_LINHA1}    //div[@class="a-section a-spacing-small puis-padding-left-small puis-padding-right-small"]/div/div/a
${PRODUTO_NUM1_BUSCA}        (//div/h2/a/span)[1]
${NOME_PRODUTO1_CARRINHOS_COMPRAS}    //a[@class="a-link-normal sc-product-link"]/span/span
${BUTTON_ADICIONAR_CARRINHO_PRODUTO1}    (//button[@class='a-button-text'][contains(.,'Adicionar ao carrinho')])[1]
${BUTTON_EXCLUIR_CARRINHO_COMPRAS_PRODUTO1}    //input[@value="Excluir"]
${TEXT_CARRINHO_VAZIO_CARRINHO_COMPRAS}    //h1[@class='a-spacing-mini a-spacing-top-base'][contains(.,'Seu carrinho de compras da Amazon está vazio.')]
    
*** Keywords ***
Abrir o navegador
    Open Browser  browser=chrome  options=add_experimental_option("detach", True)
    Maximize Browser Window


Fechar o navegador
    Capture Page Screenshot
    Close Browser

Acessar a home page do site Amazon.com.br
    Go To    url=${URL}
    Sleep     time_=30
    Wait Until Element Is Visible    locator=${MENU_ELETRONICOS}

Entrar no menu "Eletrônicos"
    Click Element    locator=${MENU_ELETRONICOS}

Verificar se aparece a frase "${FRASE}"
    Wait Until Page Contains    text=${FRASE}
    Wait Until Element Is Visible  locator=${HEADER_ELETRONICOS}

Verificar se o título da página fica "${TITULO}"
    Title Should Be     title=${TITULO}
    
Verificar se aparece a categoria "${NOME_CATEGORIA}"
    Element Should Be Visible     locator=//a[@aria-label='${NOME_CATEGORIA}']

Digitar o nome de produto "${TEXT_BUSCA}" no campo de pesquisa
    Input Text     locator=${INPUT_BUSCA}    text=${TEXT_BUSCA}

Clicar no botão de pesquisa
    Click Element   locator=${BUTTON_PESQUISA} 

Verificar o resultado da pesquisa se está listando o produto pesquisado
    Wait Until Element Is Visible  locator=${TEXTO_RESULTADO_LINHA1}  
    Scroll Element Into View    locator=${TEXTO_RESULTADO_LINHA1}    
    Element Text Should Be    locator=${TEXTO_RESULTADO_LINHA1}     expected=Xbox Series S

Adicionar o produto "Console Xbox Series S" no carrinho
    Wait Until Element Is Visible      locator=${PRODUTO_NUM1_BUSCA}
    Element Text Should Be    locator=${PRODUTO_NUM1_BUSCA}     expected=Console Xbox Series S
    Sleep    time_=15
    Scroll Element Into View    locator=${TEXTO_RESULTADO_LINHA1}
    Scroll Element Into View    locator=//div[@id="p_n_date-title"]
    Scroll Element Into View    locator=${BUTTON_ADICIONAR_CARRINHO_PRODUTO1}
    Wait Until Element Is Visible      locator=${BUTTON_ADICIONAR_CARRINHO_PRODUTO1}
    Click Element     locator=${BUTTON_ADICIONAR_CARRINHO_PRODUTO1}
    Sleep    time_=15

Verificar se o produto "Console Xbox Series S" foi adicionado com sucesso
    Wait Until Element Is Visible     locator=nav-cart-count-container
    Click Element     locator=nav-cart-count-container
    Wait Until Page Contains    text=Carrinho de compras 
    Element Text Should Be    locator=${NOME_PRODUTO1_CARRINHOS_COMPRAS}     expected=Console Xbox Series S   

Remover o produto "Console Xbox Series S" do carrinho
    Wait Until Element Is Visible     locator=${BUTTON_EXCLUIR_CARRINHO_COMPRAS_PRODUTO1}
    Click Element     locator=${BUTTON_EXCLUIR_CARRINHO_COMPRAS_PRODUTO1}
    Sleep    time_=15

    
Verificar se o carrinho fica vazio 
    Wait Until Element Is Visible     locator=${TEXT_CARRINHO_VAZIO_CARRINHO_COMPRAS} 
    Element Text Should Be    locator=${TEXT_CARRINHO_VAZIO_CARRINHO_COMPRAS}     expected=Seu carrinho de compras da Amazon está vazio.
            
      


                
            
    





# GHERKIN STEPS

Dado que estou na home page da Amazon.com.br
    Acessar a home page do site Amazon.com.br

Quando acessar o menu "Eletrônicos"
    Entrar no menu "Eletrônicos"

Então o título da página deve ficar "Eletrônicos e Tecnologia | Amazon.com.br"
     Verificar se o título da página fica "Eletrônicos e Tecnologia | Amazon.com.br"

 E o texto "Eletrônicos e Tecnologia" deve ser exibido na página
     Verificar se aparece a frase "Eletrônicos e Tecnologia"


E a categoria "Computadores e Informática" deve ser exibida na página
    Verificar se aparece a categoria "Computadores e Informática"

Quando pesquisar pelo produto "Xbox Series S"
    Digitar o nome de produto "Xbox Series S" no campo de pesquisa
    Clicar no botão de pesquisa

Então um produto da linha "Xbox Series S" deve ser mostrado na página
    Verificar o resultado da pesquisa se está listando o produto pesquisado

Quando adicionar o produto "Console Xbox Series S" no carrinho
    Quando pesquisar pelo produto "Xbox Series S"
    Então um produto da linha "Xbox Series S" deve ser mostrado na página
    Adicionar o produto "Console Xbox Series S" no carrinho
    
Então o produto "Console Xbox Series S" deve ser mostrado no carrinho
    Verificar se o produto "Console Xbox Series S" foi adicionado com sucesso

E existe o produto "Console Xbox Series S" no carrinho
    Quando adicionar o produto "Console Xbox Series S" no carrinho
    Adicionar o produto "Console Xbox Series S" no carrinho
    Verificar se o produto "Console Xbox Series S" foi adicionado com sucesso

Quando remover o produto "Console Xbox Series S" do carrinho
    Remover o produto "Console Xbox Series S" do carrinho

Então o carrinho deve ficar vazio
   Verificar se o carrinho fica vazio 
    
    



   

    
    

    

    
    
    





