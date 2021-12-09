function start(song) -- do nothing

end

function update(elapsed)
	local currentBeat = (songPos / 1000)*(bpm/60)
	for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + 4 * math.cos((currentBeat + i*0.1) * math.pi), i)
    end
end

function beatHit(beat) -- do nothing

end

function stepHit(step) -- do nothing

end

function songStart(song)
	strumLineY = strumLineY - 28
end