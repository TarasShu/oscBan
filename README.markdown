#  Reciving messeges from norns 


from norns, using 
https://monome.org/docs/norns/engine-study-3/

local osc = require("osc")


local mac_ip = "10.100.102.12"
local mac_port = 8000

function send_osc(path, args)
    osc.send({mac_ip, mac_port}, path, args)
end

function sndOscMac(x)
    send_osc("/adrs", {x})
end

