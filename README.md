# prorec

Encoding/converting pre-records into readable formats for AE/SV
Video with render time comparisons: https://www.youtube.com/watch?v=YAbM7c9nOTo
this tool converts heavily compressed video files into readable formats suited for video editing. 

## Requirements

* **[prorec.bat](https://github.com/gmzorz/prerecs/archive/master.zip)**
* [Xvid](https://www.xvid.com/download/) (download & install)
* [quicktime](https://support.apple.com/kb/DL837) (download & install)
* [ffmpeg](https://drive.google.com/uc?export=download&id=1ozqMctkULuvVtCogmyZjXGjw7Q9D-Je0) (this file must be placed in `C:\Windows\System32` or the directory of `prorec.bat` in order for it to work)

## Instructions & Usage
Download the requirements and install them accordingly. Place prorec.bat in any directory containing the footage to be converted and run it. Drag & drop works, but does not support multiple files. 

### Choosing a codec
There are notable differences between each codec, Whether you choose to go with prores completely relies on how much time you have, but also whether you want the most optimal quality. If you decide to go with xvid, expect very fast encoding speeds and small file sizes. The following table contains information about footage encoded into the formats described (2560x1440) Using Intel i5-6400 CPU @ 2.70GHz

| Codec | Encoding time | Playback time (AE) | File size |
|---|---|---|---|
| prores | 7 FPS | 16 FPS | 1.64 MB/Frame |
| xvid | 81 FPS | 9 FPS | 0.10 MB/Frame |

Another handy (visual) guide are the following difference mattes, which display the difference in pixels (white being different to original footage).
Tolerance level = 1.0%

| XVID | PRORES |
|---|---|
| <img src="http://gmzorz.com/img/diffXVID.png" width="512" height="288"></img> | <img src="http://gmzorz.com/img/diffPRORES.png" width="512" height="288"></img> |

