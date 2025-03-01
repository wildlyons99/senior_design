#!/usr/bin/env python3
import re
import sys

def parse_top_v(filename="top.v"):
    """
    Parses the top.v file to extract port information from the first module.
    Returns a dictionary with keys 'inputs' and 'outputs'. Each value is a list
    of tuples: (signal_name, width). For scalar signals, width=1.
    """
    with open(filename, "r") as f:
        content = f.read()

    # Find the module declaration
    module_match = re.search(r"module\s+(\w+)\s*\((.*?)\);", content, re.DOTALL)
    if not module_match:
        raise ValueError("No module declaration found in top.v")

    ports_str = module_match.group(2)
    
    # Regex to match port definitions
    port_regex = re.compile(r"(input|output)\s+wire\s+(?:\[(\d+):(\d+)\]\s+)?(\w+)", re.MULTILINE)
    
    ports = {"inputs": [], "outputs": []}
    
    for match in port_regex.finditer(ports_str):
        direction = match.group(1)
        msb = match.group(2)
        lsb = match.group(3)
        name = match.group(4)
        if msb and lsb:
            # Determine width from bus range (assumes descending order)
            width = abs(int(msb) - int(lsb)) + 1
        else:
            width = 1
        
        if direction == "input":
            ports["inputs"].append((name, width))
        else:
            ports["outputs"].append((name, width))
    
    return ports

def write_pcf(filename, ports):
    """
    Writes the PCF file using the extracted ports.
    Pin numbers are set to "__" as placeholders for user-defined values.
    """
    with open(filename, "w") as f:
        # Write Inputs section
        f.write("# Inputs\n")
        for name, width in ports["inputs"]:
            if width == 1:
                f.write(f"set_io -nowarn -pullup 1 {name:<20} __   # Pin for {name}\n")
            else:
                for bit in range(width):
                    f.write(f"set_io -nowarn -pullup 1 {name}[{bit}]".ljust(30))
                    f.write(f" __   # Pin for {name}[{bit}]\n")
        
        f.write("\n# Outputs\n")
        for name, width in ports["outputs"]:
            if width == 1:
                f.write(f"set_io -nowarn {name:<20} __   # Pin for {name}\n")
            else:
                for bit in range(width):
                    f.write(f"set_io -nowarn {name}[{bit}]".ljust(30))
                    f.write(f" __   # Pin for {name}[{bit}]\n")

def main():
    # Get output filename from the command-line argument, or use "noname"
    out_filename = sys.argv[1] if len(sys.argv) > 1 else "noname"
    
    try:
        ports = parse_top_v("top.v")
    except Exception as e:
        print(f"Error parsing top.v: {e}")
        sys.exit(1)
    
    write_pcf(out_filename + ".pcf", ports)
    print(f"PCF file '{out_filename}' created successfully.")

if __name__ == "__main__":
    main()
