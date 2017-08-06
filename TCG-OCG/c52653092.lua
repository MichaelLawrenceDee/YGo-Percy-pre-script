--SNo.0 ホープ・ゼアル
function c52653092.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c52653092.xyzfilter,nil,3,c52653092.ovfilter,aux.Stringid(52653092,0),nil,c52653092.xyzop,false,true)
	--cannot disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c52653092.effcon)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c52653092.effcon2)
	e3:SetOperation(c52653092.spsumsuc)
	c:RegisterEffect(e3)
	--atk & def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c52653092.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--activate limit
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(52653092,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMING_DRAW_PHASE)
	e6:SetCountLimit(1)
	e6:SetCondition(c52653092.actcon)
	e6:SetCost(c52653092.actcost)
	e6:SetOperation(c52653092.actop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e7:SetCode(511002571)
	e7:SetLabelObject(e6)
	e7:SetLabel(c:GetOriginalCode())
	c:RegisterEffect(e7)
end
c52653092.xyz_number=0
function c52653092.xyzfilter(c,chk,tp,sg)
	if chk then return c:IsHasEffect(511001175) or sg:FilterCount(Card.IsType,c,TYPE_XYZ)==0 
		or sg:IsExists(aux.FilterEqualFunction(Card.GetRank,c:GetRank()),1,c) end
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
end
function c52653092.cfilter(c)
	return c:IsSetCard(0x95) and c:GetType()==TYPE_SPELL and c:IsDiscardable()
end
function c52653092.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f)
end
function c52653092.xyzop(e,tp,chk,mc)
	if chk==0 then return mc or Duel.IsExistingMatchingCard(c52653092.cfilter,tp,LOCATION_HAND,0,1,nil) end
	if chk==1 then
		local min=Auxiliary.ProcCancellable and 0 or 1
		local ct=Duel.DiscardHand(tp,c52653092.cfilter,min,1,REASON_COST+REASON_DISCARD,nil)
		if ct>0 then
			return true,true
		else
			return false
		end
	end
end
function c52653092.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c52653092.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c52653092.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c52653092.chlimit)
end
function c52653092.chlimit(e,ep,tp)
	return tp==ep
end
function c52653092.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c52653092.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c52653092.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c52653092.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c52653092.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c52653092.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
