#!/usr/bin/env python
# encoding: utf-8
"""
yarn.py - the Tin Can server.

Initializes the tornado server, sets the routing paths, initializes the model,
etc.

Created by Drew Harry on 2010-06-09.
Copyright (c) 2010 MIT Media Lab. All rights reserved.
"""

import logging
import tornado.httpserver
import tornado.ioloop
import tornado.web
import simplejson as json


class RoomsHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Rooms.")


class UsersHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Users.")


class ConnectionHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Connection.")

# Set up the routing tables for the application.
# For now, they're really simple - one for getting information about rooms,
# one for getting information about users (and registering a new user),
# and one for managing persistent connections. 
application = tornado.web.Application([
(r"/rooms/", RoomsHandler),
(r"/users/", UsersHandler),
(r"/connect/", ConnectionHandler)])

if __name__ == '__main__':
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(8888)
    tornado.ioloop.IOLoop.instance().start()

