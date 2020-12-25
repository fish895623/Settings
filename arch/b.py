import subprocess

if __name__ == "__main__":
    print("""Put Your 'root' Disk
    ex) /dev/sda1 or /dev/sda2""")
    DEV_TARGET=input()
    print("""Put Your 'Boot' Disk
    ex) /dev/sdx""")
    DEV_BOOT=input() 

