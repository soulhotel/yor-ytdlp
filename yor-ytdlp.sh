#!/bin/bash

# https://github.com/soulhotel

yellow='\033[1;33m'
red='\033[1;31m'
green='\033[1;32m'
nocolor='\033[0m'

initialize_url_file() {
    local url_dir="$HOME/Downloads/ytdlp"
    local url_file="$url_dir/url.txt"
    
    # Create directory if it doesn't exist
    if [[ ! -d "$url_dir" ]]; then
        mkdir -p "$url_dir"
    fi
    
    # Create file if it doesn't exist
    if [[ ! -f "$url_file" ]]; then
        touch "$url_file"
    fi
}

main_menu() {
    while true; do
        clear
        echo -n -e "
             YT-DLP Simplified Script
             
 Input a Url, or default to all urls found in ~/Downloads/ytdlp/url.txt

 ${yellow}Note: The script will take 2 extra seconds to validate the Url.${nocolor}

 ${green}Tip: You can also DRAG & DROP the URL right into the terminal!${nocolor}

 Input Url or press ENTER to read from text file: "
        read input_path

        if [[ -z "$input_path" ]]; then
            input_path="$HOME/Downloads/ytdlp/url.txt"
            if [[ ! -f "$input_path" || ! -s "$input_path" ]]; then
                echo -e "\n${red}No URL provided and default URL file is either missing or empty.${nocolor}"
                sleep 2
                continue
            fi
            url_count=$(wc -l < "$input_path")
            url_message="$url_count URLs in the text file"
        else
            url_title=$(yt-dlp --get-title "$input_path" 2>/dev/null)
            url_message="${url_title:-URL}"
        fi

        select_format
    done
}

select_format() {
    while true; do
        clear
        echo -n -e "
             YT-DLP Simplified Script

  You have selected \"$url_message\"

  Type (1) for mp3
  Type (2) for video
  Type (3) to return to the Main Menu
  Type (4) to Exit

  Which would you like (1-4): "
        read format_choice

        case $format_choice in
            1) format="mp3"; playlist_or_single;;
            2) format="mp4"; playlist_or_single;;
            3) main_menu;;
            4) exit 0;;
            *) echo "Invalid option. Please try again.";;
        esac
    done
}

playlist_or_single() {
    if [[ "$input_path" == "$HOME/Downloads/ytdlp/url.txt" ]]; then
        # Input is from the text file, skip playlist or single page and go to quality check
        quality_check
    else
        # Proceed with the playlist or single page
        while true; do
            clear
            echo -n -e "
                 YT-DLP Simplified Script
  
      Set to download \"$url_message\" as \"$format\"
  
      Yes to Playlist or Single File?
  
      Type (1) for playlist
      Type (2) for single file
      Type (3) for Main Menu
      Type (4) to exit
  
      Which would you like (1-4): "
            read playlist_choice
  
            case $playlist_choice in
                1) playlist_flag=""; quality_check;;
                2) playlist_flag="--no-playlist"; quality_check;;
                3) main_menu;;
                4) exit 0;;
                *) echo "Invalid option. Please try again.";;
            esac
        done
    fi
}

quality_check() {
    if [[ "$format" == "mp4" ]]; then
        while true; do
            clear
            echo -n -e "
             YT-DLP Simplified Script

  Video quality options:

  Type (1) for Best Quality
  Type (2) for 1080p 60fps
  Type (3) for 720p 60fps
  Type (4) for 720p
  Type (5) for Main Menu
  Type (6) to exit

  Which would you like (1-6): "
            read quality_choice

            case $quality_choice in
                1) quality="best"; subtitle_check;;
                2) quality="bestvideo[height<=1080][fps<=60]+bestaudio/best"; subtitle_check;;
                3) quality="bestvideo[height<=720][fps<=60]+bestaudio/best"; subtitle_check;;
                4) quality="bestvideo[height<=720]+bestaudio/best"; subtitle_check;;
                5) main_menu;;
                6) exit 0;;
                *) echo "Invalid option. Please try again.";;
            esac
        done
    else
        quality=""
        subtitle_check
    fi
}

subtitle_check() {
    if [[ "$format" == "mp4" ]]; then
        while true; do
            clear
            echo -n -e "
             YT-DLP Simplified Script

  ${yellow}Note: yt-dlp may fail to detect auto-generated subtitles. This is no fault of yt-dlp, but possibly the requested Website itself.${nocolor}

  Subtitle options:

  Type (1) for No Subtitles
  Type (2) for Subtitles
  Type (3) for Embedded Subtitles
  Type (4) for Main Menu
  Type (5) to exit

  Which would you like (1-5): "
            read subtitle_choice

            case $subtitle_choice in
                1) subtitle_flag=""; restrict_filename_check;;
                2) subtitle_flag="--write-sub --sub-lang en"; restrict_filename_check;;
                3) subtitle_flag="--write-sub --sub-lang en --embed-subs"; restrict_filename_check;;
                4) main_menu;;
                5) exit 0;;
                *) echo "Invalid option. Please try again.";;
            esac
        done
    else
        subtitle_flag=""
        restrict_filename_check
    fi
}

restrict_filename_check() {
    while true; do
        clear
        echo -n -e "
             YT-DLP Simplified Script

  Restrict file names? (keep file names short)

  Type (1) for Yes
  Type (2) for No
  Type (3) for Main Menu
  Type (4) to exit

  Which would you like (1-4): "
        read restrict_filename_choice

        case $restrict_filename_choice in
            1) restrict_filename_flag="--restrict-filenames"; output_folder_check;;
            2) restrict_filename_flag=""; output_folder_check;;
            3) main_menu;;
            4) exit 0;;
            *) echo "Invalid option. Please try again.";;
        esac
    done
}

output_folder_check() {
    clear
    echo -n -e "
             YT-DLP Simplified Script

  Input folder path, or press ENTER to default to ~/Downloads/ytdlp folder: "
    read output_folder

    if [[ -z "$output_folder" ]]; then
        output_folder="$HOME/Downloads/ytdlp"
    fi

    run_yt_dlp
}

run_yt_dlp() {
    mkdir -p "$output_folder"
    output_template="$output_folder/%(title)s.%(ext)s"

    # Check if the input path is the default text file path
    if [[ "$input_path" == "$HOME/Downloads/ytdlp/url.txt" ]]; then
        # Read URLs from the text file and process each one individually
        while IFS= read -r url; do
            if [[ "$format" == "mp3" ]]; then
                yt-dlp -i $playlist_flag $restrict_filename_flag --extract-audio --audio-format mp3 --embed-thumbnail --output "$output_template" "$url"
            else
                yt-dlp -i $playlist_flag $restrict_filename_flag $subtitle_flag --format "$quality" --output "$output_template" "$url"
            fi
        done < "$input_path"
    else
        # Proceed as usual
        if [[ "$format" == "mp3" ]]; then
            yt-dlp -i $playlist_flag $restrict_filename_flag --extract-audio --audio-format mp3 --embed-thumbnail --output "$output_template" "$input_path"
        else
            yt-dlp -i $playlist_flag $restrict_filename_flag $subtitle_flag --format "$quality" --output "$output_template" "$input_path"
        fi
    fi

    echo -e "\n${yellow}Task complete: Review the YTDLP log for any questions. Want to do another?${nocolor}"
    echo -e "\nPress ENTER to return to the Main Menu"
    read -r another

    if [[ -z "$another" ]]; then
        main_menu
    else
        exit 0
    fi
}

main_menu
