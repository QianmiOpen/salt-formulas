salt-formulas
=============

用于存放salt sls文件。以模块化的方式组织不同的组件。
以tomcat为例简单说明组件组织方式：
tomcat
├── env.sls
├── files
│   ├── server.xml
│   └── tomcat.sh
├── init.sls
├── settings.sls
├── shutdown.sls
├── startup.sls
└── vhosts.sls

- 组件根目录用于存放执行动作对应的sls文件。
- 需要上传到minion主机中的文件统一存放到组件的files文件中
- 组件需要用到的安装包，如果需要从外网下载的，考虑到网速，统一放到组件的pkgs（参见：<http://git.dev.ofpay.com/TDA/salt-pkgs>）目录中。

在执行file.managed时，使用saltenv从base环境获取对应的包。
以java的安装为例子：
    - source: salt://java/pkgs/{{ java.package }}
    - saltenv: base
