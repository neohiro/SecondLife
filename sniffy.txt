key owner;
string username;
integer chan;
integer oldchan;
integer eavesdrop;
integer textbox;

default {
    state_entry() {   
        llPassTouches(PASS_NEVER);
        owner = llGetOwner();
        username = llGetUsername(owner);
        if (chan == 0) {
            llSay(0,"Hello, I am "+username+"'s [https://marketplace.secondlife.com/stores/81890 sniffy] & listen to public chat until my owner changes channel.");
            oldchan = 0;    
        }
        llInstantMessage(owner, "Turning on, listening to channel "+(string)chan);
        eavesdrop = llListen(chan,"","","");
    }
    touch_start(integer lol) {
        if (llDetectedKey(0) == owner){
            if (llGetObjectName() == "" || llGetObjectName() == "Object" || llGetObjectName() == "Sniffy HUD") llSetObjectName(username+"'s sniffy");
            llListenRemove(eavesdrop);
            textbox = llListen(-90772,"","","");
            llTextBox(owner,"\n \n \nType numbers of channel to listen to & click submit,\n numbers can be negative.",-90772);
        }}
    listen( integer channel, string name, key id, string message ) {
        if (message) {
            if (id == owner && -90772) {
                llListenRemove(textbox);
                chan = (integer)message;
                eavesdrop = llListen(chan,"","","");
                llSetText((string)chan,<1,1,1>,0.8);
                llInstantMessage(owner, "On, listening to channel "+(string)chan);
                if (chan == 0) llSay(0,"Hello, I'm "+username+"'s [https://marketplace.secondlife.com/stores/81890 sniffy] & now listening to public chat.");
                else if (oldchan == 0) {
                    llSay(0,"[https://marketplace.secondlife.com/stores/81890 Sniffy] has now stopped listening to public chat.");
                    oldchan = chan;
                }}
            else
                llInstantMessage(owner,message);         
        }}
    state_exit() {
        llInstantMessage(owner, "Turning off, see you next time, "+username+"!");
    }
}
