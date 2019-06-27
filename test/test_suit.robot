*** Settings ***
Library           BuiltIn
Library           OperatingSystem

*** Test Cases ***
test case
    ${var}    set variable    hello ride
    log    ${var}8    6    21log

variable types
    ${var}    set variable    ${3}    #int
    ${float}    set variable    ${3.14}    #float
    ${float}    set variable    ${-1e-4}    #float
    ${test_true}    set variable    ${true}    #boolean
    ${test_false}    set variable    ${false}    #boolean
    ${test_none}    set variable    ${None}
    ${test_null}    set variable    ${null}log$1Runmath$    00setset vaset$$${}
    #string
    ${string}    set variable    test
    #tuple
    ${tuple}    set variable    ${1,2}
    #list
    @{list}    create list    1    yy    kk
    ${Dictionary}    Create dictionary    a=1    b=2

special character
    #space
    ${test_space}    set variable    ${SPACE}
    ${test_quto}    set variable    '${SPACE}'
    ${test_4_SPACE}    set variable    ${SPACE*4}
    ${test_2_quto}    set variable    "${SPACE*2}"
    #EMPTY
    ${test_empty}    set variable    ${EMPTY}

Numeral Calculations
    ${TWO_MUL_FOUR}    SET VARIABLE    ${2*4}
    ${BOOLEAN_COMPUTE}    SET VARIABLE    ${true*4}
    ${BOOLEAN_COMPUTE_FALSE}    SET VARIABLE    ${false*4}
    ${space_COMPUTE}    SET VARIABLE    ${SPACE*4}
    ${var1}    SET VARIABLE    ${4}
    ${var2}    set variable    ${8}
    ${var1-var2}    Evaluate    ${var1}-${var2}
    ${var1+var2}    Evaluate    ${var1}+${var2}
    ${var1*var2}    Evaluate    ${var1}*${var2}
    ${var1/var2}    Evaluate    ${var1}/${var2}
    ${result}    set variable    ${3.14}
    ${status}    Evaluate    0<${result}<10
    ${get_down}    Evaluate    int(${result})
    ${get_high}    Evaluate    math.ceil(${result})    modules=math

flow
    ${var}    set variable    ${2}
    Run keyword if    ${var} == 0    log    1
    ...    ELSE IF    ${var} < 0    log    2
    ...    ELSE IF    0 < ${var} < 1    log 3
    ...    ELSE    log    4
    ${var}    set variable    yyyy
    Run keyword if    '${var}'=='tttt'    log    1
    ...    ELSE IF    '${var}'=='rrrr'    log    2
    ...    ELSE IF    '${var}'=='yyyy'    log    3
    ...    ELSE    log    4
    ${type}    evaluate    type('${var}')
    ${type}    evaluate    type('${false}')
    ${var}    set variable    ${false}
    # boolean
    Run keyword if    ${var} == ${true}    log    ${true}
    ...    ELSE    log    ${false}
    @{varlist}    Create List    ${3}    yyyy    ${4}
    ${num}    Set Variable    ${4}
    ${string}    Set Variable    yyyy
    Run Keyword If    ${num} in @{varlist} and '${string}' in @{varlist}    log    1
    ...    ELSE    log    2
    @{varlist1}    Create List    ${3}    yyyy    ${4}
    @{varlist2}    Create List    ${3}    yyyy    ${4}
    Run Keyword If    @{varlist1} == @{varlist2}    log    1
    ...    ELSE    log    2
    @{varlist1}    Create List    ${3}    yyyy    ${4}
    @{varlist2}    Create List    ${3}    yyyy    ${4}
    Run Keyword If    '@{varlist1}[0]' == '@{varlist2}[0]'    log    1
    ...    ELSE IF    '@{varlist1}[1]' == '@{varlist2}[1]'    log    2
    ...    ELSE IF    '@{varlist1}[2]' == '@{varlist2}[2]'    log    3
    ...    ELSE    log    4

cycle432e
    #Example
    log    Example1:
    : FOR    ${i}    IN    1    2    3    4
    ...    5
    \    log    'i'=${i}
    #Example:
    log    Example2:
    @{list}    Create List    4    5    6    7    8
    ...    9
    : FOR    ${i}    IN    @{list}
    \    log    i=${i}
    #multi-var
    log    Example1:
    : FOR    ${i}    ${n}    IN    1    2    3
    ...    4
    \    log many    i=${i}    n=${n}
    #multi-var-list
    @{list}    Create List    4    5    6    7
    log    Example2:
    : FOR    ${i}    ${n}    IN    @{list}
    \    log many    i=${i}    n=${n}
    # FOR IN RANGE
    LOG    Example1:
    : FOR    ${i}    IN RANGE    4
    \    LOG    ${i}
    LOG    Example:
    : FOR    ${i}    IN RANGE    3    12    3
    \    LOG    ${i}
    LOG    Example3:
    : FOR    ${i}    IN RANGE    13    -13    -3
    \    LOG    ${i}
    #EXIT FOR LOOP
    @{list}    Create List    1    2    3    4
    : FOR    ${i}    IN    @{list}
    \    Run keyword if    ${i}==2    Exit For Loop
    \    log    i=${i}
    # repeat keyword
    Repeat Keyword    3    log    3

Template1
    [Template]    log
    lisi
    wangwu
    zhangsan

Template2
    [Template]    Should Be Equal
    ${1+1}    ${2}
    ${2+2}    ${4}

Template with embedded arguments
    [Template]    The result of ${calculation} should be ${expected}
    1 + 1    ${2}
    1 + 2    ${3}

New arguments
    [Template]    The ${meaning} of ${life} should be 42
    'result'    21 * 2

*** Keywords ***
The result of ${calculation} should be ${expected}
    ${result}    evaluate    ${calculation}
    Should Be Equal    ${result}    ${expected}

The ${meaning} of ${life} should be 42
    log    ${life}=42
