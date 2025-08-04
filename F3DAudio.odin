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
* https://docs.microsoft.com/en-us/windows/desktop/api/x3daudio/
*/
package faudio

import "core:c"

_ :: c



SPEAKER_FRONT_LEFT :: 0x00000001
SPEAKER_FRONT_RIGHT :: 0x00000002
SPEAKER_FRONT_CENTER :: 0x00000004
SPEAKER_LOW_FREQUENCY :: 0x00000008
SPEAKER_BACK_LEFT :: 0x00000010
SPEAKER_BACK_RIGHT :: 0x00000020
SPEAKER_FRONT_LEFT_OF_CENTER :: 0x00000040
SPEAKER_FRONT_RIGHT_OF_CENTER :: 0x00000080
SPEAKER_BACK_CENTER :: 0x00000100
SPEAKER_SIDE_LEFT :: 0x00000200
SPEAKER_SIDE_RIGHT :: 0x00000400
SPEAKER_TOP_CENTER :: 0x00000800
SPEAKER_TOP_FRONT_LEFT :: 0x00001000
SPEAKER_TOP_FRONT_CENTER :: 0x00002000
SPEAKER_TOP_FRONT_RIGHT :: 0x00004000
SPEAKER_TOP_BACK_LEFT :: 0x00008000
SPEAKER_TOP_BACK_CENTER :: 0x00010000
SPEAKER_TOP_BACK_RIGHT :: 0x00020000

SPEAKER_MONO :: SPEAKER_FRONT_CENTER

SPEAKER_2POINT1 :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_LOW_FREQUENCY

SPEAKER_SURROUND :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_FRONT_CENTER | SPEAKER_BACK_CENTER

SPEAKER_QUAD :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_BACK_LEFT | SPEAKER_BACK_RIGHT

SPEAKER_4POINT1 :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_LOW_FREQUENCY | SPEAKER_BACK_LEFT | SPEAKER_BACK_RIGHT

SPEAKER_5POINT1 :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY | SPEAKER_BACK_LEFT | SPEAKER_BACK_RIGHT

SPEAKER_7POINT1 :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY | SPEAKER_BACK_LEFT | SPEAKER_BACK_RIGHT | SPEAKER_FRONT_LEFT_OF_CENTER | SPEAKER_FRONT_RIGHT_OF_CENTER

SPEAKER_5POINT1_SURROUND :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY | SPEAKER_SIDE_LEFT | SPEAKER_SIDE_RIGHT

SPEAKER_7POINT1_SURROUND :: SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT | SPEAKER_FRONT_CENTER | SPEAKER_LOW_FREQUENCY | SPEAKER_BACK_LEFT | SPEAKER_BACK_RIGHT | SPEAKER_SIDE_LEFT | SPEAKER_SIDE_RIGHT

SPEAKER_XBOX :: SPEAKER_5POINT1

F3DAUDIO_PI :: 3.141592654
F3DAUDIO_2PI :: 6.283185307

F3DAUDIO_CALCULATE_MATRIX :: 0x00000001
F3DAUDIO_CALCULATE_DELAY :: 0x00000002
F3DAUDIO_CALCULATE_LPF_DIRECT :: 0x00000004
F3DAUDIO_CALCULATE_LPF_REVERB :: 0x00000008
F3DAUDIO_CALCULATE_REVERB :: 0x00000010
F3DAUDIO_CALCULATE_DOPPLER :: 0x00000020
F3DAUDIO_CALCULATE_EMITTER_ANGLE :: 0x00000040
F3DAUDIO_CALCULATE_ZEROCENTER :: 0x00010000
F3DAUDIO_CALCULATE_REDIRECT_TO_LFE :: 0x00020000

/* Type Declarations */
F3DAUDIO_HANDLE_BYTESIZE :: 20

F3DAUDIO_HANDLE :: [20]u8

F3DAUDIO_VECTOR :: struct {
	x: f32,
	y: f32,
	z: f32,
}

F3DAUDIO_DISTANCE_CURVE_POINT :: struct {
	Distance:   f32,
	DSPSetting: f32,
}

F3DAUDIO_DISTANCE_CURVE :: struct {
	pPoints:    ^F3DAUDIO_DISTANCE_CURVE_POINT,
	PointCount: u32,
}

F3DAUDIO_CONE :: struct {
	InnerAngle:  f32,
	OuterAngle:  f32,
	InnerVolume: f32,
	OuterVolume: f32,
	InnerLPF:    f32,
	OuterLPF:    f32,
	InnerReverb: f32,
	OuterReverb: f32,
}

F3DAUDIO_LISTENER :: struct {
	OrientFront: F3DAUDIO_VECTOR,
	OrientTop:   F3DAUDIO_VECTOR,
	Position:    F3DAUDIO_VECTOR,
	Velocity:    F3DAUDIO_VECTOR,
	pCone:       ^F3DAUDIO_CONE,
}

F3DAUDIO_EMITTER :: struct {
	pCone:               ^F3DAUDIO_CONE,
	OrientFront:         F3DAUDIO_VECTOR,
	OrientTop:           F3DAUDIO_VECTOR,
	Position:            F3DAUDIO_VECTOR,
	Velocity:            F3DAUDIO_VECTOR,
	InnerRadius:         f32,
	InnerRadiusAngle:    f32,
	ChannelCount:        u32,
	ChannelRadius:       f32,
	pChannelAzimuths:    ^f32,
	pVolumeCurve:        ^F3DAUDIO_DISTANCE_CURVE,
	pLFECurve:           ^F3DAUDIO_DISTANCE_CURVE,
	pLPFDirectCurve:     ^F3DAUDIO_DISTANCE_CURVE,
	pLPFReverbCurve:     ^F3DAUDIO_DISTANCE_CURVE,
	pReverbCurve:        ^F3DAUDIO_DISTANCE_CURVE,
	CurveDistanceScaler: f32,
	DopplerScaler:       f32,
}

F3DAUDIO_DSP_SETTINGS :: struct {
	pMatrixCoefficients:       ^f32,
	pDelayTimes:               ^f32,
	SrcChannelCount:           u32,
	DstChannelCount:           u32,
	LPFDirectCoefficient:      f32,
	LPFReverbCoefficient:      f32,
	ReverbLevel:               f32,
	DopplerFactor:             f32,
	EmitterToListenerAngle:    f32,
	EmitterToListenerDistance: f32,
	EmitterVelocityComponent:  f32,
	ListenerVelocityComponent: f32,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/* Functions */
	F3DAudioInitialize  :: proc(SpeakerChannelMask: u32, SpeedOfSound: f32, Instance: ^u8) ---
	F3DAudioInitialize8 :: proc(SpeakerChannelMask: u32, SpeedOfSound: f32, Instance: ^u8) -> u32 ---
	F3DAudioCalculate   :: proc(Instance: ^u8, pListener: ^F3DAUDIO_LISTENER, pEmitter: ^F3DAUDIO_EMITTER, Flags: u32, pDSPSettings: ^F3DAUDIO_DSP_SETTINGS) ---
}
