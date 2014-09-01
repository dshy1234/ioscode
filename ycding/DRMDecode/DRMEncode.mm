//
//  DRMEncode.m
//  BookFMHD
//
//  Created by Ray Zhang on 12/26/11.
//  Copyright 2011 Showbox.mobi. All rights reserved.
//

#import "DRMEncode.h"
#import "ComFun.h"
#include "DRMKernelDef.h"
#include "DRMBaseDef.h"
#include "DRMClientKit.h"
#include "AppErrorMsg.h"


using namespace DRMKernel;
using namespace DRMClientKit;
using namespace DRMDef;


@implementation DRMEncode
+ (void)GetRelFile:(NSString**)relUrlString CEBXUrlString:(NSString**)cebxUrlString PostData:(NSData**)postData;
{
    LPCDRMWSTR g_lpRelFileName = L"Test1.xml"; // Rel 证书文件名，含路径
    LPCDRMWSTR g_lpTriggerFileName = L" TestTriggerProtocol.xml";  //  引导文件名，含路径
    LPDRMWSTR g_lpWstrPubkey = DRM_NULL; //  公钥数据
    LPDRMWSTR g_pProtocol = DRM_NULL; //  用来存储生成的协议参数
    DRM_DWORD g_dwProtocolInfoLen = 0; //  存储生成的协议参数的长度方正技术研究院数字出版分院
    
    NSString *CEBXFilePath;
    NSString *relFilePath;

    NSString *fileName;
    CRORequest objCRORequest;
    

    NSString *tigFile = [[NSBundle mainBundle] pathForResource:@"1323760681881" ofType:@"cfx"];
    // 构造IDRMTriggerClientKit对象
    IDRMTriggerClientKit  objIDRMTriggerClientKit([ComFun NSStringToWChar:tigFile]);
    // 解析Trigger协议
    CTrigger *pTrigger = DRM_NULL;
    DRM_INT nRet = objIDRMTriggerClientKit.doParse(&pTrigger);
    CTriggerItem objCTriggerItem;
    // 获取Trigger中TriggerItem的个数
    DRM_INT nTriggerCount = objIDRMTriggerClientKit.GetTriggerItemsCount();
    DRM_BYTE* pbyImage;

    
    for (DRM_INT i=0; i<nTriggerCount; i++)
    {
        // 获取TriggerItem信息
        nRet = objIDRMTriggerClientKit.GetTriggerItemInfo(objCTriggerItem,i);
        
        objCRORequest.m_strVersion = [ComFun NSStringToWChar:@"1.0"];//VERSION_CUR;
        objCRORequest.m_strServerID = objCTriggerItem.m_strServerID;
        objCRORequest.m_strSupportedAlgorithms = [ComFun NSStringToWChar:@"AES"];
        objCRORequest.m_strNonce = [ComFun NSStringToWChar:@"Tom"];
        objCRORequest.m_strLanguage = [ComFun NSStringToWChar:@"Chinese"];
        objCRORequest.m_objCRORequestTips.m_strROTips = objCTriggerItem.m_strROTips;
        NSString *deviceID = @"355031040141125";
        IDRMRequestClientKit objIDRMRequestClientKit(ROREQUEST_TYPE, (DRM_BYTE*)[deviceID UTF8String],[deviceID length],(CRequest*)&objCRORequest);
        printf("%i",wcslen(objCTriggerItem.m_objCCertificateChain.m_strCertificate));
        printf("\n%S",objCTriggerItem.m_objCCertificateChain.m_strCertificate);
//        long lImageSize = wcslen(objCTriggerItem.m_objCCertificateChain.m_strCertificate) * 4 + 1;
//        lImageSize = 65535;
//        pbyImage= new DRM_BYTE[lImageSize]; 
//        memset(pbyImage, 0xFF, lImageSize);
        NSString *string1 = @"$UserID=$Reader_Version=1001001$Action=borrow$Client_type=Ios";
        
       DRM_INT setRet = objIDRMRequestClientKit.SetXMLParasInfo([ComFun NSStringToWChar:@"/RORequest/ReaderData"], [ComFun NSStringToWChar:string1], [string1 length] * sizeof(wchar_t),true);
        if (setRet != 0) {
            return;
        }
        setRet = objIDRMRequestClientKit.doCreate(&pbyImage, &g_dwProtocolInfoLen, objCTriggerItem.m_objCCertificateChain.m_strCertificate, wcslen(objCTriggerItem.m_objCCertificateChain.m_strCertificate));
        if (setRet != 0) {
            return;
        }
        printf("\n%s",pbyImage);

        //nRet = objIDRMRequestClientKit.doCreate(&g_pProtocol, &g_dwProtocolInfoLen, objCTriggerItem.m_objCCertificateChain.m_strCertificate, wcslen(objCTriggerItem.m_objCCertificateChain.m_strCertificate),ECC_256,DRM_ENCODING_UTF32);
        

        // 根据TriggerItem的索引值获取相应的Asset对象的个数
        DRM_INT nAssetCount = 
        objIDRMTriggerClientKit.GetTriggerItemAssetsCount(i);
        for (DRM_INT j=0; j<nAssetCount; j++)
        {
            CAssetAttr  objCAssetAttr;
            // 根据TriggerItem的索引值获取相应的Asset对象信息
            nRet = objIDRMTriggerClientKit.GetTriggerItemAssetInfo(objCAssetAttr, j, i);
            //printf("\n%S");
            fileName = [[[NSString alloc] initWithBytes:objCAssetAttr.m_strName length:wcslen(objCAssetAttr.m_strName) * sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding] autorelease];
            
            CEBXFilePath = [[[NSString alloc] initWithBytes:objCAssetAttr.m_strContentURI length:wcslen(objCAssetAttr.m_strContentURI) * sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding] autorelease];

            relFilePath = [[[NSString alloc] initWithBytes:objCAssetAttr.m_strRightsIssuerURI length:wcslen(objCAssetAttr.m_strRightsIssuerURI) * sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding] autorelease];
            // 释放Asset对象
            objIDRMTriggerClientKit.ClearTriggerAsset(objCAssetAttr);
        }
        // 根据TriggerItem的索引值获取相应的Permission的个数
        DRM_INT nPermissionCount = objIDRMTriggerClientKit.GetTriggerItemPermissionsCount(i);
        for (DRM_INT j=0; j<nPermissionCount; j++)
        {
            CPermission objCPermission;
            // 根据TriggerItem的索引值获取相应的Permission项的信息
            nRet = objIDRMTriggerClientKit.GetTriggerItemPermissionInfo(objCPermission,j, i);
            objIDRMTriggerClientKit.ClearPermission(objCPermission);
        }
        objIDRMTriggerClientKit.ClearTriggerItem(objCTriggerItem);
    }
    // 释放协议资源
    objIDRMTriggerClientKit.Clear(pTrigger);
    
    NSArray *searchPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
    
    //NSString *tempDBFilePath = [documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_%@.%@",book.bookid,[appDelegate userid],book.typeName]];
    
    
    NSString *tempDBFilePath = [documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"111.temp"]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:tempDBFilePath]) {
        NSError *merror = [[NSError alloc] init];
        [manager removeItemAtPath:tempDBFilePath error:&merror];
//        NSDictionary *fileAttributes = [manager attributesOfItemAtPath:tempDBFilePath error:nil];
//        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
//        location = [fileSize integerValue];
//        oldFileSize = location;
        
    }
   // fileStream = [[NSOutputStream outputStreamToFileAtPath:tempDBFilePath append:YES] retain];
   // [fileStream open];
    
    NSString *urlStr = relFilePath;
    *relUrlString = [relFilePath copy];
    *cebxUrlString = [CEBXFilePath copy];

    NSData *tempData= [NSData dataWithBytes:pbyImage length:g_dwProtocolInfoLen];
    *postData = [tempData copy];
    return;
    
    printf("%S",g_pProtocol);

}

+ (bool)ParseRelResponse:(NSData*)responseData{
 //   IDRMResponseClientKit(PROTOCOL_RESPONSE_TYPE nResponseType, const DRM_BYTE* lpProtocolInfo, const DRM_DWORD dwProtocolInfoLen, DRM_UNICODE_ENCODINGTYPE nEncodeType = DRM_ENCODING_UTF16);

    IDRMResponseClientKit responseClientKit(RORESPONSE_TYPE,(DRM_BYTE*)[responseData bytes] ,[responseData length] ,DRM_ENCODING_UTF16 );
    CROResponse* pCROResponse = DRM_NULL;
    
    if (responseClientKit.doParse((CResponse **) &pCROResponse) != 0)
        return false;
    // 如果证书文件错误
    if (pCROResponse->m_strProtectedRel == NULL)
    {
        responseClientKit .Clear((CResponse *&) pCROResponse);
        return false;
    }
    NSArray *searchPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
    
    //NSString *tempDBFilePath = [documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_%@.%@",book.bookid,[appDelegate userid],book.typeName]];
    
    
    NSString *tempDBFilePath = [documentFolderPath stringByAppendingPathComponent:@"rel.cvx"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:tempDBFilePath]) {
        NSError *merror = [[NSError alloc] init];
        [manager removeItemAtPath:tempDBFilePath error:&merror];

        
    }
    NSOutputStream *fileStream = [[NSOutputStream outputStreamToFileAtPath:tempDBFilePath append:YES] retain];
    [fileStream open];
    [fileStream write:(uint8_t *)pCROResponse->m_strProtectedRel maxLength:wcslen(pCROResponse->m_strProtectedRel) * sizeof(wchar_t)];
    [fileStream close];
    responseClientKit.Clear((CResponse *&)pCROResponse);
    return true;
}
@end
