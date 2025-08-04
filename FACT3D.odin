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
/* This file has no documentation since you are expected to already know how
* XACT works if you are still using these APIs!
*/
package faudio

import "core:c"

_ :: c



FRONT_CENTER_AZIMUTH :: 0.0
// LOW_FREQUENCY_AZIMUTH :: F3DAUDIO_2PI

// BACK_CENTER_AZIMUTH :: F3DAUDIO_PI

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/* Functions */
	FACT3DInitialize :: proc(pEngine: ^FACTAudioEngine, F3DInstance: ^u8) -> u32 ---
	FACT3DCalculate  :: proc(F3DInstance: ^u8, pListener: ^F3DAUDIO_LISTENER, pEmitter: ^F3DAUDIO_EMITTER, pDSPSettings: ^F3DAUDIO_DSP_SETTINGS) -> u32 ---
	FACT3DApply      :: proc(pDSPSettings: ^F3DAUDIO_DSP_SETTINGS, pCue: ^FACTCue) -> u32 ---
}
