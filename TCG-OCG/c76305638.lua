--岩の精霊 タイタン
function c76305638.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c76305638.spcon)
	e1:SetOperation(c76305638.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c76305638.atkcon)
	e2:SetValue(300)
	c:RegisterEffect(e2)
end
function c76305638.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp~=e:GetHandler():GetControler() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c76305638.spfilter(c)
	if not c:IsAttribute(ATTRIBUTE_EARTH) or not c:IsAbleToRemoveAsCost() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c76305638.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.IsPlayerAffectedByEffect(tp,69832741)) 
		and Duel.IsExistingMatchingCard(c76305638.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c76305638.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c76305638.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
