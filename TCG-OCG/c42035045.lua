--漆黒の豹戦士パンサーウォリアー
function c42035045.initial_effect(c)
	--attack cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(c42035045.atcost)
	e1:SetOperation(c42035045.atop)
	c:RegisterEffect(e1)
end
function c42035045.atcost(e,c,tp)
	return Duel.CheckReleaseGroup(tp,nil,1,e:GetHandler())
end
function c42035045.atop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsAttackCostPaid()~=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local tc=Duel.GetReleaseGroup(tp):Filter(nil,e:GetHandler()):SelectUnselect(Group.CreateGroup(),tp,Duel.IsAttackCostPaid()==0, Duel.IsAttackCostPaid()==0)
		if tc then
			Duel.Release(tc,REASON_COST)
			Duel.AttackCostPaid()
		else
			Duel.AttackCostPaid(2)
		end
	end
end
