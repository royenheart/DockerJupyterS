# 自动构建docker镜像并配置jupyternotebook服务器

## 如何部署

克隆该仓库并进入目录，在安装了docker环境情况下运行`./build.sh`，可在本地的7777端口开启jupyternotebook服务器

1. `git clone https://github.com/royenheart/DockerJupyterS.git`
2. `cd DockerJupyterS`
3. `./build.sh`

(可能需要修改一下所属用户)

若构建成功，会在用户家目录下创建`pythonS`目录，存储notebook笔记

若在服务器上构建并准备在浏览器中浏览，请正确配置服务器的域名解析、ip地址，检查7777端口是否开启以及防火墙措施

## 常见问题

1. docker容器已运行，但浏览器无法打开

请检查服务器的网络设置，确保浏览器能访问服务器的7777端口

## TODO

- 设置一键部署反代（apache2）
- 设置SSL证书 
