#if defined  _l4d_stats_included_
 #endinput
#endif
#define _l4d_stats_included_
public SharedPlugin __pl_l4d_stats =
{
	name = "l4d_stats",
	file = "l4d_stats.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_l4d_stats_SetNTVOptional()
{
	MarkNativeAsOptional("l4dstats_GetClientScore");
	MarkNativeAsOptional("l4dstats_IsTopPlayer");
	MarkNativeAsOptional("l4dstats_GetClientPlayTime");
	MarkNativeAsOptional("l4dstats_AddClientScore");
}
#endif

/**
 * get A player Score
 *
 * @param client		Client Index.

 * @return		Player Score.
 */
native int l4dstats_GetClientScore(int client);
/**
 * get A player is in ranklimit
 *
 * @param client		Client Index.

 * @return		0 for false, 1 for true.
 */
native int l4dstats_IsTopPlayer(int client, int ranklimit);
/**
 * get A player time[min]
 *
 * @param client		Client Index.

 * @return		Player time[min].
 */
native int l4dstats_GetClientPlayTime(int client);
/**
 * add Score to client player
 *
 * @param client		Client Index.

 * @return		0 for false, 1 for true.
 */
native int l4dstats_AddClientScore(int client, int Score); 
/**
 * Called when l4d_stats plugins announce rank and score.
 *
 * @param client		Client Index.
 *
 */
forward void l4dstats_AnnounceGameTime(int client);
/**
 * Called when l4d_stats plugins successful get player time in database.
 *
 * @param client		Client Index.
 *
 */
forward void l4dstats_SuccessGetPlayerTime(int client);