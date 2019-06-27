# RobotRemoteServer

####                                                                                                                                                                                                    ------ RemoteInterface

- ### Introduction
1.  RemoteInterface 允许将自动化框架测试库(Robot Framework Library)作为一个外部过程运行，其支持的一个重要用例是在另外一台机器上运行测试库而不是在安装自动化框架的机器上，这为分布式测试提供了可能性
2.  另一个重要的用例是运行自动化框架本地支持的其他语言实现测试库。事实上，测试库可以被任何语言实现，只需求该语言支持远程接口交互的XML-RPC协议

- ### Architecture

  远程接口包含**远程库** ( Remote Library )、**远程服务器**( Remote Server )以及在这些机器上运行的实际**测试库**( Test Library)，上层结构如下图所示。

  ![Architure](E:\robotFramework\Architecture.png)

​        远程库是一个自动化框架的标准库，因此随着自动化框架自动安装。其本身并没有任何关键字，而是以代理的方式工作在自动化框架和远程服务器之间。

​        远程服务器将实际的测试库提供的关键字显示在远程库中。远程库和远程服务器使用位于XML-RPC信道顶层的简单**远程协议**通信。**远程协议**和整个远程库接口都在 Robot Framework User Guide 的 [Remote Library Interface](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#remote-library-interface) 章节详细描述。 远程协议默认接口是8270,并且已经在IANA上注册过。

远程服务器域实际测试库如何交互取决于实际语言和远程服务器的设计。远程服务器的具体实现: 

1. Python    =====> [PythonRemoteServer](<https://github.com/robotframework/PythonRemoteServer>)
2. Java         =====>  [Jremoteserver](<https://github.com/ombre42/jrobotremoteserver>)

​        把远程服务器和一或多个远程库组合到一个单一的分布式上是一种可取的解决方案。例如，可以把RemoteSwingLibrary捆绑上SwingLibrary，jrobotserver以及Remote library 本身，这样的话用户甚至就不需要知道他们使用的是远程接口。