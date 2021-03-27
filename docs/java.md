# Java 语言速记

## 内置数据类型

Java 语言提供了八种基本类型。六种数字类型（四个整数型，两个浮点型），一种字符类型，还有一种布尔型。

### byte：字节类型

> 对应 汇编语言中的 x[ 00 ] => b[ 00000000]

byte 数据类型是 8 位、[有符号]的，以二进制补码表示的整数；

补码在 2 进制里 == [反码] + 1 = 0

最小值是 -128（-2^7）；
最大值是 127（2^7-1）；
默认值是 0；

byte 类型用在大型数组中节约空间，主要代替整数，因为 byte 变量占用的空间只有 int 类型的四分之一；

例子：

```java
byte a = 100，byte b = -50。
```

### short：短型

> 对应汇编中的字 WORD
> 2 BYTE x[00 00]
> b[ 00000000 - 00000000]

short 数据类型是 16 位、有符号的以二进制补码表示的整数
最小值是 -32768（-2^15）；
最大值是 32767（2^15 - 1）；
Short 数据类型也可以像 byte 那样节省空间。一个 short 变量是 int 型变量所占空间的二分之一；
默认值是 0；

例子：

```
short s = 1000，short r = -20000。
```

### int 整形

> 对应汇编中的字 DWORD
> 4 BYTE x[00 00 00 00]
> b[ 00000000 00000000 00000000 00000000]

int 数据类型是 32 位、有符号的以二进制补码表示的整数；
最小值是 -2,147,483,648（-2^31）；
最大值是 2,147,483,647（2^31 - 1）；

一般地整型变量默认为 int 类型；
默认值是 0 ；

例子：

```java
int a = 100000, int b = -200000。
```

### long 长整型：

> 对应汇编中的字 QWORD == 8 BYTE
> x[00 00 00 00 | 00 00 00 00]
> b[ 00000000 00000000 00000000 00000000 | 00000000 00000000 00000000 00000000]

long 数据类型是 64 位、有符号的以二进制补码表示的整数；

最小值是 -9,223,372,036,854,775,808（-2^63）；

最大值是 9,223,372,036,854,775,807（2^63 -1）；

这种类型主要使用在需要比较大整数的系统上；

默认值是 0L；

例子：

```java
long a = 100000L，Long b = -200000L。
```
"L"理论上不分大小写，但是若写成"l"容易与数字"1"混淆，不容易分辩。所以最好大写。

### float：浮点数

float 数据类型是单精度、32 位、符合 IEEE 754 标准的浮点数；

float 在储存大型浮点数组的时候可节省内存空间；

默认值是 0.0f；

浮点数不能用来表示精确的值，如货币；

例子：float f1 = 234.5f。

### double：双精度浮点数

double 数据类型是双精度、64 位、符合 IEEE 754 标准的浮点数；

浮点数的默认类型为 double 类型；

double 类型同样不能表示精确的值，如货币；

默认值是 0.0d；

例子：

```java
double d1 = 123.4。
```

### boolean：布尔类型

boolean 数据类型表示一位的信息；

只有两个取值：true 和 false；

这种类型只作为一种标志来记录 true/false 情况；

默认值是 false；


例子：

```java
boolean one = true。
```

### char：

> WORD = 2 BYTE [00 00]

char 类型是一个单一的 16 位 Unicode 字符；

最小值是 \u0000（即为 0）；
最大值是 \uffff（即为 65535）；

char 数据类型可以储存任何字符；

例子：

```java
char letter = 'A';。
```

## 读取

### 从控制台读取多字符输入,使用Read

```java
//使用 BufferedReader 在控制台读取字符
 
import java.io.*;
 
public class BRRead {
    public static void main(String[] args) throws IOException {
        char c;
        // 使用 System.in 创建 BufferedReader
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("输入字符, 按下 'q' 键退出。");
        // 读取字符
        do {
            c = (char) br.read();
            System.out.println(c);
        } while (c != 'q');
    }
}
```

### 从控制台读取字符串readLine

从标准输入读取一个字符串需要使用 BufferedReader 的 readLine() 方法。

它的一般格式是：

```java
String readLine( ) throws IOException
```

下面的程序读取和显示字符行直到你输入了单词"end"。

BRReadLines.java 文件代码：

```java
//使用 BufferedReader 在控制台读取字符
import java.io.*;
 
public class BRReadLines {
    public static void main(String[] args) throws IOException {
        // 使用 System.in 创建 BufferedReader
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String str;
        System.out.println("Enter lines of text.");
        System.out.println("Enter 'end' to quit.");
        do {
            str = br.readLine();
            System.out.println(str);
        } while (!str.equals("end"));
    }
}
```

## fs 读取文件

![iostream](https://www.runoob.com/wp-content/uploads/2013/12/iostream2xx.png)

```java
import java.io.*;
 
public class fileStreamTest {
    public static void main(String[] args) {
        try {
            byte bWrite[] = { 11, 21, 3, 40, 5 };
            OutputStream os = new FileOutputStream("test.txt");
            for (int x = 0; x < bWrite.length; x++) {
                os.write(bWrite[x]); // 写入字节
            }
            os.close();
 
            InputStream is = new FileInputStream("test.txt");
            int size = is.available();
 
            for (int i = 0; i < size; i++) {
                System.out.print((char) is.read() + "  "); // 读取字节
            }
            is.close();
        } catch (IOException e) {
            System.out.print("Exception");
        }
    }
}
```

### fs操作文件夹

下面展示的例子说明如何使用 `list()` 方法来检查一个文件夹中包含的内容：

```java
import java.io.File;
 
public class DirList {
    public static void main(String args[]) {
        String dirname = "/tmp";
        File f1 = new File(dirname);
        if (f1.isDirectory()) {
            System.out.println("目录 " + dirname);
            String s[] = f1.list();
            for (int i = 0; i < s.length; i++) {
                File f = new File(dirname + "/" + s[i]);
                if (f.isDirectory()) {
                    System.out.println(s[i] + " 是一个目录");
                } else {
                    System.out.println(s[i] + " 是一个文件");
                }
            }
        } else {
            System.out.println(dirname + " 不是一个目录");
        }
    }
}
```

## 循环/条件

#### 经典语法

```java
public class Test {
   public static void main(String args[]) {
 
      for(int x = 10; x < 20; x = x+1) {
         System.out.print("value of x : " + x );
         System.out.print("\n");
      }
   }
}
```

#### Java引入了一种主要用于数组的增强型 for 循环。

```java
for(声明语句 : 表达式)
{
   //代码句子
}
```

```java
public class Test {
   public static void main(String args[]){
      int [] numbers = {10, 20, 30, 40, 50};
 
      for(int x : numbers ){
         System.out.print( x );
         System.out.print(",");
      }
      System.out.print("\n");
      String [] names ={"James", "Larry", "Tom", "Lacy"};
      for( String name : names ) {
         System.out.print( name );
         System.out.print(",");
      }
   }
}
```

#### 迭代器

```java
// 引入 ArrayList 和 Iterator 类
import java.util.ArrayList;
import java.util.Iterator;

public class RunoobTest {
    public static void main(String[] args) {

        // 创建集合
        ArrayList<String> sites = new ArrayList<String>();
        sites.add("Google");
        sites.add("Runoob");
        sites.add("Taobao");
        sites.add("Zhihu");

        // 获取迭代器
        Iterator<String> it = sites.iterator();

        // 输出集合中的第一个元素
        System.out.println(it.next());
    }
}
```


## Java 作为一种面向对象语言。支持以下基本概念：

- 多态
- 继承
- 封装
- 抽象
- 类
- 对象
- 实例
- 方法
- 重载


##  创建线程

### 三种方式的对比

1. 采用实现 Runnable、Callable 接口的方式创建多线程时，线程类只是实现了 Runnable 接口或 Callable 接口，还可以继承其他类。

2. 使用继承 Thread 类的方式创建多线程时，编写简单，如果需要访问当前线程，则无需使用 `Thread.currentThread()` 方法，直接使用 `this` 即可获得当前线程。

### 线程的几个主要概念

- 线程同步
- 线程间通信
- 线程死锁
- 线程控制：挂起、停止和恢复


### 采用实现 Runnable、Callable 接口的方式创建多线程

```java
class RunnableDemo implements Runnable {
   private Thread t;
   private String threadName;
   
  //  构造函数
   RunnableDemo( String name) {
      threadName = name;
      System.out.println("Creating " +  threadName );
   }

  //  接口的方法的具体实现
   public void run() {
      System.out.println("Running " +  threadName );
      try {
         for(int i = 4; i > 0; i--) {
            System.out.println("Thread: " + threadName + ", " + i);
            // 让线程睡眠一会
            Thread.sleep(50);
         }
      }catch (InterruptedException e) {
         System.out.println("Thread " +  threadName + " interrupted.");
      }
      System.out.println("Thread " +  threadName + " exiting.");
   }
   
   public void start () {
      System.out.println("Starting " +  threadName );
      if (t == null) {
         t = new Thread (this, threadName);
         t.start ();
      }
   }
}
 
public class TestThread {
 
   public static void main(String args[]) {
      RunnableDemo R1 = new RunnableDemo( "Thread-1");
      R1.start();
      
      RunnableDemo R2 = new RunnableDemo( "Thread-2");
      R2.start();
   }   
}
```

### 通过 Callable 和 Future 创建线程

1. 创建 Callable 接口的实现类，并实现 call() 方法，该 call() 方法将作为线程执行体，并且有返回值。

2. 创建 Callable 实现类的实例，使用 FutureTask 类来包装 Callable 对象，该 FutureTask 对象封装了该 Callable 对象的 call() 方法的返回值。

3. 使用 FutureTask 对象作为 Thread 对象的 target 创建并启动[新线程]。

4. 调用 FutureTask 对象的 get() 方法来获得子线程执行结束后的返回值。

```java
public class CallableThreadTest implements Callable<Integer> {
    public static void main(String[] args)  
    {  
        CallableThreadTest ctt = new CallableThreadTest();  
        FutureTask<Integer> ft = new FutureTask<>(ctt);  
        for(int i = 0;i < 100;i++)  
        {  
            System.out.println(Thread.currentThread().getName()+" 的循环变量i的值"+i);  
            if(i==20)  
            {  
                new Thread(ft,"有返回值的线程").start();  
            }  
        }  
        try  
        {  
            System.out.println("子线程的返回值："+ft.get());  
        } catch (InterruptedException e)  
        {  
            e.printStackTrace();  
        } catch (ExecutionException e)  
        {  
            e.printStackTrace();  
        }  
  
    }
    @Override  
    public Integer call() throws Exception  
    {  
        int i = 0;  
        for(;i<100;i++)  
        {  
            System.out.println(Thread.currentThread().getName()+" "+i);  
        }  
        return i;  
    }  
}
```

### 创建一个继承Thread的新类创建多线程

```java
class ThreadDemo extends Thread {
   private Thread t;
   private String threadName;
   
   ThreadDemo( String name) {
      threadName = name;
      System.out.println("Creating " +  threadName );
   }
   
   public void run() {
      System.out.println("Running " +  threadName );
      try {
         for(int i = 4; i > 0; i--) {
            System.out.println("Thread: " + threadName + ", " + i);
            // 让线程睡眠一会
            Thread.sleep(50);
         }
      }catch (InterruptedException e) {
         System.out.println("Thread " +  threadName + " interrupted.");
      }
      System.out.println("Thread " +  threadName + " exiting.");
   }
   
   public void start () {
      System.out.println("Starting " +  threadName );
      if (t == null) {
         t = new Thread (this, threadName);
         t.start ();
      }
   }
}
 
public class TestThread {
 
   public static void main(String args[]) {
      ThreadDemo T1 = new ThreadDemo( "Thread-1");
      T1.start();
      
      ThreadDemo T2 = new ThreadDemo( "Thread-2");
      T2.start();
   }   
}
```

### Socket 客户端实例

如下的 GreetingClient 是一个客户端程序，该程序通过 socket 连接到服务器并发送一个请求，然后等待一个响应。

GreetingClient.java 文件代码：
```java
// 文件名 GreetingClient.java
 
import java.net.*;
import java.io.*;
 
public class GreetingClient
{
   public static void main(String [] args)
   {
      String serverName = args[0]; // 第一个参数是服务器
      int port = Integer.parseInt(args[1]);  // 第二个参数是端口
      try
      {
         System.out.println("连接到主机：" + serverName + " ，端口号：" + port);
         Socket client = new Socket(serverName, port);  // 创建链接
         System.out.println("远程主机地址：" + client.getRemoteSocketAddress());
         OutputStream outToServer = client.getOutputStream(); // 获取输出流
         DataOutputStream out = new DataOutputStream(outToServer); // 使用输出流,创建数据输出流
         out.writeUTF("Hello from " + client.getLocalSocketAddress()); // 写入数据

         InputStream inFromServer = client.getInputStream(); // 获取输入输出流
         DataInputStream in = new DataInputStream(inFromServer); // 输入数据流
         System.out.println("服务器响应： " + in.readUTF()); // 读取数据
         client.close();
      }catch(IOException e)
      {
         e.printStackTrace();
      }
   }
}
```

### Socket 服务端实例

如下的GreetingServer 程序是一个服务器端应用程序，使用 Socket 来监听一个指定的端口。

GreetingServer.java 文件代码：

```java
// 文件名 GreetingServer.java
 
import java.net.*;
import java.io.*;
 
public class GreetingServer extends Thread
{
   private ServerSocket serverSocket;
   
   public GreetingServer(int port) throws IOException
   {
      serverSocket = new ServerSocket(port);
      serverSocket.setSoTimeout(10000);
   }
 
   public void run()
   {
      while(true)
      {
         try
         {
            System.out.println("等待远程连接，端口号为：" + serverSocket.getLocalPort() + "...");
            Socket server = serverSocket.accept();
            System.out.println("远程主机地址：" + server.getRemoteSocketAddress());
            DataInputStream in = new DataInputStream(server.getInputStream()); // 获取输入
            System.out.println(in.readUTF()); // 读取输入

            DataOutputStream out = new DataOutputStream(server.getOutputStream()); // 获取输出流
            out.writeUTF("谢谢连接我：" + server.getLocalSocketAddress() + "\nGoodbye!"); // 写入输出流
            server.close();
         }catch(SocketTimeoutException s)
         {
            System.out.println("Socket timed out!");
            break;
         }catch(IOException e)
         {
            e.printStackTrace();
            break;
         }
      }
   }
   public static void main(String [] args)
   {
      int port = Integer.parseInt(args[0]);
      try
      {
         Thread t = new GreetingServer(port);
         t.run();
      }catch(IOException e)
      {
         e.printStackTrace();
      }
   }
}
```



## 包管理

### 设置 CLASSPATH 系统变量

> 用下面的命令显示当前的CLASSPATH变量：
> Windows 平台（DOS 命令行下）：C:\> set CLASSPATH
> UNIX 平台（Bourne shell 下）：# echo $CLASSPATH
> 
> 删除当前CLASSPATH变量内容：
> Windows 平台（DOS 命令行下）：C:\> set CLASSPATH=
> UNIX 平台（Bourne shell 下）：# unset CLASSPATH; export CLASSPATH
> 
> 设置CLASSPATH变量:
> 
> Windows 平台（DOS 命令行下）： C:\> set CLASSPATH=C:\users\jack\java\classes
> UNIX 平台（Bourne shell 下）：# CLASSPATH=/home/jack/java/classes; export CLASSPATH

### class文件导入

有一个 `com.runoob.test` 的包，这个包包含一个叫做 `Runoob.java` 的源文件

`import com.runoob.test.*`

### 子目录`com\runoob\test\Runoob.java`

```java
// 文件名: Runoob.java
// 包名在这里
package com.runoob.test;
public class Runoob {
      
}
class Google {
      
}
```

### 编译这个文件
```bash
javac -d . Runoob.java
```

得到以下class二进制文件

.\com\runoob\test\Runoob.class
.\com\runoob\test\Google.class