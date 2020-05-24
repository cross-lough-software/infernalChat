# infernalChat
Infernal Chat

A straightforward chat page written in Perl. Free of any extra useless baggage and encumberances. It could perhaps serve as a message board, guestbook or notepad. It could be somewhere for throwing up those ideas you think are notable at the time but are actually useless.

Main script name: `infChat.pl`

# Docker
This will explain how to build and run the docker container and copy files
that have been changed into the docker container.

To build the docker container run the below command from the root directory of the repo:

`docker build -t infernal_chat .`

1. The default name for a docker file is Dockerfile.
2. The above command will look for this file and run it.
3. The **-t** command tags the custom image with a name.
4. The **dot (.)** tells it to build the docker image.

Once this is complete you can use: docker images command to see all the images that have been built.

Once the container is built you will need to run the container using this command:

`docker run -p 80:80 -p 443:443 -it/-d --name=infernal_chat infernal_chat`

1. **-it** is optional this will show the docker container output in the command line.
2. This could be changed to -d which means it will run as a daemon.
**--name=infernal_chat.**
3. This command will change the name of the running container.
4. This is useful for the copy command below.

**infernal_chat**

In the example command this is used select an image to run. but will have to run everytime:

The command below can be used to copy files over to the docker container:

`docker cp www-static/html infernal_chat:/var/www/`

**www-static/html**
This is the host path to the folder you want to copy

**infernal_chat:/var/www/**
infernal_chat is for the container name.
**/var/www/**
Is the path you want to copy to.

This also could be done by using -v command when running the docker container which is a volume command.
This makes the changes instant.
For this to work the **full path will have to be given** to the folder using -v
An example command is below:

`docker run -p 80:80 -p 443:443 -it -v /home/userNameHere/Documents/infernalChat/www-static/html:/var/www/html --name=infernal_chat infernal_chat`

So for -v you give the full path for the host folder and then the path for
the container folder you want to link seperated by a :.

**Docker tips**

To delete containers that are not running you can use:

`docker container prune`

To delete images that are old builds and are still hanging around know as dangling images use

`docker image prune`

Or if you want one command to do everything you can use:

`docker system prune`

To see docker processes use:

`docker ps`

To stop a container use:

`docker stop <continer name>`
