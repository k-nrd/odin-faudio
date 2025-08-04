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



// FAUDIONAMELESS :: _extension__

/* Type Declarations */
FAudio :: struct {}

FAudioVoice :: struct {}

FAudioSourceVoice :: struct {}

FAudioSubmixVoice :: struct {}

FAudioMasteringVoice :: struct {}

/* Enumerations */
FAudioDeviceRole :: enum c.int {
	NotDefaultDevice            = 0,
	DefaultConsoleDevice        = 1,
	DefaultMultimediaDevice     = 2,
	DefaultCommunicationsDevice = 4,
	DefaultGameDevice           = 8,
	GlobalDefaultDevice         = 15,
	InvalidDeviceRole           = -16,
}

FAudioFilterType :: enum c.int {
	LowPassFilter,
	BandPassFilter,
	HighPassFilter,
	NotchFilter,
}

FAudioStreamCategory :: enum c.int {
	Other,
	ForegroundOnlyMedia,
	BackgroundCapableMedia,
	Communications,
	Alerts,
	SoundEffects,
	GameEffects,
	GameMedia,
	GameChat,
	Speech,
	Movie,
	Media,
}

FAUDIO_DEFAULT_PROCESSOR :: 0xFFFFFFFF

/* FIXME: The original enum violates ISO C and is platform specific anyway... */
FAudioProcessor :: u32

FAudioGUID :: struct {
	Data1: u32,
	Data2: u16,
	Data3: u16,
	Data4: [8]u8,
}

/* See MSDN:
* https://msdn.microsoft.com/en-us/library/windows/desktop/dd390970%28v=vs.85%29.aspx
*/
FAudioWaveFormatEx :: struct {
	wFormatTag:      u16,
	nChannels:       u16,
	nSamplesPerSec:  u32,
	nAvgBytesPerSec: u32,
	nBlockAlign:     u16,
	wBitsPerSample:  u16,
	cbSize:          u16,
}

/* See MSDN:
* https://msdn.microsoft.com/en-us/library/windows/desktop/dd390971(v=vs.85).aspx
*/
FAudioWaveFormatExtensible :: struct {
	Format:        FAudioWaveFormatEx,
	Samples:       struct #raw_union {
		wValidBitsPerSample: u16,
		wSamplesPerBlock:    u16,
		wReserved:           u16,
	},
	dwChannelMask: u32,
	SubFormat:     FAudioGUID,
}

FAudioADPCMCoefSet :: struct {
	iCoef1: i16,
	iCoef2: i16,
}

FAudioADPCMWaveFormat :: struct {
	wfx:              FAudioWaveFormatEx,
	wSamplesPerBlock: u16,
	wNumCoef:         u16,
	aCoef:            []FAudioADPCMCoefSet,
}

FAudioDeviceDetails :: struct {
	DeviceID:     [256]i16, /* Win32 wchar_t */
	DisplayName:  [256]i16, /* Win32 wchar_t */
	Role:         FAudioDeviceRole,
	OutputFormat: FAudioWaveFormatExtensible,
}

FAudioVoiceDetails :: struct {
	CreationFlags:   u32,
	ActiveFlags:     u32,
	InputChannels:   u32,
	InputSampleRate: u32,
}

FAudioSendDescriptor :: struct {
	Flags:        u32, /* 0 or FAUDIO_SEND_USEFILTER */
	pOutputVoice: ^FAudioVoice,
}

FAudioVoiceSends :: struct {
	SendCount: u32,
	pSends:    ^FAudioSendDescriptor,
}

FAudioEffectDescriptor :: struct {
	pEffect:        ^FAPO,
	InitialState:   i32, /* 1 - Enabled, 0 - Disabled */
	OutputChannels: u32,
}

FAudioEffectChain :: struct {
	EffectCount:        u32,
	pEffectDescriptors: ^FAudioEffectDescriptor,
}

FAudioFilterParameters :: struct {
	Type:      FAudioFilterType,
	Frequency: f32, /* [0, FAUDIO_MAX_FILTER_FREQUENCY] */
	OneOverQ:  f32, /* [0, FAUDIO_MAX_FILTER_ONEOVERQ] */
}

FAudioFilterParametersEXT :: struct {
	Type:      FAudioFilterType,
	Frequency: f32, /* [0, FAUDIO_MAX_FILTER_FREQUENCY] */
	OneOverQ:  f32, /* [0, FAUDIO_MAX_FILTER_ONEOVERQ] */
	WetDryMix: f32, /* [0, 1] */
}

FAudioBuffer :: struct {
	/* Either 0 or FAUDIO_END_OF_STREAM */
	Flags: u32,

	/* Pointer to wave data, memory block size.
	* Note that pAudioData is not copied; FAudio reads directly from your
	* pointer! This pointer must be valid until FAudio has finished using
	* it, at which point an OnBufferEnd callback will be generated.
	*/
	AudioBytes: u32,
	pAudioData: ^u8,

	/* Play region, in sample frames. */
	PlayBegin: u32,
	PlayLength: u32,

	/* Loop region, in sample frames.
	* This can be used to loop a subregion of the wave instead of looping
	* the whole thing, i.e. if you have an intro/outro you can set these
	* to loop the middle sections instead. If you don't need this, set both
	* values to 0.
	*/
	LoopBegin: u32,
	LoopLength: u32,

	/* [0, FAUDIO_LOOP_INFINITE] */
	LoopCount: u32,

	/* This is sent to callbacks as pBufferContext */
	pContext: rawptr,
}

FAudioBufferWMA :: struct {
	pDecodedPacketCumulativeBytes: ^u32,
	PacketCount:                   u32,
}

FAudioVoiceState :: struct {
	pCurrentBufferContext: rawptr,
	BuffersQueued:         u32,
	SamplesPlayed:         u64,
}

FAudioPerformanceData :: struct {
	AudioCyclesSinceLastQuery:  u64,
	TotalCyclesSinceLastQuery:  u64,
	MinimumCyclesPerQuantum:    u32,
	MaximumCyclesPerQuantum:    u32,
	MemoryUsageInBytes:         u32,
	CurrentLatencyInSamples:    u32,
	GlitchesSinceEngineStarted: u32,
	ActiveSourceVoiceCount:     u32,
	TotalSourceVoiceCount:      u32,
	ActiveSubmixVoiceCount:     u32,
	ActiveResamplerCount:       u32,
	ActiveMatrixMixCount:       u32,
	ActiveXmaSourceVoices:      u32,
	ActiveXmaStreams:           u32,
}

FAudioDebugConfiguration :: struct {
	/* See FAUDIO_LOG_* */
	TraceMask: u32,
	BreakMask:       u32,

	/* 0 or 1 */
	LogThreadID: i32,
	LogFileline:     i32,
	LogFunctionName: i32,
	LogTiming:       i32,
}

/* This ISN'T packed. Strictly speaking it wouldn't have mattered anyway but eh.
* See https://github.com/microsoft/DirectXTK/issues/256
*/
FAudioXMA2WaveFormat :: struct {
	wfx:              FAudioWaveFormatEx,
	wNumStreams:      u16,
	dwChannelMask:    u32,
	dwSamplesEncoded: u32,
	dwBytesPerBlock:  u32,
	dwPlayBegin:      u32,
	dwPlayLength:     u32,
	dwLoopBegin:      u32,
	dwLoopLength:     u32,
	bLoopCount:       u8,
	bEncoderVersion:  u8,
	wBlockCount:      u16,
}

/* Constants */
FAUDIO_E_OUT_OF_MEMORY :: 0x8007000e
FAUDIO_E_INVALID_ARG :: 0x80070057
FAUDIO_E_UNSUPPORTED_FORMAT :: 0x88890008
FAUDIO_E_INVALID_CALL :: 0x88960001
FAUDIO_E_DEVICE_INVALIDATED :: 0x88960004
FAPO_E_FORMAT_UNSUPPORTED :: 0x88970001

FAUDIO_MAX_BUFFER_BYTES :: 0x80000000
FAUDIO_MAX_QUEUED_BUFFERS :: 64
FAUDIO_MAX_AUDIO_CHANNELS :: 64
FAUDIO_MIN_SAMPLE_RATE :: 1000
FAUDIO_MAX_SAMPLE_RATE :: 200000
FAUDIO_MAX_VOLUME_LEVEL :: 16777216.0

FAUDIO_MAX_FREQ_RATIO :: 1024.0
FAUDIO_DEFAULT_FREQ_RATIO :: 2.0
FAUDIO_MAX_FILTER_ONEOVERQ :: 1.5
FAUDIO_MAX_FILTER_FREQUENCY :: 1.0
FAUDIO_MAX_LOOP_COUNT :: 254

FAUDIO_COMMIT_NOW :: 0
FAUDIO_COMMIT_ALL :: 0

FAUDIO_NO_LOOP_REGION :: 0
FAUDIO_LOOP_INFINITE :: 255
FAUDIO_DEFAULT_CHANNELS :: 0
FAUDIO_DEFAULT_SAMPLERATE :: 0

FAUDIO_DEBUG_ENGINE :: 0x0001
FAUDIO_VOICE_NOPITCH :: 0x0002
FAUDIO_VOICE_NOSRC :: 0x0004
FAUDIO_VOICE_USEFILTER :: 0x0008
FAUDIO_VOICE_MUSIC :: 0x0010
FAUDIO_PLAY_TAILS :: 0x0020
FAUDIO_END_OF_STREAM :: 0x0040
FAUDIO_SEND_USEFILTER :: 0x0080
FAUDIO_VOICE_NOSAMPLESPLAYED :: 0x0100
FAUDIO_1024_QUANTUM :: 0x8000

// FAUDIO_DEFAULT_FILTER_TYPE :: FAudioLowPassFilter
FAUDIO_DEFAULT_FILTER_FREQUENCY :: FAUDIO_MAX_FILTER_FREQUENCY
FAUDIO_DEFAULT_FILTER_ONEOVERQ :: 1.0
FAUDIO_DEFAULT_FILTER_WETDRYMIX_EXT :: 1.0

FAUDIO_LOG_ERRORS :: 0x0001
FAUDIO_LOG_WARNINGS :: 0x0002
FAUDIO_LOG_INFO :: 0x0004
FAUDIO_LOG_DETAIL :: 0x0008
FAUDIO_LOG_API_CALLS :: 0x0010
FAUDIO_LOG_FUNC_CALLS :: 0x0020
FAUDIO_LOG_TIMING :: 0x0040
FAUDIO_LOG_LOCKS :: 0x0080
FAUDIO_LOG_MEMORY :: 0x0100
FAUDIO_LOG_STREAMING :: 0x1000

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

FAUDIO_FORMAT_PCM :: 1
FAUDIO_FORMAT_MSADPCM :: 2
FAUDIO_FORMAT_IEEE_FLOAT :: 3
FAUDIO_FORMAT_WMAUDIO2 :: 0x0161
FAUDIO_FORMAT_WMAUDIO3 :: 0x0162
FAUDIO_FORMAT_WMAUDIO_LOSSLESS :: 0x0163
FAUDIO_FORMAT_XMAUDIO2 :: 0x0166
FAUDIO_FORMAT_EXTENSIBLE :: 0xFFFE

/* FAudio Version API */
FAUDIO_TARGET_VERSION :: 8 /* Targeting compatibility with XAudio 2.8 */

FAUDIO_MAJOR_VERSION :: 25

// FAUDIO_COMPILED_VERSION :: (FAUDIO_ABI_VERSION * 100 * 100 * 100) + (FAUDIO_MAJOR_VERSION * 100 * 100) + (FAUDIO_MINOR_VERSION * 100) + (FAUDIO_PATCH_VERSION)

/* If something horrible happens, this will be called.
*
* Error: The error code that spawned this callback.
*/
OnCriticalErrorFunc :: proc "c" (^FAudioEngineCallback, u32)

/* This is called at the end of a processing update. */
OnProcessingPassEndFunc :: proc "c" (^FAudioEngineCallback)

/* This is called at the beginning of a processing update. */
OnProcessingPassStartFunc :: proc "c" (^FAudioEngineCallback)

FAudioEngineCallback :: struct {
	OnCriticalError:       OnCriticalErrorFunc,
	OnProcessingPassEnd:   OnProcessingPassEndFunc,
	OnProcessingPassStart: OnProcessingPassStartFunc,
}

/* When a buffer is no longer in use, this is called.
*
* pBufferContext: The pContext for the FAudioBuffer in question.
*/
OnBufferEndFunc :: proc "c" (^FAudioVoiceCallback, rawptr)

/* When a buffer is now being used, this is called.
*
* pBufferContext: The pContext for the FAudioBuffer in question.
*/
OnBufferStartFunc :: proc "c" (^FAudioVoiceCallback, rawptr)

/* When a buffer completes a loop, this is called.
*
* pBufferContext: The pContext for the FAudioBuffer in question.
*/
OnLoopEndFunc :: proc "c" (^FAudioVoiceCallback, rawptr)

/* When a buffer that has the END_OF_STREAM flag is finished, this is called. */
OnStreamEndFunc :: proc "c" (^FAudioVoiceCallback)

/* If something horrible happens to a voice, this is called.
*
* pBufferContext:	The pContext for the FAudioBuffer in question.
* Error:		The error code that spawned this callback.
*/
OnVoiceErrorFunc :: proc "c" (^FAudioVoiceCallback, rawptr, u32)

/* When this voice is done being processed, this is called. */
OnVoiceProcessingPassEndFunc :: proc "c" (^FAudioVoiceCallback)

/* When a voice is about to start being processed, this is called.
*
* BytesRequested:	The number of bytes needed from the application to
*			complete a full update. For example, if we need 512
*			frames for a whole update, and the voice is a float32
*			stereo source, BytesRequired will be 4096.
*/
OnVoiceProcessingPassStartFunc :: proc "c" (^FAudioVoiceCallback, u32)

FAudioVoiceCallback :: struct {
	OnBufferEnd:                OnBufferEndFunc,
	OnBufferStart:              OnBufferStartFunc,
	OnLoopEnd:                  OnLoopEndFunc,
	OnStreamEnd:                OnStreamEndFunc,
	OnVoiceError:               OnVoiceErrorFunc,
	OnVoiceProcessingPassEnd:   OnVoiceProcessingPassEndFunc,
	OnVoiceProcessingPassStart: OnVoiceProcessingPassStartFunc,
}

/* FAudio Custom Allocator API
* See "extensions/CustomAllocatorEXT.txt" for more information.
*/
FAudioMallocFunc :: proc "c" (c.size_t) -> rawptr

FAudioFreeFunc :: proc "c" (rawptr)

FAudioReallocFunc :: proc "c" (rawptr, c.size_t) -> rawptr

/* FAudio Engine Procedure API
* See "extensions/EngineProcedureEXT.txt" for more information.
*/
FAudioEngineCallEXT :: proc "c" (^FAudio, ^f32)

FAudioEngineProcedureEXT :: proc "c" (FAudioEngineCallEXT, ^FAudio, ^f32, rawptr)

/* FAudio I/O API */
FAUDIO_SEEK_SET :: 0
FAUDIO_SEEK_CUR :: 1
FAUDIO_SEEK_END :: 2
FAUDIO_EOF :: -1

FAudio_readfunc :: proc "c" (rawptr, rawptr, c.size_t, c.size_t) -> c.size_t

FAudio_seekfunc :: proc "c" (rawptr, i64, c.int) -> i64

FAudio_closefunc :: proc "c" (rawptr) -> c.int

FAudioIOStream :: struct {
	data:  rawptr,
	read:  FAudio_readfunc,
	seek:  FAudio_seekfunc,
	close: FAudio_closefunc,
	lock:  rawptr,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	FAudioLinkedVersion :: proc() -> u32 ---

	/* This should be your first FAudio call.
	*
	* ppFAudio:		Filled with the FAudio core context.
	* Flags:		Can be 0 or a combination of FAUDIO_DEBUG_ENGINE and FAUDIO_1024_QUANTUM.
	* XAudio2Processor:	Set this to FAUDIO_DEFAULT_PROCESSOR.
	*
	* Returns 0 on success.
	*/
	FAudioCreate :: proc(ppFAudio: ^^FAudio, Flags: u32, XAudio2Processor: FAudioProcessor) -> u32 ---

	/* See "extensions/COMConstructEXT.txt" for more details */
	FAudioCOMConstructEXT :: proc(ppFAudio: ^^FAudio, version: u8) -> u32 ---

	/* Increments a reference counter. When counter is 0, audio is freed.
	* Returns the reference count after incrementing.
	*/
	FAudio_AddRef :: proc(audio: ^FAudio) -> u32 ---

	/* Decrements a reference counter. When counter is 0, audio is freed.
	* Returns the reference count after decrementing.
	*/
	FAudio_Release :: proc(audio: ^FAudio) -> u32 ---

	/* Queries the number of sound devices available for use.
	*
	* pCount: Filled with the number of available sound devices.
	*
	* Returns 0 on success.
	*/
	FAudio_GetDeviceCount :: proc(audio: ^FAudio, pCount: ^u32) -> u32 ---

	/* Gets basic information about a sound device.
	*
	* Index:		Can be between 0 and the result of GetDeviceCount.
	* pDeviceDetails:	Filled with the device information.
	*
	* Returns 0 on success.
	*/
	FAudio_GetDeviceDetails :: proc(audio: ^FAudio, Index: u32, pDeviceDetails: ^FAudioDeviceDetails) -> u32 ---

	/* You don't actually have to call this, unless you're using the COM APIs.
	* See the FAudioCreate API for parameter information.
	*/
	FAudio_Initialize :: proc(audio: ^FAudio, Flags: u32, XAudio2Processor: FAudioProcessor) -> u32 ---

	/* Register a new set of engine callbacks.
	* There is no limit to the number of sets, but expect performance to degrade
	* if you have a whole bunch of these. You most likely only need one.
	*
	* pCallback: The completely-initialized FAudioEngineCallback structure.
	*
	* Returns 0 on success.
	*/
	FAudio_RegisterForCallbacks :: proc(audio: ^FAudio, pCallback: ^FAudioEngineCallback) -> u32 ---

	/* Remove an active set of engine callbacks.
	* This checks the pointer value, NOT the callback values!
	*
	* pCallback: An FAudioEngineCallback structure previously sent to Register.
	*
	* Returns 0 on success.
	*/
	FAudio_UnregisterForCallbacks :: proc(audio: ^FAudio, pCallback: ^FAudioEngineCallback) ---

	/* Creates a "source" voice, used to play back wavedata.
	*
	* ppSourceVoice:	Filled with the source voice pointer.
	* pSourceFormat:	The input wavedata format, see the documentation for
	*			FAudioWaveFormatEx.
	* Flags:		Can be 0 or a mix of the following FAUDIO_VOICE_* flags:
	*			NOPITCH/NOSRC:	Resampling is disabled. If you set this,
	*					the source format sample rate MUST match
	*					the output voices' input sample rates.
	*					Also, SetFrequencyRatio will fail.
	*			USEFILTER:	Enables the use of SetFilterParameters.
	*			MUSIC:		Unsupported.
	* MaxFrequencyRatio:	AKA your max pitch. This allows us to optimize the size
	*			of the decode/resample cache sizes. For example, if you
	*			only expect to raise pitch by a single octave, you can
	*			set this value to 2.0f. 2.0f is the default value.
	*			Bounds: [FAUDIO_MIN_FREQ_RATIO, FAUDIO_MAX_FREQ_RATIO].
	* pCallback:		Voice callbacks, see FAudioVoiceCallback documentation.
	* pSendList:		List of output voices. If NULL, defaults to master.
	*			All output voices must have the same sample rate!
	* pEffectChain:	List of FAPO effects. This value can be NULL.
	*
	* Returns 0 on success.
	*/
	FAudio_CreateSourceVoice :: proc(audio: ^FAudio, ppSourceVoice: ^^FAudioSourceVoice, pSourceFormat: ^FAudioWaveFormatEx, Flags: u32, MaxFrequencyRatio: f32, pCallback: ^FAudioVoiceCallback, pSendList: ^FAudioVoiceSends, pEffectChain: ^FAudioEffectChain) -> u32 ---

	/* Creates a "submix" voice, used to mix/process input voices.
	* The typical use case for this is to perform CPU-intensive tasks on large
	* groups of voices all at once. Examples include resampling and FAPO effects.
	*
	* ppSubmixVoice:	Filled with the submix voice pointer.
	* InputChannels:	Input voices will convert to this channel count.
	* InputSampleRate:	Input voices will convert to this sample rate.
	* Flags:		Can be 0 or FAUDIO_VOICE_USEFILTER.
	* ProcessingStage:	If you have multiple submixes that depend on a specific
	*			order of processing, you can sort them by setting this
	*			value to prioritize them. For example, submixes with
	*			stage 0 will process first, then stage 1, 2, and so on.
	* pSendList:		List of output voices. If NULL, defaults to master.
	*			All output voices must have the same sample rate!
	* pEffectChain:	List of FAPO effects. This value can be NULL.
	*
	* Returns 0 on success.
	*/
	FAudio_CreateSubmixVoice :: proc(audio: ^FAudio, ppSubmixVoice: ^^FAudioSubmixVoice, InputChannels: u32, InputSampleRate: u32, Flags: u32, ProcessingStage: u32, pSendList: ^FAudioVoiceSends, pEffectChain: ^FAudioEffectChain) -> u32 ---

	/* This should be your second FAudio call, unless you care about which device
	* you want to use. In that case, see GetDeviceDetails.
	*
	* ppMasteringVoice:	Filled with the mastering voice pointer.
	* InputChannels:	Device channel count. Can be FAUDIO_DEFAULT_CHANNELS.
	* InputSampleRate:	Device sample rate. Can be FAUDIO_DEFAULT_SAMPLERATE.
	* Flags:		This value must be 0.
	* DeviceIndex:		0 for the default device. See GetDeviceCount.
	* pEffectChain:	List of FAPO effects. This value can be NULL.
	*
	* Returns 0 on success.
	*/
	FAudio_CreateMasteringVoice :: proc(audio: ^FAudio, ppMasteringVoice: ^^FAudioMasteringVoice, InputChannels: u32, InputSampleRate: u32, Flags: u32, DeviceIndex: u32, pEffectChain: ^FAudioEffectChain) -> u32 ---

	/* This is the XAudio 2.8+ version of CreateMasteringVoice.
	* Right now this doesn't do anything. Don't use this function.
	*/
	FAudio_CreateMasteringVoice8 :: proc(audio: ^FAudio, ppMasteringVoice: ^^FAudioMasteringVoice, InputChannels: u32, InputSampleRate: u32, Flags: u32, szDeviceId: ^u16, pEffectChain: ^FAudioEffectChain, StreamCategory: FAudioStreamCategory) -> u32 ---

	/* Starts the engine, begins processing the audio graph.
	* Returns 0 on success.
	*/
	FAudio_StartEngine :: proc(audio: ^FAudio) -> u32 ---

	/* Stops the engine and halts all processing.
	* The audio device will continue to run, but will produce silence.
	* The graph will be frozen until you call StartEngine, where it will then
	* resume all processing exactly as it would have had this never been called.
	*/
	FAudio_StopEngine :: proc(audio: ^FAudio) ---

	/* Flushes a batch of FAudio calls compiled with a given "OperationSet" tag.
	* This function is based on IXAudio2::CommitChanges from the XAudio2 spec.
	* This is useful for pushing calls that need to be done perfectly in sync. For
	* example, if you want to play two separate sources at the exact same time, you
	* can call FAudioSourceVoice_Start with an OperationSet value of your choice,
	* then call CommitChanges with that same value to start the sources together.
	*
	* OperationSet: Either a value known by you or FAUDIO_COMMIT_ALL
	*
	* Returns 0 on success.
	*/
	FAudio_CommitOperationSet :: proc(audio: ^FAudio, OperationSet: u32) -> u32 ---

	/* DO NOT USE THIS FUNCTION OR I SWEAR TO GOD */
	FAudio_CommitChanges :: proc(audio: ^FAudio) -> u32 ---

	/* Requests various bits of performance information from the engine.
	*
	* pPerfData: Filled with the data. See FAudioPerformanceData for details.
	*/
	FAudio_GetPerformanceData :: proc(audio: ^FAudio, pPerfData: ^FAudioPerformanceData) ---

	/* When using a Debug binary, this lets you configure what information gets
	* logged to output. Be careful, this can spit out a LOT of text.
	*
	* pDebugConfiguration:	See FAudioDebugConfiguration for details.
	* pReserved:		Set this to NULL.
	*/
	FAudio_SetDebugConfiguration :: proc(audio: ^FAudio, pDebugConfiguration: ^FAudioDebugConfiguration, pReserved: rawptr) ---

	/* Requests the values that determine's the engine's update size.
	* For example, a 48KHz engine with a 1024-sample update period would return
	* 1024 for the numerator and 48000 for the denominator. With this information,
	* you can determine the precise update size in milliseconds.
	*
	* quantumNumerator - The engine's update size, in sample frames.
	* quantumDenominator - The engine's sample rate, in Hz
	*/
	FAudio_GetProcessingQuantum :: proc(audio: ^FAudio, quantumNumerator: ^u32, quantumDenominator: ^u32) ---

	/* Requests basic information about a voice.
	*
	* pVoiceDetails: See FAudioVoiceDetails for details.
	*/
	FAudioVoice_GetVoiceDetails :: proc(voice: ^FAudioVoice, pVoiceDetails: ^FAudioVoiceDetails) ---

	/* Change the output voices for this voice.
	* This function is invalid for mastering voices.
	*
	* pSendList:	List of output voices. If NULL, defaults to master.
	*		All output voices must have the same sample rate!
	*
	* Returns 0 on success.
	*/
	FAudioVoice_SetOutputVoices :: proc(voice: ^FAudioVoice, pSendList: ^FAudioVoiceSends) -> u32 ---

	/* Change/Remove the effect chain for this voice.
	*
	* pEffectChain:	List of FAPO effects. This value can be NULL.
	*			Note that the final channel counts for this chain MUST
	*			match the input/output channel count that was
	*			determined at voice creation time!
	*
	* Returns 0 on success.
	*/
	FAudioVoice_SetEffectChain :: proc(voice: ^FAudioVoice, pEffectChain: ^FAudioEffectChain) -> u32 ---

	/* Enables an effect in the effect chain.
	*
	* EffectIndex:		The index of the effect (based on the chain order).
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioVoice_EnableEffect :: proc(voice: ^FAudioVoice, EffectIndex: u32, OperationSet: u32) -> u32 ---

	/* Disables an effect in the effect chain.
	*
	* EffectIndex:		The index of the effect (based on the chain order).
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioVoice_DisableEffect :: proc(voice: ^FAudioVoice, EffectIndex: u32, OperationSet: u32) -> u32 ---

	/* Queries the enabled/disabled state of an effect in the effect chain.
	*
	* EffectIndex:	The index of the effect (based on the chain order).
	* pEnabled:	Filled with either 1 (Enabled) or 0 (Disabled).
	*
	* Returns 0 on success.
	*/
	FAudioVoice_GetEffectState :: proc(voice: ^FAudioVoice, EffectIndex: u32, pEnabled: ^i32) ---

	/* Submits a block of memory to be sent to FAPO::SetParameters.
	*
	* EffectIndex:		The index of the effect (based on the chain order).
	* pParameters:		The values to be copied and submitted to the FAPO.
	* ParametersByteSize:	This should match what the FAPO expects!
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioVoice_SetEffectParameters :: proc(voice: ^FAudioVoice, EffectIndex: u32, pParameters: rawptr, ParametersByteSize: u32, OperationSet: u32) -> u32 ---

	/* Requests the latest parameters from FAPO::GetParameters.
	*
	* EffectIndex:		The index of the effect (based on the chain order).
	* pParameters:		Filled with the latest parameter values from the FAPO.
	* ParametersByteSize:	This should match what the FAPO expects!
	*
	* Returns 0 on success.
	*/
	FAudioVoice_GetEffectParameters :: proc(voice: ^FAudioVoice, EffectIndex: u32, pParameters: rawptr, ParametersByteSize: u32) -> u32 ---

	/* Sets the filter variables for a voice.
	* This is only valid on voices with the USEFILTER flag.
	*
	* pParameters:		See FAudioFilterParameters for details.
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioVoice_SetFilterParameters :: proc(voice: ^FAudioVoice, pParameters: ^FAudioFilterParameters, OperationSet: u32) -> u32 ---

	/* Requests the filter variables for a voice.
	* This is only valid on voices with the USEFILTER flag.
	*
	* pParameters: See FAudioFilterParameters for details.
	*/
	FAudioVoice_GetFilterParameters :: proc(voice: ^FAudioVoice, pParameters: ^FAudioFilterParameters) ---

	/* Sets the filter variables for a voice's output voice.
	* This is only valid on sends with the USEFILTER flag.
	*
	* pDestinationVoice:	An output voice from the voice's send list.
	* pParameters:		See FAudioFilterParameters for details.
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioVoice_SetOutputFilterParameters :: proc(voice: ^FAudioVoice, pDestinationVoice: ^FAudioVoice, pParameters: ^FAudioFilterParameters, OperationSet: u32) -> u32 ---

	/* Requests the filter variables for a voice's output voice.
	* This is only valid on sends with the USEFILTER flag.
	*
	* pDestinationVoice:	An output voice from the voice's send list.
	* pParameters:		See FAudioFilterParameters for details.
	*/
	FAudioVoice_GetOutputFilterParameters :: proc(voice: ^FAudioVoice, pDestinationVoice: ^FAudioVoice, pParameters: ^FAudioFilterParameters) ---

	/* Sets the filter variables for a voice.
	* This is only valid on voices with the USEFILTER flag.
	*
	* pParameters:		See FAudioFilterParametersEXT for details.
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioVoice_SetFilterParametersEXT :: proc(voice: ^FAudioVoice, pParameters: ^FAudioFilterParametersEXT, OperationSet: u32) -> u32 ---

	/* Requests the filter variables for a voice.
	* This is only valid on voices with the USEFILTER flag.
	*
	* pParameters: See FAudioFilterParametersEXT for details.
	*/
	FAudioVoice_GetFilterParametersEXT :: proc(voice: ^FAudioVoice, pParameters: ^FAudioFilterParametersEXT) ---

	/* Sets the filter variables for a voice's output voice.
	* This is only valid on sends with the USEFILTER flag.
	*
	* pDestinationVoice:	An output voice from the voice's send list.
	* pParameters:		See FAudioFilterParametersEXT for details.
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioVoice_SetOutputFilterParametersEXT :: proc(voice: ^FAudioVoice, pDestinationVoice: ^FAudioVoice, pParameters: ^FAudioFilterParametersEXT, OperationSet: u32) -> u32 ---

	/* Requests the filter variables for a voice's output voice.
	* This is only valid on sends with the USEFILTER flag.
	*
	* pDestinationVoice:	An output voice from the voice's send list.
	* pParameters:		See FAudioFilterParametersEXT for details.
	*/
	FAudioVoice_GetOutputFilterParametersEXT :: proc(voice: ^FAudioVoice, pDestinationVoice: ^FAudioVoice, pParameters: ^FAudioFilterParametersEXT) ---

	/* Sets the global volume of a voice.
	*
	* Volume:		Amplitude ratio. 1.0f is default, 0.0f is silence.
	*			Note that you can actually set volume < 0.0f!
	*			Bounds: [-FAUDIO_MAX_VOLUME_LEVEL, FAUDIO_MAX_VOLUME_LEVEL]
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioVoice_SetVolume :: proc(voice: ^FAudioVoice, Volume: f32, OperationSet: u32) -> u32 ---

	/* Requests the global volume of a voice.
	*
	* pVolume: Filled with the current voice amplitude ratio.
	*/
	FAudioVoice_GetVolume :: proc(voice: ^FAudioVoice, pVolume: ^f32) ---

	/* Sets the per-channel volumes of a voice.
	*
	* Channels:		Must match the channel count of this voice!
	* pVolumes:		Amplitude ratios for each channel. Same as SetVolume.
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioVoice_SetChannelVolumes :: proc(voice: ^FAudioVoice, Channels: u32, pVolumes: ^f32, OperationSet: u32) -> u32 ---

	/* Requests the per-channel volumes of a voice.
	*
	* Channels:	Must match the channel count of this voice!
	* pVolumes:	Filled with the current channel amplitude ratios.
	*/
	FAudioVoice_GetChannelVolumes :: proc(voice: ^FAudioVoice, Channels: u32, pVolumes: ^f32) ---

	/* Sets the volumes of a send's output channels. The matrix is based on the
	* voice's input channels. For example, the default matrix for a 2-channel
	* source and a 2-channel output voice is as follows:
	* [0] = 1.0f; <- Left input, left output
	* [1] = 0.0f; <- Right input, left output
	* [2] = 0.0f; <- Left input, right output
	* [3] = 1.0f; <- Right input, right output
	* This is typically only used for panning or 3D sound (via F3DAudio).
	*
	* pDestinationVoice:	An output voice from the voice's send list.
	* SourceChannels:	Must match the voice's input channel count!
	* DestinationChannels:	Must match the destination's input channel count!
	* pLevelMatrix:	A float[SourceChannels * DestinationChannels].
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioVoice_SetOutputMatrix :: proc(voice: ^FAudioVoice, pDestinationVoice: ^FAudioVoice, SourceChannels: u32, DestinationChannels: u32, pLevelMatrix: ^f32, OperationSet: u32) -> u32 ---

	/* Gets the volumes of a send's output channels. See SetOutputMatrix.
	*
	* pDestinationVoice:	An output voice from the voice's send list.
	* SourceChannels:	Must match the voice's input channel count!
	* DestinationChannels:	Must match the voice's output channel count!
	* pLevelMatrix:	A float[SourceChannels * DestinationChannels].
	*/
	FAudioVoice_GetOutputMatrix :: proc(voice: ^FAudioVoice, pDestinationVoice: ^FAudioVoice, SourceChannels: u32, DestinationChannels: u32, pLevelMatrix: ^f32) ---

	/* Removes this voice from the audio graph and frees memory. */
	FAudioVoice_DestroyVoice :: proc(voice: ^FAudioVoice) ---

	/*
	* Returns S_OK on success and E_FAIL if voice could not be destroyed (e. g., because it is in use).
	*/
	FAudioVoice_DestroyVoiceSafeEXT :: proc(voice: ^FAudioVoice) -> u32 ---

	/* Starts processing for a source voice.
	*
	* Flags:		Must be 0.
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioSourceVoice_Start :: proc(voice: ^FAudioSourceVoice, Flags: u32, OperationSet: u32) -> u32 ---

	/* Pauses processing for a source voice. Yes, I said pausing.
	* If you want to _actually_ stop, call FlushSourceBuffers next.
	*
	* Flags:		Can be 0 or FAUDIO_PLAY_TAILS, which allows effects to
	*			keep emitting output even after processing has stopped.
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioSourceVoice_Stop :: proc(voice: ^FAudioSourceVoice, Flags: u32, OperationSet: u32) -> u32 ---

	/* Submits a block of wavedata for the source to process.
	*
	* pBuffer:	See FAudioBuffer for details.
	* pBufferWMA:	See FAudioBufferWMA for details. (Also, don't use WMA.)
	*
	* Returns 0 on success.
	*/
	FAudioSourceVoice_SubmitSourceBuffer :: proc(voice: ^FAudioSourceVoice, pBuffer: ^FAudioBuffer, pBufferWMA: ^FAudioBufferWMA) -> u32 ---

	/* Removes all buffers from a source, with a minor exception.
	* If the voice is still playing, the active buffer is left alone.
	* All buffers that are removed will spawn an OnBufferEnd callback.
	*
	* Returns 0 on success.
	*/
	FAudioSourceVoice_FlushSourceBuffers :: proc(voice: ^FAudioSourceVoice) -> u32 ---

	/* Takes the last buffer currently queued and sets the END_OF_STREAM flag.
	*
	* Returns 0 on success.
	*/
	FAudioSourceVoice_Discontinuity :: proc(voice: ^FAudioSourceVoice) -> u32 ---

	/* Sets the loop count of the active buffer to 0.
	*
	* OperationSet: See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioSourceVoice_ExitLoop :: proc(voice: ^FAudioSourceVoice, OperationSet: u32) -> u32 ---

	/* Requests the state and some basic statistics for this source.
	*
	* pVoiceState:	See FAudioVoiceState for details.
	* Flags:	Can be 0 or FAUDIO_VOICE_NOSAMPLESPLAYED.
	*/
	FAudioSourceVoice_GetState :: proc(voice: ^FAudioSourceVoice, pVoiceState: ^FAudioVoiceState, Flags: u32) ---

	/* Sets the frequency ratio (fancy phrase for pitch) of this source.
	*
	* Ratio:		The frequency ratio, must be <= MaxFrequencyRatio.
	* OperationSet:	See CommitChanges. Default is FAUDIO_COMMIT_NOW.
	*
	* Returns 0 on success.
	*/
	FAudioSourceVoice_SetFrequencyRatio :: proc(voice: ^FAudioSourceVoice, Ratio: f32, OperationSet: u32) -> u32 ---

	/* Requests the frequency ratio (fancy phrase for pitch) of this source.
	*
	* pRatio: Filled with the frequency ratio.
	*/
	FAudioSourceVoice_GetFrequencyRatio :: proc(voice: ^FAudioSourceVoice, pRatio: ^f32) ---

	/* Resets the core sample rate of this source.
	* You probably don't want this, it's more likely you want SetFrequencyRatio.
	* This is used to recycle voices without having to constantly reallocate them.
	* For example, if you have wavedata that's all float32 mono, but the sample
	* rates are different, you can take a source that was being used for a 48KHz
	* wave and call this so it can be used for a 44.1KHz wave.
	*
	* NewSourceSampleRate: The new sample rate for this source.
	*
	* Returns 0 on success.
	*/
	FAudioSourceVoice_SetSourceSampleRate :: proc(voice: ^FAudioSourceVoice, NewSourceSampleRate: u32) -> u32 ---

	/* Requests the channel mask for the mastering voice.
	* This is typically used with F3DAudioInitialize, but you may find it
	* interesting if you want to see the user's basic speaker layout.
	*
	* pChannelMask: Filled with the channel mask.
	*
	* Returns 0 on success.
	*/
	FAudioMasteringVoice_GetChannelMask      :: proc(voice: ^FAudioMasteringVoice, pChannelMask: ^u32) -> u32 ---
	FAudioCreateWithCustomAllocatorEXT       :: proc(ppFAudio: ^^FAudio, Flags: u32, XAudio2Processor: FAudioProcessor, customMalloc: FAudioMallocFunc, customFree: FAudioFreeFunc, customRealloc: FAudioReallocFunc) -> u32 ---
	FAudioCOMConstructWithCustomAllocatorEXT :: proc(ppFAudio: ^^FAudio, version: u8, customMalloc: FAudioMallocFunc, customFree: FAudioFreeFunc, customRealloc: FAudioReallocFunc) -> u32 ---
	FAudio_SetEngineProcedureEXT             :: proc(audio: ^FAudio, clientEngineProc: FAudioEngineProcedureEXT, user: rawptr) ---
	FAudio_fopen                             :: proc(path: cstring) -> ^FAudioIOStream ---
	FAudio_memopen                           :: proc(mem: rawptr, len: c.int) -> ^FAudioIOStream ---
	FAudio_memptr                            :: proc(io: ^FAudioIOStream, offset: c.size_t) -> ^u8 ---
	FAudio_close                             :: proc(io: ^FAudioIOStream) ---
}
