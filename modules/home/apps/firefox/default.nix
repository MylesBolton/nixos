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
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };

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
        name = "Default";
        isDefault = true;
        
        settings = {
          "browser.startup.homepage" = "https://nixos.org";
          "browser.search.region" = "GB";
          "browser.search.isUS" = false;
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "general.useragent.locale" = "en-GB";
          "browser.bookmarks.showMobileBookmarks" = false;
          "extensions.autoDisableScopes" = 0;
          "browser.newtabpage.pinned" = [
            {
              title = "NixOS";
              url = "https://nixos.org";
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
            plasma-integration # desktop intergration
            react-devtools # dev tools
            snowflake # help other peeps
            enhanced-github # better gh
            new-tab-override # start page
            terms-of-service-didnt-read # TOS TLDR
            ublock-origin # ad block

            #yt specific
            enhancer-for-youtube # 1080p 2.5x speed mods
            youtube-recommended-videos # remove yt brain rot
            dearrow # change pics and titles
            sponsorblock # remove yt sponsor spots

            #bullshit removers
            clearurls
            news-feed-eradicator
            re-enable-right-click
            absolute-enable-right-click
            ublacklist
            i-dont-care-about-cookies

            #stuff i need to look at later
            #startup-bookmarks
            #markdownload
            #omnivore
            #aria2-integration
          ];
        };
      };
    };
  };
}
