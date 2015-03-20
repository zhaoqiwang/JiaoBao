//
//  RSATool.m
//  EncryptionDemo
//
//  Created by Lhp@WPH on 14-8-26.
//  Copyright (c) 2014年 vip.com. All rights reserved.
//

#import "RSATool.h"
//#import "Base64.h"
#import <Security/Security.h>
#import <Foundation/Foundation.h>
@implementation RSATool

static SecKeyRef _public_key=nil;

//+ (SecKeyRef) getPublicKey{ // 从公钥证书文件中获取到公钥的SecKeyRef指针
//    if(_public_key == nil){
//        NSString *path = [[NSBundle mainBundle]pathForResource:@"jsyiamsCA" ofType:@"cer"];
//        NSData *certificateData = [NSData dataWithContentsOfFile:path];
////        NSString *str22 = [NSData da]
////        NSString *rawString=[[NSString alloc]initWithData:certificateData encoding:kCFStringEncodingUTF8];
//        D("oisjgodh---%@",certificateData);
////        D("rawString---%@",rawString);
////        D("22222222---\n%@",RSA_KEY_BASE64);
////        NSData *certificateData = [NSData dataWithBase64EncodedString:RSA_KEY_BASE64];
////        NSData *certificateData = [RSA_KEY_BASE64 dataUsingEncoding:NSUTF8StringEncoding]; //[NSData dataWithBase64EncodedString:RSA_KEY_BASE64];
////        SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
//        SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
//        D("myCertificate-==%@",myCertificate);
//        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
//        SecTrustRef myTrust;
//        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
//        SecTrustResultType trustResult;
//        if (status == noErr) {
//            status = SecTrustEvaluate(myTrust, &trustResult);
//        }
//        _public_key = SecTrustCopyPublicKey(myTrust);
//        CFRelease(myCertificate);
//        CFRelease(myPolicy);
//        CFRelease(myTrust);
//        
//    }
//    return _public_key;
//}
//
//+ (NSData*) rsaEncryptString:(NSString*) string{
//    SecKeyRef key = [self getPublicKey];
//    size_t cipherBufferSize = SecKeyGetBlockSize(key);
//    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
//    NSData *stringBytes = [string dataUsingEncoding:NSUTF8StringEncoding];
//    size_t blockSize = cipherBufferSize - 11;
//    size_t blockCount = (size_t)ceil([stringBytes length] / (double)blockSize);
//    NSMutableData *encryptedData = [[NSMutableData alloc] init];
//    for (int i=0; i<blockCount; i++) {
//        int bufferSize = MIN(blockSize,[stringBytes length] - i * blockSize);
//        NSData *buffer = [stringBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
//        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes],
//                                        [buffer length], cipherBuffer, &cipherBufferSize);
//        if (status == noErr){
//            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
//            [encryptedData appendData:encryptedBytes];
//        }else{
//            if (cipherBuffer) free(cipherBuffer);
//            return nil;
//        }
//    }
//    if (cipherBuffer) free(cipherBuffer);
//    return encryptedData;
//}

+ (SecKeyRef)getPublicKey{
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"jsyiamsCA" ofType:@"cer"];
    SecCertificateRef myCertificate = nil;
    NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certPath];
//    myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
    myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    return SecTrustCopyPublicKey(myTrust);
}
+ (NSData *)encrypt:(NSString *)plainText error:(NSError **)err
{
    SecKeyRef key = [self getPublicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = NULL;
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    int blockSize = cipherBufferSize - 11;
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        int bufferSize = MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length], cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr)
        {
            NSData *encryptedBytes = [[NSData alloc]
                                       initWithBytes:(const void *)cipherBuffer
                                       length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }
        else
        {
            *err = [NSError errorWithDomain:@"errorDomain" code:status userInfo:nil];
            D("encrypt:usingKey: Error: %d", (int)status);
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
//    D("Encrypted text (%d bytes): %@",
//          [encryptedData length], [encryptedData description]);
    return encryptedData;
}
@end
