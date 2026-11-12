"""Export parts from the .scad files and print their size and weight.

Usage: python measure_parts.py [OPENSCAD_EXECUTABLE]

Exports each part to a temporary STL with the OpenSCAD command line, then
reports bounding box, volume and weight in PLA. Needs: numpy-stl.
"""
import os, subprocess, sys, tempfile
import numpy as np
from stl import mesh

HERE = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
OPENSCAD = sys.argv[1] if len(sys.argv) > 1 else 'openscad'
PLA = 1.24  # g/cm3

# (label, file, {parameter: value})
PARTS = [
    ('fit test, left half', 'interface_check.scad', {'view': 'fit test: left half'}),
    ('fit test, right half', 'interface_check.scad', {'view': 'fit test: right half'}),
    ('A left half', 'split_concepts.scad', {'concept': 'A', 'part': 'A_left'}),
    ('A right half', 'split_concepts.scad', {'concept': 'A', 'part': 'A_right'}),
    ('B centre piece', 'split_concepts.scad', {'concept': 'B', 'part': 'B_centre'}),
    ('B pod', 'split_concepts.scad', {'concept': 'B', 'part': 'B_pod'}),
    ('C left half', 'split_concepts.scad', {'concept': 'C', 'part': 'C_left'}),
    ('C right half', 'split_concepts.scad', {'concept': 'C', 'part': 'C_right'}),
    ('deck plate, left', 'split_concepts.scad', {'concept': 'A', 'with_deck': True, 'part': 'deck_left'}),
    ('placeholder drawer', 'split_concepts.scad', {'concept': 'A', 'part': 'drawer'}),
]

def define(k, v):
    return '%s=%s' % (k, 'true' if v is True else 'false' if v is False else '"%s"' % v)

with tempfile.TemporaryDirectory() as tmp:
    for label, scad, params in PARTS:
        out = os.path.join(tmp, 'part.stl')
        cmd = [OPENSCAD, '-o', out, '--export-format', 'binstl']
        for k, v in params.items():
            cmd += ['-D', define(k, v)]
        r = subprocess.run(cmd + [os.path.join(HERE, scad)], capture_output=True, text=True)
        if r.returncode or not os.path.exists(out):
            print('%-22s FAILED: %s' % (label, r.stderr.strip().splitlines()[-1:]))
            continue
        m = mesh.Mesh.from_file(out)
        vol = m.get_mass_properties()[0] / 1000
        pts = m.vectors.reshape(-1, 3)
        size = pts.max(0) - pts.min(0)
        print('%-22s %6.1f x %6.1f x %5.1f mm   %6.1f cm3   %4.0f g PLA'
              % (label, size[0], size[1], size[2], vol, vol * PLA))
        os.remove(out)
