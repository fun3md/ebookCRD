#!/bin/sh

sleep 75
initctl stop framework
lipc-set-prop com.lab126.appmgrd start app://com.lab126.browser?view=file:///mnt/us/esign/index.html
sleep 60
                        
lipc-set-prop com.lab126.pillow interrogatePillow '{"pillowId": "default_status_bar", "function": "nativeBridge.hideMe();"}'
lipc-set-prop com.lab126.pillow interrogatePillow '{"pillowId": "search_bar", "function": "nativeBridge.hideMe();"}'
lipc-set-prop com.lab126.powerd preventScreenSaver 1 
