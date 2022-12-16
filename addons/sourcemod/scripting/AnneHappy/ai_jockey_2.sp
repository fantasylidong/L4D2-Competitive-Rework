#pragma semicolon 1
#pragma newdecls required

// 头文件
#include <sourcemod>
#include <sdktools>
#include <left4dhooks>
#include <treeutil>

#define CVAR_FLAG FCVAR_NOTIFY
#define SPECIAL_JUMP_DIST 250.0
#define BACK_JUMP_DIST 70.0
#define FREEZE_MAX_TIME 0.8
#define SHOVE_INTERVAL 1.0
#define FL_JUMPING 65922
#define DEBUG_ALL 0

enum AimType
{
	AimEye,
	AimBody,
	AimChest
};
enum
{
	ACTION_FROZEN,
	ACTION_JUMP_BACK,
	ACTION_JUMP_HIGH,
	ACTION_COUNT
};

public Plugin myinfo = 
{
	name 			= "Ai_Jockey 2.0 版本",
	author 			= "Breezy，High Cookie，Standalone，Newteee，cravenge，Harry，Sorallll，PaimonQwQ，夜羽真白",
	description 	= "觉得Ai猴子太弱了？ Try this！",
	version 		= "2022/11/16",
	url 			= "https://steamcommunity.com/id/saku_ra/"
}

// ConVars
ConVar g_hBhopSpeed, g_hStartHopDistance, g_hJockeyStumbleRadius, g_hJockeyLeapTime,
		g_hSpecialJumpAngle, g_hSpecialJumpChance, g_hActionChance, g_hAllowInterControl, g_hJockeySpeed;
// Ints 
int g_iState[MAXPLAYERS + 1][8], g_iActionArray[ACTION_COUNT], g_iLockViewMode[MAXPLAYERS + 1] = { 0 };
// Float
float g_fShovedTime[MAXPLAYERS + 1] = {0.0}, g_fNoActionTime[MAXPLAYERS + 1][2], g_fPlayerShovedTime[MAXPLAYERS + 1] = {0.0};
// Bools
bool g_bHasBeenShoved[MAXPLAYERS + 1], g_bCanAttackPinned[MAXPLAYERS + 1] = { false };
// StringMap
StringMap interControlMap = null;

public void OnPluginStart()
{
	g_hBhopSpeed = CreateConVar("ai_JockeyBhopSpeed", "80.0", "Jockey 连跳的速度", CVAR_FLAG, true, 0.0);
	g_hStartHopDistance = CreateConVar("ai_JockeyStartHopDistance", "800", "Jockey 距离生还者多少距离开始主动连跳", CVAR_FLAG, true, 0.0);
	g_hJockeyStumbleRadius = CreateConVar("ai_JockeyStumbleRadius", "50", "Jockey 骑到人后会对多少范围内的生还者产生硬直效果", CVAR_FLAG, true, 0.0);
	// 骗推设置
	g_hSpecialJumpAngle = CreateConVar("ai_JockeySpecialJumpAngle", "60", "当目标正在看着 Jockey 并与其处于这个角度之内，Jockey 会尝试骗推", CVAR_FLAG, true, 0.0, true, 180.0);
	g_hSpecialJumpChance = CreateConVar("ai_JockeySpecialJumpChance", "60", "Jockey 有多少概率执行骗推", CVAR_FLAG, true, 0.0, true, 100.0);
	g_hActionChance = CreateConVar("ai_jockeyNoActionChance", "20,20,60", "Jockey 执行以下行为的概率（冻结行动 [时间 0 - FREEZE_MAX_TIME 秒随机]，向后跳，高跳）逗号分割", CVAR_FLAG, true, 0.0, true, 100.0);
	g_hAllowInterControl = CreateConVar("ai_JockeyAllowInterControl", "0", "Jockey 优先找被这些特感控制的生还者，抢控或补控（不想要这个功能可以设置为 0）", CVAR_FLAG);
	//g_hJockeyAirAngles = CreateConVar("ai_JockeyAirAngles", "60.0", "Jockey的速度方向与到目标的向量方向的距离大于这个角度，改变方向", FCVAR_NOTIFY, true, 0.0, true, 180.0);
	g_hJockeyLeapTime =	FindConVar("z_jockey_leap_time");
	// 其他
	g_hJockeySpeed = FindConVar("z_jockey_speed");
	// HookEvent
	HookEvent("player_spawn", evt_PlayerSpawn, EventHookMode_Pre);
	HookEvent("player_shoved", evt_PlayerShoved, EventHookMode_Pre);
	HookEvent("jockey_ride", evt_JockeyRide);
	// AddChangeHook
	g_hActionChance.AddChangeHook(GetActionPercent_Cvars);
	g_hAllowInterControl.AddChangeHook(GetInterControl_Cvars);
	// GetActionPercent
	getActionPercent();
	// BuildStringMap
	interControlMap = new StringMap();
	// GetInterControlInfected
	getInterControlInfected();
}
public void OnPluginEnd()
{
	delete interControlMap;
}

void GetActionPercent_Cvars(ConVar convar, const char[] oldValue, const char[] newValue) { getActionPercent(); }
void GetInterControl_Cvars(ConVar convar, const char[] oldValue, const char[] newValue) { getInterControlInfected(); }

public Action OnPlayerRunCmd(int jockey, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	if (!IsAiJockey(jockey) || !IsPlayerAlive(jockey)) { return Plugin_Continue; }
	float fSpeed[3] = {0.0}, fCurrentSpeed = 0.0, fJockeyPos[3] = {0.0};
	int actionPercent;
	GetEntPropVector(jockey, Prop_Data, "m_vecVelocity", fSpeed);
	fCurrentSpeed = SquareRoot(Pow(fSpeed[0], 2.0) + Pow(fSpeed[1], 2.0));
	GetClientAbsOrigin(jockey, fJockeyPos);
	// 获取jockey状态
	int iFlags = GetEntityFlags(jockey), iTarget = g_bCanAttackPinned[jockey] ? GetClientAimTarget(jockey, true) : GetClosetMobileSurvivor(jockey);
	bool bHasSight = view_as<bool>(GetEntProp(jockey, Prop_Send, "m_hasVisibleThreats"));
	// 在梯子上，禁止跳与蹲
	if (GetEntityMoveType(jockey) & MOVETYPE_LADDER)
	{
		buttons &= ~IN_JUMP;
		buttons &= ~IN_DUCK;
		return Plugin_Changed;
	}
	if (!bHasSight || !IsValidSurvivor(iTarget) || !IsPlayerAlive(iTarget) || g_bHasBeenShoved[jockey]) { return Plugin_Continue; }
	// 当前 Jockey 有效，目标有效，进行其他操作
	float fBuffer[3] = {0.0}, fTargetPos[3] = {0.0}, fDistance = NearestSurvivorDistance(jockey);
	GetClientAbsOrigin(iTarget, fTargetPos);
	fBuffer = UpdatePosition(jockey, iTarget, g_hBhopSpeed.FloatValue);
	// 当前速度不大于 130.0 或距离大于 StartHopDistance，不进行操作
	if (fCurrentSpeed <= 130.0 || fDistance > g_hStartHopDistance.FloatValue) { return Plugin_Continue; }
	LockView(jockey, iTarget);
	if (iFlags & FL_ONGROUND)
	{
		// Jockey 距离目标的距离小于 SPECIAL_JUMP_DIST
		if (fDistance <= SPECIAL_JUMP_DIST)
		{
			// 如果目标没有正在看着 Jockey，则直接骑乘
			if (!IsTargetWatchingAttacker(jockey, iTarget, g_hSpecialJumpAngle.IntValue))
			{
				buttons |= IN_ATTACK;
				buttons |= IN_JUMP;
				buttons |= IN_ATTACK2;
				SetState(jockey, 0, IN_ATTACK);
				#if (DEBUG_ALL)
				{
					PrintToConsoleAll("[Ai-Jockey]：目标没有看着生还者，直接进行攻击");
				}
				#endif
			}
			// 如果目标正在看着 Jockey 而且正在两次推之间，直接骑乘
			else if (GetGameTime() - g_fPlayerShovedTime[iTarget] < SHOVE_INTERVAL)
			{
				buttons |= IN_ATTACK;
				buttons |= IN_JUMP;
				buttons |= IN_ATTACK2;
				g_iLockViewMode[jockey] = 1;
				SetState(jockey, 0, IN_ATTACK);
				#if (DEBUG_ALL)
				{
					PrintToConsoleAll("[Ai-Jockey]：目标：%N 正在推的 cd 内，直接进行攻击", iTarget);
				}
				#endif
			}
			// 如果目标正在看着 Jockey 没有在两次推之间，尝试骗推
			else
			{
				// 获取骗推概率
				if (getRandomIntInRange(0, 100) <= g_hSpecialJumpChance.IntValue && fDistance >= BACK_JUMP_DIST && (GetState(jockey, 0) & IN_JUMP))
				{
					actionPercent = getRandomIntInRange(0, 100);
					// 概率冻结 Jockey，Jockey 解冻后仍然在地上，无需设置状态为 IN_ATTACK，进行其他操作
					if (actionPercent <= g_iActionArray[ACTION_FROZEN]
						&& g_fNoActionTime[jockey][0] == 0.0)
					{
						g_fNoActionTime[jockey][0] = GetGameTime();
						g_fNoActionTime[jockey][1] = getRandomFloatInRange(0.0, FREEZE_MAX_TIME);
						g_iLockViewMode[jockey] = 1;
						SetEntityMoveType(jockey, MOVETYPE_NONE);
						CreateTimer(g_fNoActionTime[jockey][1], setMoveTypeToCustomHandler, jockey);
						#if (DEBUG_ALL)
						{
							PrintToConsoleAll("[Ai-Jockey]：目前概率：%d，冻结 Jockey：%.2f 秒，时间戳：%.2f", actionPercent, g_fNoActionTime[jockey][1], GetGameTime());
						}
						#endif
					}
					else if (actionPercent > g_iActionArray[ACTION_FROZEN] 
						&& actionPercent <= g_iActionArray[ACTION_JUMP_BACK]
						&& (fDistance > 0.0 && fDistance <= SPECIAL_JUMP_DIST))
					{
						// 距离大于 BACK_JUMP_DIST 且小于 SPECIAL_JUMP_DIST，Jockey 向后跳
						float subtractVec[3] = {0.0};
						SubtractVectors(fTargetPos, fJockeyPos, subtractVec);
						NegateVector(subtractVec);
						NormalizeVector(subtractVec, subtractVec);
						ScaleVector(subtractVec, g_hJockeySpeed.FloatValue);
						buttons |= IN_JUMP;
						g_iLockViewMode[jockey] = 2;
						TeleportEntity(jockey, NULL_VECTOR, NULL_VECTOR, subtractVec);
						SetState(jockey, 0, IN_ATTACK);
						#if (DEBUG_ALL)
						{
							PrintToConsoleAll("[Ai-Jockey]：目前概率：%d，Jockey 向后跳", actionPercent);
						}
						#endif
					}
					else if (actionPercent > g_iActionArray[ACTION_JUMP_BACK] 
						&& actionPercent <= g_iActionArray[ACTION_JUMP_HIGH])
					{
						// 高跳
						float eyeAngles[3] = {0.0}, angle = getRandomFloatInRange(30.0, 60.0);
						eyeAngles = angles;
						eyeAngles[0] = -angle;
						g_iLockViewMode[jockey] = 0;
						TeleportEntity(jockey, NULL_VECTOR, eyeAngles, NULL_VECTOR);
						buttons |= IN_ATTACK;
						buttons |= IN_ATTACK2;
						SetState(jockey, 0, IN_ATTACK);
						#if (DEBUG_ALL)
						{
							PrintToConsoleAll("[Ai-Jockey]：目前概率：%d，Jockey 高跳，角度：%.2f", actionPercent, eyeAngles[0]);
						}
						#endif
					}
				}
			}
		}
		else
		{
			// Jockey 和生还者距离超过 SPECIAL_JUMP_DIST，正常连跳靠近生还者
			buttons |= IN_JUMP;
			SetState(jockey, 0, IN_JUMP);
			// 目标正在看着 Jockey
			if (IsTargetWatchingAttacker(jockey, iTarget, g_hSpecialJumpAngle.IntValue))
			{
				g_iLockViewMode[jockey] = 0;
				float eyeAngles[3] = {0.0}, eyeAngleVec[3] = {0.0};
				GetClientEyeAngles(jockey, eyeAngles);
				// 50% 概率向左向右跳
				if (getRandomIntInRange(0, 1)) { eyeAngles[1] += getRandomIntInRange(15, 45); }
				else { eyeAngles[1] -= getRandomIntInRange(15, 45); }
				TeleportEntity(jockey, NULL_VECTOR, eyeAngles, NULL_VECTOR);
				GetAngleVectors(eyeAngles, eyeAngleVec, NULL_VECTOR, NULL_VECTOR);
				NormalizeVector(eyeAngleVec, eyeAngleVec);
				eyeAngleVec[2] = 0.0;
				ScaleVector(eyeAngleVec, g_hBhopSpeed.FloatValue);
				if ((buttons & IN_FORWARD) || (buttons & IN_MOVELEFT) || (buttons & IN_MOVERIGHT)) { ClientPush(jockey, eyeAngleVec); }
				#if (DEBUG_ALL)
				{
					PrintToConsoleAll("[Ai-Jockey]：目标正在看着 Jockey，随机角度：%.2f %.2f %.2f", eyeAngles[0], eyeAngles[1], eyeAngles[2]);
				}
				#endif
			}
			else if (!g_bCanAttackPinned[jockey] && (buttons & IN_FORWARD) || (buttons & IN_MOVELEFT) || (buttons & IN_MOVERIGHT))
			{ 
				g_iLockViewMode[jockey] = 1;
				ClientPush(jockey, fBuffer); 
			}
		}
	}
	else
	{
		buttons &= ~IN_JUMP;
		buttons &= ~IN_ATTACK;
		/*
		//太近不允许强制换方向
		if(fDistance > 150.0){
			//PrintToConsoleAll("检测猴子在空中");
			float fAngles[3], new_velvec[3] = {0.0}, self_target_vec[3] = {0.0};
			GetVectorAngles(fSpeed, fAngles);
			fAngles[0] = fAngles[2] = 0.0;
			GetAngleVectors(fAngles, new_velvec, NULL_VECTOR, NULL_VECTOR);
			NormalizeVector(new_velvec, new_velvec);
			// 保存当前位置
			// 生还比特感高，关闭z方向
			if(fTargetPos[2] > fTargetPos[2])
				fJockeyPos[2] = fTargetPos[2] = 0.0;
			MakeVectorFromPoints(fJockeyPos, fTargetPos, self_target_vec);
			NormalizeVector(self_target_vec, self_target_vec);
			float fAngleDifference = RadToDeg(ArcCosine(GetVectorDotProduct(new_velvec, self_target_vec)));
			//PrintToConsoleAll("速度夹角：%f", fAngleDifference);
			// 计算距离
			if (fAngleDifference > g_hJockeyAirAngles.IntValue && fAngleDifference < 120.0)
			{
				//重新设置方向
				MakeVectorFromPoints(fJockeyPos, fTargetPos, new_velvec);
				//GetVectorAngles(new_velvec, fAngles);
				NormalizeVector(new_velvec, new_velvec);
				//NegateVector(new_velvec);
				// 按照原来速度向量长度 + 缩放长度缩放修正后的速度向量，觉得太阴间了可以修改
				ScaleVector(new_velvec, fCurrentSpeed * 0.9);
				//PrintToConsoleAll("方向夹角为： %f,强制转向后的速度: %f", fAngleDifference, GetVectorLength(new_velvec));
				TeleportEntity(jockey, NULL_VECTOR, NULL_VECTOR, new_velvec);
			}
		}
		*/
	}
	return Plugin_Continue;
}
//mode 0 关闭 ，1 锁定目标 2 倒着锁定目标
stock void LockView(int client, int target)
{
	if(g_iLockViewMode[client] == 0)
		return;
	float self_eye_pos[3] = {0.0}, targetpos[3] = {0.0}, look_at[3] = {0.0};
	GetClientEyePosition(client, self_eye_pos);
	GetClientAbsOrigin(target, targetpos);
	targetpos[2] += 45.0;
	MakeVectorFromPoints(self_eye_pos, targetpos, look_at);
	if(g_iLockViewMode[client] == 2)
	{
		NegateVector(look_at);
	}
	GetVectorAngles(look_at, look_at);
	TeleportEntity(client, NULL_VECTOR, look_at, NULL_VECTOR);
}

public Action L4D2_OnChooseVictim(int specialInfected, int &curTarget)
{
	if (!IsAiJockey(specialInfected) || !IsPlayerAlive(specialInfected)) { return Plugin_Continue; }
	char interControlName[32] = {'\0'};
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && IsPlayerAlive(i) && IsClientPinned(i))
		{
			IntToString(GetClientPinnedInfectedType(i), interControlName, sizeof(interControlName));
			if (!interControlMap.ContainsKey(interControlName)) { continue; }
			curTarget = i;
			g_bCanAttackPinned[specialInfected] = true;
			return Plugin_Changed;
		}
	}
	g_bCanAttackPinned[specialInfected] = false;
	return Plugin_Continue;
}

public void L4D_OnSwingStart(int client, int weapon)
{
	if (!IsValidSurvivor(client) || !IsPlayerAlive(client)) { return; }
	g_fPlayerShovedTime[client] = GetGameTime();
}

// ***************
//		Stuff
// ***************
public Action setMoveTypeToCustomHandler(Handle timer, int client)
{
	if (!IsAiJockey(client)) { return Plugin_Continue; }
	SetEntityMoveType(client, MOVETYPE_CUSTOM);
	g_fNoActionTime[client][0] = g_fNoActionTime[client][1] = 0.0;
	#if (DEBUG_ALL)
	{
		PrintToConsoleAll("[Ai-Jockey]：解冻 Jockey，时间戳：%.2f", GetGameTime());
	}
	#endif
	return Plugin_Continue;
}

public Action evt_PlayerShoved(Event event, const char[] name, bool dontBroadcast)
{
	int iShovedPlayer = GetClientOfUserId(event.GetInt("userid"));
	if (IsAiJockey(iShovedPlayer))
	{
		g_bHasBeenShoved[iShovedPlayer] = true;
		g_fShovedTime[iShovedPlayer] = GetGameTime();
		CreateTimer(g_hJockeyLeapTime.FloatValue, Timer_LeapTimeCoolDown, iShovedPlayer, TIMER_FLAG_NO_MAPCHANGE);
	}
	return Plugin_Continue;
}

public Action Timer_LeapTimeCoolDown(Handle timer, int jockey)
{
	g_bHasBeenShoved[jockey] = false;
	return Plugin_Continue;
}

public Action evt_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int iSpawnPlayer = GetClientOfUserId(event.GetInt("userid"));
	if (!IsAiJockey(iSpawnPlayer)) { return Plugin_Continue; }
	g_bHasBeenShoved[iSpawnPlayer] = g_bCanAttackPinned[iSpawnPlayer] = false;
	g_fShovedTime[iSpawnPlayer] = g_fNoActionTime[iSpawnPlayer][0] = g_fNoActionTime[iSpawnPlayer][1] = 0.0;
	SetState(iSpawnPlayer, 0, IN_JUMP);
	return Plugin_Continue;
}

public void evt_JockeyRide(Event event, const char[] name, bool dontBroadcast)
{
	if (IsCoop)
	{
		int attacker = GetClientOfUserId(event.GetInt("userid"));
		int victim = GetClientOfUserId(event.GetInt("victim"));
		if (attacker > 0 && victim > 0)
		{
			StumbleByStanders(victim, attacker);
		}
	}
}

bool IsCoop()
{
	static char sGameMode[16];
	sGameMode[0] = 0;
	FindConVar("mp_gamemode").GetString(sGameMode, sizeof(sGameMode));
	return strcmp(sGameMode, "versus", false) != 0 && strcmp(sGameMode, "scavenge", false) != 0;
}

void StumbleByStanders(int pinnedSurvivor, int pinner) 
{
	static float pinnedSurvivorPos[3], pos[3], dir[3];
	GetClientAbsOrigin(pinnedSurvivor, pinnedSurvivorPos);
	for(int i = 1; i <= MaxClients; i++) 
	{
		if(IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2)
		{
			if(i != pinnedSurvivor && i != pinner && !IsClientPinned(i)) 
			{
				GetClientAbsOrigin(i, pos);
				SubtractVectors(pos, pinnedSurvivorPos, dir);
				if(GetVectorLength(dir) <= g_hJockeyStumbleRadius.FloatValue) 
				{
					NormalizeVector(dir, dir); 
					L4D_StaggerPlayer(i, pinnedSurvivor, dir);
				}
			}
		} 
	}
}

// ***** 方法 *****
bool IsAiJockey(int client)
{
	return GetInfectedClass(client) == ZC_JOCKEY && IsFakeClient(client);
}

float NearestSurvivorDistance(int client)
{
	int closestSurvivor = GetClosetMobileSurvivor(client);
	if (IsValidSurvivor(closestSurvivor))
	{
		float selfPos[3] = {0.0}, targetPos[3] = {0.0};
		GetClientAbsOrigin(client, selfPos);
		GetClientAbsOrigin(closestSurvivor, targetPos);
		return GetVectorDistance(selfPos, targetPos);
	}
	return -1.0;
}

bool IsTargetWatchingAttacker(int attacker, int target, int offset)
{
	if (GetClientTeam(attacker) == TEAM_INFECTED && IsPlayerAlive(attacker))
	{
		if (IsValidSurvivor(target) && !IsClientPinned(target))
		{
			int iOffset = RoundToNearest(GetPlayerAimOffset(target, attacker));
			return iOffset <= offset;
		}
	}
	return false;
}

float GetPlayerAimOffset(int attacker, int target)
{
	if (IsClientConnected(attacker) && IsClientInGame(attacker) && IsPlayerAlive(attacker) && IsClientInGame(target) && IsPlayerAlive(target))
	{
		float fAttackerPos[3], fTargetPos[3], fAimVector[3], fDirectVector[3], fResultAngle;
		GetClientEyeAngles(attacker, fAimVector);
		fAimVector[0] = fAimVector[2] = 0.0;
		GetAngleVectors(fAimVector, fAimVector, NULL_VECTOR, NULL_VECTOR);
		NormalizeVector(fAimVector, fAimVector);
		// 获取目标位置
		GetClientAbsOrigin(target, fTargetPos);
		GetClientAbsOrigin(attacker, fAttackerPos);
		fAttackerPos[2] = fTargetPos[2] = 0.0;
		MakeVectorFromPoints(fAttackerPos, fTargetPos, fDirectVector);
		NormalizeVector(fDirectVector, fDirectVector);
		// 计算角度
		fResultAngle = RadToDeg(ArcCosine(GetVectorDotProduct(fAimVector, fDirectVector)));
		return fResultAngle;
	}
	return -1.0;
}

void SetState(int client, int no, int value)
{
	g_iState[client][no] = value;
}

int GetState(int client, int no)
{
	return g_iState[client][no];
}

float[] UpdatePosition(int jockey, int target, float fForce)
{
	float fBuffer[3] = {0.0}, fTankPos[3] = {0.0}, fTargetPos[3] = {0.0};
	GetClientAbsOrigin(jockey, fTankPos);
	GetClientAbsOrigin(target, fTargetPos);
	SubtractVectors(fTargetPos, fTankPos, fBuffer);
	NormalizeVector(fBuffer, fBuffer);
	ScaleVector(fBuffer, fForce);
	fBuffer[2] = 0.0;
	return fBuffer;
}

void ClientPush(int client, float fForwardVec[3])
{
	float fCurVelVec[3];
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", fCurVelVec);
	AddVectors(fCurVelVec, fForwardVec, fCurVelVec);
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, fCurVelVec);
}

int getRandomIntInRange(int min, int max)
{
	return (GetURandomInt() % (max - min + 1)) + min;
}
float getRandomFloatInRange(float min, float max)
{
	return GetURandomFloat() * (max - min) + min;
}
void getActionPercent()
{
	int total = 0;
	char cvarString[64] = {'\0'}, actionArray[ACTION_COUNT][4];
	g_hActionChance.GetString(cvarString, sizeof(cvarString));
	ExplodeString(cvarString, ",", actionArray, 4, 4);
	for (int i = 0; i < ACTION_COUNT; i++)
	{
		g_iActionArray[i] = total + StringToInt(actionArray[i]);
		total += StringToInt(actionArray[i]);
	}
}
void getInterControlInfected()
{
	if (interControlMap != null) { interControlMap.Clear(); }
	char cvarString[64] = {'\0'}, interControlArray[ZC_CHARGER][4];
	g_hAllowInterControl.GetString(cvarString, sizeof(cvarString));
	ExplodeString(cvarString, ",", interControlArray, ZC_CHARGER, 4);
	for (int i = 0; i < ZC_CHARGER; i++)
	{
		if (!(strcmp(interControlArray[i], NULL_STRING) == 0)) { interControlMap.SetString(interControlArray[i][0], ""); }
	}
}