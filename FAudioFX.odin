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
* https://docs.microsoft.com/en-us/windows/desktop/api/xaudio2fx/
*
* Note, however, that FAudio's Reverb implementation does NOT support the new
* parameters for XAudio 2.9's 7.1 Reverb effect!
*/
package faudio

import "core:c"

_ :: c



FAudioFXVolumeMeterLevels :: struct {
	pPeakLevels:  ^f32,
	pRMSLevels:   ^f32,
	ChannelCount: u32,
}

FAudioFXCollectorState :: struct {
	WriteOffset: u32,
}

FAudioFXReverbParameters :: struct {
	WetDryMix:           f32,
	ReflectionsDelay:    u32,
	ReverbDelay:         u8,
	RearDelay:           u8,
	PositionLeft:        u8,
	PositionRight:       u8,
	PositionMatrixLeft:  u8,
	PositionMatrixRight: u8,
	EarlyDiffusion:      u8,
	LateDiffusion:       u8,
	LowEQGain:           u8,
	LowEQCutoff:         u8,
	HighEQGain:          u8,
	HighEQCutoff:        u8,
	RoomFilterFreq:      f32,
	RoomFilterMain:      f32,
	RoomFilterHF:        f32,
	ReflectionsGain:     f32,
	ReverbGain:          f32,
	DecayTime:           f32,
	Density:             f32,
	RoomSize:            f32,
}

FAudioFXReverbParameters9 :: struct {
	WetDryMix:           f32,
	ReflectionsDelay:    u32,
	ReverbDelay:         u8,
	RearDelay:           u8,
	SideDelay:           u8,
	PositionLeft:        u8,
	PositionRight:       u8,
	PositionMatrixLeft:  u8,
	PositionMatrixRight: u8,
	EarlyDiffusion:      u8,
	LateDiffusion:       u8,
	LowEQGain:           u8,
	LowEQCutoff:         u8,
	HighEQGain:          u8,
	HighEQCutoff:        u8,
	RoomFilterFreq:      f32,
	RoomFilterMain:      f32,
	RoomFilterHF:        f32,
	ReflectionsGain:     f32,
	ReverbGain:          f32,
	DecayTime:           f32,
	Density:             f32,
	RoomSize:            f32,
}

FAudioFXReverbI3DL2Parameters :: struct {
	WetDryMix:         f32,
	Room:              i32,
	RoomHF:            i32,
	RoomRolloffFactor: f32,
	DecayTime:         f32,
	DecayHFRatio:      f32,
	Reflections:       i32,
	ReflectionsDelay:  f32,
	Reverb:            i32,
	ReverbDelay:       f32,
	Diffusion:         f32,
	Density:           f32,
	HFReference:       f32,
}

/* Constants */
FAUDIOFX_DEBUG :: 1

FAUDIOFX_REVERB_MIN_FRAMERATE :: 20000
FAUDIOFX_REVERB_MAX_FRAMERATE :: 48000

FAUDIOFX_REVERB_MIN_WET_DRY_MIX :: 0.0
FAUDIOFX_REVERB_MIN_REFLECTIONS_DELAY :: 0
FAUDIOFX_REVERB_MIN_REVERB_DELAY :: 0
FAUDIOFX_REVERB_MIN_REAR_DELAY :: 0
FAUDIOFX_REVERB_MIN_7POINT1_SIDE_DELAY :: 0
FAUDIOFX_REVERB_MIN_7POINT1_REAR_DELAY :: 0
FAUDIOFX_REVERB_MIN_POSITION :: 0
FAUDIOFX_REVERB_MIN_DIFFUSION :: 0
FAUDIOFX_REVERB_MIN_LOW_EQ_GAIN :: 0
FAUDIOFX_REVERB_MIN_LOW_EQ_CUTOFF :: 0
FAUDIOFX_REVERB_MIN_HIGH_EQ_GAIN :: 0
FAUDIOFX_REVERB_MIN_HIGH_EQ_CUTOFF :: 0
FAUDIOFX_REVERB_MIN_ROOM_FILTER_FREQ :: 20.0
FAUDIOFX_REVERB_MIN_ROOM_FILTER_MAIN :: -100.0
FAUDIOFX_REVERB_MIN_ROOM_FILTER_HF :: -100.0
FAUDIOFX_REVERB_MIN_REFLECTIONS_GAIN :: -100.0
FAUDIOFX_REVERB_MIN_REVERB_GAIN :: -100.0
FAUDIOFX_REVERB_MIN_DECAY_TIME :: 0.1
FAUDIOFX_REVERB_MIN_DENSITY :: 0.0
FAUDIOFX_REVERB_MIN_ROOM_SIZE :: 0.0

FAUDIOFX_REVERB_MAX_WET_DRY_MIX :: 100.0
FAUDIOFX_REVERB_MAX_REFLECTIONS_DELAY :: 300
FAUDIOFX_REVERB_MAX_REVERB_DELAY :: 85
FAUDIOFX_REVERB_MAX_REAR_DELAY :: 5
FAUDIOFX_REVERB_MAX_7POINT1_SIDE_DELAY :: 5
FAUDIOFX_REVERB_MAX_7POINT1_REAR_DELAY :: 20
FAUDIOFX_REVERB_MAX_POSITION :: 30
FAUDIOFX_REVERB_MAX_DIFFUSION :: 15
FAUDIOFX_REVERB_MAX_LOW_EQ_GAIN :: 12
FAUDIOFX_REVERB_MAX_LOW_EQ_CUTOFF :: 9
FAUDIOFX_REVERB_MAX_HIGH_EQ_GAIN :: 8
FAUDIOFX_REVERB_MAX_HIGH_EQ_CUTOFF :: 14
FAUDIOFX_REVERB_MAX_ROOM_FILTER_FREQ :: 20000.0
FAUDIOFX_REVERB_MAX_ROOM_FILTER_MAIN :: 0.0
FAUDIOFX_REVERB_MAX_ROOM_FILTER_HF :: 0.0
FAUDIOFX_REVERB_MAX_REFLECTIONS_GAIN :: 20.0
FAUDIOFX_REVERB_MAX_REVERB_GAIN :: 20.0
FAUDIOFX_REVERB_MAX_DENSITY :: 100.0
FAUDIOFX_REVERB_MAX_ROOM_SIZE :: 100.0

FAUDIOFX_REVERB_DEFAULT_WET_DRY_MIX :: 100.0
FAUDIOFX_REVERB_DEFAULT_REFLECTIONS_DELAY :: 5
FAUDIOFX_REVERB_DEFAULT_REVERB_DELAY :: 5
FAUDIOFX_REVERB_DEFAULT_REAR_DELAY :: 5
FAUDIOFX_REVERB_DEFAULT_7POINT1_SIDE_DELAY :: 5
FAUDIOFX_REVERB_DEFAULT_7POINT1_REAR_DELAY :: 20
FAUDIOFX_REVERB_DEFAULT_POSITION :: 6
FAUDIOFX_REVERB_DEFAULT_POSITION_MATRIX :: 27
FAUDIOFX_REVERB_DEFAULT_EARLY_DIFFUSION :: 8
FAUDIOFX_REVERB_DEFAULT_LATE_DIFFUSION :: 8
FAUDIOFX_REVERB_DEFAULT_LOW_EQ_GAIN :: 8
FAUDIOFX_REVERB_DEFAULT_LOW_EQ_CUTOFF :: 4
FAUDIOFX_REVERB_DEFAULT_HIGH_EQ_GAIN :: 8
FAUDIOFX_REVERB_DEFAULT_HIGH_EQ_CUTOFF :: 4
FAUDIOFX_REVERB_DEFAULT_ROOM_FILTER_FREQ :: 5000.0
FAUDIOFX_REVERB_DEFAULT_ROOM_FILTER_MAIN :: 0.0
FAUDIOFX_REVERB_DEFAULT_ROOM_FILTER_HF :: 0.0
FAUDIOFX_REVERB_DEFAULT_REFLECTIONS_GAIN :: 0.0
FAUDIOFX_REVERB_DEFAULT_REVERB_GAIN :: 0.0
FAUDIOFX_REVERB_DEFAULT_DECAY_TIME :: 1.0
FAUDIOFX_REVERB_DEFAULT_DENSITY :: 100.0
FAUDIOFX_REVERB_DEFAULT_ROOM_SIZE :: 100.0

FAUDIOFX_I3DL2_PRESET_DEFAULT :: {100,-10000, 0,0.0, 1.00,0.50,-10000,0.020,-10000,0.040,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_GENERIC :: {100, -1000, -100,0.0, 1.49,0.83, -2602,0.007, 200,0.011,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_PADDEDCELL :: {100, -1000,-6000,0.0, 0.17,0.10, -1204,0.001, 207,0.002,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_ROOM :: {100, -1000, -454,0.0, 0.40,0.83, -1646,0.002, 53,0.003,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_BATHROOM :: {100, -1000,-1200,0.0, 1.49,0.54, -370,0.007, 1030,0.011,100.0, 60.0,5000.0}

FAUDIOFX_I3DL2_PRESET_LIVINGROOM :: {100, -1000,-6000,0.0, 0.50,0.10, -1376,0.003, -1104,0.004,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_STONEROOM :: {100, -1000, -300,0.0, 2.31,0.64, -711,0.012, 83,0.017,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_AUDITORIUM :: {100, -1000, -476,0.0, 4.32,0.59, -789,0.020, -289,0.030,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_CONCERTHALL :: {100, -1000, -500,0.0, 3.92,0.70, -1230,0.020, -2,0.029,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_CAVE :: {100, -1000, 0,0.0, 2.91,1.30, -602,0.015, -302,0.022,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_ARENA :: {100, -1000, -698,0.0, 7.24,0.33, -1166,0.020, 16,0.030,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_HANGAR :: {100, -1000,-1000,0.0,10.05,0.23, -602,0.020, 198,0.030,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_CARPETEDHALLWAY :: {100, -1000,-4000,0.0, 0.30,0.10, -1831,0.002, -1630,0.030,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_HALLWAY :: {100, -1000, -300,0.0, 1.49,0.59, -1219,0.007, 441,0.011,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_STONECORRIDOR :: {100, -1000, -237,0.0, 2.70,0.79, -1214,0.013, 395,0.020,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_ALLEY :: {100, -1000, -270,0.0, 1.49,0.86, -1204,0.007, -4,0.011,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_FOREST :: {100, -1000,-3300,0.0, 1.49,0.54, -2560,0.162, -613,0.088, 79.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_CITY :: {100, -1000, -800,0.0, 1.49,0.67, -2273,0.007, -2217,0.011, 50.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_MOUNTAINS :: {100, -1000,-2500,0.0, 1.49,0.21, -2780,0.300, -2014,0.100, 27.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_QUARRY :: {100, -1000,-1000,0.0, 1.49,0.83,-10000,0.061, 500,0.025,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_PLAIN :: {100, -1000,-2000,0.0, 1.49,0.50, -2466,0.179, -2514,0.100, 21.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_PARKINGLOT :: {100, -1000, 0,0.0, 1.65,1.50, -1363,0.008, -1153,0.012,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_SEWERPIPE :: {100, -1000,-1000,0.0, 2.81,0.14, 429,0.014, 648,0.021, 80.0, 60.0,5000.0}

FAUDIOFX_I3DL2_PRESET_UNDERWATER :: {100, -1000,-4000,0.0, 1.49,0.10, -449,0.007, 1700,0.011,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_SMALLROOM :: {100, -1000, -600,0.0, 1.10,0.83, -400,0.005, 500,0.010,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_MEDIUMROOM :: {100, -1000, -600,0.0, 1.30,0.83, -1000,0.010, -200,0.020,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_LARGEROOM :: {100, -1000, -600,0.0, 1.50,0.83, -1600,0.020, -1000,0.040,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_MEDIUMHALL :: {100, -1000, -600,0.0, 1.80,0.70, -1300,0.015, -800,0.030,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_LARGEHALL :: {100, -1000, -600,0.0, 1.80,0.70, -2000,0.030, -1400,0.060,100.0,100.0,5000.0}

FAUDIOFX_I3DL2_PRESET_PLATE :: {100, -1000, -200,0.0, 1.30,0.90, 0,0.002, 0,0.010,100.0, 75.0,5000.0}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/* Functions */
	FAudioCreateCollectorEXT :: proc(ppApo: ^^FAPO, Flags: u32, pBuffer: ^f32, bufferLength: u32) -> u32 ---
	FAudioCreateVolumeMeter  :: proc(ppApo: ^^FAPO, Flags: u32) -> u32 ---
	FAudioCreateReverb       :: proc(ppApo: ^^FAPO, Flags: u32) -> u32 ---
	FAudioCreateReverb9      :: proc(ppApo: ^^FAPO, Flags: u32) -> u32 ---

	/* See "extensions/CustomAllocatorEXT.txt" for more information. */
	FAudioCreateCollectorWithCustomAllocatorEXT   :: proc(ppApo: ^^FAPO, Flags: u32, pBuffer: ^f32, bufferLength: u32, customMalloc: FAudioMallocFunc, customFree: FAudioFreeFunc, customRealloc: FAudioReallocFunc) -> u32 ---
	FAudioCreateVolumeMeterWithCustomAllocatorEXT :: proc(ppApo: ^^FAPO, Flags: u32, customMalloc: FAudioMallocFunc, customFree: FAudioFreeFunc, customRealloc: FAudioReallocFunc) -> u32 ---
	FAudioCreateReverbWithCustomAllocatorEXT      :: proc(ppApo: ^^FAPO, Flags: u32, customMalloc: FAudioMallocFunc, customFree: FAudioFreeFunc, customRealloc: FAudioReallocFunc) -> u32 ---
	FAudioCreateReverb9WithCustomAllocatorEXT     :: proc(ppApo: ^^FAPO, Flags: u32, customMalloc: FAudioMallocFunc, customFree: FAudioFreeFunc, customRealloc: FAudioReallocFunc) -> u32 ---
	ReverbConvertI3DL2ToNative                    :: proc(pI3DL2: ^FAudioFXReverbI3DL2Parameters, pNative: ^FAudioFXReverbParameters) ---
	ReverbConvertI3DL2ToNative9                   :: proc(pI3DL2: ^FAudioFXReverbI3DL2Parameters, pNative: ^FAudioFXReverbParameters9, sevenDotOneReverb: i32) ---
}
