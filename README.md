# Damn Vulnerable Redis Container
-----------------------------

It's known there are security issues with running redis without authentication (which is the default behavior). [Others have shown](http://antirez.com/news/96) exposing redis on a port can lead to RCE (in this example, only if ssh is exposed). [Others have also shown](http://www.agarri.fr/kom/archives/2014/09/11/trying_to_hack_redis_via_http_requests/index.html) you can run Redis commands via CSRF.

This docker image runs Redis and SSH, and provides a CSRF example, which will write your SSH key to the authorized_keys file, even if redis is not exposed, allowing an attacker to log in.

## Setup
-----------------------------

Build the docker image

```
docker build -t redis .
```

Run the container, forwarding redis ports and ssh ports (ssh is forwarded onto port 2222 for simplicity)

```
docker run -p 127.0.0.1:2222:22 -p 127.0.0.1:6379:6379 -t redis
```

You should now have redis running on port 6379 and ssh on 2222. Try logging into port 2222 and you should be greeted with a password prompt

```
$ ssh testuser@localhost -p 2222
testuser@localhost's password: 
```

Visit [https://security.love/Damn-Vulnerable-Redis-Container/csrf.html](https://security.love/Damn-Vulnerable-Redis-Container/csrf.html) in Firefox (not currently sure why this doesn't work in chrome, pull requests welcome), paste your SSH key in, and submit it. You should now be able to log into port 2222 without a password.

```
$ ssh testuser@localhost -p 2222
Welcome to Ubuntu 14.04.5 LTS (GNU/Linux 3.19.0-65-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Last login: Sun Sep 11 00:59:35 2016 from 172.17.0.1
```
## Impact
Servers or dev machines running Redis unathenticated internally with SSH externally exposed can be compromised by getting a victim to visit a malicious link. 
