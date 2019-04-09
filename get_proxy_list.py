#!/usr/bin/python

import requests
from bs4 import BeautifulSoup

response = requests.get("https://www.socks-proxy.net/")

if response.status_code != 200:
    print("proxy list unavailable")
    exit()


soup = BeautifulSoup(response.text, "html.parser")
proxy_list_table = soup.find(id="proxylisttable")

for tr in proxy_list_table.tbody:
    proxy_string = str()
    proxy_type = int()
    for index, td in enumerate(tr.find_all("td")):
        if index == 0:
            proxy_string = td.string
        if index == 1:
            proxy_string = f'{proxy_string}:{td.string}'
        if index == 4 and "Socks5" in td.string:
            #print(td.string)
            print(f'{proxy_string}#{td.string.upper()}')

"""response = requests.get("http://spys.one/en/socks-proxy-list/")

if response.status_code != 200:
    print(f'Something wrong! HTTP code:{response.status_code}')
    exit(2)

soup = BeautifulSoup(response.text, "html.parser")
scripts = soup.find_all('script')
stupid_vars_line = scripts[3].string.split(';')
stupid_vars_line = stupid_vars_line[:-1]
stupid_vars = dict()
for var in stupid_vars_line:
    var_name = var.split('=')[0]
    var_value = var.split('=')[1]
    if '^' in var_value:
        mult1 = int(var_value.split('^')[0])
        mult2 = stupid_vars[str(var_value.split('^')[1])]
        var_value = mult1 ^ mult2
    stupid_vars[var_name] = int(var_value)

tables = soup.find_all('table')
for index, table in enumerate(tables):
    if index == 2:
        for tr_index, tr in enumerate(table):
            if tr_index > 2 and tr_index < 33:
                proxy_td = tr.find_all('td')[0]
                proxy_line = proxy_td.find_all('font')[1]
                script_line = proxy_td.find('script')
                proxy_ip = proxy_line.__repr__()[str(proxy_line).find('>')+1:]
                proxy_ip = proxy_ip[:proxy_ip.find('<')]
                script_line = script_line.string
                script_result = script_line[script_line.find('+')+1:-1]
                port_vars = script_result.split('+')
                port = str()
                for port_var in port_vars:
                    mult1 = stupid_vars[port_var[1:-1].split('^')[0]]
                    mult2 = stupid_vars[port_var[1:-1].split('^')[1]]
                    port = port + str(mult1 ^ mult2)
                print(f"{proxy_ip}:{port}")"""

