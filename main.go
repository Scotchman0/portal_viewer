package main

import (
	"fmt"
	"os"
	"github.com/adrg/libvlc-go/v2"
)

func main() {
	//initialize libVLC (here's where we can set our parameters on the media execution as well)
	err := vlc.Init("--video-wallpaper","--quiet")
	if err != nil {
		fmt.Println("Error initializing libVLC:", err)
		return
	}
	defer vlc.Release()

	//create new player instance
	player, err := vlc.NewPlayer()
	if err != nil {
		fmt.Println("Error creating player:", err)
		return
	}
	defer player.Stop()
	defer player.Release()

	//set up event manager
	manager, err := player.EventManager()
	if err != nil {
		fmt.Println("Error getting event manager:", err)
		return
	}

	//register event callback
	quit := make(chan struct{})
	eventCallback := func(event vlc.Event, userData interface{}) {
		switch event {
		case vlc.MediaPlayerEndReached:
			fmt.Println("Playback ended")
			close(quit)
		}
	}
    
    //define eventID
	eventID, err := manager.Attach(vlc.MediaPlayerEndReached, eventCallback, nil)
	if err != nil {
		fmt.Println("Error attaching event:", err)
		return
	}
	defer manager.Detach(eventID)

	//get command-line args
	args := os.Args[1:]
	if len(args) < 1 {
		fmt.Println("Usage: go run main.go <file-path>")
		return
	}
        
	//set media from filepath
	media, err := player.LoadMediaFromPath(args[0])
	if err != nil {
		fmt.Println("Error loading media:", err)
		return
	}
	defer media.Release()

    //start playing
    if err = player.Play(); err != nil {
    	fmt.Println("Error playing media:", err)
    	return
    }

    //wait for playback to end/exit
    <-quit
}
