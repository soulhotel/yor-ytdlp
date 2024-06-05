## Your very own YT-DLP Tool

This script simplifies the use of yt-dlp, when the User often desires multiple different outputs. It does this through its user-friendly "menu's" that guide the user with simple 1-2-3 steps. By guiding the user through commonly requested options with clear prompts, this script makes yt-dlp easier to use  with minimal effort.

Also its lightweight (7.4kb) compared to the alternative of GUI applications that could exceed 100mb (like electron apps..).

## How it works

1. The User can input a URL or press ENTER to default to URLs in ~/Downloads/ytdlp/url.txt
   - ✔ The script validates URLs and creates the directory for you
   - ✔ Multiple URLs in the url.txt can batch custom download
   - ✔ Entering a Playlist URL can batch custom download
   - ✔ Drag & Drop URLs into the script to select it

2. The User selects audio or video
 
3. The User decides if they want a playlist or single file (if applicable) 

4. The User determines what quality they would like

5. Subtitles, yes, no, embedded? (for videos)

6. Restrict file name? keeping it short.
 
7. Finally, destination. Press ENTER to default to Downloads/ytdlp/ or Specify a folder path.

###### Note: This script (by default) downloads the best format available for videos, it *may* result in recieving an .mkv file for one video and .mp4 file for another video. Meanwhile, mp3s defaults to best quality possible with embed thumbnail/cover-art.

## See it in action

https://github.com/soulhotel/yor-ytdlp/assets/155501797/b74a18d4-a7ca-4e95-ad68-40612333202b

## Usage

- Git clone this repo or download the source above
- Make the script an executable then run it
- Drag a URL in, or use the text file
- Make your choices
- Profit

```
git clone https://github.com/soulhotel/yor-ytdlp.git
```
```
cd yor-ytdlp
chmod +x yor-ytdlp.sh
```

To have it show up in your applications list and searches
- place the .desktop file in the appropriate directory, usually `/home/user/.local/share/applications`.
- If you place the script somewhere other than `~/yor-ytdlp/` then open the .desktop file and make sure the Exec path is set accordingly.

