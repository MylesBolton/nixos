{
  inputs,
  lib,
  host,
  pkgs,
  config,
  namespace,
  ...
}:
with lib;
let
  cfg = config.apps.firefox;
in
{
  options.apps.firefox = {
    enable = mkEnableOption "enable firefox browser";
  };

  config = mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "text/xml" = [ "firefox.desktop" ];
      "application/pdf" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
    stylix.targets.firefox.profileNames = [ "default" ];
    programs.firefox = {
      enable = true;
      languagePacks = [ "en-GB" ];
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
      profiles.default = {
        name = "default";
        isDefault = true;

        settings = {
          "browser.startup.homepage" = "https://startpage.mylesbolton.com/";
          "browser.search.region" = "GB";
          "browser.search.isUS" = false;
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "general.useragent.locale" = "en-GB";
          "browser.bookmarks.showMobileBookmarks" = false;
          "extensions.autoDisableScopes" = 0;
          "browser.newtabpage.pinned" = [
            {
              title = "NixOS";
              url = "https://startpage.mylesbolton.com/";
            }
          ];
        };

        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            gopass-bridge # password manager
            stylus # custom styles
            temporary-containers # auto delete browsing sessions
            floccus # bookmark sync
            languagetool # spelling help
            enhanced-github # better gh
            custom-new-tab-page # startpage
            ublock-origin # ad block
            startup-bookmarks # opens a folder of bookmarks on startup
            markdownload # dowlaods webpages as markdown

            #yt specific
            #enhancer-for-youtube # 1080p 2.5x speed mods
            youtube-recommended-videos # remove yt brain rot
            sponsorblock # remove yt sponsor spots

            #bullshit removers
            clearurls
            news-feed-eradicator
            re-enable-right-click
            ublacklist
            i-dont-care-about-cookies
          ];
        };
      };
    };
  };
}
