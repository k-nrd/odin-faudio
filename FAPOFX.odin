/* FAudio - XAudio Reimplementation for FNA
*
* Copyright (c) 2011-2024 Ethan Lee, Luigi Auriemma, and the MonoGame Team
*
* This software is provided 'as-is', without any express or implied warranty.
* In no event will the authors be held liable for any damages arising from
* the use of this software.
*
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
*
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software in a
* product, an acknowledgment in the product documentation would be
* appreciated but is not required.
*
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
*
* 3. This notice may not be removed or altered from any source distribution.
*
* Ethan "flibitijibibo" Lee <flibitijibibo@flibitijibibo.com>
*
*/
package faudio

import "core:c"

_ :: c



// FAPOFXAPI :: FAUDIOAPI

/* See FAPOFXEQ_* constants below.
* FrequencyCenter is in Hz, Gain is amplitude ratio, Bandwidth is Q factor.
*/
FAPOFXEQParameters :: struct {
	FrequencyCenter0: f32,
	Gain0:            f32,
	Bandwidth0:       f32,
	FrequencyCenter1: f32,
	Gain1:            f32,
	Bandwidth1:       f32,
	FrequencyCenter2: f32,
	Gain2:            f32,
	Bandwidth2:       f32,
	FrequencyCenter3: f32,
	Gain3:            f32,
	Bandwidth3:       f32,
}

/* See FAPOFXMASTERINGLIMITER_* constants below. */
FAPOFXMasteringLimiterParameters :: struct {
	Release:  u32, /* In milliseconds */
	Loudness: u32, /* In... uh, MSDN doesn't actually say what. */
}

/* See FAPOFXREVERB_* constants below.
* Both parameters are arbitrary and should be treated subjectively.
*/
FAPOFXReverbParameters :: struct {
	Diffusion: f32,
	RoomSize:  f32,
}

/* See FAPOFXECHO_* constants below. */
FAPOFXEchoParameters :: struct {
	WetDryMix: f32, /* Percentage of processed signal vs original */
	Feedback:  f32, /* Percentage to feed back into input */
	Delay:     f32, /* In milliseconds */
}

/* Constants */
FAPOFXEQ_MIN_FRAMERATE :: 22000
FAPOFXEQ_MAX_FRAMERATE :: 48000

FAPOFXEQ_MIN_FREQUENCY_CENTER :: 20.0
FAPOFXEQ_MAX_FREQUENCY_CENTER :: 20000.0
FAPOFXEQ_DEFAULT_FREQUENCY_CENTER_0 :: 100.0
FAPOFXEQ_DEFAULT_FREQUENCY_CENTER_1 :: 800.0
FAPOFXEQ_DEFAULT_FREQUENCY_CENTER_2 :: 2000.0
FAPOFXEQ_DEFAULT_FREQUENCY_CENTER_3 :: 10000.0

FAPOFXEQ_MIN_GAIN :: 0.126
FAPOFXEQ_MAX_GAIN :: 7.94
FAPOFXEQ_DEFAULT_GAIN :: 1.0

FAPOFXEQ_MIN_BANDWIDTH :: 0.1
FAPOFXEQ_MAX_BANDWIDTH :: 2.0
FAPOFXEQ_DEFAULT_BANDWIDTH :: 1.0

FAPOFXMASTERINGLIMITER_MIN_RELEASE :: 1
FAPOFXMASTERINGLIMITER_MAX_RELEASE :: 20
FAPOFXMASTERINGLIMITER_DEFAULT_RELEASE :: 6

FAPOFXMASTERINGLIMITER_MIN_LOUDNESS :: 1
FAPOFXMASTERINGLIMITER_MAX_LOUDNESS :: 1800
FAPOFXMASTERINGLIMITER_DEFAULT_LOUDNESS :: 1000

FAPOFXREVERB_MIN_DIFFUSION :: 0.0
FAPOFXREVERB_MAX_DIFFUSION :: 1.0
FAPOFXREVERB_DEFAULT_DIFFUSION :: 0.9

FAPOFXREVERB_MIN_ROOMSIZE :: 0.0001
FAPOFXREVERB_MAX_ROOMSIZE :: 1.0
FAPOFXREVERB_DEFAULT_ROOMSIZE :: 0.6

FAPOFXECHO_MIN_WETDRYMIX :: 0.0
FAPOFXECHO_MAX_WETDRYMIX :: 1.0
FAPOFXECHO_DEFAULT_WETDRYMIX :: 0.5

FAPOFXECHO_MIN_FEEDBACK :: 0.0
FAPOFXECHO_MAX_FEEDBACK :: 1.0
FAPOFXECHO_DEFAULT_FEEDBACK :: 0.5

FAPOFXECHO_MIN_DELAY :: 1.0
FAPOFXECHO_MAX_DELAY :: 2000.0
FAPOFXECHO_DEFAULT_DELAY :: 500.0

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/* Creates an effect from the pre-made FAPOFX effect library.
	*
	* clsid:		A reference to one of the FAPOFX_CLSID_* GUIDs
	* pEffect:		Filled with the resulting FAPO object
	* pInitData:		Starting parameters, pass NULL to use the default values
	* InitDataByteSize:	Parameter struct size, pass 0 if pInitData is NULL
	*
	* Returns 0 on success.
	*/
	FAPOFX_CreateFX :: proc(clsid: ^FAudioGUID, pEffect: ^^FAPO, pInitData: rawptr, InitDataByteSize: u32) -> u32 ---

	/* See "extensions/CustomAllocatorEXT.txt" for more details. */
	FAPOFX_CreateFXWithCustomAllocatorEXT :: proc(clsid: ^FAudioGUID, pEffect: ^^FAPO, pInitData: rawptr, InitDataByteSize: u32, customMalloc: FAudioMallocFunc, customFree: FAudioFreeFunc, customRealloc: FAudioReallocFunc) -> u32 ---
}
