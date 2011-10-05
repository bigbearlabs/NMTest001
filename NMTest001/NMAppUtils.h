/*
 Utility functions relating to applications, pids, etc.
 */

#define NM_BAD_PID ((pid_t)(-1))

NSDate *NMExpireDate(NSUInteger days);

NSString *NMOwnBundleID(void);

NSString *NMBundleIdForPID(pid_t pid);

pid_t NMPIDForBundleId(NSString *bundleId);

pid_t NMActiveApplicationPid(void);

pid_t NMFocusedApplicationPid(void);

NSString *NMOSVersionString(void);

NSString *NMAppVersionString(void);

@interface NSNumber (NMPidAdditions)
+ (NSNumber *)numberWithPid:(pid_t)pid;
- (pid_t)pidValue;
@end
