#if defined _ai_smoker_new_included
 #endinput
#endif
#define _ai_smoker_new_included

/**
 * @brief Get Smoker Ability status.
 * @remarks you must send alive smoker client index.
 *
 * @param client			smoker client
 *
 * @return 1 cansmoker 0 cannotsmoker
 */
native int IsSmokerCanUseAbility(int client);

public SharedPlugin __pl_ai_smoker_new = 
{
	name = "ai_smoker_new",
	file = "ai_smoker_new.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_ai_smoker_new_SetNTVOptional()
{
	MarkNativeAsOptional("IsSmokerCanUseAbility");
}
#endif