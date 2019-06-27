# Test Library(测试库)

* 名称要求

  1. 测试库名称通常与python模块或者java类名相同,如 `MyLibrary`，其文件为`MyLibrary.py`。

  2. 通常会有多个类在一个文件中，如果类所实现库与模块同名，自动化框架允许在导入库的时候丢弃类名，例如*MyLib.py*中有一个`MyLib`类作为测试库，只要直接导入 *MyLib*。这也适用于子模块，因此，例如，如果 *parent.MyLib*模块具有类`MyLib`，则仅使用 parent.MyLib导入它。 如果模块名称和类名称不同，则必须使用模块和类名来使用库，例如 mymodule.MyLibrary或 parent.submodule.MyLib 。

  3. java 类在非默认包中必须使用全路径名，`MYLib`在`com.mycompany.myproject`包中，必须使用`com.mycompany.myproject.MyLib` 导入

  4. 假若库文件名称太长，可以用 `WITH NAME` 语法给库一个别名

* 测试库的参数

   所有以类实现的测试库都可以接收参数，这些参数在`Setting` 表中库名称后面指定。当框架创建被导入函数库的实例时，这些参数会被传递给构造器。作为模块实现的库不能接受任何参数，因此尝试使用这些参数会导致错误。

  ```
  *** Settings ***
  Library    MyLibrary     10.0.0.1    8080
  Library    AnotherLib    ${VAR}
  ```

  MyLibrary (implemented by python)和AnotherLib (implemented by java)具体实现如下：

  ```python
  from example import Connection
  
  class MyLibrary:
  
      def __init__(self, host, port=80):
          self._conn = Connection(host, int(port))
  
      def send_message(self, message):
          self._conn.send(message)
  ```

  ```java
  public class AnotherLib {
  
      private String setting = null;
  
      public AnotherLib(String setting) {
          setting = setting;
      }
  
      public void doSomething() {
          if setting.equals("42") {
              // do something ...
          }
      }
  }
  ```
  
* 测试库域范围

   ​        以类实现的库可以有内部状态，可以通过关键字或库构造函数参数改变。这些参数会影响关键字的实际运行确保一个测试用例不会异常影响另一个其他测试用例。多种依赖会导致难以debug的问题，例如新的case加入并且用的时不一致的库。

   ​       框架尝试去保持测试用例彼此独立，默认情况下，它为每一个测试案例创建新的测试库实例。然而这种行为并不是在所有场合想都需要，比如说某些用例需要共享状态。另外，所有没有状态的库，给他们创建新的实例也是没有必要的

   可以在创建新测试库的时候使用类属性`ROBOT_LIBRARY_SCOPE` 对库加以控制，这个属性有三种值：

   * TEST CASE : 为每个测试用力创建库的新实例，默认值。

   * TEST SUITE : 为每个测试套件创建库的新实例，使用测试用例文件创建包含测试用例的最级别测试套件拥有本身的实例，而高级别测试套件可以获得本身的实例来进行可能的配置和卸载。

   * GLOBAL : 整个测试执行的时候只会创建一个实例，被所有用例和套件共享，由模块创建的库通常都是全局的。

     以 TEST SUITE 为作用范围python库:

     ```python
     class ExampleLibrary:
     
         ROBOT_LIBRARY_SCOPE = 'TEST SUITE'
     
         def __init__(self):
             self._counter = 0
     
         def count(self):
             self._counter += 1
             print(self._counter)
     
         def clear_counter(self):
             self._counter = 0
     ```

     以 GLOBAL 为作用范围python库:

     ```java
     public class ExampleLibrary {
     
         public static final String ROBOT_LIBRARY_SCOPE = "GLOBAL";
     
         private int counter = 0;
     
         public void count() {
             counter += 1;
             System.out.println(counter);
         }
      
         public void clearCounter() {
             counter = 0;
         }
     }
     ```

* 测试库版本

   运行一个库的时候框架会尝试确定其版本，这些信息会被写入系统日志以提供调试信息。库文档工具Libdoc也会也会把这个信息写入关键字文档当他生成的时候。

   版本信息从`ROBOT_LIBRARY_VERSION` 属性读取，如果`ROBOT_LIBRARY_VERSION` 不存在，就尝试从`_version_` 读取，这些属性必须在类或者模块中。java实现的库中版本信息一般被声明为`static final`

   `_version_` 例子

   ```
   __version__ = '0.1'
   
   def keyword():
       pass
   ```

   `ROBOT_LIBRARY_VERSION` 例子

   ```
   public class VersionExample {
   
       public static final String ROBOT_LIBRARY_VERSION = "1.0.2";
   
       public void keyword() {
       }
   }
   ```
   
* 指定测试库文本形式

   库文档工具Libdoc 支持多种形式文档，如果你不想用框架默认的文档形式，可以在源码中加入`ROBOT_LIBRARY_DOC_FORMAT` 属性，其值大小写敏感，包括ROBOT (default), HTML, TEXT (plain text),和 reST (reStructuredText)，使用`reST`  需要预装docutils

* 测试库作为监听器

  Listener interface 允许外部监听器获得关于测试用例的执行状态提示，然后在特定点触发监听器，比如说在测试用例或测试套件开始、结束之时。对于测试库来说获取这些提示很有用的，可以使用关键字`ROBOT_LIBRARY_LISTENER`来注册客户监听器。这个关键字是被监听器实例使用，也可能是库本身。