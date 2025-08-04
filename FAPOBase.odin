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
* https://docs.microsoft.com/en-us/windows/desktop/api/xapobase/
*
* Of course, the APIs aren't exactly the same since XAPO is super dependent on
* C++. Instead, we use a struct full of functions to mimic a vtable.
*
* To mimic the CXAPOParametersBase experience, initialize the object like this:
*
* extern FAPORegistrationProperties MyFAPOProperties;
* extern int32_t producer;
* typedef struct MyFAPOParams
* {
*	uint32_t something;
* } MyFAPOParams;
* typedef struct MyFAPO
* {
*	FAPOBase base;
*	uint32_t somethingElse;
* } MyFAPO;
* void MyFAPO_Free(void* fapo)
* {
*	MyFAPO *mine = (MyFAPO*) fapo;
*	mine->base.pFree(mine->base.m_pParameterBlocks);
*	mine->base.pFree(fapo);
* }
*
* MyFAPO *result = (MyFAPO*) SDL_malloc(sizeof(MyFAPO));
* uint8_t *params = (uint8_t*) SDL_malloc(sizeof(MyFAPOParams) * 3);
* CreateFAPOBase(
*	&result->base,
*	&MyFAPOProperties,
*	params,
*	sizeof(MyFAPOParams),
*	producer
* );
* result->base.base.Initialize = (InitializeFunc) MyFAPO_Initialize;
* result->base.base.Process = (ProcessFunc) MyFAPO_Process;
* result->base.Destructor = MyFAPO_Free;
*/
package faudio

import "core:c"

_ :: c



/* Constants */
// FAPOBASE_DEFAULT_FORMAT_TAG :: FAUDIO_FORMAT_IEEE_FLOAT
// FAPOBASE_DEFAULT_FORMAT_MIN_CHANNELS :: FAPO_MIN_CHANNELS
// FAPOBASE_DEFAULT_FORMAT_MAX_CHANNELS :: FAPO_MAX_CHANNELS
// FAPOBASE_DEFAULT_FORMAT_MIN_FRAMERATE :: FAPO_MIN_FRAMERATE
// FAPOBASE_DEFAULT_FORMAT_MAX_FRAMERATE :: FAPO_MAX_FRAMERATE
FAPOBASE_DEFAULT_FORMAT_BITSPERSAMPLE :: 32

// FAPOBASE_DEFAULT_FLAG :: FAPO_FLAG_CHANNELS_MUST_MATCH | FAPO_FLAG_FRAMERATE_MUST_MATCH | FAPO_FLAG_BITSPERSAMPLE_MUST_MATCH | FAPO_FLAG_BUFFERCOUNT_MUST_MATCH | FAPO_FLAG_INPLACE_SUPPORTED

FAPOBASE_DEFAULT_BUFFER_COUNT :: 1

OnSetParametersFunc :: proc "c" (^FAPOBase, rawptr, u32)

FAPOBase :: struct {
	/* Base Classes/Interfaces */
	base: FAPO,
	Destructor:                   proc "c" (rawptr),

	/* Public Virtual Functions */
	OnSetParameters: OnSetParametersFunc,

	/* Private Variables */
	m_pRegistrationProperties: ^FAPORegistrationProperties,
	m_pfnMatrixMixFunction:       rawptr,
	m_pfl32MatrixCoefficients:    ^f32,
	m_nSrcFormatType:             u32,
	m_fIsScalarMatrix:            u8,
	m_fIsLocked:                  u8,
	m_pParameterBlocks:           ^u8,
	m_pCurrentParameters:         ^u8,
	m_pCurrentParametersInternal: ^u8,
	m_uCurrentParametersIndex:    u32,
	m_uParameterBlockByteSize:    u32,
	m_fNewerResultsReady:         u8,
	m_fProducer:                  u8,
	m_lReferenceCount:            i32, /* LONG */

	/* Allocator callbacks, NOT part of XAPOBase spec! */
	pMalloc: FAudioMallocFunc,
	pFree:                        FAudioFreeFunc,
	pRealloc:                     FAudioReallocFunc,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	CreateFAPOBase :: proc(fapo: ^FAPOBase, pRegistrationProperties: ^FAPORegistrationProperties, pParameterBlocks: ^u8, uParameterBlockByteSize: u32, fProducer: u8) ---

	/* See "extensions/CustomAllocatorEXT.txt" for more information. */
	CreateFAPOBaseWithCustomAllocatorEXT :: proc(fapo: ^FAPOBase, pRegistrationProperties: ^FAPORegistrationProperties, pParameterBlocks: ^u8, uParameterBlockByteSize: u32, fProducer: u8, customMalloc: FAudioMallocFunc, customFree: FAudioFreeFunc, customRealloc: FAudioReallocFunc) ---
	FAPOBase_AddRef                      :: proc(fapo: ^FAPOBase) -> i32 ---
	FAPOBase_Release                     :: proc(fapo: ^FAPOBase) -> i32 ---
	FAPOBase_GetRegistrationProperties   :: proc(fapo: ^FAPOBase, ppRegistrationProperties: ^^FAPORegistrationProperties) -> u32 ---
	FAPOBase_IsInputFormatSupported      :: proc(fapo: ^FAPOBase, pOutputFormat: ^FAudioWaveFormatEx, pRequestedInputFormat: ^FAudioWaveFormatEx, ppSupportedInputFormat: ^^FAudioWaveFormatEx) -> u32 ---
	FAPOBase_IsOutputFormatSupported     :: proc(fapo: ^FAPOBase, pInputFormat: ^FAudioWaveFormatEx, pRequestedOutputFormat: ^FAudioWaveFormatEx, ppSupportedOutputFormat: ^^FAudioWaveFormatEx) -> u32 ---
	FAPOBase_Initialize                  :: proc(fapo: ^FAPOBase, pData: rawptr, DataByteSize: u32) -> u32 ---
	FAPOBase_Reset                       :: proc(fapo: ^FAPOBase) ---
	FAPOBase_LockForProcess              :: proc(fapo: ^FAPOBase, InputLockedParameterCount: u32, pInputLockedParameters: ^FAPOLockForProcessBufferParameters, OutputLockedParameterCount: u32, pOutputLockedParameters: ^FAPOLockForProcessBufferParameters) -> u32 ---
	FAPOBase_UnlockForProcess            :: proc(fapo: ^FAPOBase) ---
	FAPOBase_CalcInputFrames             :: proc(fapo: ^FAPOBase, OutputFrameCount: u32) -> u32 ---
	FAPOBase_CalcOutputFrames            :: proc(fapo: ^FAPOBase, InputFrameCount: u32) -> u32 ---
	FAPOBase_ValidateFormatDefault       :: proc(fapo: ^FAPOBase, pFormat: ^FAudioWaveFormatEx, fOverwrite: u8) -> u32 ---
	FAPOBase_ValidateFormatPair          :: proc(fapo: ^FAPOBase, pSupportedFormat: ^FAudioWaveFormatEx, pRequestedFormat: ^FAudioWaveFormatEx, fOverwrite: u8) -> u32 ---
	FAPOBase_ProcessThru                 :: proc(fapo: ^FAPOBase, pInputBuffer: rawptr, pOutputBuffer: ^f32, FrameCount: u32, InputChannelCount: u16, OutputChannelCount: u16, MixWithOutput: u8) ---
	FAPOBase_SetParameters               :: proc(fapo: ^FAPOBase, pParameters: rawptr, ParameterByteSize: u32) ---
	FAPOBase_GetParameters               :: proc(fapo: ^FAPOBase, pParameters: rawptr, ParameterByteSize: u32) ---
	FAPOBase_OnSetParameters             :: proc(fapo: ^FAPOBase, parameters: rawptr, parametersSize: u32) ---
	FAPOBase_ParametersChanged           :: proc(fapo: ^FAPOBase) -> u8 ---
	FAPOBase_BeginProcess                :: proc(fapo: ^FAPOBase) -> ^u8 ---
	FAPOBase_EndProcess                  :: proc(fapo: ^FAPOBase) ---
}
