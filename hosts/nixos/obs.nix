{ config, pkgs, ... }:
{

	environment.systemPackages = [
		(pkgs.wrapOBS {
			plugins = with pkgs.obs-studio-plugins; [
				wlrobs
				obs-backgroundremoval
				obs-pipewire-audio-capture
			];
		})
	];
  #Thread Priority for better performance
  # Add to your configuration.nix
	systemd.services.obs = {
	  serviceConfig = {
	    CPUAffinity = "6 7";  # Dedicating threads 6-7 (last physical core)
	    Nice = -10;           # Higher priority but not maximum
	  };
	};
}
