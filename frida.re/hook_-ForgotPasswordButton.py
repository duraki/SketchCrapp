import frida
import sys

def on_message(message, data):
    print("[{}] => {}".format(message, data))

def main(target_process):
    session = frida.attach(target_process)

if __name__ == "__main__":
    main("Sketch")
