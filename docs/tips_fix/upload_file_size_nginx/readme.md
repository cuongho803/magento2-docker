## Fix issue upload file big size 

- Go to source ~/Docker/.shared-services/nginx.tmpl and add command 

` client_max_body_size 4G; `

![](../../imgs/client_max_body_size.jpg)

- Reload `cd ~/Docker and bash docker-setup.sh`


