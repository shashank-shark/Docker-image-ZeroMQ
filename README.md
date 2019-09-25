# Docker-image-ZeroMQ
A docker image containing development tools for zeromq.

Note that this image comes with libzmq v3.x.x and czmq v3.x.x and are not the latest version.


The main aim of this image is to provide a learning and testing platform for newbies who want to explore zeromq.


The reason for not using the latest version is because the libraries went through significant chnages and hence there was no updated guide in accordance with the newer versions. So, in order to bring a learning experince with Z-GUIDE (http://zguide.zeromq.org/page:all) this docker image was made.

## Using the docker image

#### **First pull out the image from doker hub**

$ `docker pull shashankshark/zeromq-dev`

#### **Verify the pull**

$ `sudo docker images`

#### **Run the container**
$ `sudo docker run -d -P --name test_zmq shashankshark/zeromq-dev`

#### **Find the port number on which container is communicating for ssh**

$ `sudo docker port test_zmq 22`

You can expect your output would be something like `0.0.0.0:49154`

Here `49154` is the port number that we need. Note that it may be different on your system.

#### **Now ssh into the container**

You can either ssh from terminal like

$ `ssh root@localhost -p 49154`

OR

You can use vscode's remote-explorer package to connect. I prefer this way because you can have a awesome gui and a terminal without any extra configurations.

You can refer to this link for setting up the environment (just installing a package).
https://medium.com/@agavatar/working-with-docker-in-visual-studio-code-756ea8b32abc

#### **Set your LOCALE**

$ `export LC_ALL=C`

#### **Now let's test by compiling a piece of zmq code**

Copy the below program to `wuclient.c`

```c
//  Weather update client
//  Connects SUB socket to tcp://localhost:5556
//  Collects weather updates and finds avg temp in zipcode

#include "zhelpers.h"

int main (int argc, char *argv [])
{
    //  Socket to talk to server
    printf ("Collecting updates from weather server...\n");
    void *context = zmq_ctx_new ();
    void *subscriber = zmq_socket (context, ZMQ_SUB);
    int rc = zmq_connect (subscriber, "tcp://localhost:5556");
    assert (rc == 0);

    //  Subscribe to zipcode, default is NYC, 10001
    char *filter = (argc > 1)? argv [1]: "10001 ";
    rc = zmq_setsockopt (subscriber, ZMQ_SUBSCRIBE,
                         filter, strlen (filter));
    assert (rc == 0);

    //  Process 100 updates
    int update_nbr;
    long total_temp = 0;
    for (update_nbr = 0; update_nbr < 100; update_nbr++) {
        char *string = s_recv (subscriber);

        int zipcode, temperature, relhumidity;
        sscanf (string, "%d %d %d",
            &zipcode, &temperature, &relhumidity);
        total_temp += temperature;
        free (string);
    }
    printf ("Average temperature for zipcode '%s' was %dF\n",
        filter, (int) (total_temp / update_nbr));

    zmq_close (subscriber);
    zmq_ctx_destroy (context);
    return 0;
}
```

and the below code to `wuserver.c`

```c
//  Weather update server
//  Binds PUB socket to tcp://*:5556
//  Publishes random weather updates

#include "zhelpers.h"

int main (void)
{
    //  Prepare our context and publisher
    void *context = zmq_ctx_new ();
    void *publisher = zmq_socket (context, ZMQ_PUB);
    int rc = zmq_bind (publisher, "tcp://*:5556");
    assert (rc == 0);

    //  Initialize random number generator
    srandom ((unsigned) time (NULL));
    while (1) {
        //  Get values that will fool the boss
        int zipcode, temperature, relhumidity;
        zipcode     = randof (100000);
        temperature = randof (215) - 80;
        relhumidity = randof (50) + 10;

        //  Send message to all subscribers
        char update [20];
        sprintf (update, "%05d %d %d", zipcode, temperature, relhumidity);
        s_send (publisher, update);
    }
    zmq_close (publisher);
    zmq_ctx_destroy (context);
    return 0;
}
```

#### **Now compile and run the program**

$ `gcc wuclient.c -lczmq -lzmq -o weather-client`

$ `gcc wuserver.c -lczmq -lzmq -o weather-server`

$ `./weather-server`

$ `./weather-client`


### Need an image with latest lib's ?

If you need an image with pre-installed and pre-configured ZeroMQ libraries, you can reach out to my another docker image.

The following are the updates and versions of the libraries that are installed in the image.

## IMAGE UPDATE
