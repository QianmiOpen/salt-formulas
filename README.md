salt-formulas
=============

用于存放salt sls文件。以模块化的方式组织不同的组件。
以tomcat为例简单说明组件组织方式：
tomcat
├── env.sls
├── files
│   ├── server.xml
│   └── tomcat.sh
├── init.sls
├── settings.sls
├── shutdown.sls
├── startup.sls
└── vhosts.sls

1. 组件根目录用于存放执行动作对应的sls文件。
2. 需要上传到minion主机中的文件统一存放到组件的files文件中
