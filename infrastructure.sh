#!/bin/bash

function mysqlIsRunning() {
    docker exec -it serp_mysql_1 bash -c 'mysqladmin -proot ping' | grep 'mysqld is alive'
}

DOCKER_COMPOSE_ARGS=$@

if [[ ${DOCKER_COMPOSE_ARGS[0]} == "up -d" ]]; then

    # start infrastrucutre
    docker-compose -p serp -f infrastructure.yml up -d mysql

    # wait for successful mysql startup
    MYSQL_WAIT_COUNTER=0;
    SLEEP_TIME=5;
    TIME_TO_WAIT=30;
    while [[ -z ${MYSQL_IS_RUNNING} ]] && [[ ${MYSQL_WAIT_COUNTER} -le ${TIME_TO_WAIT} ]]; do
        echo "waiting for successful mysql startup ..."
        sleep ${SLEEP_TIME}
        ((MYSQL_WAIT_COUNTER+=${SLEEP_TIME}))
        MYSQL_IS_RUNNING=$(mysqlIsRunning)
    done

    # run mysql init scripts
    if [[ -n ${MYSQL_IS_RUNNING} ]]; then
        echo "ready to run database init scripts"
    else
        echo "unable to start mysql successfully within ${TIME_TO_WAIT}s, exiting..."
        exit 1
    fi
else
    docker-compose -p serp -f infrastructure.yml ${DOCKER_COMPOSE_ARGS}
fi