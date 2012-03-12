**Pappy helps you make really easy mobile APIs**

Install Pappy
=============

0\. Get and use quicklisp

```bash
$ curl -O http://beta.quicklisp.org/quicklisp.lisp
$ sbcl --load quicklisp.lisp
```

1\. Clone pappy into ~/quicklisp/local-projects

```bash
$ cd ~/quicklisp/local-projects && git clone git@github.com:colinyoung/pappy.git 
```

2\. Install pappy binaries

```bash
$ cd ~/quicklisp/local-projects/pappy && sbcl --load install.lisp
```

3\. Use pappy binary to generate your project

```bash
# In your project's parent directory
$ pappy new myproject

# This is obviously meant to look like rails.
```

4\. Start a server

```bash
# In your project directory
$ pappy server
```
