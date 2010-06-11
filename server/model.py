#!/usr/bin/env python
# encoding: utf-8
"""
types.py

Defines the basic types for the server:
 * room
 * meeting
 * user
 * task
 * topic

Created by Drew Harry on 2010-06-09.
Copyright (c) 2010 MIT Media Lab. All rights reserved.
"""

import uuid
import time
import simplejson as json


# This dictionary stores all known major types. This is used primarily so 
# we can cheaply bridge UUIDs into objects. When any of these major types
# is created, it's automatically registered here (via the YarnBaseType
# constructor). 
db = {}

class YarnBaseType(object):
    """Identify object with a UUID and register it with the store."""
    
    def __init__(self):
        # If one of the subclasses has already set this, move on. If it was
        # left as None, then we'll generate a new UUID for it. 
        if(self.uuid==None):
            self.uuid = str(uuid.uuid4())
        
        # Register the new object with the main object store.
        db[self.uuid] = self
        
    def getDict(self):
        return {"uuid":self.uuid}
    
    def getJSON(self):
        """Return a JSON representation of the type."""
        return json.dumps(self.getDict())
        
    # TODO do we ever need to del these things? if so, overload that operator
    # here and make sure to pull the object out of obj. 

class Room(YarnBaseType):
    """Store the room-related information."""

    def __init__(self, name, roomUUID=None, currentMeeting=None):
        self.uuid = roomUUID
        YarnBaseType.__init__(self)
        
        self.name = name
        
        if(currentMeeting != None)
            self.currentMeeting = obj[  currentMeeting]
    
    def getDict(self):
        d = YarnBaseType.getDict(self)
        d["name"] = self.name
        d["currentMeeting"] = self.currentMeeting.uuid
        return d
        
class Meeting(YarnBaseType):
    """Store meeting-related information."""

    def __init__(self, meetingUUID=None, roomUUID=None, title=None, startedAt=None):
        self.uuid = meetingUUID
        YarnBaseType.__init__(self)
        self.room = roomUUID
        self.title = title
        
        if startedAt==None:
            self.startedAt = time.time()
        else:
            self.startedAt = startedAt
            
        self.endedAt = None
        self.isLive = False
        self.allParticipants = []
        self.currentParticipants = []
        
    
    def getDict(self):
        d = YarnBaseType.getDict(self)
        d["endedAt"] = self.endedAt
        d["isLive"] = self.isLive
        d["allParticipants"] = self.allParticipants
        d["currentParticipants"] = self.currentParticipants
        return d
    

class User(YarnBaseType):
    """Store meeting-related information."""
    
    def __init__(self, name, userUUID=None):
        self.uuid = userUUID
        
        YarnBaseType.__init__(self)
        
        self.name = name
        self.inMeeting = None
        self.loggedIn = False
        self.status = None
        
    def getDict(self):
        d = YarnBaseType.getDict(self)
        d["name"] = self.name
        d["inMeeting"] = self.inMeeting
        d["loggedIn"] = self.loggedIn
        d["status"] = self.status
        return d


class MeetingObjectType(YarnBaseType):
    """Defines some basic properties that are shared by meeting objects."""

    def __init__(self, creatorUUID, meetingUUID):
        YarnBaseType.__init__(self)

        # TODO we almost certainly want to unswizzle these UUIDS
        # to their actual objects. When we do that, we'll need to
        # switch all the getDict methods to getting the UUID instead
        # of just taking the whole object like it does now.
        self.createdBy = creatorUUID
        self.createdAt = time.time()

        self.meeting = meetingUUID
    
    def getDict(self):
        d = YarnBaseType.getDict(self)
        d["createdBy"] = self.createdBy.uuid
        d["createdat"] = self.createdAt
        d["meeting"] = self.meeting.uuid
        return d

class Task(MeetingObjectType):
    """Store information about a task."""
    
    def __init__(self, meetingUUID, creatorUUID, text):
        self.uuid=None

        MeetingObjectType.__init__(self, creatorUUID, meetingUUID)
        self.text = text
        self.ownedBy = None
        
    def getDict(self):
        d = MeetingObjectType.getDict(self)
        d["text"] = self.text
        d["ownedBy"] = self.ownedBy.uuid
        return d

class Topic(MeetingObjectType):
    """Store information about a topic."""

    def __init__(self, meetingUUID, creatorUUID, text, timeStarted=None, timeEnded=None):
        self.uuid=None

        MeetingObjectType.__init__(self, creatorUUID, meetingUUID)
        self.text = text
        self.timeStarted = timeStarted
        self.timeEnded = timeEnded

    def getDict(self):
        d = MeetingObjectType.getDict(self)
        d["text"] = self.text
        d["timeStarted"] = self.timeStarted
        d["timeEnded"] = self.timeEnded
        return d


class YarnModelJSONEncoder(json.JSONEncoder):
    """JSON Encoder for Yarn model objects."""
    def default(self, obj):
        if isinstance(obj, YarnBaseType):
            # use the getDict method for model objects, since we can't
            # encode python objects to JSON directly.
            return obj.getDict()
        return json.JSONEncoder.default(self, obj)

if __name__ == "__main__":
    # try making some new things and spitting them back out again.
    room1 = Room("Garden")
    room2 = Room("Orange and Green")
    
    print "room 1: " + str(room1)
    print "room 1 json: " + str(room1.getJSON())
    print "obj store: " + str(db)
    
    