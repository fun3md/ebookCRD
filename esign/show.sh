#!/bin/sh
lipc-set-prop com.lab126.pillow interrogatePillow '{"pillowId": "default_status_bar", "function": "nativeBridge.showMe();"}'
lipc-set-prop com.lab126.pillow interrogatePillow '{"pillowId": "search_bar", "function": "nativeBridge.showMe();"}'
lipc-set-prop com.lab126.powerd preventScreenSaver 0 
