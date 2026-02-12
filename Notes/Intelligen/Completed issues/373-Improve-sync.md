---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-05-30T12:13
tags:
  - intelligen
status: completed
product: ScpCloud
---

Ξ¤ΞΏ Ξ²ΟΞ®ΞΊΞ± Ο„ΞΏ Ο€ΟΟΞ²Ξ»Ξ·ΞΌΞ±. Ξ¦Ξ±Ξ―Ξ½ΞµΟ„Ξ±ΞΉ ΟΟ„ΞΉ ΟΟ„Ξ±Ξ½ ΟƒΟ„ΞΏ sync Ο…Ο€ΞΏΞ»ΞΏΞ³Ξ―Ξ¶ΞΏΟ…ΞΌΞµ Ο„Ξ± overlapping batches Ξ΄ΞµΞ½ ΟƒΞΊΞµΟ†Ο„Ξ®ΞΊΞ±ΞΌΞµ (ΟƒΞΊΞ­Ο†Ο„Ξ·ΞΊΞ±) Ο„Ξ·Ξ½ Ο€ΞµΟΞ―Ο€Ο„Ο‰ΟƒΞ· Ξ½Ξ± ΞµΞ―Ο‡Ξ±ΞΌΞµ Ξ­Ξ½Ξ± ΞΌΞ±ΞΊΟΟ batch ΞΌΞµ conflict ΞΌΞµ Ο„ΞΏ ΞµΟ€ΟΞΌΞµΞ½ΞΏ batch, Ο„ΞΏ ΞΏΟ€ΞΏΞ―ΞΏ Ξ½Ξ± ΞΊΞΏΞ½Ο„Ξ±Ξ―Ξ½ΞµΞΉ ΞΊΞ±ΞΉ Ξ¬ΟΞ± Ξ½Ξ± ΞΌΞ·Ξ½ ΞΊΞ¬Ξ½ΞµΞΉ Ο€ΞΉΞ± overlap (ΞΏΟΟ„Ξµ conflict) ΞΌΞµ Ο„ΞΏ ΞµΟ€ΟΞΌΞµΞ½ΞΏ. Ξ•Ο€ΞµΞΉΞ΄Ξ® Ξ΄ΞµΞ½ ΞΊΞ¬Ξ½ΞµΞΉ overlap Ξ΄ΞµΞ½ ΞΈΞ± Ξ±Ξ½Ξ±Ξ½ΞµΟ‰ΞΈΞΏΟΞ½ Ο„Ξ± eocData Ο„ΞΏΟ….
 
Ξ— ΟƒΟ…Ξ½Ξ®ΞΈΞ·Ο‚ ΞΊΞ±Ο„Ξ¬ΟƒΟ„Ξ±ΟƒΞ· ΞµΞ―Ξ½Ξ±ΞΉ Ο„ΞΏ batch Ξ½Ξ± ΞΌΞ±ΞΊΟΞ±Ξ―Ξ½ΞµΞΉ, Ξ±Ξ»Ξ»Ξ¬ Ο€Ξ±Ξ―Ξ¶ΞΏΞ½Ο„Ξ±Ο‚ ΞΌΞµ Ο„ΞΏ revert Ο„Ο‰Ξ½ updates ΞµΞ―Ο‡Ξ± Ο„Ξ·Ξ½ Ξ±Ξ½Ο„Ξ―ΞΈΞµΟ„Ξ· Ο€ΞµΟΞ―Ο€Ο„Ο‰ΟƒΞ· ΞΊΞ±ΞΉ Ξ­Ο„ΟƒΞΉ ΞµΞ―Ξ΄Ξ± Ο„ΞΏ Ο€ΟΟΞ²Ξ»Ξ·ΞΌΞ±
 
ΞΟ‡Ο‰ ΞΌΞΉΞ± ΞΊΞ±Ξ»Ξ® Ξ»ΟΟƒΞ· Ξ½ΞΏΞΌΞ―Ξ¶Ο‰. Ξ‘Ξ½ ΟƒΟΞ¶ΞΏΟ…ΞΌΞµ Ο„Ξ± Start/End Ο„Ο‰Ξ½ batches ΞΊΞ±Ο„Ξ¬ Ο„ΞΏ sync ==(Ξ±Ο…Ο„Ο Ξ³Ξ―Ξ½ΞµΟ„Ξ±ΞΉ ΟƒΟ„ΞΏ batchcontents)==, ΞΌΟ€ΞΏΟΞΏΟΞΌΞµ Ξ½Ξ± Ο„ΟƒΞµΞΊΞ¬ΟΞΏΟ…ΞΌΞµ Ο„ΞΏ overlap ΞΊΞ±ΞΉ ΞΌΞµ Ο„Ξ± Ξ΄ΟΞΏ Ξ¶ΞµΟΞ³Ξ· (Start/End ΞΊΞ±ΞΉ SyncStart/SyncEnd)  
Ξ”Ξ·Ξ»Ξ±Ξ΄Ξ® ΞΌΞ±Ο‚ ΞµΞ½Ξ΄ΞΉΞ±Ο†Ξ­ΟΞµΞΉ Ξ½Ξ± ΞΊΞ¬Ξ½ΞΏΟ…ΞΌΞµ update Ο„Ξ± batches Ο€ΞΏΟ… ΞµΞ―Ο„Ξµ Ο„ΟΟΞ± ΞΊΞ¬Ξ½ΞΏΟ…Ξ½ overlap ΞµΞ―Ο„Ξµ ΞΊΞ¬Ξ½Ξ±Ξ½ overlap ΟƒΟ„ΞΏ Ο€ΟΞΏΞ·Ξ³ΞΏΟΞΌΞµΞ½ΞΏ sync
 
Gia concurrency token poy den yparxei sto scheduling board ta svino sto production  
Gia concurrencty token poy allaxe vgazo olo  
Gia ta concurrency token poy den exoyn allaxei stelnei mono ta eocdata gia batches poy exoyn lower priority (precedence)
      



![[373-Improve-sync - Ink.svg|641x372]]


![[image-9.png]]


- [ ] full-sync  na ginei  full-production-sync 
- [ ] kai republish-all neo endpoint




