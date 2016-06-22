""" scrumtious/routes.py
"""
import smtplib
from re import sub as resub
import hashlib
from datetime import datetime

from flask import request, redirect, render_template

from scrumtious import app, mongo

def send_email(addresses, subject, message):
    server = smtplib.SMTP('smtp.gmail.com:587')
    server.starttls()
    server.login(app.config['GMAIL_USERNAME'], app.config['GMAIL_PASSWORD'])
    server.sendmail('%s@gmail.com' % app.config['GMAIL_USERNAME'],
                    addresses,
                    'Subject: %s\n\n%s' % (subject, message))
    server.quit()


creator_message = '''Hi!

You created the scrumboard "%s". Here's the link:
https://scrumtio.us/%s/%s
Share this link with everybody who's working on this project.

<3 Scrumtious
https://scrumtio.us
'''
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        # Create board details
        boardName = resub(r'[^-\w ]', '', request.form['boardName'])
        singleTokenBoardName = boardName.lower().replace(' ', '-')
        boardId = hashlib.sha1(boardName + datetime.now().__str__()).hexdigest()

        # Add board to database
        mongo.db.boards.insert_one({
            'boardId': boardId,
            'boardName': boardName,
            'singleTokenBoardName': singleTokenBoardName,
            'maxNid': 0,
            'notes': {}
        })

        # Send email to creator
        send_email(request.form['email'],
                      'Link for the scrumboard %s' % boardName,
                      creator_message % (boardName, singleTokenBoardName, boardId))

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


share_message = '''Hi!

The %s scrumboard was shared with you. Here's the link:
https://scrumtio.us/%s/%s

<3 Scrumtious
https://scrumtio.us
'''
@app.route('/email', methods=['POST'])
def email():
    dbItem = mongo.db.boards.find_one({'boardId': request.form['boardId']})
    if dbItem:
        send_email(request.form['emailString'].replace(' ', '').split(','),
                   'Scrumboard for our project',
                   share_message % (dbItem['boardName'], dbItem['singleTokenBoardName'], dbItem['boardId']))
    return ''
