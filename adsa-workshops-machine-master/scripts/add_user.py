#!/usr/bin/env python
from passlib.hash import pbkdf2_sha256
import pymysql.cursors
import click


@click.command()
@click.option('--mysql_host', envvar='MYSQL_HOST', required=True)
@click.option('--mysql_port', envvar='MYSQL_PORT', required=True,
              type=int)
@click.option('--mysql_user', envvar='MYSQL_USER', required=True)
@click.option('--mysql_pass', prompt=True, hide_input=True,
              envvar='MYSQL_PASS', required=True)
@click.option('--mysql_db', envvar='MYSQL_DB', required=True)
@click.option('--username', prompt=True, required=True)
@click.option('--password', prompt=True, hide_input=True,
              confirmation_prompt=True, required=True)
def add_user(mysql_host, mysql_port, mysql_user, mysql_pass,
             mysql_db, username, password):
    conn = pymysql.connect(host=mysql_host,
                           port=mysql_port,
                           user=mysql_user,
                           password=mysql_pass,
                           db=mysql_db,
                           charset='utf8mb4',
                           cursorclass=pymysql.cursors.DictCursor)

    with conn.cursor() as cursor:
        user = conn.escape(username)
        hash_ = pbkdf2_sha256.encrypt(password)
        hash_ = conn.escape(hash_)
        sql = 'INSERT INTO users (username, password) ' \
              'VALUES ({0}, {1})'.format(user, hash_)
        cursor.execute(sql)
        conn.commit()
    conn.close()

if __name__ == '__main__':
    add_user()
