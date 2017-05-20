--LL－インディペンデント・ナイチンゲール
--Lyrical Luscinia - Independent Nightingale
--Scripted by Eerie Code
function c76815942.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,48608796,c76815942.ffilter)
	--increase level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76815942,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c76815942.lvcon)
	e1:SetOperation(c76815942.lvop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c76815942.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c76815942.efilter)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c76815942.atkval)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(76815942,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c76815942.damtg)
	e4:SetOperation(c76815942.damop)
	c:RegisterEffect(e4)
end
function c76815942.ffilter(c)
	return c:IsFusionSetCard(0xf7) or c:IsFusionCode(8491961)
end
function c76815942.matval(c)
	local b
	if Card.IsOriginalSetCard then
		b=c:IsOriginalSetCard(0xf7)
	else
		b=c:IsSetCard(0xf7)
	end
	if (b or c:GetOriginalCode()==8491961) and c:IsType(TYPE_XYZ) then
		return c:GetOverlayCount()
	end
	return 0
end
function c76815942.valcheck(e,c)
	local val=c:GetMaterial():GetSum(c76815942.matval)
	e:GetLabelObject():SetLabel(val)
end
function c76815942.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and e:GetLabel()>0
end
function c76815942.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c76815942.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c76815942.atkval(e,c)
	return c:GetLevel()*500
end
function c76815942.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetLevel()*500)
end
function c76815942.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Damage(p,c:GetLevel()*500,REASON_EFFECT)
	end
end