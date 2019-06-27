# shortcut

* 关键字驱动
描述工作流
若干关键字和他们必要的参数
* 数据驱动
针对相同工作流，执行不同的输入数据
只使用一个高级的用户关键字，其中定义了工作流，然后使用不同的输入和输出数据测试相同的场景
每个测试中可以重复同一个关键字，但是test template功能只允许定义以此被使用的关键字
* 行为驱动：
描述工作流
Acceptance Test Driven Development, ATDD
Specification by Example
BDD's Given-When-Then    
And or But，如果测试步骤中操作较多
支持嵌入数据到关键字名

    ```
搜索关键字的时候， 如果full name没有搜索到， Given-When-Then-And-But等前缀会被忽略
Given login page is open
When valid username and password are inserted
and credentials are submitted
Then welcome page should be open
    ```

 *[Documentation]*

Used for specifying a [test case documentation](#test-case-name-and-documentation).

*[Tags]*

Used for [tagging test cases](#tagging-test-cases).

*[Setup]*, *[Teardown]*

Specify [test setup and teardown](#test-setup-and-teardown).

*[Template]*

Specifies the [template keyword](#test-templates) to use. The test itself will contain only data to use as arguments to that keyword.

*[Timeout]*

Used for setting a [test case timeout](#test-case-timeout). [Timeouts](#timeouts) are discussed in their own section.



## Extending Robot Framework

​       In addition to the normal standard libraries listed above, there is also Remote library that is totally different than the other standard libraries. It does not have any keywords of its own but it works as a proxy between Robot Framework and actual test library implementations. These libraries can be running on other machines than the core framework and can even be implemented using languages not supported by Robot Framework natively.

**Robot Framework has three different test library APIs.**

Static API

> The simplest approach is having a module (in Python) or a class (in Python or Java) with methods which map directly to [keyword names](#keyword-names). Keywords also take the same [arguments](#keyword-arguments)as the methods implementing them. Keywords [report failures](#reporting-keyword-status) with exceptions, [log](#logging-information) by writing to standard output and can [return values](#returning-values) using the `return` statement.

Dynamic API

> Dynamic libraries are classes that implement a method to get the names of the keywords they implement, and another method to execute a named keyword with given arguments. The names of the keywords to implement, as well as how they are executed, can be determined dynamically at runtime, but reporting the status, logging and returning values is done similarly as in the static API.

Hybrid API

> This is a hybrid between the static and the dynamic API. Libraries are classes with a method telling what keywords they implement, but those keywords must be available directly. Everything else except discovering what keywords are implemented is similar as in the static API.


## Creating test library class or module

* #### Test library names

​    The name of a test library that is used when a library is imported is the same as the name of the module or class implementing it. For example, if you have a Python module `MyLibrary` (that is, file *MyLibrary.py*), it will create a library with name *MyLibrary*. Similarly, a Java class `YourLibrary`, when it is not in any package, creates a library with exactly that name.