#import "Foundation/Foundation.h"
#import "NMAppUtils.h"

NSDate *NMExpireDate(NSUInteger days)
{
	NSCalendarDate* nowDate=[NSCalendarDate dateWithNaturalLanguageString:[NSString stringWithUTF8String:__DATE__] locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
	NSCalendarDate* expireDate=[nowDate dateByAddingTimeInterval:(60*60*24*days)];
	return expireDate?expireDate:[NSDate distantPast];
}

NSString *NMOwnBundleID(void)
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
}

NSString *NMBundleIdForPID(pid_t pid)
{
	ProcessSerialNumber psn={0, 0};
	OSStatus status=GetProcessForPID(pid, &psn);
	if (status==noErr)
	{
		return [(NSDictionary *)NSMakeCollectable(ProcessInformationCopyDictionary(&psn, kProcessDictionaryIncludeAllInformationMask)) objectForKey:(NSString *)kCFBundleIdentifierKey];
	}
	return nil;
}

pid_t NMPIDForBundleId(NSString *bundleId)
{
	for(NSRunningApplication *ra in [[NSWorkspace sharedWorkspace] runningApplications])
	{
		if ([[ra bundleIdentifier] isEqualToString:bundleId]) {
			return [ra processIdentifier];
		}
	}
	return NM_BAD_PID;
}

pid_t NMActiveApplicationPid(void)
{
	return [[[[NSWorkspace sharedWorkspace] activeApplication] objectForKey:@"NSApplicationProcessIdentifier"] intValue];
}

pid_t NMFocusedApplicationPid(void)
{
	pid_t result=-1;
	AXUIElementRef system = AXUIElementCreateSystemWide();
	if (system)
	{
		AXUIElementRef focusedAppElement=NULL;
		AXUIElementCopyAttributeValue(system,(CFStringRef)kAXFocusedApplicationAttribute,(CFTypeRef*)&focusedAppElement);
		if (focusedAppElement) {
			AXUIElementGetPid(focusedAppElement, &result);
		}
		CFRelease(system);
	}
	return result;
}

NSString *NMOSVersionString(void)
{
	SInt32 versionMajor = 0;
	SInt32 versionMinor = 0;
	SInt32 versionBugfix = 0;
	Gestalt( gestaltSystemVersionMajor, &versionMajor );
	Gestalt( gestaltSystemVersionMinor, &versionMinor );
	Gestalt( gestaltSystemVersionBugFix, &versionBugfix );
	return [NSString stringWithFormat:@"%d.%d.%d", versionMajor, versionMinor, versionBugfix];
}

NSString *NMAppVersionString(void)
{
	return [NSString stringWithFormat:@"%@",
			[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

@implementation NSNumber (NMPidAdditions)
+ (NSNumber *)numberWithPid:(pid_t)pid
{
	return [NSNumber numberWithInt:pid];
}
- (pid_t)pidValue
{
	return [self intValue];
}
@end
