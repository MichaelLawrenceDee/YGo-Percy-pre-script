--Halfway to Forever
function c511001445.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001445.target)
	e1:SetOperation(c511001445.activate)
	c:RegisterEffect(e1)
end
function c511001445.filter(c,tid)
	return c:GetTurnID()==tid and c:IsReason(REASON_BATTLE)
end
function c511001445.mfilter1(c,mg,tp)
	return mg:IsExists(c511001445.mfilter2,1,c,c,tp)
end
function c511001445.mfilter2(c,c1,tp)
	return Duel.IsExistingMatchingCard(c511001445.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(c,c1))
end
function c511001445.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2)
end
function c511001445.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local mg=Duel.GetMatchingGroup(c511001445.filter,tp,LOCATION_GRAVE,0,nil,tid)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>1
		and Duel.IsExistingMatchingCard(c511001445.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c511001445.activate(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c511001445.filter,tp,LOCATION_GRAVE,0,nil,tid)
	if mg:GetCount()<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg1=mg:FilterSelect(tp,c511001445.mfilter1,1,1,nil,mg,tp)
	local mc=mg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg2=mg:FilterSelect(tp,c511001445.mfilter2,1,1,mc,mc,tp)
	mg1:Merge(mg2)
	local xyzg=Duel.GetMatchingGroup(c511001445.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg1)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,mg1)
	end
end
