/**
 * Copyright (C) 2020 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */
package android.app.usage.cts.test1;

import androidx.annotation.Nullable;
import android.app.Activity;
import android.content.LocusId;
import android.os.Bundle;
import android.util.Log;
import android.view.WindowManager;

public final class SomeActivityWithLocus extends Activity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        LocusId locus = new LocusId("Locus1");
        setLocusContext(locus, null);
    }

    @Override
    protected void onStart() {
        setLocusContext(new LocusId("Locus11"), null);
    }
}
