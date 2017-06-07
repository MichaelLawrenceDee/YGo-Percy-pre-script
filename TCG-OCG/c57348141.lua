--トワイライト・イレイザー
--Twilight Eraser
--Scripted by Eerie Code
function c57348141.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c57348141.condition)
	e1:SetCost(c57348141.cost)
	e1:SetTarget(c57348141.target)
	e1:SetOperation(c57348141.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c57348141.spcon)
	e2:SetTarget(c57348141.sptg)
	e2:SetOperation(c57348141.spop)
	c:RegisterEffect(e2)
end
function c57348141.filter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x38) 
		and Duel.IsExistingMatchingCard(c57348141.filter2,tp,LOCATION_MZONE,0,1,c,c:GetRace(),c:GetCode())
end
function c57348141.filter2(c,race,code)
	return c:IsFaceup() and c:IsSetCard(0x38) and c:IsRace(race) and not c:IsCode(code)
end
function c57348141.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c57348141.filter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c57348141.cfilter(c)
	if not c:IsType(TYPE_MONSTER) or not c:IsSetCard(0x38) or not c:IsAbleToRemoveAsCost() then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c57348141.filter(c,g,sg)
	sg:AddCard(c)
	local res
	if sg:GetCount()<2 then
		res=g:IsExists(c57348141.filter,1,sg,g,sg)
	else
		res=Duel.IsExistingTarget(Card.IsAbleToRemove,0,LOCATION_ONFIELD,LOCATION_ONFIELD,2,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c57348141.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c57348141.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return cg:IsExists(c57348141.filter,1,nil,cg,Group.CreateGroup()) end
	local rg=Group.CreateGroup()
	while rg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Group.SelectUnselect(cg:Filter(c57348141.filter,rg,cg,rg),rg,tp)
		if rg:IsContains(tc) then
			rg:RemoveCard(tc)
		else
			rg:AddCard(tc)
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c57348141.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c57348141.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c57348141.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x38) 
		and bit.band(r,REASON_EFFECT)~=0
end
function c57348141.spfilter(c,e,tp)
	return c:IsSetCard(0x38) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c57348141.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c57348141.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c57348141.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c57348141.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
