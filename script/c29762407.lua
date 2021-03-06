--王家の神殿
function c29762407.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Trap activate in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetCountLimit(1,29762407)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(29762407,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,29762408)
	e3:SetCost(c29762407.cost)
	e3:SetTarget(c29762407.target)
	e3:SetOperation(c29762407.operation)
	c:RegisterEffect(e3)
end
function c29762407.cfilter(c,ft,tp)
	if c:IsFacedown() or not c:IsCode(89194033) or not c:IsAbleToGraveAsCost() then return false end
	if ft>0 or (ft>-1 and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5) then
		if Duel.IsExistingMatchingCard(c29762407.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) then
			return true
		end
	end
	return Duel.GetLocationCountFromEx(tp,tp,c)>0 and Duel.IsExistingMatchingCard(c29762407.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c29762407.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c29762407.cfilter,tp,LOCATION_ONFIELD,0,1,nil,ft,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c29762407.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,ft,tp)
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c29762407.filter(c,e,tp)
	return (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsType(TYPE_FUSION))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29762407.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c29762407.operation(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND+LOCATION_DECK end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29762407.filter,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
