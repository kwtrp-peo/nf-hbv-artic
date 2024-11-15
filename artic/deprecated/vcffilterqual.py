#!/usr/bin/env python

import vcf
import sys

vcf_reader = vcf.Reader(filename=sys.argv[1])
vcf_writer = vcf.Writer(sys.stdout, vcf_reader)


def filter(record):
    # nanopolish-only call
    try:
        support = float(record.INFO["SupportFraction"][0])
        total_reads = int(record.INFO["TotalReads"][0])
    except KeyError:
        return 1

    if record.QUAL >= 200 and total_reads >= 50:
        return 0

    # add support for masking ?

    return 1


number_vcf = 0
for record in vcf_reader:
    if not filter(record):
        number_vcf += 1
        vcf_writer.write_record(record)
    else:
        print >> sys.stderr, "Filtering %s" % (record)

print >> sys.stderr, "Output %s records" % (number_vcf)
