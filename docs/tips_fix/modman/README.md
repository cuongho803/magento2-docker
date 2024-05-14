0. git clone repo_url ./source
0. fr-docker-nit sourcepath = /home/[.....]/[project_name]/source
1. edit document root = /app/html/pub
2. exec insite container deploy  (command nginx run --rm deploy)
3. install modman
4. cd html -> modman repair --force
 
(do cái này nó có sub html, nên ko xài dc "php|composer" ở ngoài host, phải vào container mới dùng dc)

insite docker => rm .modman, ln -s ../custom .modman again
download and install modman, and ./modman repair --force

