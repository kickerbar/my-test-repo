#!/bin/bash
# 기존 실행 중인 자바 프로세스 종료
pid=$(pgrep -f 'my-app-1.0.jar')
if [ -n "$pid" ]; then
    kill -9 $pid
fi

# 새 JAR 실행 (백그라운드)
nohup java -jar /app/my-app-1.0.jar > /app/app.log 2>&1 &