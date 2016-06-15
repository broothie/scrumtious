""" scrumtious/Memory.py
"""
from scrumtious import redis


class Memory:
    def populateBoard(self, board):
        boardId = board['boardId']

        pipe = redis.pipeline()

        pipe.set('%s:boardName' % boardId, board['boardName'])
        pipe.set('%s:singleTokenBoardName' % boardId, board['singleTokenBoardName'])
        pipe.set('%s:activeUserCount' % boardId, 0)
        pipe.set('%s:maxNid' % boardId, board['maxNid'])

        for nid, note in board['notes'].iteritems():
            pipe.sadd('%s:nids' % boardId, nid)
            pipe.hmset('%s:%d' % (boardId, int(nid)), note)

        pipe.execute()

    def eraseBoard(self, boardId):
        pipe = redis.pipeline()

        for nid in self.getNids(boardId):
            pipe.delete('%s:%s' % (boardId, nid))

        fields = ['boardName', 'singleTokenBoardName', 'activeUserCount', 'maxNid', 'nids']
        for field in fields:
            pipe.delete('%s:%s' % (boardId, field))

        pipe.execute()

    def getBoard(self, boardId):
        return {
            'boardId': boardId,
            'boardName': self.getBoardName(boardId),
            'singleTokenBoardName': self.getSingleTokenBoardName(boardId),
            'maxNid': self.getMaxNid(boardId),
            'notes': self.getNotes(boardId)
        }


    def getBoardName(self, boardId):
        return redis.get('%s:boardName' % boardId)

    def getSingleTokenBoardName(self, boardId):
        return redis.get('%s:singleTokenBoardName' % boardId)


    def addUser(self, boardId):
        redis.incr('%s:activeUserCount' % boardId)

    def removeUser(self, boardId):
        redis.decr('%s:activeUserCount' % boardId)

    def boardIsActive(self, boardId):
        activeUserCount = redis.get('%s:activeUserCount' % boardId)
        return activeUserCount != None and int(activeUserCount) != 0


    def getMaxNid(self, boardId):
        return int(redis.get('%s:maxNid' % boardId))


    def newNote(self, boardId, xr, yr):
        ogMaxNid = self.getMaxNid(boardId)
        pipe = redis.pipeline()

        pipe.sadd('%s:nids' % boardId, ogMaxNid)
        pipe.hmset('%s:%d' % (boardId, int(ogMaxNid)), {
            'nid': ogMaxNid,
            'xr': xr,
            'yr': yr,
            'content': ''
        })
        pipe.incr('%s:maxNid' % boardId)

        pipe.execute()
        return ogMaxNid

    def changeNote(self, boardId, nid, content):
        redis.hset('%s:%d' % (boardId, int(nid)), 'content', content)

    def moveNote(self, boardId, nid, xr, yr):
        redis.hmset('%s:%d' % (boardId, int(nid)), {
            'xr': xr,
            'yr': yr
        })

    def deleteNote(self, boardId, nid):
        redis.pipeline().srem('%s:nids' % boardId, nid).delete('%s:%d' % (boardId, int(nid))).execute()

    def getNote(self, boardId, nid):
        return redis.hgetall('%s:%d' % (boardId, int(nid)))

    def getNotes(self, boardId):
        return dict((nid, self.getNote(boardId, nid)) for nid in self.getNids(boardId))

    def getNids(self, boardId):
        return [int(nid) for nid in redis.smembers('%s:nids' % boardId)]
