import sys

if sys.argv[1] == "write":
    with open("display_focus.txt", "w") as f:
        f.write(sys.argv[2])
    
if sys.argv[1] == "read":
    with open("display_focus.txt", "r") as f:
        print(f.readline())
