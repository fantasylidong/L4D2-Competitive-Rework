#pragma semicolon 1
#pragma newdecls required

// 头文件
#include <sourcemod>
#include <sdktools>
#include <colors>
#include <treeutil>

#define CVAR_FLAG FCVAR_NOTIFY

public Plugin myinfo = 
{
	name 			= "Tank Damage Announce",
	author 			= "夜羽真白",
	description 	= "坦克伤害统计",
	version 		= "2022/6/8",
	url 			= "https://steamcommunity.com/id/saku_ra/"
}

// ConVars
ConVar g_hEnable, g_hEnableHealthSet, g_hHealthLimit, g_hSurvivorLimit;
// Bools
bool g_bTankInPlay = false, g_bAnnounceDamage = false, g_bHasPrintedRemaingHealth = false;
// Ints
int g_iTankClient = -1, g_iLastTankHealth = 0, g_iPassCount = 0;
// Chars
char client_name[64] = {'\0'}, temp_name[64] = {'\0'}, controlers_name[256] = {'\0'};

// 编译器会将所有未初始化的 int 类型初始化为 0
enum struct TankDamageFact
{
	float fLifeTime;
	bool bWasTank;
	int iGotDamage;
	int iSurvivorDamage;
	int iPunch;
	int iRock;
	int iHittable;
	void TankAttackFact_Init()
	{
		this.fLifeTime = 0.0;
		this.bWasTank = false;
		this.iGotDamage = this.iSurvivorDamage = this.iPunch = this.iRock = this.iHittable = 0;
	}
}
static TankDamageFact eTankDamageFact[MAXPLAYERS + 1];

public void OnPluginStart()
{
	g_hEnable = CreateConVar("l4d_tankdamage_enabled", "1", "是否开启坦克伤害统计", CVAR_FLAG, true, 0.0, true, 1.0);
	g_hEnableHealthSet = CreateConVar("l4d_tankdamage_enable_healthset", "1", "是否将坦克的生命值设置为 z_tank_health 数值", CVAR_FLAG, true, 0.0, true, 1.0);
	g_hSurvivorLimit = FindConVar("survivor_limit");
	g_hHealthLimit = FindConVar("z_tank_health");
	// HookEvents
	HookEvent("tank_spawn", evt_TankSpawn);
	HookEvent("player_hurt", evt_PlayerHurt);
	HookEvent("player_death", evt_PlayerDeath);
	HookEvent("round_start", evt_RoundStart);
	HookEvent("round_end", evt_RoundEnd);
	HookEvent("tank_frustrated", evt_TankFrustrated);
}

public void OnMapStart()
{
	ClearTankDamage();
}

stock int GetTeamPlayer(int team)
{
	int playerCount=0;
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i) && GetClientTeam(i) == team && IsPlayerAlive(i))
			playerCount++;
	}
	if(playerCount < g_hSurvivorLimit.IntValue)
		return g_hSurvivorLimit.IntValue;
	else
		return playerCount;
}

public void evt_TankSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsTank(client))
	{
		g_iPassCount += 1;
		g_iTankClient = client;
		eTankDamageFact[client].TankAttackFact_Init();
		eTankDamageFact[client].fLifeTime = GetGameTime();
		// 设置生命
		if (g_hEnableHealthSet.BoolValue)
		{
			int MaxTankHealth = GetConVarInt(g_hHealthLimit);
			if(g_hSurvivorLimit.IntValue == 2 || g_hSurvivorLimit.IntValue == 3)
				MaxTankHealth = 1000 + (g_hSurvivorLimit.IntValue -1) * 1500;
			else if(g_hSurvivorLimit.IntValue > 4)
			{
				MaxTankHealth = 6000 + (g_hSurvivorLimit.IntValue -4) * 2000;
				if(g_hSurvivorLimit.IntValue > 6)
					MaxTankHealth += (g_hSurvivorLimit.IntValue -6) * 500;
			}
			SetConVarInt(g_hHealthLimit, MaxTankHealth);
			SetEntProp(client, Prop_Data, "m_iHealth", g_hHealthLimit.IntValue);
			SetEntProp(client, Prop_Data, "m_iMaxHealth", g_hHealthLimit.IntValue);
		}
		if (IsFakeClient(client))
		{
			FormatEx(client_name, sizeof(client_name), "{blue}#%d：{green}AI ", g_iPassCount);
			StrCat(controlers_name, sizeof(controlers_name), client_name);
		}
		else
		{
			GetClientName(client, client_name, sizeof(client_name));
			FormatEx(temp_name, sizeof(temp_name), "{blue}#%d：{green}%s ", g_iPassCount, client_name);
			StrCat(controlers_name, sizeof(controlers_name), temp_name);
		}
		if (!g_bTankInPlay)
		{
			g_bTankInPlay = g_bAnnounceDamage = true;
			g_iLastTankHealth = GetEntProp(client, Prop_Data, "m_iHealth");
		}
	}
}

public void evt_TankFrustrated(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsValidClient(client))
	{
		eTankDamageFact[client].fLifeTime = GetGameTime() - eTankDamageFact[client].fLifeTime;
	}
}

public void evt_PlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
	char weapon[64] = {'\0'};
	int victim = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	int damage = event.GetInt("dmg_health");
	int remaining_health = event.GetInt("health");
	event.GetString("weapon", weapon, sizeof(weapon));
	// 坦克在场，如果受害者是坦克且不在倒地状态且攻击者为生还者，记录每个生还者对坦克的伤害和坦克剩余血量
	if (g_bTankInPlay)
	{
		if (victim == GetTankClient() && !IsClientIncapped(victim) && IsValidSurvivor(attacker) && damage > 0)
		{
			eTankDamageFact[attacker].iGotDamage += damage;
			g_iLastTankHealth = remaining_health;
		}
	}
	// 如果攻击者是坦克且受害者是生还者同时不在倒地状态，伤害大于 0，则记录生还者受到的伤害类型
	if (attacker == GetTankClient() && IsValidSurvivor(victim) && damage > 0)
	{
		if (strcmp(weapon, "tank_claw") == 0)
		{
			eTankDamageFact[victim].iPunch += 1;
		}
		else if (strcmp(weapon, "tank_rock") == 0)
		{
			eTankDamageFact[victim].iRock += 1;
		}
		else
		{
			eTankDamageFact[victim].iHittable += 1;
		}
	}
	if (attacker == GetTankClient() && IsValidSurvivor(victim) && damage > 0)
	{
		eTankDamageFact[victim].iSurvivorDamage += damage;
	}
}

public void evt_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	if (g_bTankInPlay)
	{
		int victim = GetClientOfUserId(event.GetInt("userid"));
		int attacker = GetClientOfUserId(event.GetInt("attacker"));
		// 坦克被处死或者卡死，victim == attacker，处死或者卡死时，不显示伤害报告
		if (victim == g_iTankClient && victim != attacker)
		{
			// 获取当前坦克最大生命值与控制者
			TrimString(controlers_name);
			int max_health = GetEntProp(victim, Prop_Data, "m_iMaxHealth");
			eTankDamageFact[victim].fLifeTime = GetGameTime() - eTankDamageFact[victim].fLifeTime;
			if (IsValidClient(attacker))
			{
				eTankDamageFact[attacker].iGotDamage += g_iLastTankHealth;
			}
			// 创建数据包，传当前坦克玩家的 ID 与最大血量
			DataPack dPack = new DataPack();
			dPack.WriteCell(victim);
			dPack.WriteCell(max_health);
			CreateTimer(0.1, Timer_CheckTank, dPack);
		}
	}
}
public Action Timer_CheckTank(Handle timer, DataPack dPack)
{
	dPack.Reset();
	int client = dPack.ReadCell();
	int max_health = dPack.ReadCell();
	delete dPack;
	// 读取完毕数据，进行伤害统计
	if (g_iTankClient == client)
	{
		int new_tankclient = FindTankClient();
		// 找到的新的坦克客户端与之前传入的坦克客户端不相同，说明找到了新的存活的坦克，返回
		if (IsValidClient(new_tankclient) && new_tankclient != client)
		{
			g_iTankClient = new_tankclient;
			return Plugin_Stop;
		}
		if (g_bAnnounceDamage)
		{
			PrintTankDamage(client, max_health);
			ClearTankDamage();
			g_bTankInPlay = false;
		}
	}
	return Plugin_Continue;
}
// 开局事件，清空坦克 ID 与所有生还者对坦克的伤害
public void evt_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	g_iTankClient = 0;
	g_bTankInPlay = g_bHasPrintedRemaingHealth = false;
	ClearTankDamage();
}

public void evt_RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	// 如果当前坦克仍然存活，则打印剩余血量和伤害
	if (g_bAnnounceDamage && IsTank(g_iTankClient))
	{
		int max_health = GetEntProp(g_iTankClient, Prop_Data, "m_iMaxHealth");
		PrintRemainingHealth();
		PrintTankDamage(g_iTankClient, max_health);
	}
	ClearTankDamage();
}

// 坦克未死亡时，打印当前坦克剩余生命值
void PrintRemainingHealth()
{
	if (g_hEnable.BoolValue)
	{
		g_bHasPrintedRemaingHealth = true;
		int new_tankclient = GetTankClient();
		if (IsValidClient(new_tankclient))
		{
			CPrintToChatAll("{blue}Tank\n{default}（{blue}控制：{green}%s{default}）剩余：{green}%d {default}血量：", controlers_name, g_iLastTankHealth);
		}
	}
}
// 打印当前生还者对坦克的伤害
void PrintTankDamage(int tank_client, int max_health)
{
	if (g_hEnable.BoolValue)
	{
		// 先循环一次所有客户端，同时获取所有客户端的操控坦克的总时长，无需在打印伤害标题前再循环一次所有玩家
		float total_survive_time = 0.0;
		int[] survivors = new int[g_hSurvivorLimit.IntValue];
		int survivor, total_percent = 0, total_damage = 0, survivor_index = -1, damage_percent = 0, damage = 0, percent_adjustment = 0, last_percent = 100, adjust_percent_damage = 0,
			got_damage = 0, total_got_damage = 0, got_damage_percent = 0;
		// 首先 survivor 等于 0，用于计算坦克存活时间
		for (survivor = 0; survivor <= MaxClients; survivor++)
		{
			total_survive_time += eTankDamageFact[survivor].fLifeTime;
			eTankDamageFact[survivor].fLifeTime = 0.0;
			if (IsValidSurvivor(survivor))
			{
				survivor_index += 1;
				survivors[survivor_index] = survivor;
				damage = eTankDamageFact[survivor].iGotDamage;
				total_damage += damage;
				// 计算每个生还者对坦克的伤害百分比
				damage_percent = GetDamageAsPercent(damage, max_health);
				total_percent += damage_percent;
				total_got_damage += eTankDamageFact[survivor].iSurvivorDamage;
			}
		}
		// 没有打印坦克剩余血量的情况，则说明坦克已死亡
		if (!g_bHasPrintedRemaingHealth)
		{
			char survive_time[64] = {'\0'};
			FormatDuration(survive_time, sizeof(survive_time), total_survive_time);
			CPrintToChatAll("[{blue}!{default}] {blue}生还者 {default}对 {blue}Tank {default}- {blue}存活时间：{green}%s", survive_time);
			CPrintToChatAll("（{blue}控制：{green}%s{default}）{blue}的伤害：", controlers_name);
		}
		// 通过总伤害进行排序
		SortCustom1D(survivors, g_hSurvivorLimit.IntValue, SortByDamageDesc);
		// 如果总伤害百分比相加低于 100 同时对坦克造成的伤害大于 99.5%，伤害调整的数值为 100 - 总伤害百分比
		if ((total_percent < 100 && float(total_damage) > (max_health - (max_health / 200))))
		{
			percent_adjustment = 100 - total_percent;
		}
		// 重新计算每个生还者调整后的伤害及伤害百分比
		for (int i = 0; i <= survivor_index; i++)
		{
			survivor = survivors[i];
			damage = eTankDamageFact[survivor].iGotDamage;
			damage_percent = GetDamageAsPercent(damage, max_health);
			got_damage = eTankDamageFact[survivor].iSurvivorDamage;
			got_damage_percent = GetDamageAsPercent(got_damage, total_got_damage);
			// 如果伤害调整的数值不等于 0 且某个生还者对坦克造成的伤害大于 0 且伤害百分比显示不准确的情况下，重新计算伤害百分比
			// 实际伤害：float（打的伤害 / 坦克血量） * 100.0，显示的伤害 int（打的伤害 / 坦克血量），有小数位数的差别，差别大于 1% 时判断为伤害百分比不准确
			if (percent_adjustment != 0 && damage > 0 && !IsExactPercent(damage, max_health))
			{
				// 伤害百分比计算不准确的情况下，将新的伤害百分比计算为：原伤害百分比 + 伤害调整的数值
				adjust_percent_damage = damage_percent + percent_adjustment;
				if (adjust_percent_damage <= last_percent)
				{
					damage_percent = adjust_percent_damage;
					percent_adjustment = 0;
				}
			}
			last_percent = damage_percent;
			CPrintToChatAll("[%d] {blue}[{default}拳:{green}%d{blue}] [{default}石:{green}%d{blue}] [{default}铁:{green}%d{blue}]（{default}%d%%{blue}） {green}| {default}承伤:{green}%d {blue}（{default}%d%%{blue}） {green}%N", damage, eTankDamageFact[survivor].iPunch, eTankDamageFact[survivor].iRock, eTankDamageFact[survivor].iHittable, damage_percent, got_damage, got_damage_percent, survivor);
			// 打印完伤害，清空坦克对生还者的伤害数据
			eTankDamageFact[survivor].TankAttackFact_Init();
		}
		// 清空控制者名称
		controlers_name = "";
		eTankDamageFact[tank_client].TankAttackFact_Init();
	}
	g_iPassCount = 0;
}

bool IsTank(int client)
{
	return view_as<bool>(GetInfectedClass(client) == view_as<int>(ZC_TANK));
}

int SortByDamageDesc(int elem1, int elem2, const int[] array, Handle hndl)
{
	if (eTankDamageFact[elem1].iGotDamage > eTankDamageFact[elem2].iGotDamage)
	{
		return -1;
	}
	else if (eTankDamageFact[elem2].iGotDamage > eTankDamageFact[elem1].iGotDamage)
	{
		return 1;
	}
	else if (elem1 > elem2)
	{
		return -1;
	}
	else if (elem2 > elem1)
	{
		return 1;
	}
	return 0;
}

int GetDamageAsPercent(int damage, int max_health)
{
	if (damage == 0.0 && max_health == 0.0)
	{
		return 0;
	}
	return RoundToNearest(float(damage) / float(max_health)  * 100.0);
}

bool IsExactPercent(int damage, int max_health)
{
	float damage_as_percent = (damage / max_health) * 100.0;
	float difference = float(GetDamageAsPercent(damage, max_health)) - damage_as_percent;
	return (FloatAbs(difference) < 0.001) ? true : false;
}

int FindTankClient()
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsTank(client))
		{
			return client;
		}
	}
	return 0;
}

int GetTankClient()
{
	if (g_bTankInPlay)
	{
		int new_tankclient = g_iTankClient;
		// 如果记录的坦克 ID 不是坦克，则寻找新的坦克客户端，找到，返回客户端 ID，找不到，返回 0，如果还是坦克，则直接返回客户端 ID
		if (!IsTank(new_tankclient))
		{
			new_tankclient = FindTankClient();
			if (IsTank(new_tankclient))
			{
				g_iTankClient = new_tankclient;
			}
			else
			{
				return 0;
			}
		}
		return new_tankclient;
	}
	return 0;
}

void ClearTankDamage()
{
	g_bAnnounceDamage = false;
	g_iPassCount = g_iLastTankHealth = 0;
	for (int client = 1; client <= MaxClients; client++)
	{
		eTankDamageFact[client].TankAttackFact_Init();
	}
}

void FormatDuration(char[] duration, int length, float timestamp)
{
	int new_timestamp = RoundToNearest(timestamp);
	if (new_timestamp < 60)
	{
		FormatEx(duration, length, "{green}%d秒", new_timestamp);
	}
	else if (new_timestamp < 3600)
	{
		int minute = new_timestamp / 60;
		FormatEx(duration, length, "{green}%d分钟%d秒", minute, new_timestamp - (minute * 60));
	}
	else
	{
		int hour = new_timestamp / 3600;
		int minute = new_timestamp % 3600 / 60;
		int second = new_timestamp % 60;
		FormatEx(duration, length, "{green}%d小时%d分钟%d秒", hour, minute, second);
	}
}
