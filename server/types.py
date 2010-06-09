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

class MeetingObjectType(BaseType):
    """Defines some basic properties that are shared by meeting objects."""
    def __init__(self, creatorUUID, meetingUUID):
        BaseType.__init__(self)
        
        # TODO we almost certainly want to unswizzle these UUIDS
        # to their actual objects. 
        self.createdBy = creatorUUID
        self.createdAt = time.time()
        
        self.meeting = meetingUUID

class Room(BaseType):
    """Stores the room-related information."""
    def __init__(self, name):
        BaseType.__init__(self)
        self.name = name
        self.currentMeeting = None
        
class Meeting(BaseType):
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