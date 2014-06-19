export CATALINA_HOME={{ tomcat_home }}
export CATALINA_BASE={{ tomcat_home }}
export JAVA_OPTS="-Djava.awt.headless=true -Xmx{{ java_Xmx }} -XX:MaxPermSize={{ java_MaxPermSize }}"