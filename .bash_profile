# .sh_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

#here begin log process.

unset COMMAND

echo ""
echo "Use 'passwd' to change your password"
echo "Use 'help' to get help"
echo "Use 'exit' or 'logout' to logout"
echo ""
echo "Telnet use 'telnet IP' or 'telnet IP PORT'"
echo "SSH use 'ssh user@IP' or 'ssh user@IP PORT'"
echo ""
echo "You may telnet or ssh to your devices below"
echo ""


while [ "$COMMAND" != "exit" ] && [ "$COMMAND" != "logout" ]
do
#User can input 'Ctrl+C'.
trap 2
#Read words from input.
        echo -n "[$USER@Bravo ~]$ "
        read COMMAND
        LENTH=${#COMMAND}
#If user inputs "Enter", continue.
        if [ $LENTH = 0 ]; then
                continue
        fi
#User changes his/her password.
        if [ "$COMMAND" = "passwd" ]; then
                passwd
                echo ""
                continue
        fi
#User gets help.
        if [ "$COMMAND" = "help" ]; then
                echo ""
                echo "Telnet use 'telnet IP' or 'telnet IP PORT'"
                echo "z.B. 'telnet 10.10.10.10' or 'telnet 10.10.10.10 23'"
                echo ""
                echo "SSH use 'ssh user@IP' or 'ssh user@IP PORT'"
                echo "z.B. 'ssh user@10.10.10.10' or 'ssh user@10.10.10.10 22'"
                echo ""
                echo "Use 'exit' or 'logout' to logout"
                continue
        fi
#Get date, commnad(telnet or ssh), port from system and input.
        DATE=`date +%Y-%m%d-%H%M%S`
#Get the first string named CMD, it must be "telnet" or "ssh".
        CMD=`echo $COMMAND | awk '{print $1}' | tr '[A-Z]' '[a-z]'`
#Get the last string named PORT, it maybe "port number".
        PORT=`echo $COMMAND | awk '{print $NF}'`

#Begin telnet.
        if [ "$CMD" = "telnet" ]; then
#If user input more than 4 trings, continue
                N=`echo $COMMAND | awk '{print NF-1}'`
                if [ $N -gt 2 ]; then
                echo "Too many parameters! Type 'help' to get help"
                continue
                fi
#Ensure thers is more than two strings, get IP address from input and define file name.if IP is null, continue.
                if [ "$CMD" != "$COMMAND" ]; then
                        IP=`echo $COMMAND | awk '{print $2}'`
                        FILE="[$IP]-[$USER]-[$DATE]"
#If IP is null, prompt to input IP address, continue.
                else
                        echo "Please Input IP address!"
                        continue
                fi
#Get port number, if it is null, set default.
                if [ $PORT = $IP ]; then
                        PORT="23"
#If the port is a number and it must between 0-65535.
                else if expr $PORT + 0 &>/dev/null; then
                        if [ "$PORT" -gt "0" ] && [ "$PORT" -lt "65535" ]; then
                                PORT=$PORT
                        else
                                echo "Please input a legal Port number!"
                                continue
                        fi
#If the port is not legal, prompt to input a legal Port number.
                      else
                              echo "Please input a legal Port number!"
                              continue
                      fi
                fi
#Print the command.
                echo "telnet $IP $PORT"
#Excute the command, read from standard input and write to a file, ignore-interrupts.
                telnet $IP $PORT | tee -i /var/telnet_log/$FILE
                echo""

#Begin ssh
        else    if [ "$CMD" = "ssh" ]; then
#If user input more than 4 trings, continue
                N=`echo $COMMAND | awk '{print NF-1}'`
                if [ $N -gt 2 ]; then
                echo "Too many parameters! Type 'help' to get help"
                continue
                fi
#Ensure thers is more than two strings, get IP address from input and define file name.if IP is null, continue.
                        if [ "$CMD" != "$COMMAND" ]; then
                                IP=`echo $COMMAND | awk '{print $2}'`
                                FILE="[$IP]-[$USER]-[$DATE]"
#If IP is null, prompt to input IP address, continue.
                        else
                                echo "Please Input IP address!"
                                continue
                        fi
#Get port number, if it is null, set default.
                        if [ $PORT = $IP ]; then
                                PORT="22"
#If the port is a number it must between 0-65535.
                        else if expr $PORT + 0 &>/dev/null; then
                                if [ "$PORT" -gt "0" ] && [ "$PORT" -lt "65535" ]; then
                                PORT=$PORT
                                else
                                        echo "Please input a legal Port number!"
                                        continue
                                fi
#If the port is not legal, prompt to input a legal Port number.
                             else
                                        echo "Please input a legal Port number!"
                                        continue
                             fi 
                        fi
#Print the command.
                        echo "ssh $IP -p $PORT"
#Excute the command, read from standard input and write to a file, ignore-interrupts.
                        ssh $IP -p $PORT | tee -i /var/ssh_log/$FILE
                        echo""
#If user inputs other words, continue
                else
                        if [ "$CMD" != "exit" ] && [ "$CMD" != "logout" ]; then
                                echo "Bad Command! Use 'help' to get help"
                                continue
                        fi
                fi
                fi
done
        echo "Logout, Auf Wiedersehen!"
exit
