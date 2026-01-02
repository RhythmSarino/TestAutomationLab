*** Settings ***
Library           SeleniumLibrary
Test Setup        Launch Registration Page
Test Teardown     Take Screenshot And Close

*** Variables ***
${URL}                      http://localhost:5500/StarterFiles/Registration.html
${BROWSER}                  Chrome
${CHROME_BROWSER_PATH}      G:${/}Vsc test${/}ChromeForTesting${/}chrome-win64${/}chrome.exe
${CHROME_DRIVER_PATH}       G:${/}Vsc test${/}ChromeForTesting${/}chromedriver-win64${/}chromedriver.exe

${FIRSTNAME_FIELD}          id=firstname
${LASTNAME_FIELD}           id=lastname
${ORGANIZATION_FIELD}       id=organization
${EMAIL_FIELD}              id=email
${PHONE_FIELD}              id=phone
${REGISTER_BUTTON}          id=registerButton
${ERROR_FIELD}              id=errors

*** Test Cases ***
# =========================
# UAT-Lab04-001
# =========================
UAT-Lab04-001-TC01
    [Documentation]    ลงทะเบียนสำเร็จ (กรอกข้อมูลครบทุกช่อง)
    [Tags]    UAT-Lab04-001
    Fill Registration With Organization
    Verify Registration Success

UAT-Lab04-001-TC02
    [Documentation]    ลงทะเบียนสำเร็จ (ไม่กรอก Organization)
    [Tags]    UAT-Lab04-001
    Fill Registration Without Organization
    Verify Registration Success

# =========================
# UAT-Lab04-002
# =========================
UAT-Lab04-002-TC01
    [Documentation]    ไม่กรอกชื่อหน้า
    [Tags]    UAT-Lab04-002
    Fill Without First Name
    Submit Registration
    Verify Error Message    Please enter your first name!!

UAT-Lab04-002-TC02
    [Documentation]    ไม่กรอกนามสกุล
    [Tags]    UAT-Lab04-002
    Fill Without Last Name
    Submit Registration
    Verify Error Message    Please enter your last name!!

UAT-Lab04-002-TC03
    [Documentation]    ไม่กรอกชื่อ
    [Tags]    UAT-Lab04-002
    Fill Email,Organization And Phone Only
    Submit Registration
    Verify Error Message    Please enter your name!!

UAT-Lab04-002-TC04
    [Documentation]    ไม่กรอกอีเมล
    [Tags]    UAT-Lab04-002
    Fill Without Email
    Submit Registration
    Verify Error Message    Please enter your email!!

UAT-Lab04-002-TC05
    [Documentation]    ไม่กรอกเบอร์โทรศัพท์
    [Tags]    UAT-Lab04-002
    Fill Without Phone
    Submit Registration
    Verify Error Message    Please enter your phone number!!

UAT-Lab04-002-TC06
    [Documentation]    กรอกเบอร์โทรศัพท์ไม่ถูกต้อง
    [Tags]    UAT-Lab04-002
    Fill Invalid Phone Number
    Submit Registration
    Verify Error Message    Please enter a valid phone number, e.g., 081-234-5678, 081 234 5678, or 081.234.5678”

*** Keywords ***
Launch Registration Page
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_argument    --start-maximized
    ${chrome_options.binary_location}    Set Variable    ${CHROME_BROWSER_PATH}

    ${service}=    Evaluate
    ...    selenium.webdriver.chrome.service.Service(executable_path=r"${CHROME_DRIVER_PATH}")
    ...    modules=selenium.webdriver.chrome.service

    Create Webdriver    Chrome    options=${options}    service=${service}
    Go To    ${URL}
    Title Should Be    Registration
    Capture Page Screenshot    ${TEST NAME}_start.png

Fill Registration With Organization
    Input Text    ${FIRSTNAME_FIELD}      Somyod
    Input Text    ${LASTNAME_FIELD}       Sodsai
    Input Text    ${ORGANIZATION_FIELD}   CS KKU
    Input Text    ${EMAIL_FIELD}          somyod@kkumail.com
    Input Text    ${PHONE_FIELD}          091-001-1234
    Click Button  ${REGISTER_BUTTON}

Fill Registration Without Organization
    Input Text    ${FIRSTNAME_FIELD}      Somyod
    Input Text    ${LASTNAME_FIELD}       Sodsai
    Input Text    ${EMAIL_FIELD}          somyod@kkumail.com
    Input Text    ${PHONE_FIELD}          091-001-1234
    Click Button  ${REGISTER_BUTTON}

Verify Registration Success
    Wait Until Location Contains    Success.html    timeout=5s
    Title Should Be    Success
    Page Should Contain    Thank you for registering with us.
    Page Should Contain    We will send a confirmation to your email soon.

Submit Registration
    Click Button    ${REGISTER_BUTTON}

Verify Error Message
    [Arguments]    ${expected_message}
    Element Text Should Be    ${ERROR_FIELD}    ${expected_message}

Fill Without First Name
    Input Text    ${LASTNAME_FIELD}        Sodyod
    Input Text    ${ORGANIZATION_FIELD}    CS KKU
    Input Text    ${EMAIL_FIELD}           somyod@kkumail.com
    Input Text    ${ORGANIZATION_FIELD}    CS KKU
    Input Text    ${PHONE_FIELD}           091-001-1234

Fill Without Last Name
    Input Text    ${FIRSTNAME_FIELD}       Somyod
    Input Text    ${ORGANIZATION_FIELD}    CS KKU
    Input Text    ${EMAIL_FIELD}           somyod@kkumail.com
    Input Text    ${PHONE_FIELD}           091-001-1234

Fill Email,Organization And Phone Only
    Input Text    ${ORGANIZATION_FIELD}    CS KKU
    Input Text    ${EMAIL_FIELD}           somyod@kkumail.com
    Input Text    ${PHONE_FIELD}           091-001-1234

Fill Without Email
    Input Text    ${FIRSTNAME_FIELD}       Somyod
    Input Text    ${LASTNAME_FIELD}        Sodsai
    Input Text    ${ORGANIZATION_FIELD}    CS KKU
    Input Text    ${PHONE_FIELD}           091-001-1234

Fill Without Phone
    Input Text    ${FIRSTNAME_FIELD}       Somyod
    Input Text    ${LASTNAME_FIELD}        Sodsai
    Input Text    ${ORGANIZATION_FIELD}    CS KKU
    Input Text    ${EMAIL_FIELD}           somyod@kkumail.com

Fill Invalid Phone Number
    Input Text    ${FIRSTNAME_FIELD}       Somyod
    Input Text    ${LASTNAME_FIELD}        Sodsai
    Input Text    ${ORGANIZATION_FIELD}    CS KKU
    Input Text    ${EMAIL_FIELD}           somyod@kkumail.com
    Input Text    ${PHONE_FIELD}           1234

Take Screenshot And Close
    Capture Page Screenshot    ${TEST NAME}_end.png
    Close Browser
