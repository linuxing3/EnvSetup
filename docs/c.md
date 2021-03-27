# C/C++ 基础

作为一门古老的编程语言，C语言已经坚挺了好几十年了，初学者从C语言入门，大学将C语言视为基础课程。不管别人如何抨击，如何唱衰，C语言就是屹立不倒；Java、C#、Python、PHP、Perl 等都有替代方案，它们都可以倒下，唯独C语言不行。

程序是在内存中运行的，一名合格的程序员必须了解内存，学习C语言是了解内存布局的最简单、最直接、最有效的途径，C语言简直是为内存而生的，它比任何一门编程语言都贴近内存。

所有的程序都在拼尽全力节省内存，都在不遗余力提高内存使用效率，计算机的整个发展过程都在围绕内存打转，不断地优化内存布局，以保证可以同时运行多个程序。

不了解内存，就学不会进程和线程，就没有资格玩中大型项目，没有资格开发底层组件，没有资格架构一个系统，命中注定你就是一个菜鸟，成不了什么气候。

至关重要的一点是，我能够把内存和具体的编程知识以及程序的运行过程结合起来，真正做到了学以致用，让概念落地，而不是空谈，这才是最难得的。

另外一个惊喜是，攻克内存后我竟然也能够理解进程和线程了，原来进程和线程也是围绕内存打转的，从一定程度上讲，它们的存在也是为了更加高效地利用内存。

从C语言到内存，从内存到进程和线程，环环相扣：不学C语言就吃不透内存，不学内存就吃不透进程和线程。

「内存 + 进程 + 线程」这几个最基本的计算机概念是菜鸟和大神的分水岭，也只有学习C语言才能透彻地理解它们。

Java、C#、PHP、Python、JavaScript 程序员工作几年后会遇到瓶颈，有很多人会回来学习C语言，重拾底层概念，让自己再次突破。

## C

输入和输出

```c++
#include <stdio.h>
int main()
{
    int a = 0, b = 0, c = 0, d = 0;
    scanf("%d", &a);  //输入整数并赋值给变量a
    scanf("%d", &b);  //输入整数并赋值给变量b
    printf("a+b=%d\n", a+b);  //计算a+b的值并输出
    scanf("%d %d", &c, &d);  //输入两个整数并分别赋值给c、d
    printf("c*d=%d\n", c*d);  //计算c*d的值并输出

    return 0;
}
```

### 检查的输入

最容易理解的字符输入函数是 getchar()，它就是 scanf("%c", c)的替代品，除了更加简洁，没有其它优势了；

或者说，getchar() 就是 scanf() 的一个简化版本。

```c++
#include <stdio.h>
int main()
{
    char c;
    c = getchar();
    printf("c: %c\n", c);

    return 0;
}
```

### getche()

就比较有意思了，它没有缓冲区，输入一个字符后会立即读取，不用等待用户按下回车键，这是它和 scanf()、getchar() 的最大区别。请看下面的代码：

### getch()

也没有缓冲区，输入一个字符后会立即读取，不用按下回车键，这一点和 getche() 相同。

getch() 的特别之处是它没有回显，看不到输入的字符。所谓回显，就是在控制台上显示出用户输入的字符；

没有回显，就不会显示用户输入的字符，就好像根本没有输入一样。

### gets()

这个专用的字符串输入函数，它拥有一个 scanf() 不具备的特性。

```c++
#include <stdio.h>
int main()
{
    char author[30], lang[30], url[30];
    gets(author);
    printf("author: %s\n", author);
    gets(lang);
    printf("lang: %s\n", lang);
    gets(url);
    printf("url: %s\n", url);

    return 0;
}
```

### if/else

```c++
#include <stdio.h>
int main()
{
    int age;
    printf("请输入你的年龄：");
    scanf("%d", &age);
    if(age>=18){
        printf("恭喜，你已经成年，可以使用该软件！\n");
    }else{
        printf("抱歉，你还未成年，不宜使用该软件！\n");
    }
    return 0;
}
```

### switch

```c++
#include <stdio.h>
int main(){
    int a;
    printf("Input integer number:");
    scanf("%d",&a);
    switch(a){
        case 1: printf("Monday\n");
        case 2: printf("Tuesday\n");
        case 3: printf("Wednesday\n");
        case 4: printf("Thursday\n");
        case 5: printf("Friday\n");
        case 6: printf("Saturday\n");
        case 7: printf("Sunday\n");
        default:printf("error\n");
    }
    return 0;
}
```

### array

```c++
#include <stdio.h>
int main(){
    int i, j;  //二维数组下标
    int sum = 0;  //当前科目的总成绩
    int average;  //总平均分
    int v[3];  //各科平均分
    int a[5][3] = {{80,75,92}, {61,65,71}, {59,63,70}, {85,87,90}, {76,77,85}};
    for(i=0; i<3; i++){
        for(j=0; j<5; j++){
            sum += a[j][i];  //计算当前科目的总成绩
        }
        v[i] = sum / 5;  // 当前科目的平均分
        sum = 0;
    }
    average = (v[0] + v[1] + v[2]) / 3;
    printf("Math: %d\nC Languag: %d\nEnglish: %d\n", v[0], v[1], v[2]);
    printf("Total: %d\n", average);
    return 0;
}
```

### 结构体数组

```c++
#include <stdio.h>
struct{
    char *name;  //姓名
    int num;  //学号
    int age;  //年龄
    char group;  //所在小组
    float score;  //成绩
}class[] = {
    {"Li ping", 5, 18, 'C', 145.0},
    {"Zhang ping", 4, 19, 'A', 130.5},
    {"He fang", 1, 18, 'A', 148.5},
    {"Cheng ling", 2, 17, 'F', 139.0},
    {"Wang ming", 3, 17, 'B', 144.5}
};
int main(){
    int i, num_140 = 0;
    float sum = 0;
    for(i=0; i<5; i++){
        sum += class[i].score;
        if(class[i].score < 140) num_140++;
    }
    printf("sum=%.2f\naverage=%.2f\nnum_140=%d\n", sum, sum/5, num_140);
    return 0;
}
```

### 指针

```c++
#include <stdio.h>
int main(){
    int a = 100, b = 999, temp;
    int *pa = &a, *pb = &b;
    printf("a=%d, b=%d\n", a, b);
    /*****开始交换*****/
    temp = *pa;  //将a的值先保存起来,在内存中是通过AX/BX寄存器实现temp存储
    *pa = *pb;  //将b的值交给a
    *pb = temp;  //再将保存起来的a的值交给b
    /*****结束交换*****/
    printf("a=%d, b=%d\n", a, b);
    return 0;
}
```

#### 关于 \* 和 & 的谜题

假设有一个 int 类型的变量 a，pa 是指向它的指针，那么*&a 和&*pa 分别是什么意思呢？

1. `*&a`

可以理解为`*(&a)`，`&a`表示取变量 a 的地址（等价于 pa），`*(&a)`表示取这个地址上的数据（等价于 `*pa`）

\*&a 仍然等价于 a。

2. `&\*pa

可以理解为`&(*pa)`，`*pa`表示取得 pa 指向的数据（等价于 a），`&(*pa)`表示数据的地址（等价于 `&a`）

所以&\*pa 等价于 pa。

### 文件操作

#### 使用 <stdio.h> 头文件中的 fopen() 函数即可打开文件

它的用法为：

````c++
FILE *fopen(char *filename, char *mode);
``

filename为文件名（包括文件路径），mode为打开方式，它们都是字符串。

fopen() 会获取文件信息，包括文件名、文件状态、当前读写位置等，并将这些信息保存到一个 FILE 类型的结构体变量中，然后将该变量的地址返回。

```c++
#include <stdio.h>
#include <stdlib.h>
#define N 100
int main() {
    FILE *fp;
    char str[N + 1];
    //判断文件是否打开失败
    if ( (fp = fopen("d:\\demo.txt", "rt")) == NULL ) {
        puts("Fail to open file!");
        exit(0);
    }
    //循环读取文件的每一行数据
    while( fgets(str, N, fp) != NULL ) {
        printf("%s", str);
    }

    //操作结束后关闭文件
    fclose(fp);
    return 0;
}
````

## C++

## 早期和 c 兼容时代

C++ 是在 C 语言的基础上开发的，早期的 C++ 还不完善，不支持命名空间，没有自己的编译器，而是将 C++ 代码翻译成 C 代码，再通过 C 编译器完成编译。

这个时候的 C++ 仍然在使用 C 语言的库，stdio.h、stdlib.h、string.h 等头文件依然有效；

此外 C++ 也开发了一些新的库，增加了自己的头文件，例如：

- iostream.h：用于控制台输入输出头文件。
- fstream.h：用于文件操作的头文件。
- complex.h：用于复数计算的头文件。

和 C 语言一样，C++ 头文件仍然以.h 为后缀，它们所包含的类、函数、宏等都是全局范围的。

## 命名空间的引入

后来 C++ 引入了命名空间的概念，计划重新编写库，将类、函数、宏等都统一纳入一个命名空间，这个命名空间的名字就是 std。

std 是 standard 的缩写，意思是“标准命名空间”。

但是这时已经有很多用老式 C++ 开发的程序了，它们的代码中并没有使用命名空间，直接修改原来的库会带来一个很严重的后果：程序员会因为不愿花费大量时间修改老式代码而极力反抗，拒绝使用新标准的 C++ 代码。

C++ 开发人员想了一个好办法:

### 保留原来的库和头文件

它们在 C++ 中可以继续使用，

### 原来的库复制一份

在此基础上稍加修改，把类、函数、宏等纳入命名空间 std 下，就成了新版 C++ 标准库。

这样共存在了两份功能相似的库，使用了老式 C++ 的程序可以继续使用原来的库，新开发的程序可以使用新版的 C++ 库。

为了避免头文件重名，新版 C++ 库也对头文件的命名做了调整，去掉了后缀.h，所以老式 C++ 的 iostream.h 变成了 iostream，fstream.h 变成了 fstream。

而对于原来 C 语言的头文件，也采用同样的方法，但在每个名字前还要添加一个 c 字母，所以 C 语言的 stdio.h 变成了 cstdio，stdlib.h 变成了 cstdlib。

需要注意的是，旧的 C++ 头文件是官方所反对使用的，已明确提出不再支持，但旧的 C 头文件仍然可以使用，以保持对 C 的兼容性。

实际上，编译器开发商不会停止对客户现有软件提供支持，可以预计，旧的 C++ 头文件在未来数年内还是会被支持。

## C++ 头文件的现状：

1. 旧的 C++ 头文件，如 iostream.h、fstream.h 等将会继续被支持，尽管它们不在官方标准中。这些头文件的内容不在命名空间 std 中。

2. 新的 C++ 头文件，如 iostream、fstream 等包含的基本功能和对应的旧版头文件相似，但头文件的内容在命名空间 std 中。
   注意：在标准化的过程中，库中有些部分的细节被修改了，所以旧的头文件和新的头文件不一定完全对应。

3. 标准 C 头文件如 stdio.h、stdlib.h 等继续被支持。头文件的内容不在 std 中。

4. 具有 C 库功能的新 C++头文件具有如 cstdio、cstdlib 这样的名字。它们提供的内容和相应的旧的 C 头文件相同，只是内容在 std 中。

可以发现，对于不带.h 的头文件，所有的符号都位于命名空间 std 中，使用时需要声明命名空间 std；

对于带.h 的头文件，没有使用任何命名空间，所有符号都位于全局作用域。这也是 C++ 标准所规定的。

不过现实情况和 C++ 标准所期望的有些不同，对于原来 C 语言的头文件，即使按照 C++ 的方式来使用，即#include <cstdio>这种形式，那么符号可以位于命名空间 std 中，也可以位于全局范围中，请看下面的两段代码。

1. 使用命名空间 std：

```c++
#include <cstdio>
int main(){
    std::printf("http://c.biancheng.net\n");
    return 0;
}
```

2. 不使用命名空间 std：

```c++
#include <cstdio>
int main(){
    printf("http://c.biancheng.net\n");
    return 0;
}
```

```c++
#include <iostream>
#include <string>

int main(){
    //声明命名空间std
    using namespace std;

    //定义字符串变量
    string str;
    //定义 int 变量
    int age;
    //从控制台获取用户输入
    cin>>str>>age;
    //将数据输出到控制台
    cout<<str<<"已经成立"<<age<<"年了！"<<endl;

    return 0;
}
```
