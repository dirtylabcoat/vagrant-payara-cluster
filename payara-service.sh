#!/bin/sh
### BEGIN INIT INFO
# Provides:          payara5
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Basic Payara service
# Description:       Start, stop and restart the Payara server
### END INIT INFO

PAYARA_HOME=/opt/payara5
export PAYARA_HOME

start() {
    echo -n "Starting Payara: "
    $PAYARA_HOME/bin/asadmin start-domain $1
}

stop() {
    echo -n "Stopping Payara: "
    $PAYARA_HOME/bin/asadmin stop-domain $1
}

case "$1" in
    start)
        start ${2:-domain1}
        ;;
    stop)
        stop ${2:-domain1}
        ;;
    restart)
        $PAYARA_HOME/bin/asadmin restart-domain >/dev/null
        ;;
    \*)
        echo "usage: $0 (start|stop|restart|help)"
esac
