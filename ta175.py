# bot.py
# IMPORT DISCORD.PY. ALLOWS ACCESS TO DISCORD'S API.
import discord

# IMPORT THE OS MODULE.
import os
import datetime
from datetime import date
# IMPORT LOAD_DOTENV FUNCTION FROM DOTENV MODULE.
from dotenv import load_dotenv

import win32com.client
from time import sleep
import re
# IMPORT COMMANDS FROM THE DISCORD.EXT MODULE.
from discord.ext import commands
import subprocess, sys
#from ta175 import * # Call logic
#
#Call logic
#
def download_url_with_ie(url):
    currentDT = datetime.datetime.now()
    datetime_string = str(currentDT.strftime("%Y%m%d%H%M%S"))

    url=url.replace("&",'"&"')
    p = subprocess.run([
    "powershell.exe", 
    "C:\\Discord_Bots\\TA175\\Scanning_Protocol", 
    url,
    datetime_string
    ],
    stdout=sys.stdout)
    filename = "C:\\Discord_Bots\\TA175\\files\\"+datetime_string+".txt"

    with open(filename) as f:
        contents = f.read()
        global outdata3
        outdata3= contents.replace('\r','')
    return(outdata3)
# LOADS THE .ENV FILE THAT RESIDES ON THE SAME LEVEL AS THE SCRIPT.
load_dotenv()
TOKEN = os.getenv('DISCORD_TOKEN')
# GRAB THE API TOKEN FROM THE .ENV FILE.
DISCORD_TOKEN = os.getenv("DISCORD_TOKEN")
bot = commands.Bot(command_prefix='!')

@bot.command(name="Remove")
async def Remove(ctx: commands.Context):

    channel = ctx.message.channel
    messages = await channel.history().flatten()
    for item in messages:
        message = await channel.fetch_message(item.id)
        txt = message.content
        print(message)
        #if "!hello" in txt.lower():
        #    await message.delete()




@bot.command(name="Destruct")
async def Remove(ctx: commands.Context,mid):# yes, you can do msg: discord.Message
        message_id=mid 
        print (message_id)
        msg = await ctx.fetch_message(message_id)
        print(msg)
        await msg.delete()
        fchannel=msg.channel
        checkstring = "!Destruct "+mid 
        print(checkstring)
        messages = await ctx.channel.history(limit=10).flatten()
        for msg in messages:
            if checkstring in msg.content:
               print(checkstring)
               print(msg.id)
               await ctx.fetch_message(msg.id)
               await msg.delete()             





@bot.event
async def on_message(msg):
    if '://xwing-legacy.com/' in msg.content:
        link=msg.content 
        linkUrl = (re.search("(?P<url>https?://[^\s]+)", link).group("url"))
        if (len(linkUrl)>90):
            print("Short Link skipping")
            
            linklength=len(linkUrl)+5  #length of the url +5 character
            print('Link Found')     #info
            print(linkUrl)           #info
            Channelid=msg.channel    
            sometext="Searching....."
            #await msg.channel.send(dsout[linklength:])   #Post data
            sendmessage=await msg.reply(sometext, mention_author=False) #post data in reply
            #
            download_url_with_ie(linkUrl)  #run function
            dsout = outdata3 #replace double space from Global var
            print(dsout[linklength:])
            #
            smessageid = sendmessage.id
            SMessageupdate = await Channelid.fetch_message(smessageid)
            #
            spaces = "\r\n\r\n" 
            SMIDString=str(smessageid)
            SmessageMain="To remove please use !Destruct "+ SMIDString
            outputtext=dsout+spaces+SmessageMain
            print(outputtext)
            await SMessageupdate.edit(content=outputtext)
        else:
            print("Short link skipping")    
    await bot.process_commands(msg)


"""
@bot.event
async def on_message(gomsg):
    if 'go' in gomsg.content:
        print(gomsg)
        print(gomsg.channel)
        Channelid=gomsg.channel
        print(gomsg.id)
        sometext="Searching....."
        sendmessage=await gomsg.reply(sometext, mention_author=True)
        messageid = sendmessage.id
        print(sendmessage)
        print(messageid)
        sendMID=messageid
        msg1 = await Channelid.fetch_message(sendMID)
        print(msg1)
        spaces = "\r\n\r\n" 
        SMIDString=str(sendMID) 
        outputtext=sometext+spaces+SMIDString
        await msg1.edit(content=outputtext)
    await bot.process_commands(gomsg)
"""
bot.run(DISCORD_TOKEN)