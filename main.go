package main

import (
	"flag"
	"fmt"
	"os"
	"os/signal"
	"time"

	"github.com/fatih/color"
)

var (
	age      float64
	birthday time.Time
	err      error
	fp       *os.File
	input    string
	now      time.Time

	Bold = color.New(color.Bold).SprintFunc()
	Cyan = color.New(color.FgCyan, color.Bold).SprintfFunc()

	reset = flag.Bool("reset", false, "reset birthday.")

	exit        bool
	cleanupDone = make(chan bool)
	signalChan  = make(chan os.Signal, 1)
)

func main() {
	flag.Parse()

	signal.Notify(signalChan, os.Interrupt)
	go func() {
		for range signalChan {
			fmt.Println("\nReceived an interrupt, stopping services...")
			exit = true
			<-cleanupDone
		}
	}()

	// reset birthday
	if *reset {
		setBirtday()
	}

	getBirtday()
	showAge()
}

func getHomePath() string {
	return os.Getenv("HOME")
}

func getBirtday() {
	fp, err = os.OpenFile(getHomePath()+"/.age", os.O_RDWR|os.O_CREATE, os.ModePerm)
	defer fp.Close()
	fstat, _ := fp.Stat()
	if os.IsNotExist(err) || fstat.Size() != 10 {
		setBirtday()
	}
	buf := make([]byte, 10)
	fp.Read(buf)
	birthday, _ = time.Parse("2006/01/02", string(buf))
}

func setBirtday() {
	fmt.Printf("Please enter your birthday(format is %s),like %s\n", Bold("yyyy/MM/dd"), Bold("1991/03/04"))
	fmt.Scanf("%s", &input)
	birthday, err = time.Parse("2006/01/02", input)
	if err != nil {
		// Move the cursor to the origin, clean screen and show msg.
		fmt.Println("\033[0;0H\033[2JError date format,try again.")
		time.Sleep(5e8)
		setBirtday()
	}
	fp.WriteString(input)
	showAge()
}

func showAge() {
	for {
		if exit {
			cleanupDone <- true
			return
		}
		now = time.Now()
		age = float64(now.UnixNano()-birthday.UnixNano()) / 1e9 / 86400 / 365
		fmt.Printf("Time flies, you've been %s years old.\r", Cyan("%3.9f", age))
		time.Sleep(3e7)
	}
}
