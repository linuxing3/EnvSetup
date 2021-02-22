#!/usr/bin/env bash
echo "========================================================================="
echo "Quickly set up database on windows 10"
echo "We intentionally use git bash to ensure nix like environment"
echo "to use this shell script and deno/go on windows"
echo "========================================================================="

PATH=/c/ProgramData/chocolatey/bin:/c/Users/Administrator/.deno/bin:/c/Go/bin/go:/c/Users/Administrator/go/bin:$PATH
PATH=/c/Users/Administrator/EnvSetup/bash/bin:/lib/mingw/mingw64/bin:$PATH

echo "Setting global environment variables"
export POST_PASSWORD=20090909
export POST_HOST=homepi.local
export POST_PORT=5432
export POST_DATABASE=vpsman
export POST_USERNAME=pi
export DATABASE_URL="postgresql://$POST_USERNAME:$POST_PASSWORD@$POST_HOST:$POST_PORT/$POST_DATABASE?schema=public"

while true; do
  read -r -p "请选择你的功能   [1] db [2] prisma [3] frontend:  " opt
  case $opt in
    1)
      echo "1. 数据库初始化"
      echo "Using denodb/orm to setup your database"
      cd ~/workspace/js-projects/deno-game-monitor
      cat ./.env
      deno run -A --unstable ./denodb/sql/create_table_postgres.ts
      break
      ;;
    2)
      echo "2.3. 生成CLI客户端"
      echo "Using prisma to introspect your database"
      cd ~/go/src/github.com/linuxing3/go-prisma
      cat ./.env
      echo "2.1. 数据库导入"
      go run github.com/prisma/prisma-client-go introspect
      echo "2.2. 数据库迁移(optional)"
      go run github.com/prisma/prisma-client-go db push --preview-feature
      echo "2.3. 生成CLI客户端"
      go run github.com/prisma/prisma-client-go generate
      echo "Now you can build your CLI client"
      echo "go run ."
      break
      ;;
    3)
      echo "3.3. 生成web客户端"
      echo "Using vpsman-post to generate automatically frontend pages"
      cd ~/go/src/github.com/linuxing3/vpsman-post
      cat ./adm.ini
      go mod tidy
      adm geneate -l cn -c adm.ini
      echo "Now you can build your frontend client"
      echo "go run ."
      break
      ;;
    *)
      echo "Please choose corret answer"
      ;;
  esac
done