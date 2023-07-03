
CMD:talk(playerid, params[])
{
    new string[128];
    format(string, 128, "You said: %s",params);
    SendClientMessage(playerid, -1, string);
    return 1;
}


public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if (!success)
    {
        new magicnumber = floatround(strlen(cmdtext) * 0.4), i, buffer[32], best, bestmatch[32], match;
        while (GetPublicName(i, buffer))
        {
            if (strcmp(buffer, "cmd_", false, 4) == 0)
            {
                strdel(buffer, 0, 3);
                buffer[0] = '/';

                if (Levenshtein_distance(buffer, cmdtext) <= 3 && Levenshtein_distance(buffer, cmdtext) > best)
                {
                    best = Levenshtein_distance(buffer, cmdtext);
                    format(bestmatch, 32, "%s",buffer);
                    match = 1;
                }
            }
            i++;
        }
        if (match)
        {
            new string[64];
            format(string, 64, "Did you mean: %s ?",bestmatch);
            SendClientMessage(playerid, -1, string);
        }
        else
        {
            SendClientMessage(playerid, -1, "Command not found.");
        }
    }
    return 1;
}

stock GetPublicName(idx, buffer[32])
{
    if (idx >= 0)
    {
        new publics,
            natives;
        #emit lctrl 1
        #emit const.alt 32
        #emit sub.alt
        #emit stor.s.pri publics
        #emit add.c 4
        #emit stor.s.pri natives
        #emit lref.s.pri natives
        #emit stor.s.pri natives
        #emit lref.s.pri publics
        #emit load.s.alt idx
        #emit shl.c.alt 3
        #emit add
        #emit stor.s.pri publics
        if (publics < natives)
        {
            #emit lctrl 1
            #emit move.alt
            #emit load.s.pri publics
            #emit add.c 4
            #emit sub
            #emit stor.s.pri publics
            #emit lref.s.pri publics
            #emit sub
            #emit stor.s.pri natives
            for (idx = 0; ; natives += 4)
            {
                #emit lref.s.pri natives
                #emit stor.s.pri publics
                if ((buffer[idx++] = publics & 0xFF) == EOS || (buffer[idx++] = publics >> 8 & 0xFF) == EOS || (buffer[idx++] = publics >> 16 & 0xFF) == EOS || (buffer[idx++] = publics >>> 24) == EOS)
                {
                    return idx;
                }
            }
        }
    }
    return 0;
}