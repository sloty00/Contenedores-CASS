#!/opt/python/bin/python2.7
# Paul Porter 2013 http://paulgporter.net

import csv
import cStringIO
import datetime
import netsnmp
import requests
import argparse
import sys

# Listing of arguments this command will accept. Defaults are given for some values.

def main(argv=sys.argv[1:]):
    parser = argparse.ArgumentParser(description='nagios port saturation check')
    parser.add_argument('-H', '--host', required=True,
                                help='Host we are checking')
    parser.add_argument('-C', '--snmp_com', default='public', required=True,
                                help='SNMP community')
    parser.add_argument('-V', '--snmp_ver', type=int, default=2, choices=[1, 2, 3],
                                help='SNMP version')
    parser.add_argument('-g', '--graph_id', required=True,
                                help='Cacti graph id')
    parser.add_argument('-s', '--cacti_server', required=True,
                                help='Cacti server hostname')
    parser.add_argument('-c', '--crit', default=90, type=int,
                                help='critical saturation level in %')
    parser.add_argument('-w', '--warn', default=80, type=int,
                                help='warning saturation level in %')
    parser.add_argument('-i', '--if_index', required=True,
                                help='ifIndex value for snmp')
    args = parser.parse_args(argv)

# Create empty arrays

    inbound = []
    outbound = []

# Download the data from Cacti. Update the cert path to match yours.

    text = requests.get('https://'+ args.cacti_server +'/cacti/graph_xport.php?local_graph_id='+ args.graph_id +'&rra_id=5&view_type=', verify='/etc/ssl/certs/ca-certificates.crt').content

# If download was successful parse the CSV file, skip the headers, and retrieve data from the Inbound and Outbound columns. Otherwise exit with an error.

    if len(text) > 1 :
        for i in csv.DictReader(cStringIO.StringIO(text[text.index('""') + 3:])):
            if datetime.datetime.now() - datetime.datetime.strptime(i['Date'], '%Y-%m-%d %H:%M:%S') <= datetime.timedelta(minutes=17):
                inbound.append(float(i['Inbound']) / (100 * 1024 * 1024) * 100),
                outbound.append(float(i['Outbound']) / (100 * 1024 * 1024) * 100),
    else :
        print "ERROR: No Results Found"
        sys.exit(text)

# Use SNMP with the provided Hostname and IfIndex values to get the maximum speed of this interface

    max_speed = (netsnmp.snmpget(netsnmp.Varbind('.1.3.6.1.2.1.31.1.1.1.15.' + args.if_index), DestHost=args.host, Version=args.snmp_ver, Community=args.snmp_com, UseNumeric=True)[0])

# Takes the data from the Inbound and Outbound columns, converts it to Mbps, and adds to the arrays

    avg_inbound = round(sum(inbound) / len(inbound), 2)
    avg_outbound = round(sum(outbound) / len(outbound), 2)

# Apply the specified WARN and CRIT levels to the max speed and convert to decimal format
    warn_threshold = int(max_speed) * (args.warn * .01)
    crit_threshold = int(max_speed) * (args.crit * .01)

# Compare values

    if (avg_inbound >= crit_threshold) or (avg_outbound >= crit_threshold) :
        print 'CRITICAL: Avg_In= %s Mbps and Avg_Out= %s Mbps' % (avg_inbound, avg_outbound)
    elif (warn_threshold <= avg_inbound) or (warn_threshold <= avg_outbound) :
        print 'WARNING: Avg_In= %s Mbps and Avg_Out= %s Mbps' % (avg_inbound, avg_outbound)
    elif (0 <= avg_inbound <= warn_threshold) and (0 <= avg_outbound <= warn_threshold):
        print 'SUCCESS: Avg_In= %s Mbps and Avg_Out= %s Mbps' % (avg_inbound, avg_outbound)

if __name__ == '__main__':
    main()
