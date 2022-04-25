surface.CreateFont( "HUD.Name", {
	font = "Bahnschrift",
	extended = true,
	size = 35,
	weight = 500,
	antialias = true,
} )

surface.CreateFont( "HUD.Job", {
	font = "Bahnschrift",
	extended = true,
	size = 20,
	weight = 500,
	antialias = true,
} )

surface.CreateFont( "HUD.Money", {
	font = "Bahnschrift",
	extended = true,
	size = 17,
	weight = 500,
	antialias = true,
} )

surface.CreateFont( "HUD.Ammo", {
	font = "Roboto Light Italic",
	extended = true,
	size = 17,
	weight = 500,
	antialias = true,
} )


local hide = {
    ['CHudHealth'] =true,
    ['CHudBattery'] =true,
    ['CHudSuitPower'] =true,
    ['CHudAmmo'] =true,
    ['CHudSecondaryAmmo'] =true,
    ['DarkRP_LocalPlayerHUD'] =true,
    ['DarkRP_Hungermod'] =true,
    ['DarkRP_LockdownHUD'] =true,
    ['DarkRP_EntityDisplay']=true,
}
hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then
		return false
	end
end )

function draw.HealthBar(health)
	surface.SetDrawColor(0,255,0, 10)
	surface.DrawPoly({
		{ x = 50, y = ScrH() - 30 },
		{ x = 30, y = ScrH() - 40 },

		{ x = 230, y = ScrH() - 40 },
		{ x = 250, y = ScrH() - 30 },
	})

	surface.SetDrawColor(0,255,0, 255)
	surface.DrawPoly({
		{ x = 50, y = ScrH() - 30 },
		{ x = 30, y = ScrH() - 40 },

		{ x = 30 + health, y = ScrH() - 40 },
		{ x = 50 + health, y = ScrH() - 30 },
	})
end

function draw.ArmorBar(armor)
	surface.SetDrawColor(0,100,250,50)
	surface.DrawPoly({
		{ x = 50 + 260, y = ScrH() - 30 },
		{ x = 30 + 260, y = ScrH() - 40 },

		{ x = 230 + 260, y = ScrH() - 40 },
		{ x = 250 + 260, y = ScrH() - 30 },
	})

	surface.SetDrawColor(0,100,250,255)
	surface.DrawPoly({
		{ x = 50 + 260, y = ScrH() - 30 },
		{ x = 30 + 260, y = ScrH() - 40 },

		{ x = 30 + armor + 260, y = ScrH() - 40 },
		{ x = 50 + armor + 260, y = ScrH() - 30 },
	})
end

local pos = 40

function draw.InfoPanel(localplayer)
	local name = localplayer:Nick()
	local job = team.GetName(localplayer:Team())
	local money = localplayer:getDarkRPVar('money')
	draw.SimpleText(name, "HUD.Name", 30, ScrH() - 180 + pos, Color(255, 255, 255))

	draw.RoundedBox(0, 35, ScrH() - 144 + pos, 2, 20, team.GetColor(localplayer:Team()))
	draw.SimpleText(job, "HUD.Job", 40, ScrH() - 145 + pos, Color(255, 255, 255))

	draw.RoundedBox(0, 35, ScrH() - 120 + pos, 2, 20, Color(0, 125, 250))
	draw.SimpleText(DarkRP.formatMoney(money), "HUD.Money", 41, ScrH() - 119 + pos, Color(255, 255, 255))

	if(GetGlobalBool('DarkRP_LockDown')) then
		draw.SimpleText('Объявлен комендантский час!', "HUD.Name", 30, 30, Color(255, 255, 255))
	end
end

function draw.Ammo(clip, clip1)
	draw.SimpleText(clip .. ' / ' .. clip1, "HUD.Ammo", ScrW() - 84, ScrH() - 56, Color(255, 255, 255))
end


hook.Add("HUDPaint", "PerfectHUDDraw", function()
	local lp = LocalPlayer()
	local health = math.Clamp(lp:Health(), 0, 100) * 2
	local armor = math.Clamp(lp:Armor(), 0, 100) * 2

	draw.HealthBar(health)
	if(armor > 0) then
		draw.ArmorBar(armor)
	end

	draw.InfoPanel(lp)

    local wep = lp:GetActiveWeapon()
	if not IsValid(wep) or wep:GetPrimaryAmmoType() < 0 then 
		return 
	end

    local ammo1 = wep:Clip1()
    local ammo2 = LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType())

    draw.Ammo(ammo1, ammo2)
end)