#todo write a about section

### ISO Reminder

```
#minimal install iso
nix build .#install-isoConfigurations.minimal

#graphical install iso
nix build .#install-isoConfigurations.graphical

#install iso to usb
dd if=result/iso/* of=/dev/* status=progress
```

## Credits

https://gitlab.com/hmajid2301/nixicle
https://github.com/jakehamilton/config/
https://github.com/IogaMaster/dotfiles
