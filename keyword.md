# keyword

* 哪些方法会作为关键字？

  当时用静态库API时，框架会使用反射去找到类或者模块中包含哪些访问修饰符为public的方法，会忽略以下划线`_` 开头的方法 ( 除非使用自定义关键字名，@keyword(‘custom keyword name’) )。在java实现的库中也会忽略继承自` java.lang.Object` 的方法。其他没有被忽略的方法都是关键字

  python 关键字：

  ```python
  class MyLibrary:
  
      def my_keyword(self, arg):
          return self._helper_method(arg)
  
      def _helper_method(self, arg):
          return arg.upper()
  ```

  java 关键字：

  ```java
  public class MyLibrary {
  
      public String myKeyword(String arg) {
          return helperMethod(arg);
      }
  
      private String helperMethod(String arg) {
          return arg.toUpperCase();
      }
  }
  ```

  当用java类或python类实现一个库的时候，其继承的来的方法还是很可能被认为时关键字。以python模块实现的的库，其方法导入命名空间也可能会变成关键字。例如下面的模块就包含三个关键字`Example Keyword` ` Second Example ` **` Current Thread`**

  ```
  from threading import current_thread
  
  
  def example_keyword():
      print('Running in thread "%s".' % current_thread().name)
  
  def second_example():
      pass
  ```

  * 一个避免导入的函数变成关键字的简单方法时直接倒是模块而不是导入具体方法`import threading` ,使用模块调用方法的方式使用具体方法`threading.current_thread()`
  
  * 另一种方式就是在导入方法的时候加入带下划线的别名`from threading import current_thread as _current_threa`
  
  * 还有一种更加明确的方式去限制哪些在模块中的方法可以被视为关键字，使用`_all_` 关键字，语气在python包中的作用相似。使用的时候，只要列出哪些方法可以被转换成关键字，下面的例子中的关键字只有 `Example Keyworf`  `Second Example`  
  
    ```python
    from threading import current_thread
    
    
    __all__ = ['example_keyword', 'second_example']
    
    
    def example_keyword():
        print('Running in thread "%s".' % current_thread().name)
    
    def second_example():
        pass
    
    def not_exposed_as_keyword():
        pass
    ```
  
* 关键字名称

  将在测试脚本中使用的关键字名称与库中方法名称比较来找到方法实现的关键字，关键字名称不区分大小写并且空格与下划线会被忽略。关键字名称*Hello*,  *hello* 或 *h e l l o*  都会对应到 `hello` 方法。相似的，关键字*Do Nothing*可以对应到`do_nothing` 和 `doNothing` 方法。

  ```python
  def hello(name):
      print("Hello, %s!" % name)
  
  def do_nothing():
      pass
  ```

  ```java
  public class MyLibrary {
  
      public void hello(String name) {
          System.out.println("Hello, " + name + "!");
      }
  
      public void doNothing() {
      }
  
  }
  ```

  在测试脚本中使用关键字

  ```tex
  *** Settings ***
  Library    MyLibrary
  
  *** Test Cases ***
  My Test
      Do Nothing
      Hello    world
  ```

* 使用自定义关键字名称

  ​         给方法对应的关键字不使用默认名称而使用自定义名称也是可以的，可以通过在方法上设置`robot_name` 属性来实现，通常使用更简单的注解方式`robot.api.deco.keyword` 来实现

  ```python
  from robot.api.deco import keyword
  
  @keyword('Login Via User Panel')
  def login(username, password):
      # ...
  ```

  不带参数的装饰器不会影响关键字名称，但任然会设置`robot_name` 属性，这就可以使得可以把方法变成关键字而不用改变关键字名。框架从3.02开始可以把以下划线开头的方法变成关键字。另外设置自定义关键字名使用内嵌参数语法能够让关键字接收参数

* 关键字标签

  框架从2.9开始， 用户关键字和库关键字都支持标签，可以在方法中使用`robot_tags` 属性定义标签列表。与自定义关键字名称相似，使用装饰器 `robot.api.deco.keyword` 可以快捷地设置标签：

  ```python
  from robot.api.deco import keyword
  
  @keyword(tags=['tag1', 'tag2'])
  def login(username, password):
      # ...
  
  @keyword('Custom name', ['tags', 'here'])
  def another_example():
      # ...
  ```

  另一种可选的添加标签的方式是在关键字文档的最后一行以`Tags` 添加标签，以逗号分隔：

  ```python
  def login(username, password):
      """Log user in to SUT.
  
      Tags: tag1, tag2
      """
      # ...
  ```

  

* 关键字参数

  使用静态和混合API，关键字需要多少参数的信息是由其的实现方法直接提供的，而动态API则使用其他方法获得这个信息。

  最常见和简单的情况是关键字需要知道参数的准确数量。这种情况下python和java方法都可以准确接受参数

  ```python
  def no_arguments():
      print("Keyword got no arguments.")
  
  def one_argument(arg):
      print("Keyword got one argument '%s'." % arg)
  
  def three_arguments(a1, a2, a3):
      print("Keyword got three arguments '%s', '%s' and '%s'." % (a1, a2, a3))
  Note
  ```

  

* 默认参数

  python方法支持默认参数，而java方法则需要用重载

  

* 可变参数

  框架支持关键字任意参数，实际编写库语法在Java和python不同

  python Example:

  ```python
  def any_arguments(*args):
      print("Got arguments:")
      for arg in args:
          print(arg)
  
  def one_required(required, *others):
      print("Required: %s\nOthers:" % required)
      for arg in others:
          print(arg)
  
  def also_defaults(req, def1="default 1", def2="default 2", *rest):
      print(req, def1, def2, rest)
  ```

  ```Text
  *** Test Cases ***
  Varargs
      Any Arguments
      Any Arguments    argument
      Any Arguments    arg 1    arg 2    arg 3    arg 4    arg 5
      One Required     required arg
      One Required     required arg    another arg    yet another
      Also Defaults    required
      Also Defaults    required    these two    have defaults
      Also Defaults    1    2    3    4    5    6
  ```

  java Example    ps：java方法中的可变参数有且只能有一个，位置必须是参数中最后一个

  ```java
  public void anyArguments(String... varargs) {
      System.out.println("Got arguments:");
      for (String arg: varargs) {
          System.out.println(arg);
      }
  }
  
  public void oneRequired(String required, String... others) {
      System.out.println("Required: " + required + "\nOthers:");
      for (String arg: others) {
          System.out.println(arg);
      }
  }
  ```

  * 改用列表实现

  ```java
  public void anyArguments(String[] varargs) {
      System.out.println("Got arguments:");
      for (String arg: varargs) {
          System.out.println(arg);
      }
  }
  
  public void oneRequired(String required, List<String> others) {
      System.out.println("Required: " + required + "\nOthers:");
      for (String arg: others) {
          System.out.println(arg);
      }
  }
  ```

  

