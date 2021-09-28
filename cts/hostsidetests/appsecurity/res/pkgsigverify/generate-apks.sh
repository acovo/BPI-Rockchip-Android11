# Generating the APKs for certain methods
# Run this script from the repo's top-level directory.

# testInstallV4WithV2NoVeritySigner (without verity)
apksigner sign --v2-signing-enabled true --v3-signing-enabled false --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/dsa-3072.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/dsa-3072.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v2-Sha256withDSA.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled true --v3-signing-enabled false --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v2-Sha256withEC.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled true --v3-signing-enabled false --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-2048.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-2048.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v2-Sha256withRSA.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled true --v3-signing-enabled false --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v2-Sha512withEC.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled true --v3-signing-enabled false --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-4096.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-4096.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v2-Sha512withRSA.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk

# testInstallV4WithV2VeritySigner (with verity, and only for the DSA key / the smaller-sized keys of RSA/EC, since the verity algorithm is not used otherwise)
apksigner sign --v2-signing-enabled true --v3-signing-enabled false --v4-signing-enabled --verity-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/dsa-3072.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/dsa-3072.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v2-Sha256withDSA-Verity.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled true --v3-signing-enabled false --v4-signing-enabled --verity-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v2-Sha256withEC-Verity.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled true --v3-signing-enabled false --v4-signing-enabled --verity-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-2048.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-2048.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v2-Sha256withRSA-Verity.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk

# testInstallV4WithV3NoVeritySigner (without verity)
apksigner sign --v2-signing-enabled false --v3-signing-enabled true --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/dsa-3072.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/dsa-3072.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v3-Sha256withDSA.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled false --v3-signing-enabled true --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v3-Sha256withEC.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled false --v3-signing-enabled true --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-2048.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-2048.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v3-Sha256withRSA.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled false --v3-signing-enabled true --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v3-Sha512withEC.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled false --v3-signing-enabled true --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-4096.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-4096.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v3-Sha512withRSA.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk

# testInstallV4WithV3VeritySigner (with verity, and only for the DSA key / the smaller-sized keys of RSA/EC, since the verity algorithm is not used otherwise)
apksigner sign --v2-signing-enabled false --v3-signing-enabled true --v4-signing-enabled --verity-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/dsa-3072.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/dsa-3072.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v3-Sha256withDSA-Verity.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled false --v3-signing-enabled true --v4-signing-enabled --verity-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v3-Sha256withEC-Verity.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled false --v3-signing-enabled true --v4-signing-enabled --verity-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-2048.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/rsa-2048.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-digest-v3-Sha256withRSA-Verity.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk


# testV4IncToV3NonInc* tests
apksigner rotate --out ~/tmp/rotated_key --old-signer   --key /ssd/android/cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.pk8 --cert /ssd/android/cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.x509.pem --new-signer  --key /ssd/android/cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.pk8 --cert /ssd/android/cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.x509.pem
apksigner sign --v2-signing-enabled false --v3-signing-enabled true --v4-signing-enabled  --key cts/hostsidetests/appsecurity/certs/pkgsigverify/dsa-3072.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/dsa-3072.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-inc-to-v3-noninc-dsa-3072-appv1.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v2-signing-enabled false --v3-signing-enabled true --v4-signing-enabled  --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-inc-to-v3-noninc-ec-p256-appv1.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v1-signing-enabled false --v2-signing-enabled false --v3-signing-enabled true  --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-inc-to-v3-noninc-ec-p384-rotated-ec-p256-appv2.apk --lineage /tmp/ec_p256_to_ec_384_rotated_key cts/hostsidetests/appsecurity/res/pkgsigverify/originalv2.apk
apksigner sign --v1-signing-enabled false --v2-signing-enabled false --v3-signing-enabled true  --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-inc-to-v3-noninc-ec-p384-appv2.apk cts/hostsidetests/appsecurity/res/pkgsigverify/originalv2.apk
apksigner sign --v2-signing-enabled false --v3-signing-enabled true --v4-signing-enabled  --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-inc-to-v3-noninc-ec-p256-appv2.apk cts/hostsidetests/appsecurity/res/pkgsigverify/originalv2.apk

# testV4IncToV2NonInc* tests
apksigner sign --v2-signing-enabled true --v3-signing-enabled false --v4-signing-enabled  --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-inc-to-v2-noninc-ec-p256-appv1.apk cts/hostsidetests/appsecurity/res/pkgsigverify/original.apk
apksigner sign --v1-signing-enabled false --v2-signing-enabled true --v3-signing-enabled false  --v4-signing-enabled --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p384.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-inc-to-v2-noninc-ec-p384-appv2.apk cts/hostsidetests/appsecurity/res/pkgsigverify/originalv2.apk
apksigner sign --v2-signing-enabled true --v3-signing-enabled false --v4-signing-enabled  --key cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.pk8 --cert cts/hostsidetests/appsecurity/certs/pkgsigverify/ec-p256.x509.pem -out cts/hostsidetests/appsecurity/res/pkgsigverify/v4-inc-to-v2-noninc-ec-p256-appv2.apk cts/hostsidetests/appsecurity/res/pkgsigverify/originalv2.apk