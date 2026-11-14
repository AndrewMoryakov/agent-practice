---
name: seek-animations-for-frames
description: Capture frames of a browser animation (CSS animations, transitions, Web Animations) at chosen moments by pausing every animation and setting its time, instead of waiting for the moment in real time. Use when reviewing or testing a cartoon, intro, loading sequence or any timed animation, especially a long one, and when a check must look at a specific moment.
---

# Seek Animations for Frames

A frame at second 133 of a cartoon costs 133 seconds of waiting when you wait
for it, and the machine's cores do not help: the browser plays in real time. On
a long animation this makes every review round cost minutes, so reviews get
skipped, and checks pinned to "sleep, then look" drift with load. The browser
can be told the time instead.

## Procedure

1. Open the page and let the animated content render (the animations exist
   once their elements are in the document and styled).
2. For each moment `t` (seconds from the start of the animation):

   ```js
   document.getAnimations().forEach(a => { a.pause(); a.currentTime = t * 1000; });
   await new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)));
   // now take the screenshot or read computed styles
   ```

   `currentTime` counts from the animation's start including its delay, so
   delayed and staggered animations land correctly; infinite ones land at their
   own phase. The two frames of waiting let the style apply before the shot.
3. Seek in any order; going back is as cheap as going forward.
4. To resume real time afterwards: `a.play()` on each.

## Where it does not reach

- **Script timers.** Anything driven by `setTimeout`, `setInterval` or
  `requestAnimationFrame` counters in the page's own code is not an animation
  and does not move with `currentTime`: sounds, text swapped by a timer, state
  changes. If the moment you need depends on them, either drive the page's
  clock (a fake-timer facility of your test tool) or move that behaviour into
  CSS/Web Animations where it can be seeked.
- **Animations created later.** `getAnimations()` returns what exists now. An
  element added by a timer at second 10 has no animation to seek at second 0.
- **Different start times.** All animations started at the same render share
  one clock; ones started by a later class change have their own zero. Seek
  each relative to its own start, or start them together.
- **The test tool's own animation handling.** A screenshot option that
  "disables" animations may fast-forward finite ones to their end and cancel
  infinite ones, which overrides the time you set. Take the seeked shot with
  animations allowed.

## Proving it on your page

Before trusting seeked frames for review, compare one seeked frame with one
captured by waiting, at the same exact moment (pause the waited page, read its
`currentTime`, seek the other page to that value), pixel by pixel. Accept the
method when the difference is a handful of anti-aliased pixels. A large
difference means something on the page is timer-driven (see above).

## Origin

A 160-second cartoon of a children's game (2026-11-14). Frame sheets for review
were taken by waiting: about three minutes per sheet, and the same again after
every fix. Seeking was then compared with waiting on the same page at 20, 34
and 89.5 seconds: 0, 1 and 0 differing pixels out of 343,922; the three seeked
frames took 0.5 s, the waited ones 89.5 s. The same project then used seeking
in its test of the father's story lines, which change on the cartoon's
timeline: every line was checked at the middle of its window without waiting
160 seconds.

**Confidence:** high for CSS animations in Chromium (measured); not checked in
WebKit or Firefox.
