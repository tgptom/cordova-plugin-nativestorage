#import "NativeStorage.h"
#import <Cordova/CDVPlugin.h>
#import <CommonCrypto/CommonCrypto.h>

@interface NativeStorage()
@property (nonatomic, strong) NSUserDefaults *appGroupUserDefaults;
@property (nonatomic, copy) NSString *suiteName;
@end

@implementation NativeStorage

- (void) initWithSuiteName: (CDVInvokedUrlCommand*) command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSString* aSuiteName = [command.arguments objectAtIndex:0];
        
        if(aSuiteName!=nil)
        {
            _suiteName = aSuiteName;
            _appGroupUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:_suiteName];
	    pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK];
        }
        else
        {
            pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Reference or SuiteName was null"];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
    }];
}

- (NSUserDefaults*) getUserDefault {
	if (_suiteName != nil)
	{
        return _appGroupUserDefaults;
	}
	return [NSUserDefaults standardUserDefaults];
}

- (void) remove: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];

		if(reference!=nil)
		{
			NSUserDefaults *defaults = [self getUserDefault];
			[defaults removeObjectForKey: reference];
			BOOL success = [defaults synchronize];
			if(success) pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK];
			else pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Remove has failed"];
		}
		else
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Reference was null"];
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}

- (void) clear: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSUserDefaults *defaults = [self getUserDefault];
		if (_suiteName != nil) {
			[defaults removePersistentDomainForName:_suiteName];
		} else {
			[defaults removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
		}
		BOOL success = [defaults synchronize];
		if(success) pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK];
		else pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Clear has failed"];
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}

- (void) putBoolean: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];
		BOOL aBoolean = [[command.arguments objectAtIndex:1] boolValue];

		if(reference!=nil)
		{
			NSUserDefaults *defaults = [self getUserDefault];
			[defaults setBool: aBoolean forKey:reference];
			BOOL success = [defaults synchronize];
			if(success) pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsBool:aBoolean];
			else pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Write has failed"];
		}
		else
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Reference was null"];
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}
- (void) getBoolean: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];

		if(reference!=nil)
		{
			BOOL aBoolean = [[self getUserDefault] boolForKey:reference];
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsBool:aBoolean];
		}
		else
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Reference was null"];
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}

- (void) putInt: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];
		NSInteger anInt = [[command.arguments objectAtIndex:1] integerValue];

		if(reference!=nil)
		{
			NSUserDefaults *defaults = [self getUserDefault];
			[defaults setInteger: anInt forKey:reference];
			BOOL success = [defaults synchronize];
			if(success) pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsNSInteger:anInt];
			else pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Write has failed"];
		}
		else
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Reference was null"];
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}
- (void) getInt: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];

		if(reference!=nil)
		{
			NSInteger anInt = [[self getUserDefault] integerForKey:reference];
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsNSInteger:anInt];
		}
		else
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Reference was null"];
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}


- (void) putDouble: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];
		double aDouble = [[command.arguments objectAtIndex:1] doubleValue];

		if(reference!=nil)
		{
			NSUserDefaults *defaults = [self getUserDefault];
			[defaults setDouble: aDouble forKey:reference];
			BOOL success = [defaults synchronize];
			if(success) pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDouble:aDouble];
			else pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Write has failed"];
		}
		else
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Reference was null"];
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}
- (void) getDouble: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];

		if(reference!=nil)
		{
			double aDouble = [[self getUserDefault] doubleForKey:reference];
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDouble:aDouble];
		}
		else
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Reference was null"];
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}

- (void) putString: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];
		NSString* aString = [command.arguments objectAtIndex:1];

		if(reference!=nil)
		{
			NSUserDefaults *defaults = [self getUserDefault];
			[defaults setObject: aString forKey:reference];
			BOOL success = [defaults synchronize];
			if(success) pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:aString];
			else pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Write has failed"];

		}
		else
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Reference was null"];
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}
- (void) getString: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];

		if(reference!=nil)
		{
			NSString* aString = [[self getUserDefault] stringForKey:reference];
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:aString];
		}
		else
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Reference was null"];
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}


- (void) setItem: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];
		NSString* aString = [command.arguments objectAtIndex:1];

		if(reference==nil || [aString class] == [NSNull class])
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsInt:3];
		}
		else
		{
			NSUserDefaults *defaults = [self getUserDefault];
			[defaults setObject: aString forKey:reference];
			BOOL success = [defaults synchronize];
			if(success) pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:aString];
			else pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsInt:1]; //Write has failed
		}

		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}

- (void) getItem: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];

		if(reference!=nil)
		{
			NSString* aString = [[self getUserDefault] stringForKey:reference];
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:aString];
			if(aString==nil)
			{
				pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsInt:2]; //Ref not found
			}
		}
		else
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsInt:3]; //Reference was null
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}

#pragma mark - Password-based secret storage (CommonCrypto PBKDF2 + AES-CBC)

// Crypto parameters intentionally match the Android Crypto.java implementation so that
// ciphertexts produced on one platform can be decrypted on the other:
//   - Algorithm:   PBKDF2-SHA1 (kCCPRFHmacAlgSHA1)
//   - Iterations:  10,000
//   - Salt length: 8 bytes (PKCS5_SALT_LENGTH)
//   - Key length:  256 bits (AES-256)
//   - IV length:   16 bytes (AES block size)
//   - Cipher:      AES/CBC/PKCS7Padding
//   - Delimiter:   "@~@~@" between base64(salt), base64(iv), base64(ciphertext)

// Derives a 256-bit AES key from a password and salt using PBKDF2-SHA1.
- (NSData *)deriveKeyFromPassword:(NSString *)password salt:(NSData *)salt
{
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *derivedKey = [NSMutableData dataWithLength:kCCKeySizeAES256];
    CCStatus status = CCKeyDerivationPBKDF(kCCPBKDF2,
                         passwordData.bytes, passwordData.length,
                         salt.bytes, salt.length,
                         kCCPRFHmacAlgSHA1,
                         10000,
                         derivedKey.mutableBytes, derivedKey.length);
    if (status != kCCSuccess) {
        return nil;
    }
    return derivedKey;
}

// Encrypts plaintext using AES-256-CBC with a PBKDF2-derived key.
// Returns a Base64 string of the format: base64(salt) + "@~@~@" + base64(iv) + "@~@~@" + base64(ciphertext)
- (NSString *)encryptString:(NSString *)plaintext withPassword:(NSString *)password
{
    NSData *plaintextData = [plaintext dataUsingEncoding:NSUTF8StringEncoding];

    // Generate random 8-byte salt and 16-byte IV
    NSMutableData *salt = [NSMutableData dataWithLength:8];
    if (SecRandomCopyBytes(kSecRandomDefault, salt.length, salt.mutableBytes) != errSecSuccess) {
        return nil;
    }
    NSMutableData *iv = [NSMutableData dataWithLength:kCCBlockSizeAES128];
    if (SecRandomCopyBytes(kSecRandomDefault, iv.length, iv.mutableBytes) != errSecSuccess) {
        return nil;
    }

    NSData *key = [self deriveKeyFromPassword:password salt:salt];
    if (key == nil) {
        return nil;
    }

    size_t bufferSize = plaintextData.length + kCCBlockSizeAES128;
    NSMutableData *cipherData = [NSMutableData dataWithLength:bufferSize];
    size_t bytesEncrypted = 0;
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES,
                                     kCCOptionPKCS7Padding,
                                     key.bytes, key.length,
                                     iv.bytes,
                                     plaintextData.bytes, plaintextData.length,
                                     cipherData.mutableBytes, bufferSize,
                                     &bytesEncrypted);
    if (status != kCCSuccess) {
        return nil;
    }
    cipherData.length = bytesEncrypted;

    NSString *saltB64 = [salt base64EncodedStringWithOptions:0];
    NSString *ivB64   = [iv base64EncodedStringWithOptions:0];
    NSString *ctB64   = [cipherData base64EncodedStringWithOptions:0];
    return [NSString stringWithFormat:@"%@@~@~@%@@~@~@%@", saltB64, ivB64, ctB64];
}

// Decrypts a ciphertext produced by encryptString:withPassword:.
- (NSString *)decryptString:(NSString *)ciphertext withPassword:(NSString *)password
{
    NSArray *parts = [ciphertext componentsSeparatedByString:@"@~@~@"];
    if (parts.count != 3) {
        return nil;
    }

    NSData *salt      = [[NSData alloc] initWithBase64EncodedString:parts[0] options:0];
    NSData *iv        = [[NSData alloc] initWithBase64EncodedString:parts[1] options:0];
    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:parts[2] options:0];

    if (!salt || !iv || !cipherData) {
        return nil;
    }

    NSData *key = [self deriveKeyFromPassword:password salt:salt];

    size_t bufferSize = cipherData.length + kCCBlockSizeAES128;
    NSMutableData *plainData = [NSMutableData dataWithLength:bufferSize];
    size_t bytesDecrypted = 0;
    CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmAES,
                                     kCCOptionPKCS7Padding,
                                     key.bytes, key.length,
                                     iv.bytes,
                                     cipherData.bytes, cipherData.length,
                                     plainData.mutableBytes, bufferSize,
                                     &bytesDecrypted);
    if (status != kCCSuccess) {
        return nil;
    }
    plainData.length = bytesDecrypted;
    return [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
}

- (void) setItemWithPassword: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];
		NSString* aString   = [command.arguments objectAtIndex:1];
		NSString* password  = [command.arguments objectAtIndex:2];

		if (reference == nil || [reference isKindOfClass:[NSNull class]] ||
		    aString == nil   || [aString isKindOfClass:[NSNull class]] ||
		    password == nil  || [password isKindOfClass:[NSNull class]])
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsInt:3]; // NULL_REFERENCE
		}
		else
		{
			NSString *ciphertext = [self encryptString:aString withPassword:password];
			if (ciphertext == nil) {
				pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Encryption failed"];
			} else {
				NSUserDefaults *defaults = [self getUserDefault];
				[defaults setObject:ciphertext forKey:reference];
				BOOL success = [defaults synchronize];
				if (success) pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:aString];
				else pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsInt:1]; // NATIVE_WRITE_FAILED
			}
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}

- (void) getItemWithPassword: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSString* reference = [command.arguments objectAtIndex:0];
		NSString* password  = [command.arguments objectAtIndex:1];

		if (reference == nil || [reference isKindOfClass:[NSNull class]] ||
		    password == nil  || [password isKindOfClass:[NSNull class]])
		{
			pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsInt:3]; // NULL_REFERENCE
		}
		else
		{
			NSString* ciphertext = [[self getUserDefault] stringForKey:reference];
			if (ciphertext == nil) {
				pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsInt:2]; // ITEM_NOT_FOUND
			} else {
				NSString *plaintext = [self decryptString:ciphertext withPassword:password];
				if (plaintext == nil) {
					pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:@"Decryption failed"];
				} else {
					pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:plaintext];
				}
			}
		}
		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}

- (void) keys: (CDVInvokedUrlCommand*) command
{
	[self.commandDelegate runInBackground:^{
		CDVPluginResult* pluginResult = nil;
		NSArray *keys = [[[self getUserDefault] dictionaryRepresentation] allKeys];
		pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsArray:keys];

		[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
	}];
}


@end
