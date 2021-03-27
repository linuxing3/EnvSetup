# set go environment
#
ggg() {
	if [ -e /usr/lib/go/bin/go ]; then
		export GOROOT=/usr/lib/go
	elif [ -e $HOME/.go ]; then
		export GOROOT=$HOME/.go
	elif [ -e /usr/local/go ]; then
		export GOROOT=/usr/local/go
	fi

	export GO111MODULE=on
	export GOPATH=$HOME/go
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
}

go_asm() {
	green ""
	green "你可以使用两种命令来生成汇编代码"
	green "go build -gcflags -S $1"
	green "go tool 6g -S $1"
	green ""
	green "符号说明:"
	green "PC、R0 和 SP 都是寄存器。"
	green "还有两个预声明的符号，即 SB（静态基）和 FP（帧指针）。除跳转标签外，所有用户定义的符号都会写作这些伪寄存器的偏移量。"
	green ""
	green "SB  =>  内存来源 符号 foo(SB) 是将名字 foo 作为内存地址。"
	green ""
	green "FP  Function Pointer  =>  用于引用函数实参的虚拟帧指针"
	green "0(FP) 函数的第一个实参"
	green "8(FP) 就是第二个（在64位机器上, 8 x 8 = 64)"
	green "实参名字放在前面， first_arg+0(FP) 和 second_arg+8(FP) "
	green ""
	green "SP Stack Pointer   =>  引用局部栈帧变量的虚拟栈指针，其实参用于函数调用。 "
	green "它指向栈顶，因此引用需使用区间偏移量： 如 x-8(SP)、y-4(SP)"
	green "x-8(SP) 引用了虚拟栈指针的伪寄存器 "
	green "-8(SP) 引用了硬件上的 SP 寄存器。"
	green ""
	green "\$24-8表示函数栈桢需要占用24字节, 参数占用8字节(1字节=8位),内存中显示如下"
	green "00 00 00 00      00 00 00 00"
	green "00 是16进制的写法, 即十进制的0 "
	green "用二进制表示就是 0000-0000"
	green "FF 是16进制的写法,即十进制的255 =  (128 + 64 + 32 + 16) + (8 + 4 + 2 + 1)"
	green "用二进制表示就是 1111-1111"

	green ""
	green "DATA	symbol+offset(SB)/width, value"
	green "DATA divtab<>+0x00(SB)/4, \$0xf4f8fcff 在SB偏移00的位置创建一个4字节的divtab符号"
	green ""
	green "GLOBL runtime·tlsoffset(SB), NOPTR, \$4 在SB处创建一个名为tlsoffset的4字节符号,不是指针,无需垃圾回收"
	green ""
}

go_build_without_debuginfo() {
	green "可通过向[连接器]传递 '-w' 标记来省略调试信息"
	go build -ldflags "-w" $1
}

go_build_without_optimization() {
	green "内联函数调用和注册变量。这些优化有时会让 GDB 调试变得更难。要在调试时关闭它们"
	go build -gcflags "-N -l" $1
}

go_build_with_escape() {
	green "m可以检查代码的编译优化情况，打印出编译器逃逸分析的过程"
	go build -gcflags "-m -l" $1
}

go_gdb() {
	go_gdb_help
}

go_gdb_help() {
	green "为代码显示文件与行号，设置断点并反汇编："
	green "(gdb) list"
	green "(gdb) list line"
	green "(gdb) list file.go:line"
	green "(gdb) break line"
	green "(gdb) break file.go:line"
	green "(gdb) disas"
	green "显示回溯并展开栈帧："
	green "(gdb) bt"
	green "(gdb) frame n"
	green "显示本地变量、实参与返回值的栈帧上的名字、类型与位置："
	green "(gdb) info locals"
	green "(gdb) info args"
	green "(gdb) p variable"
	green "(gdb) whatis variable"
	green "显示全局变量的名字、类型与位置："
	green "(gdb) info variables regexp"
}

go_test_c() {
	cd $GOROOT/src/pkg/regexp
	green "生成regexp.test文件"
	go test -c

	green ""
	green "gdb regexp.test -d $GOROOT"
	green "使用 l 或 list 命令来检查源码。"
	green "(gdb) l main.main"
	green "(gdb) l regexp.go:1"
	green "测试函数"
	green "(gdb) b 'regexp.TestFind'"
	green "(gdb) info goroutines"

	green "检查栈"
	green "bt or backtrace"
	green "gouroute 1 bt"

	green "(gdb) info frame 显示栈"
	green "(gdb) info args 显示实参"
	green "(gdb) p locals 显示本地变量"
	green "(gdb) p re 显示实参, 其实是一个指针"
	green "(gdb) p *re 显示实参的内容"
	green "(gdb) p *re->prog 显示实参的prog对象"

}

go_compile() {
	green "反编译代码为汇编代码"
	go tool compile -S -N -l $1 >$2
}

go_pprof() {
	cat >>cpu.go <<-EOF
		package main
		import (
		    "github.com/pkg/profile"
		    "time"
		)
		func joinSlice() []string {
		    var arr []string
		    for i := 0; i < 100000; i++ {
		     // 故意造成多次的切片添加(append)操作, 由于每次操作可能会有内存重新分配和移动, 性能较低
		        arr = append(arr, "arr")
		    }
		    return arr
		}
		func main() {
		    // 开始性能分析, 返回一个停止接口
		    stopper := profile.Start(profile.CPUProfile, profile.ProfilePath("."))
		    // 在main()结束时停止性能分析
		    defer stopper.Stop()
		    // 分析的核心逻辑
		    joinSlice()
		    // 让程序至少运行1秒
		    time.Sleep(time.Second)
		}
	EOF
	go build -o cpu cpu.go
	./cpu
	tool pprof --pdf cpu cpu.pprof >cpu.pdf
}

ggg
