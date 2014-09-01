/*
 * Core AR
 * homography.cpp
 *
 * Copyright (c) Yuichi YOSHIDA, 11/07/23.
 * All rights reserved.
 * 
 * BSD License
 *
 * Redistribution and use in source and binary forms, with or without modification, are 
 * permitted provided that the following conditions are met:
 * - Redistributions of source code must retain the above copyright notice, this list of
 *  conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, this list
 *  of conditions and the following disclaimer in the documentation and/or other materia
 * ls provided with the distribution.
 * - Neither the name of the "Yuichi Yoshida" nor the names of its contributors may be u
 * sed to endorse or promote products derived from this software without specific prior 
 * written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY E
 * XPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES O
 * F MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SH
 * ALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENT
 * AL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROC
 * UREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS I
 * NTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRI
 * CT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF T
 * HE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "homography.h"

#include "CoreAR.h"
#include "CRTest.h"

void homorgraphy_test() {
	printf("=================================================>Homography test\n");

	unsigned char *pixel = NULL;
	int width = 0;
	int height = 0;
	
	CRChainCode *chaincode = new CRChainCode();
	
	////////////////////////////////////////////////////////////////////////////////
	//
	// make test pixel data
	//
	////////////////////////////////////////////////////////////////////////////////
	
	width = 640;
	height = 480;
	
	CRHomogeneousVec3 *corners = new CRHomogeneousVec3 [4];
	
	float focal = 650;
	float xdeg = 0;
	float ydeg = M_PI / 10.0f;
	float zdeg = M_PI / 10.0f;
	
	float xt = -0.3;
	float yt = -0.5;
	float zt = 20;
	float pMat[4][4];
	
	float codeSize = 1;
	
	_CRTestMakePixelDataAndPMatrixWithProjectionSettingAndCodeSize(
																   codeSize,
																   pMat,
																   &pixel,
																   width,
																   height,
																   corners,
																   focal,
																   xdeg, 
																   ydeg, 
																   zdeg, 
																   xt, 
																   yt,
																   zt);
	
	printf("Ground truth RT Matrix\n");
	_CRTestDumpMat(pMat);
	printf("\n");
	
	////////////////////////////////////////////////////////////////////////////////
	//
	// parse chain code
	//
	////////////////////////////////////////////////////////////////////////////////
	chaincode->parsePixel(pixel, width, height);
	
	CRCode *gtCode = new CRCode(corners, corners+1, corners+2, corners+3);
	gtCode->dumpCorners();
	gtCode->normalizeCornerForImageCoord(width, height, focal, focal);
	gtCode->getSimpleHomography(codeSize);
	gtCode->dumpHomography();
	gtCode->dumpMatrix();
	
	if (!chaincode->blobs->empty()) {
		CRChainCodeBlob *blob = chaincode->blobs->front();
		CRCode *code_normal = blob->code();
		
		printf("Corners on the image.\n");
		code_normal->dumpCorners();
		
		// normalize corners' coordinates.
		code_normal->normalizeCornerForImageCoord(width, height, focal, focal);
		
		printf("Normalized corners on the image.\n");
		code_normal->dumpCorners();
		
		// caluculate homography matrix with least square method.
		_CRTic();
		code_normal->getSimpleHomography(codeSize);
		printf("Homography\n\t%0.5f[msec]\n\n", _CRTocWithoutLog());
		
		printf("Homography matrix\n");
		_CRTestShowMatrix3x3(code_normal->homography);
		printf("RT matrix\n");
		_CRTestShowMatrix4x4(code_normal->matrix);
	
		SAFE_DELETE(code_normal);
	}
	
	////////////////////////////////////////////////////////////////////////////////
	//
	// Release
	//
	////////////////////////////////////////////////////////////////////////////////
	SAFE_FREE(pixel);
	SAFE_DELETE(gtCode);
	SAFE_DELETE(chaincode);
	SAFE_DELETE_ARRAY(corners);
}