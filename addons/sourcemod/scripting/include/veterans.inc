/*
*	Veterans System
*	Copyright (C) 2022 morzlee
*
*	This program is free software: you can redistribute it and/or modify
*	it under the terms of the GNU General Public License as published by
*	the Free Software Foundation, either version 3 of the License, or
*	(at your option) any later version.
*
*	This program is distributed in the hope that it will be useful,
*	but WITHOUT ANY WARRANTY; without even the implied warranty of
*	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*	GNU General Public License for more details.
*
*	You should have received a copy of the GNU General Public License
*	along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#if defined _veterans_included
 #endinput
#endif
#define _veterans_included



public SharedPlugin __pl_veterans = 
{
	name = "veterans",
	file = "veterans.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};


#if !defined REQUIRE_PLUGIN
public void __pl_veterans_SetNTVOptional()
{
	MarkNativeAsOptional("Veterans_Get");
}
#endif

// The options Values used for the natives:
enum TARGET_OPTION_INDEX
{
	TIME_TOTAL		= 0,	// "totaltime"
	TIME_REAL		= 1,	// "realtime"
	TIME_SERVER		= 2,	// "servertime"
	TIME_2WEEK		= 3,	// "2WeekPlaytime"
	GOURP_MEMBER	= 4		// "groupmember"
}


/**
* @brief Returns the current option value for the specified Special Infected
*
* @param	index			The TARGET_SI_INDEX index of the Special Infected type to affect (Tank, etc)
* @param	option			The TARGET_OPTION_INDEX option index to affect ("pinned", "targeted", etc)
*
* @return	int or float value for the option selected
*/
native any Veterans_Get(int client, TARGET_OPTION_INDEX option);

