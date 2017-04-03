import numpy
import time
import argparse
import psutil

parser = argparse.ArgumentParser(description='Creates memory or CPU stress.', epilog='Written by Etienne Gaudrain <etienne.gaudrain@cnrs.fr>\nCopyright 2017 CNRS (FR), UMCG (NL)', formatter_class=argparse.RawDescriptionHelpFormatter)
parser.add_argument('type', choices=['memory', 'cpu'], default='cpu')
parser.add_argument('duration', default=5., type=float)

args = parser.parse_args()
dt = args.duration
t0 = time.time()

if args.type=='memory':
    N = int(numpy.sqrt(psutil.virtual_memory().available/8))
    print "Creating a matrix with %dx%d elements" % (N,N)
    while time.time()<t0+dt:
        try:
            print "Generating matrix"
            M = numpy.random.rand(N,N).astype('f4')
            #print "Multiplying matrix"
            #M = numpy.dot(M,M)
            #print "Calculating inverse"
            #numpy.linalg.inv(M)
        except:
            pass
    print "Timeout"
else:
    while time.time()<t0+dt:
        print 'yes'