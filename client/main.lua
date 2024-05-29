if (Ajustes and Ajustes.paraEventos.bool) then 
    local evento = Ajustes.paraEventos.eventos
    RegisterNetEvent(evento[1], Hud.Start)
    RegisterNetEvent(evento[2], Hud.Stop)
else
    Hud.Start()
end