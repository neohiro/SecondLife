/////////////// FOR MARTIN, MAY YOUR CODE BE OF GOOD USER EXPERIENCE /////////////////

string GROUP = ""; // PUT PANDORASOUNDBOX CORRADE GROUP NAME OR UUID BETWEEN ""
string PASSWORD = ""; // PUT PANDORASOUNDBOX CORRADE GROUP PASSWORD BETWEEN ""

//////////////////////////////////////////////////////////////////////////////////////

string wasURLEscape(string i) {
    string o = "";
        do {
            string ce = llGetSubString(i, 0, 0);
                i = llDeleteSubString(i, 0, 0);
                if(ce == "") jump continue;
                if(ce == " ") {
                o += "+";
                jump continue;
                }
                if(ce == "\n") {
                    o += "%0D" + llEscapeURL(ce);
                    jump continue;
                }
            o += llEscapeURL(ce);
            @continue;
        } while(i != "");
        return o;
}

string wasKeyValueEncode(list data) {
    list k = llList2ListStrided(data, 0, -1, 2);
    list v = llList2ListStrided(llDeleteSubList(data, 0, 0), 0, -1, 2);
        data = [];
        do {
            data += llList2String(k, 0) + "=" + llList2String(v, 0);
            k = llDeleteSubList(k, 0, 0);
            v = llDeleteSubList(v, 0, 0);
        } while(llGetListLength(k) != 0);
        return llDumpList2String(data, "&");
}

string wasURLUnescape(string i) {
    return llUnescapeURL(llDumpList2String(llParseString2List(llDumpList2String(llParseString2List(i,["+"],[])," "),["%0D%0A"],[]),"\n"));}

string URL = "";
integer received;

default {
    touch_start(integer x) {
        if (llDetectedKey(0) == llGetOwner()){ 
            llRequestURL();
        }
    }
    http_request(key id, string method, string body) {
        if(method != URL_REQUEST_GRANTED) return;
        URL = body;
        state main;
    }
}
state main {
    state_entry() {
         llInstantMessage("921a5210-1172-401f-abb6-bd7a65acb00d",wasKeyValueEncode([
            "command", "walkto",
            "group", wasURLEscape(GROUP),
            "password", wasURLEscape(PASSWORD),
            "position", llGetPos(),
            "vicinity", 1,
            "duration", 10000,
            "callback", wasURLEscape(URL)
        ]));
        llRegionSayTo(llDetectedKey(0),0,"Hey Martin, the walkto command was sent to bish");
        llSetAlpha(0.,ALL_SIDES);
        llSetTimerEvent(10);
    }
    http_request(key id, string method, string body) {
        llHTTPResponse(id, 200, "Ok");
        llOwnerSay(wasURLUnescape(body));
        received = 1;
    }
    timer() {
        llSetTimerEvent(0);
        if (received == 0) llOwnerSay("Nothing received after 10s.."); 
        else received = 0;
        llSetAlpha(1.,ALL_SIDES);
        state default;
    }
}
