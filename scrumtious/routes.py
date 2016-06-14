""" scrumtious/routes.py
"""
from re import sub as resub
import hashlib
from datetime import datetime

from flask import request, redirect, render_template

from scrumtious import app, mongo

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        # Create board details
        boardName = resub(r'[^-\w ]', '', request.form['boardName'])
        singleTokenBoardName = boardName.replace(' ', '-')
        boardId = hashlib.sha1(boardName + datetime.now().__str__()).hexdigest()

        # Add board to database
        mongo.db.boards.insert_one({
            'boardId': boardId,
            'boardName': boardName,
            'singleTokenBoardName': singleTokenBoardName,
            'maxNid': 0,
            'notes': []
        })

        # Redirect user to their new board
        return redirect('/%s/%s' % (singleTokenBoardName, boardId))

    # Render start page on GET
    return render_template('start.j2')

@app.route('/<singleTokenBoardName>/<boardId>')
def board(singleTokenBoardName, boardId):
    dbItem = mongo.db.boards.find_one({'boardId': boardId})
    if dbItem and dbItem['singleTokenBoardName'] == singleTokenBoardName:
        # Render board
        return render_template('board.j2')

    # Not detected in database, redirect to start page
    return redirect('/')
