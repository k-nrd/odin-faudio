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



// FACTAPI :: FAUDIOAPI

/* Type Declarations */
FACTAudioEngine :: struct {}

FACTSoundBank :: struct {}

FACTWaveBank :: struct {}

FACTWave :: struct {}

FACTCue :: struct {}

FACTRendererDetails :: struct {
	rendererID:    [255]i16, /* Win32 wchar_t */
	displayName:   [255]i16, /* Win32 wchar_t */
	defaultDevice: i32,
}

FACTOverlapped :: struct {
	Internal:     rawptr, /* ULONG_PTR */
	InternalHigh: rawptr, /* ULONG_PTR */
	using _: struct #raw_union {
		using _: struct {
			Offset:     u32,
			OffsetHigh: u32,
		},
		Pointer: rawptr,
	},
	hEvent:       rawptr,
}

FACTReadFileCallback :: proc "c" (rawptr, rawptr, u32, ^u32, ^FACTOverlapped) -> i32

FACTGetOverlappedResultCallback :: proc "c" (rawptr, ^FACTOverlapped, ^u32, i32) -> i32

FACTFileIOCallbacks :: struct {
	readFileCallback:            FACTReadFileCallback,
	getOverlappedResultCallback: FACTGetOverlappedResultCallback,
}

FACTNotificationCallback :: proc "c" (^FACTNotification)

/* FIXME: ABI bug! This should be pack(1) explicitly. Do not memcpy this! */
FACTRuntimeParameters :: struct {
	lookAheadTime:                 u32,
	pGlobalSettingsBuffer:         rawptr,
	globalSettingsBufferSize:      u32,
	globalSettingsFlags:           u32,
	globalSettingsAllocAttributes: u32,
	fileIOCallbacks:               FACTFileIOCallbacks,
	fnNotificationCallback:        FACTNotificationCallback,
	pRendererID:                   ^i16, /* Win32 wchar_t* */
	pXAudio2:                      ^FAudio,
	pMasteringVoice:               ^FAudioMasteringVoice,
}

FACTStreamingParameters :: struct {
	file:       rawptr,
	offset:     u32,
	flags:      u32,
	packetSize: u16, /* Measured in DVD sectors, or 2048 bytes */
}

FACT_WAVEBANK_TYPE_BUFFER :: 0x00000000
FACT_WAVEBANK_TYPE_STREAMING :: 0x00000001
FACT_WAVEBANK_TYPE_MASK :: 0x00000001

FACT_WAVEBANK_FLAGS_ENTRYNAMES :: 0x00010000
FACT_WAVEBANK_FLAGS_COMPACT :: 0x00020000
FACT_WAVEBANK_FLAGS_SYNC_DISABLED :: 0x00040000
FACT_WAVEBANK_FLAGS_SEEKTABLES :: 0x00080000
FACT_WAVEBANK_FLAGS_MASK :: 0x000F0000

FACTWaveBankSegIdx :: enum c.int {
	BANKDATA = 0,
	ENTRYMETADATA,
	SEEKTABLES,
	ENTRYNAMES,
	ENTRYWAVEDATA,
	COUNT,
}

FACTWaveBankRegion :: struct {
	dwOffset: u32,
	dwLength: u32,
}

FACTWaveBankSampleRegion :: struct {
	dwStartSample:  u32,
	dwTotalSamples: u32,
}

FACTWaveBankHeader :: struct {
	dwSignature:     u32,
	dwVersion:       u32,
	dwHeaderVersion: u32,
	Segments:        [5]FACTWaveBankRegion,
}

FACTWaveBankMiniWaveFormat :: struct #raw_union {
	using _: struct {
		wFormatTag:     u32,
		nChannels:      u32,
		nSamplesPerSec: u32,
		wBlockAlign:    u32,
		wBitsPerSample: u32,
	},
	dwValue: u32,
}

FACTWaveBankEntry :: struct {
	using _: struct #raw_union {
		using _: struct {
			dwFlags:  u32,
			Duration: u32,
		},
		dwFlagsAndDuration: u32,
	},
	Format:     FACTWaveBankMiniWaveFormat,
	PlayRegion: FACTWaveBankRegion,
	LoopRegion: FACTWaveBankSampleRegion,
}

FACTWaveBankEntryCompact :: struct {
	dwOffset:          u32,
	dwLengthDeviation: u32,
}

FACTWaveBankData :: struct {
	dwFlags:                    u32,
	dwEntryCount:               u32,
	szBankName:                 [64]c.char,
	dwEntryMetaDataElementSize: u32,
	dwEntryNameElementSize:     u32,
	dwAlignment:                u32,
	CompactFormat:              FACTWaveBankMiniWaveFormat,
	BuildTime:                  u64,
}

FACTWaveProperties :: struct {
	friendlyName:      [64]c.char,
	format:            FACTWaveBankMiniWaveFormat,
	durationInSamples: u32,
	loopRegion:        FACTWaveBankSampleRegion,
	streaming:         i32,
}

FACTWaveInstanceProperties :: struct {
	properties:      FACTWaveProperties,
	backgroundMusic: i32,
}

FACTCueProperties :: struct {
	friendlyName:     [255]c.char,
	interactive:      i32,
	iaVariableIndex:  u16,
	numVariations:    u16,
	maxInstances:     u8,
	currentInstances: u8,
}

FACTTrackProperties :: struct {
	duration:      u32,
	numVariations: u16,
	numChannels:   u8,
	waveVariation: u16,
	loopCount:     u8,
}

FACTVariationProperties :: struct {
	index:         u16,
	weight:        u8,
	iaVariableMin: f32,
	iaVariableMax: f32,
	linger:        i32,
}

FACTSoundProperties :: struct {
	category:           u16,
	priority:           u8,
	pitch:              i16,
	volume:             f32,
	numTracks:          u16,
	arrTrackProperties: [1]FACTTrackProperties,
}

FACTSoundVariationProperties :: struct {
	variationProperties: FACTVariationProperties,
	soundProperties:     FACTSoundProperties,
}

FACTCueInstanceProperties :: struct {
	allocAttributes:           u32,
	cueProperties:             FACTCueProperties,
	activeVariationProperties: FACTSoundVariationProperties,
}

FACTNotificationDescription :: struct {
	type:       u8,
	flags:      u8,
	pSoundBank: ^FACTSoundBank,
	pWaveBank:  ^FACTWaveBank,
	pCue:       ^FACTCue,
	pWave:      ^FACTWave,
	cueIndex:   u16,
	waveIndex:  u16,
	pvContext:  rawptr,
}

FACTNotificationCue :: struct {
	cueIndex:   u16,
	pSoundBank: ^FACTSoundBank,
	pCue:       ^FACTCue,
}

FACTNotificationMarker :: struct {
	cueIndex:   u16,
	pSoundBank: ^FACTSoundBank,
	pCue:       ^FACTCue,
	marker:     u32,
}

FACTNotificationSoundBank :: struct {
	pSoundBank: ^FACTSoundBank,
}

FACTNotificationWaveBank :: struct {
	pWaveBank: ^FACTWaveBank,
}

FACTNotificationVariable :: struct {
	cueIndex:      u16,
	pSoundBank:    ^FACTSoundBank,
	pCue:          ^FACTCue,
	variableIndex: u16,
	variableValue: f32,
	local:         i32,
}

FACTNotificationGUI :: struct {
	reserved: u32,
}

FACTNotificationWave :: struct {
	pWaveBank:  ^FACTWaveBank,
	waveIndex:  u16,
	cueIndex:   u16,
	pSoundBank: ^FACTSoundBank,
	pCue:       ^FACTCue,
	pWave:      ^FACTWave,
}

FACTNotification :: struct {
	type:      u8,
	timeStamp: i32,
	pvContext: rawptr,
	using _: struct #raw_union {
		cue:       FACTNotificationCue,
		marker:    FACTNotificationMarker,
		soundBank: FACTNotificationSoundBank,
		waveBank:  FACTNotificationWaveBank,
		variable:  FACTNotificationVariable,
		gui:       FACTNotificationGUI,
		wave:      FACTNotificationWave,
	},
}

/* Constants */
FACT_CONTENT_VERSION :: 46

FACT_ENGINE_LOOKAHEAD_DEFAULT :: 250

FACT_MAX_WMA_AVG_BYTES_PER_SEC_ENTRIES :: 7

FACT_MAX_WMA_BLOCK_ALIGN_ENTRIES :: 17

@(default_calling_convention="c", link_prefix="")
foreign lib {
	/* AudioEngine Interface */
	FACTCreateEngine :: proc(dwCreationFlags: u32, ppEngine: ^^FACTAudioEngine) -> u32 ---

	/* See "extensions/CustomAllocatorEXT.txt" for more details. */
	FACTCreateEngineWithCustomAllocatorEXT :: proc(dwCreationFlags: u32, ppEngine: ^^FACTAudioEngine, customMalloc: FAudioMallocFunc, customFree: FAudioFreeFunc, customRealloc: FAudioReallocFunc) -> u32 ---
	FACTAudioEngine_AddRef                 :: proc(pEngine: ^FACTAudioEngine) -> u32 ---
	FACTAudioEngine_Release                :: proc(pEngine: ^FACTAudioEngine) -> u32 ---

	/* FIXME: QueryInterface? Or just ignore COM garbage... -flibit */
	FACTAudioEngine_GetRendererCount        :: proc(pEngine: ^FACTAudioEngine, pnRendererCount: ^u16) -> u32 ---
	FACTAudioEngine_GetRendererDetails      :: proc(pEngine: ^FACTAudioEngine, nRendererIndex: u16, pRendererDetails: ^FACTRendererDetails) -> u32 ---
	FACTAudioEngine_GetFinalMixFormat       :: proc(pEngine: ^FACTAudioEngine, pFinalMixFormat: ^FAudioWaveFormatExtensible) -> u32 ---
	FACTAudioEngine_Initialize              :: proc(pEngine: ^FACTAudioEngine, pParams: ^FACTRuntimeParameters) -> u32 ---
	FACTAudioEngine_ShutDown                :: proc(pEngine: ^FACTAudioEngine) -> u32 ---
	FACTAudioEngine_DoWork                  :: proc(pEngine: ^FACTAudioEngine) -> u32 ---
	FACTAudioEngine_CreateSoundBank         :: proc(pEngine: ^FACTAudioEngine, pvBuffer: rawptr, dwSize: u32, dwFlags: u32, dwAllocAttributes: u32, ppSoundBank: ^^FACTSoundBank) -> u32 ---
	FACTAudioEngine_CreateInMemoryWaveBank  :: proc(pEngine: ^FACTAudioEngine, pvBuffer: rawptr, dwSize: u32, dwFlags: u32, dwAllocAttributes: u32, ppWaveBank: ^^FACTWaveBank) -> u32 ---
	FACTAudioEngine_CreateStreamingWaveBank :: proc(pEngine: ^FACTAudioEngine, pParms: ^FACTStreamingParameters, ppWaveBank: ^^FACTWaveBank) -> u32 ---
	FACTAudioEngine_PrepareWave             :: proc(pEngine: ^FACTAudioEngine, dwFlags: u32, szWavePath: cstring, wStreamingPacketSize: u32, dwAlignment: u32, dwPlayOffset: u32, nLoopCount: u8, ppWave: ^^FACTWave) -> u32 ---
	FACTAudioEngine_PrepareInMemoryWave     :: proc(pEngine: ^FACTAudioEngine, dwFlags: u32, entry: FACTWaveBankEntry, pdwSeekTable: ^u32, pbWaveData: ^u8, dwPlayOffset: u32, nLoopCount: u8, ppWave: ^^FACTWave) -> u32 ---
	FACTAudioEngine_PrepareStreamingWave    :: proc(pEngine: ^FACTAudioEngine, dwFlags: u32, entry: FACTWaveBankEntry, streamingParams: FACTStreamingParameters, dwAlignment: u32, pdwSeekTable: ^u32, pbWaveData: ^u8, dwPlayOffset: u32, nLoopCount: u8, ppWave: ^^FACTWave) -> u32 ---
	FACTAudioEngine_RegisterNotification    :: proc(pEngine: ^FACTAudioEngine, pNotificationDescription: ^FACTNotificationDescription) -> u32 ---
	FACTAudioEngine_UnRegisterNotification  :: proc(pEngine: ^FACTAudioEngine, pNotificationDescription: ^FACTNotificationDescription) -> u32 ---
	FACTAudioEngine_GetCategory             :: proc(pEngine: ^FACTAudioEngine, szFriendlyName: cstring) -> u16 ---
	FACTAudioEngine_Stop                    :: proc(pEngine: ^FACTAudioEngine, nCategory: u16, dwFlags: u32) -> u32 ---
	FACTAudioEngine_SetVolume               :: proc(pEngine: ^FACTAudioEngine, nCategory: u16, volume: f32) -> u32 ---
	FACTAudioEngine_Pause                   :: proc(pEngine: ^FACTAudioEngine, nCategory: u16, fPause: i32) -> u32 ---
	FACTAudioEngine_GetGlobalVariableIndex  :: proc(pEngine: ^FACTAudioEngine, szFriendlyName: cstring) -> u16 ---
	FACTAudioEngine_SetGlobalVariable       :: proc(pEngine: ^FACTAudioEngine, nIndex: u16, nValue: f32) -> u32 ---
	FACTAudioEngine_GetGlobalVariable       :: proc(pEngine: ^FACTAudioEngine, nIndex: u16, pnValue: ^f32) -> u32 ---

	/* SoundBank Interface */
	FACTSoundBank_GetCueIndex      :: proc(pSoundBank: ^FACTSoundBank, szFriendlyName: cstring) -> u16 ---
	FACTSoundBank_GetNumCues       :: proc(pSoundBank: ^FACTSoundBank, pnNumCues: ^u16) -> u32 ---
	FACTSoundBank_GetCueProperties :: proc(pSoundBank: ^FACTSoundBank, nCueIndex: u16, pProperties: ^FACTCueProperties) -> u32 ---
	FACTSoundBank_Prepare          :: proc(pSoundBank: ^FACTSoundBank, nCueIndex: u16, dwFlags: u32, timeOffset: i32, ppCue: ^^FACTCue) -> u32 ---
	FACTSoundBank_Play             :: proc(pSoundBank: ^FACTSoundBank, nCueIndex: u16, dwFlags: u32, timeOffset: i32, ppCue: ^^FACTCue) -> u32 ---
	FACTSoundBank_Play3D           :: proc(pSoundBank: ^FACTSoundBank, nCueIndex: u16, dwFlags: u32, timeOffset: i32, pDSPSettings: ^F3DAUDIO_DSP_SETTINGS, ppCue: ^^FACTCue) -> u32 ---
	FACTSoundBank_Stop             :: proc(pSoundBank: ^FACTSoundBank, nCueIndex: u16, dwFlags: u32) -> u32 ---
	FACTSoundBank_Destroy          :: proc(pSoundBank: ^FACTSoundBank) -> u32 ---
	FACTSoundBank_GetState         :: proc(pSoundBank: ^FACTSoundBank, pdwState: ^u32) -> u32 ---

	/* WaveBank Interface */
	FACTWaveBank_Destroy           :: proc(pWaveBank: ^FACTWaveBank) -> u32 ---
	FACTWaveBank_GetState          :: proc(pWaveBank: ^FACTWaveBank, pdwState: ^u32) -> u32 ---
	FACTWaveBank_GetNumWaves       :: proc(pWaveBank: ^FACTWaveBank, pnNumWaves: ^u16) -> u32 ---
	FACTWaveBank_GetWaveIndex      :: proc(pWaveBank: ^FACTWaveBank, szFriendlyName: cstring) -> u16 ---
	FACTWaveBank_GetWaveProperties :: proc(pWaveBank: ^FACTWaveBank, nWaveIndex: u16, pWaveProperties: ^FACTWaveProperties) -> u32 ---
	FACTWaveBank_Prepare           :: proc(pWaveBank: ^FACTWaveBank, nWaveIndex: u16, dwFlags: u32, dwPlayOffset: u32, nLoopCount: u8, ppWave: ^^FACTWave) -> u32 ---
	FACTWaveBank_Play              :: proc(pWaveBank: ^FACTWaveBank, nWaveIndex: u16, dwFlags: u32, dwPlayOffset: u32, nLoopCount: u8, ppWave: ^^FACTWave) -> u32 ---
	FACTWaveBank_Stop              :: proc(pWaveBank: ^FACTWaveBank, nWaveIndex: u16, dwFlags: u32) -> u32 ---

	/* Wave Interface */
	FACTWave_Destroy               :: proc(pWave: ^FACTWave) -> u32 ---
	FACTWave_Play                  :: proc(pWave: ^FACTWave) -> u32 ---
	FACTWave_Stop                  :: proc(pWave: ^FACTWave, dwFlags: u32) -> u32 ---
	FACTWave_Pause                 :: proc(pWave: ^FACTWave, fPause: i32) -> u32 ---
	FACTWave_GetState              :: proc(pWave: ^FACTWave, pdwState: ^u32) -> u32 ---
	FACTWave_SetPitch              :: proc(pWave: ^FACTWave, pitch: i16) -> u32 ---
	FACTWave_SetVolume             :: proc(pWave: ^FACTWave, volume: f32) -> u32 ---
	FACTWave_SetMatrixCoefficients :: proc(pWave: ^FACTWave, uSrcChannelCount: u32, uDstChannelCount: u32, pMatrixCoefficients: ^f32) -> u32 ---
	FACTWave_GetProperties         :: proc(pWave: ^FACTWave, pProperties: ^FACTWaveInstanceProperties) -> u32 ---

	/* Cue Interface */
	FACTCue_Destroy               :: proc(pCue: ^FACTCue) -> u32 ---
	FACTCue_Play                  :: proc(pCue: ^FACTCue) -> u32 ---
	FACTCue_Stop                  :: proc(pCue: ^FACTCue, dwFlags: u32) -> u32 ---
	FACTCue_GetState              :: proc(pCue: ^FACTCue, pdwState: ^u32) -> u32 ---
	FACTCue_SetMatrixCoefficients :: proc(pCue: ^FACTCue, uSrcChannelCount: u32, uDstChannelCount: u32, pMatrixCoefficients: ^f32) -> u32 ---
	FACTCue_GetVariableIndex      :: proc(pCue: ^FACTCue, szFriendlyName: cstring) -> u16 ---
	FACTCue_SetVariable           :: proc(pCue: ^FACTCue, nIndex: u16, nValue: f32) -> u32 ---
	FACTCue_GetVariable           :: proc(pCue: ^FACTCue, nIndex: u16, nValue: ^f32) -> u32 ---
	FACTCue_Pause                 :: proc(pCue: ^FACTCue, fPause: i32) -> u32 ---
	FACTCue_GetProperties         :: proc(pCue: ^FACTCue, ppProperties: ^^FACTCueInstanceProperties) -> u32 ---
	FACTCue_SetOutputVoices       :: proc(pCue: ^FACTCue, pSendList: ^FAudioVoiceSends) -> u32 ---
	FACTCue_SetOutputVoiceMatrix  :: proc(pCue: ^FACTCue, pDestinationVoice: ^FAudioVoice, SourceChannels: u32, DestinationChannels: u32, pLevelMatrix: ^f32) -> u32 ---
}
