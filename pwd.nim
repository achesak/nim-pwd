# Nim port of Python's "pwd" module.

# Written by Adam Chesak.
# Released under the MIT open source license.


import strutils


type
    Pwd* = ref object
        pw_name : string
        pw_passwd : string
        pw_uid : int
        pw_gid : int
        pw_gecos : string
        pw_dir : string
        pw_shell : string


# Internal constant.
const PASSWD_FILE = "/etc/passwd"


proc getpwall*(): seq[Pwd] = 
    ## Returns a sequence of all entries in the passwd file.
    
    var f : string = readFile(PASSWD_FILE)
    var lines : seq[string] = f.splitLines()
    var pwds : seq[Pwd] = newSeq[Pwd](len(lines))
    
    for i in 0..high(lines):
        var s : seq[string] = lines[i].split(":")
        var p : Pwd = Pwd(pw_name: s[0], pw_passwd: s[1], pw_uid: parseInt(s[2]), pw_gid: parseInt(s[3]), pw_gecos: s[4],
                          pw_dir: s[5], pw_shell: s[6])
        pwds[i] = p
    
    return pwds


proc getpwid*(uid : int): Pwd = 
    ## Returns the entry with the given ``uid``. Returns ``nil`` if not found.
    
    var pwds : seq[Pwd] = getpwall()
    
    for i in pwds:
        if i.pw_uid == uid:
            return i
    
    return nil


proc getpwnam*(name : string): Pwd = 
    ## Returns the entry with the given ``name``. Returns ``nil`` if not found.
    
    var pwds : seq[Pwd] = getpwall()
    
    for i in pwds:
        if i.pw_name == name:
            return i
    
    return nil

