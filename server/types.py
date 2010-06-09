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


class ObjectManager():
    """Store all the primary objects in the system by UUID. Singleton."""
    pass

class BaseType(object):
    """Identify object with a UUID and register it with the store."""
    
    # TODO add a way to hard code the UUID. This will be important for
    # situations where we're loading from disk, and need to have UUIDs
    # match their historical values. 
    def __init__(self):
        self.uuid = uuid.uuid4()
        
        # When we have the object store up and running, register this new
        # object with it.
        
    def getDict(self):
        return {"uuid":uuid}
    
    def getJSON(self):
        """Return a JSON representation of the type."""
        return json.dumps(self.getDict())

class Room(BaseType):
    """Store the room-related information."""

    def __init__(self, name):
        BaseType.__init__(self)
        self.name = name
        self.currentMeeting = None
    
    def getDict(self):
        d = BaseType.getDict(self)
        d["name"] = name
        d["currentMeeting"] = currentMeeting
        return d
        
class Meeting(BaseType):
    """Store meeting-related information."""

    def __init__(self, roomUUID, title=None, startedAt=None):
        BaseType.__init__(self)
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
        d = BaseType.getDict(self)
        d["endedAt"] = endedAt
        d["isLive"] = isLive
        d["allParticipants"] = allParticipants
        d["currentParticipants"] = currentParticipants
        return d
    

class User(BaseType):
    """Store meeting-related information."""
    
    def __init__(self, name):
        BaseType.__init__(self)
        
        self.name = name
        self.inMeeting = None
        self.loggedIn = False
        self.status = None
        
    def getDict(self):
        d = BaseType.getDict(self)
        d["name"] = name
        d["inMeeting"] = inMeeting
        d["loggedIn"] = loggedIn
        d["status"] = status
        return d


class MeetingObjectType(BaseType):
    """Defines some basic properties that are shared by meeting objects."""

    def __init__(self, creatorUUID, meetingUUID):
        BaseType.__init__(self)

        # TODO we almost certainly want to unswizzle these UUIDS
        # to their actual objects. When we do that, we'll need to
        # switch all the getDict methods to getting the UUID instead
        # of just taking the whole object like it does now.
        self.createdBy = creatorUUID
        self.createdAt = time.time()

        self.meeting = meetingUUID
    
    def getDict(self):
        d = BaseType.getDict(self)
        d["createdBy"] = createdBy
        d["createdat"] = createdAt
        d["meeting"] = meeting
        return d

class Task(MeetingObjectType):
    """Store information about a task."""
    
    def __init__(self, meetingUUID, creatorUUID, text):
        MeetingObjectType.__init__(self, creatorUUID, meetingUUID)
        self.text = text
        self.ownedBy = None
        
    def getDict(self):
        d = MeetingObjectType.getDict(self)
        d["text"] = text
        d["ownedBy"] = ownedBy

class Topic(MeetingObjectType):
    """Store information about a topic."""

    def __init__(self, meetingUUID, creatorUUID, text, timeStarted=None, timeEnded=None):
        MeetingObjectType.__init__(self, creatorUUID, meetingUUID)
        self.text = text
        self.timeStarted = timeStarted
        self.timeEnded = timeEnded

    def getDict(self):
        d = MeetingObjectType.getDict(self)
        d["text"] = text
        d["timeStarted"] = timeStarted
        d["timeEnded"] = timeEnded
        return d

