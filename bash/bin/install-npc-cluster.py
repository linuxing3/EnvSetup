#!/usr/bin/env python3

from os import path
from subprocess import call
import click

# 定义一个命令组
cli = click.Group()

def restart():
    executable=path.expanduser("~/npc/npc")
    print("Executalbe is " + executable)
    call(["systemctl","restart", "Npc"])
    call(["systemctl","status", "Npc"])

# 这里使用cli代替click
@cli.command()
@click.option("--vkey", "-k", prompt=True, default="qqyzkzldrxycbdzwwsgh",  help="Unique client key")
@click.option("--port", "-p", prompt=True, default="8024",  help="Unique nps server port")
@click.option("--server", "-s", prompt=True, default="xunqinji.xyz", help="Your nps server address")
def connect(server, port, vkey):
    print(server + ":" + port)
    print(vkey)
    #write_file()
    configfile=path.expanduser("~/npc/conf/npc.conf")
    file=open(configfile, "a+")
    file.write("\n[common]\n")
    file.write("server_addr=" + server + ":" + port + "\n")
    file.write("vkey=" + vkey + "\n")
    file.write("conn_type=tcp\n")
    file.write("auto_reconnection=true\n")
    file.write("crypt=true\n")
    file.write("compress=true\n")
    file.close()
    print("Writen to " + configfile)

@cli.command()
@click.option("--memo", "memo", prompt=True, default="Tcp Tunnel")
@click.option("--mode", "mode", prompt=True, default="tcp", help="tcp, socks5, http_proxy")
@click.option("--listen", "listen", prompt=True, default="2222")
@click.option("--target", "target", prompt=True, default="127.0.0.1:22")
def tunnel(memo, mode, listen, target):
    #write_file()
    configfile=path.expanduser("~/npc/conf/npc.conf")
    file=open(configfile, "a+")
    file.write("\n[" + memo + "]\n")
    file.write("mode=" + mode + "\n")
    file.write("server_port=" + listen + "\n")
    file.write("target_addr" + target + "\n")
    file.close()
    print("Writen to " + configfile)

@cli.command()
@click.option("--opt", type=click.Choice(['connect', 'tunnel', 'restart'], case_sensitive=False))
@click.pass_context
def main(ctx, opt):
    click.echo(opt)
    if opt == 'connect':
        ctx.invoke(connect)
    elif opt == 'tunnel':
        click.invoke(tunnel)
    elif opt == 'restart':
        restart()
    else:
        print("Use --help to see usage!")

if __name__ == "__main__":
    main()
