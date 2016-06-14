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

        pipe.delete('%s:notes' % boardId)
        for note in board['notes']:
            pipe.sadd('%s:notes' % boardId, note['nid'])
            pipe.hmset('%s:%d' % (boardId, note['nid']), note)

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

        pipe.sadd('%s:notes' % boardId, ogMaxNid)
        pipe.hmset('%s:%d' % (boardId, ogMaxNid), {
            'nid': ogMaxNid,
            'xr': xr,
            'yr': yr,
            'content': ''
        })
        pipe.incr('%s:maxNid')

        pipe.execute()
        return ogMaxNid

    def changeNote(self, boardId, nid, content):
        redis.hset('%s:%d' % (boardId, nid), 'content', content)

    def moveNote(self, boardId, nid, xr, yr):
        redis.hmset('%s:%d' % (boardId, nid), {
            'xr': xr,
            'yr': yr
        })

    def deleteNote(self, boardId, nid):
        redis.pipeline().srem('%s:notes' % boardId, nid).delete('%s:%d' % (boardId, nid)).execute()

    def getNote(self, boardId, nid):
        return redis.hgetall('%s:%d' % (boardId, nid))

    def getNotes(self, boardId):
        return list(redis.smembers('%s:notes' % boardId))
