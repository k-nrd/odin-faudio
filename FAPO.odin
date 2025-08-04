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
/* This file has no documentation since the MSDN docs are still perfectly fine:
* https://docs.microsoft.com/en-us/windows/desktop/api/xapo/
*
* Of course, the APIs aren't exactly the same since XAPO is super dependent on
* C++. Instead, we use a struct full of functions to mimic a vtable.
*
* The only serious difference is that our FAPO (yes, really) always has the
* Get/SetParameters function pointers, for simplicity. You can ignore these if
* your effect does not have parameters, as they will never get called unless
* it is explicitly requested by the application.
*/
package faudio

import "core:c"

_ :: c



// FAPOAPI :: FAUDIOAPI
// FAPOCALL :: FAUDIOCALL

/* Enumerations */
FAPOBufferFlags :: enum c.int {
	SILENT,
	VALID,
}

FAPORegistrationProperties :: struct {
	clsid:                FAudioGUID,
	FriendlyName:         [256]i16, /* Win32 wchar_t */
	CopyrightInfo:        [256]i16, /* Win32 wchar_t */
	MajorVersion:         u32,
	MinorVersion:         u32,
	Flags:                u32,
	MinInputBufferCount:  u32,
	MaxInputBufferCount:  u32,
	MinOutputBufferCount: u32,
	MaxOutputBufferCount: u32,
}

FAPOLockForProcessBufferParameters :: struct {
	pFormat:       ^FAudioWaveFormatEx,
	MaxFrameCount: u32,
}

FAPOProcessBufferParameters :: struct {
	pBuffer:         rawptr,
	BufferFlags:     FAPOBufferFlags,
	ValidFrameCount: u32,
}

/* Constants */
FAPO_MIN_CHANNELS :: 1
FAPO_MAX_CHANNELS :: 64

FAPO_MIN_FRAMERATE :: 1000
FAPO_MAX_FRAMERATE :: 200000

FAPO_REGISTRATION_STRING_LENGTH :: 256

FAPO_FLAG_CHANNELS_MUST_MATCH :: 0x00000001
FAPO_FLAG_FRAMERATE_MUST_MATCH :: 0x00000002
FAPO_FLAG_BITSPERSAMPLE_MUST_MATCH :: 0x00000004
FAPO_FLAG_BUFFERCOUNT_MUST_MATCH :: 0x00000008
FAPO_FLAG_INPLACE_REQUIRED :: 0x00000020
FAPO_FLAG_INPLACE_SUPPORTED :: 0x00000010

AddRefFunc :: proc "c" (rawptr) -> i32

ReleaseFunc :: proc "c" (rawptr) -> i32

GetRegistrationPropertiesFunc :: proc "c" (rawptr, ^^FAPORegistrationProperties) -> u32

IsInputFormatSupportedFunc :: proc "c" (rawptr, ^FAudioWaveFormatEx, ^FAudioWaveFormatEx, ^^FAudioWaveFormatEx) -> u32

IsOutputFormatSupportedFunc :: proc "c" (rawptr, ^FAudioWaveFormatEx, ^FAudioWaveFormatEx, ^^FAudioWaveFormatEx) -> u32

InitializeFunc :: proc "c" (rawptr, rawptr, u32) -> u32

ResetFunc :: proc "c" (rawptr)

LockForProcessFunc :: proc "c" (rawptr, u32, ^FAPOLockForProcessBufferParameters, u32, ^FAPOLockForProcessBufferParameters) -> u32

UnlockForProcessFunc :: proc "c" (rawptr)

ProcessFunc :: proc "c" (rawptr, u32, ^FAPOProcessBufferParameters, u32, ^FAPOProcessBufferParameters, i32)

CalcInputFramesFunc :: proc "c" (rawptr, u32) -> u32

CalcOutputFramesFunc :: proc "c" (rawptr, u32) -> u32

SetParametersFunc :: proc "c" (rawptr, rawptr, u32)

GetParametersFunc :: proc "c" (rawptr, rawptr, u32)

FAPO :: struct {
	AddRef:                    AddRefFunc,
	Release:                   ReleaseFunc,
	GetRegistrationProperties: GetRegistrationPropertiesFunc,
	IsInputFormatSupported:    IsInputFormatSupportedFunc,
	IsOutputFormatSupported:   IsOutputFormatSupportedFunc,
	Initialize:                InitializeFunc,
	Reset:                     ResetFunc,
	LockForProcess:            LockForProcessFunc,
	UnlockForProcess:          UnlockForProcessFunc,
	Process:                   ProcessFunc,
	CalcInputFrames:           CalcInputFramesFunc,
	CalcOutputFrames:          CalcOutputFramesFunc,
	SetParameters:             SetParametersFunc,
	GetParameters:             GetParametersFunc,
}

