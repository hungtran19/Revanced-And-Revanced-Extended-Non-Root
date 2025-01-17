#!/bin/bash
# Revanced build
source src/build/utils.sh

release=$(curl -s "https://api.github.com/repos/revanced/revanced-patches/releases/latest")
asset=$(echo "$release" | jq -r '.assets[] | select(.name | test("revanced-patches.*\\.jar$")) | .browser_download_url')
curl -sL -O "$asset"
ls revanced-patches*.jar >> new.txt
rm -f revanced-patches*.jar
release=$(curl -s "https://api.github.com/repos/$repository/releases/latest")
asset=$(echo "$release" | jq -r '.assets[] | select(.name == "revanced-version.txt") | .browser_download_url')
curl -sL -O "$asset"
if diff -q revanced-version.txt new.txt >/dev/null ; then
echo "Old patch!!! Not build"
exit 0
else
rm -f *.txt

dl_gh "revanced-patches revanced-cli revanced-integrations" "revanced" "latest"

# Patch Instagram:
get_patches_key "instagram"
version="271.1.0.21.84"
get_apk "instagram-arm64-v8a" "instagram-instagram" "instagram/instagram-instagram/instagram-instagram" "arm64-v8a"
patch "instagram-arm64-v8a" "instagram/instagram-arm64-v8a-revanced"
get_patches_key "instagram"
version="271.1.0.21.84"
get_apk "instagram-armeabi-v7a" "instagram-instagram" "instagram/instagram-instagram/instagram-instagram" "armeabi-v7a"
patch "instagram-armeabi-v7a" "instagram/instagram-armeabi-v7a-revanced"

# Patch Messenger:
get_patches_key "messenger"
get_apk "messenger-arm64-v8a" "messenger" "facebook-2/messenger/messenger" "arm64-v8a"
patch "messenger-arm64-v8a" "messenger/messenger-arm64-v8a-revanced"
get_patches_key "messenger"
get_apk "messenger-armeabi-v7a" "messenger" "facebook-2/messenger/messenger" "armeabi-v7a"
patch "messenger-armeabi-v7a" "messenger/messenger-armeabi-v7a-revanced"

# Patch YouTube Music:
get_patches_key "youtube-music-revanced"
get_ver "hide-get-premium" "com.google.android.apps.youtube.music"
get_apk "youtube-music-arm64-v8a" "youtube-music" "google-inc/youtube-music/youtube-music" "arm64-v8a"
patch "youtube-music-arm64-v8a" "youtube-music/youtube-music-arm64-v8a-revanced"
get_ver "hide-get-premium" "com.google.android.apps.youtube.music"
get_patches_key "youtube-music-revanced"
get_apk "youtube-music-armeabi-v7a" "youtube-music" "google-inc/youtube-music/youtube-music" "armeabi-v7a"
patch "youtube-music-armeabi-v7a" "youtube-music/youtube-music-armeabi-v7a-revanced"

# Patch YouTube:
get_patches_key "youtube-revanced"
get_ver "video-ads" "com.google.android.youtube"
get_apk "youtube" "youtube" "google-inc/youtube/youtube"
patch "youtube" "youtube-revanced"

# Patch Twitter:
get_patches_key "twitter"
version="9.86.0-release.0"
get_apk "twitter" "twitter" "twitter-inc/twitter/twitter"
patch "twitter" "twitter-revanced"

# Patch Reddit:
get_patches_key "reddit"
get_ver "general-reddit-ads" "com.reddit.frontpage"
get_apk "reddit" "reddit" "redditinc/reddit/reddit"
patch "reddit" "reddit-revanced"

# Patch Twitch:
get_patches_key "twitch"
get_ver "block-video-ads" "tv.twitch.android.app"
get_apk "twitch" "twitch" "twitch-interactive-inc/twitch/twitch"
patch "twitch" "twitch-revanced"

# Patch Windy:
get_patches_key "windy"
get_apk "windy" "windy-wind-weather-forecast" "windy-weather-world-inc/windy-wind-weather-forecast/windy-wind-weather-forecast"
patch "windy" "windy-revanced"

# Patch Tiktok:
rm -f patches*.json revanced-patches*.jar revanced-integrations*.apk revanced-cli*.jar
dl_gh "revanced-patches" "revanced" "tags/v2.173.0"
dl_gh "revanced-integrations" "revanced" "tags/v0.107.0"
dl_gh "revanced-cli" "revanced" "tags/v2.21.0"
get_patches_key "tiktok"
version="27.8.3"
get_apk "tiktok" "tik-tok-including-musical-ly" "tiktok-pte-ltd/tik-tok-including-musical-ly/tik-tok-including-musical-ly"
patch "tiktok" "tiktok-revanced"

# Split architecture:
rm -f revanced-cli*
dl_gh "revanced-cli" "j-hc" "latest"
# Split architecture Youtube:
for i in {0..3}; do
    split_arch "youtube-revanced" "youtube-${archs[i]}-revanced" "$(gen_rip_libs ${libs[i]})"
done
# Split architecture Reddit:
#for i in 0 1; do
#    split_arch "reddit-revanced" "reddit-${archs[i]}-revanced" "$(gen_rip_libs ${libs[i]})"
#done
# Split architecture Twitch:
#for i in 0 1; do
#    split_arch "twitch-revanced" "twitch-${archs[i]}-revanced" "$(gen_rip_libs ${libs[i]})"
#done
# Split architecture Tiktok:
#for i in 0 1; do
#    split_arch "tiktok-revanced" "tiktok-${archs[i]}-revanced" "$(gen_rip_libs ${libs[i]})"
#done
# Split architecture Twitter:
#for i in 0 1; do
#    split_arch "twitter-revanced" "twitter-${archs[i]}-revanced" "$(gen_rip_libs ${libs[i]})"
#done

# Merge architecture:
dl_gh "APKEditor" "REAndroid" "latest"
# Merge architecture Messenger:
merge_arch "messenger" "revanced"
# Merge architecture Instagram:
merge_arch "instagram" "revanced"
# Merge architecture YouTube Music:
merge_arch "youtube-music" "revanced"

ls revanced-patches*.jar >> revanced-version.txt
fi