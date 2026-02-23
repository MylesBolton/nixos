# Project Overview

This repository contains a comprehensive NixOS and home-manager configuration for multiple systems and users, managed as a Nix Flake. It leverages `snowfall-lib` to provide a structured and modular framework.

The configuration is organized into several key areas:
-   **Systems (`/systems`):** Each subdirectory defines a specific machine's system-level configuration, including hardware, networking, and enabled system-wide roles.
-   **Homes (`/homes`):** User-specific configurations are managed here with `home-manager`. Each profile is tailored for a user on a particular machine, defining their roles, applications, and personal dotfiles.
-   **NixOS Modules (`/modules/nixos`):** Reusable modules that define system-level configurations, grouped into roles like `desktop`, `server`, and `gaming`.
-   **Home Manager Modules (`/modules/home`):** Reusable modules for user-specific configurations, also grouped into roles.
-   **Packages (`/packages`):** Custom and overridden packages for use across the configurations.
-   **Library (`/lib`):** Custom helper functions and libraries to simplify and abstract configurations, integrated via `snowfall-lib`.

The flake uses several advanced Nix tools, including:
-   **`disko`:** For declarative disk partitioning and formatting.
-   **`stylix`:** For system-wide theming and styling.
-   **`agenix`:** For managing secrets declaratively.
-   **`comin`:** For automatically pulling and applying the latest configuration from the Git repository.

## Building and Running

The configurations in this flake are managed by NixOS and home-manager.

### System Configuration (NixOS)

To apply the configuration for a specific system, use the `nixos-rebuild` command. The host to be built is specified as a flake output anchor.

**Example:** To build the configuration for `laptop-02`:
```sh
# From the repository root
sudo nixos-rebuild switch --flake .#laptop-02
```
Replace `laptop-02` with the desired hostname from the `/systems/x86_64-linux/` directory.

### User Configuration (home-manager)

To apply a user's configuration, use the `home-manager` command. The target is a combination of the user and hostname.

**Example:** To apply the configuration for the user `jj` on `laptop-02`:
```sh
# From the repository root
home-manager switch --flake .#jj@laptop-02
```
Replace `jj@laptop-02` with the desired user profile from the `/homes/x86_64-linux/` directory.

## Development Conventions

-   **Modularity is Key:** The configuration is highly modular. When adding new functionality, prefer creating a new module in the appropriate directory (`/modules/nixos` or `/modules/home`).
-   **Use Roles:** Group related modules into "roles" (e.g., `roles.dev`, `roles.gaming`). This makes it easy to compose configurations for different systems and users.
-   **System-Specific vs. User-Specific:**
    -   System-wide settings (e.g., kernel, system services, hardware) belong in NixOS modules under `/modules/nixos`.
    -   User-specific settings (e.g., dotfiles, user applications, themes) belong in home-manager modules under `/modules/home`.
-   **Secrets:** Managed with `agenix`. Do not commit unencrypted secrets. Refer to the `agenix` documentation and existing files for the correct procedure.
-   **Formatting:** The code is formatted with `nixfmt`. You can format the entire repository by running `nix fmt`.
