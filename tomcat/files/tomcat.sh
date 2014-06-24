export CATALINA_HOME={{ tomcatHome }}
export CATALINA_BASE={{ tomcatHome }}
export JAVA_OPTS="-Djava.awt.headless=true -Xmx{{ javaXmx }} -XX:MaxPermSize={{ javaMaxPermSize }}"