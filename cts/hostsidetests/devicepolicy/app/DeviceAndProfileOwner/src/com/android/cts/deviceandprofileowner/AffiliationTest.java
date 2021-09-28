/*
 * Copyright (C) 2019 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.android.cts.deviceandprofileowner;

import static com.android.cts.deviceandprofileowner.BaseDeviceAdminTest.ADMIN_RECEIVER_COMPONENT;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertFalse;
import static junit.framework.Assert.assertTrue;
import static junit.framework.Assert.fail;

import static org.junit.Assert.assertArrayEquals;

import android.app.admin.DevicePolicyManager;
import android.content.Context;

import androidx.test.InstrumentationRegistry;
import androidx.test.runner.AndroidJUnit4;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.util.Collections;
import java.util.Set;

@RunWith(AndroidJUnit4.class)
public class AffiliationTest {

    private DevicePolicyManager mDevicePolicyManager;

    @Before
    public void setUp() {
        Context context = InstrumentationRegistry.getContext();
        mDevicePolicyManager = (DevicePolicyManager)
                context.getSystemService(Context.DEVICE_POLICY_SERVICE);
    }

    @Test
    public void testSetAffiliationId1() {
        setAffiliationIds(Collections.singleton("id.number.1"));
    }

    @Test
    public void testSetAffiliationId2() {
        setAffiliationIds(Collections.singleton("id.number.2"));
    }

    @Test
    public void testLockTaskMethodsThrowExceptionIfUnaffiliated() {
        checkLockTaskMethodsThrow();
    }

    /** Assumes that the calling user is already affiliated before calling this method */
    @Test
    public void testSetLockTaskPackagesClearedIfUserBecomesUnaffiliated() {
        final String[] packages = {"package1", "package2"};
        mDevicePolicyManager.setLockTaskPackages(ADMIN_RECEIVER_COMPONENT, packages);
        assertArrayEquals(packages,
                mDevicePolicyManager.getLockTaskPackages(ADMIN_RECEIVER_COMPONENT));
        assertTrue(mDevicePolicyManager.isLockTaskPermitted("package1"));
        assertFalse(mDevicePolicyManager.isLockTaskPermitted("package3"));

        final Set<String> previousAffiliationIds =
                mDevicePolicyManager.getAffiliationIds(ADMIN_RECEIVER_COMPONENT);
        try {
            // Clearing affiliation ids for this user. Lock task methods unavailable.
            setAffiliationIds(Collections.emptySet());
            checkLockTaskMethodsThrow();
            assertFalse(mDevicePolicyManager.isLockTaskPermitted("package1"));

            // Affiliating the user again. Previously set packages have been cleared.
            setAffiliationIds(previousAffiliationIds);
            assertEquals(0,
                    mDevicePolicyManager.getLockTaskPackages(ADMIN_RECEIVER_COMPONENT).length);
            assertFalse(mDevicePolicyManager.isLockTaskPermitted("package1"));
        } finally {
            mDevicePolicyManager.setAffiliationIds(ADMIN_RECEIVER_COMPONENT,
                    previousAffiliationIds);
        }
    }

    private void setAffiliationIds(Set<String> ids) {
        mDevicePolicyManager.setAffiliationIds(ADMIN_RECEIVER_COMPONENT, ids);
        assertEquals(ids, mDevicePolicyManager.getAffiliationIds(ADMIN_RECEIVER_COMPONENT));
    }

    private void checkLockTaskMethodsThrow() {
        try {
            mDevicePolicyManager.setLockTaskPackages(ADMIN_RECEIVER_COMPONENT, new String[0]);
            fail("setLockTaskPackages did not throw expected SecurityException");
        } catch (SecurityException expected) {
        }
        try {
            mDevicePolicyManager.getLockTaskPackages(ADMIN_RECEIVER_COMPONENT);
            fail("getLockTaskPackages did not throw expected SecurityException");
        } catch (SecurityException expected) {
        }
    }
}
