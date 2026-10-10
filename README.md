# 9510-lab2
 this simple antivirus search for selected words in the file and if founded then goes to qarantine file

 # folder structure
 9510-lab2
  |_antivirused.sh
  |_restore.sh
  |_makefile
  |_readme.md
  |_antivirus-cron.sh
  |_whitelist.txt
  |_testdir
  |_quarantine (for virusd files)

  sudo apt update 
  sudo apt install make cron

  # how to run
  make the scripts executable :
  cd 9510-lab2
  chmod +x antivirusd.sh restore.sh antivirus-cron.sh

~~create the monitores directory and test files
 mkdir testdir
 echo "enjy trying" > testdir/true.txt 
 echo " this is a malware " > testdir/false.txt
 touch testdir/tryinggg.exe
 
 ~~ start the daemon:
  make run

   This first creates `quarantine/` (pre-build step), then runs
   `./antivirusd.sh testdir quarantine 3` and for each malicious file it prints
   `<file> is malicious and it is DELETED`
you can  add or change files in `testdir` from another terminal; the daemon scans
   again within 3 seconds. Stop it with `Ctrl+C`

   you can also run it directly: `./antivirusd.sh dir malicious_dir interval-secs`.
  do not run the daemon and the restore tool at the same time

  # restore tool
make restoreequivalent to `./restore.sh testdir quarantine`. The tool lists the
quarantined files and  asks for a number, then asks:

- `1` restore the file to the monitored directory (false positive)
- `2` permanently delete the file
- `3` leave it and go back to the list

enter `0` to quit. If the quarantine directory is empty it prints
`No malicious files to review.`

## 5. Bonus 1: Cron Job

`antivirus-cron.sh` does a single check (snapshot, compare, scan if changed)
and exits, so cron provides the repetition instead of `sleep`.

### Prerequisites

- The `cron` service must be installed and running:
```
  sudo apt install cron
  sudo systemctl enable --now cron
  systemctl status cron
```
- `antivirus-cron.sh` must be executable (`chmod +x antivirus-cron.sh`).
- Edit the `base=` line at the top of `antivirus-cron.sh` to the absolute path
  of the project (output of `pwd` inside the folder). Cron does not run from
  the project folder, so absolute paths are required.
- The monitored directory `testdir` should exist.

### Steps

1. Open your crontab: `crontab -e` (choose `nano` if asked).
2. Add this line at the end (replace the path with yours). Cron's smallest
   unit is one minute, so it runs every minute and waits 23 seconds first:
```
   * * * * * sleep 23; /home/enjy/Downloads/9510-lab2/antivirus-cron.sh >> /home/enjy/Downloads/9510-lab2/cron.log 2>&1
```
3. Save (`Ctrl+O`, `Enter`, `Ctrl+X`).
4. Verify with `crontab -l`.
5. Create a malicious file and wait a minute: `echo "trojan" > testdir/t.txt`,
   then check `ls testdir` and `cat cron.log`.
6. To stop it, run `crontab -e` and delete the line or put `#` in front of it.

# Third Friday of the month at 12:31 am

The third Friday always falls between day 15 and 21, so:

```
31 0 15-21 * 5
```

note: when both day-of-month and day-of-week are given, cron treats them as
OR (it would run on every Friday AND on days 15 to 21). To get a real third
Friday, restrict the day of month and test the weekday inside the command
(`%` must be escaped in crontab):

```
31 0 15-21 * * [ "$(date +\%u)" = 5 ] && /home/enjy/Downloads/9510-lab2/antivirus-cron.sh
```

# 6. Bonus 2: Whitelist

- **How a file is added:** when the user chooses `1` (restore) in `restore.sh`,
  the file name is appended to `whitelist.txt` (`echo "$name" >> whitelist.txt`).
  The file is created automatically on first use.
- **How the daemon checks it:** inside `scan`, right after reading the file
  name and before the extension and keyword checks, the scripts run
  `grep -qxF "$name" whitelist.txt` (exact, whole-line, fixed-string match).
  If the name is listed, the file is skipped (`continue`).
- **Persistence:** the whitelist is a plain file on disk, so it is still
  respected after the daemon is stopped and restarted.
- **Limitation:** files are whitelisted by name only.


