--白銀の翼
function c25231813.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c25231813.filter)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(2)
	e3:SetValue(c25231813.indval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c25231813.reptg2)
	e4:SetOperation(c25231813.repop2)
	c:RegisterEffect(e4)
end
function c25231813.filter(c)
	return c:IsLevelAbove(8) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
end
function c25231813.indval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c25231813.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetEquipTarget():IsReason(REASON_EFFECT) and not c:GetEquipTarget():IsReason(REASON_REPLACE)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c25231813.repop2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:GetHandler():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
