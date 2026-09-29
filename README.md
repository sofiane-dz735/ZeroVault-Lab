# ZeroVault - Reentrancy Lab

مخبر تعليمي لثغرة Reentrancy التي سرقت +100M$ في 2022.

## الثغرة
ضعيف: يرسل قبل ما ينقص

## الحل
محمي: ينقص قبل ما يرسل (CEI)

## النتيجة
Before: PASS - Bank drained
After: FAIL - Attack blocked

forge test -vvv
