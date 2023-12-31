float cycletime = 27.; //change this float to the seconds of delay in between animations. Rest can be left unchanged.

integer xyz;
integer inv;
changeanimation(){
    llStopObjectAnimation(llGetInventoryName(INVENTORY_ANIMATION,xyz));
    if (xyz++ == inv-1) xyz = 0;
    llStartObjectAnimation(llGetInventoryName(INVENTORY_ANIMATION, xyz));
    llSetTimerEvent(cycletime);
}
default{
    on_rez(integer start_param){
        llResetScript();
    }
    changed(integer change){
        if (change & (CHANGED_OWNER | CHANGED_INVENTORY)){        
            llResetScript();
        }
    } 
    state_entry(){    
        inv = llGetInventoryNumber(INVENTORY_ANIMATION);
        if(inv<1){
            llOwnerSay("Try putting some anims into me");
            return;
        } changeanimation(); 
    }  
    timer(){
        llSetTimerEvent(0.);
        changeanimation();
    }
}
