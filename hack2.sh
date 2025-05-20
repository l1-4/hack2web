#!/bin/bash

#=========================================
#    أداة فحص سيرفر ومعرفة مواقع مرتبطة
#    By: AL-F | Snapchat: LSLF | Insta: LSLF_6
#=========================================

read -p "أدخل رابط الموقع (مثال: example.com): " DOMAIN

# استخراج IP
IP=$(dig +short "$DOMAIN" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)

if [[ -z "$IP" ]]; then
    echo "[!] لم يتم العثور على IP. تحقق من الرابط."
    exit 1
fi

echo "========================================="
echo "[*] IP الخاص بالموقع ($DOMAIN): $IP"
echo

# فحص السيرفر عبر nmap
echo "-----------------------------------------"
echo "[+] فحص المنافذ على السيرفر $IP"
nmap -sV -Pn "$IP"
echo

# البحث عن مواقع أخرى على نفس السيرفر باستخدام crt.sh API
echo "-----------------------------------------"
echo "[+] محاولة العثور على مواقع أخرى على نفس السيرفر (نفس IP)"

REVERSE_DOMAINS=$(curl -s "https://api.hackertarget.com/reverseiplookup/?q=$IP")

if [[ "$REVERSE_DOMAINS" == "error" || -z "$REVERSE_DOMAINS" ]]; then
    echo "[-] لم يتم العثور على نطاقات مرتبطة أو تم حظر الطلب."
else
    echo "[+] نطاقات على نفس السيرفر:"
    echo "$REVERSE_DOMAINS"
fi

echo "========================================="
echo "[*] تم الانتهاء - بواسطة AL-F"
echo "    Snapchat: LSLF | Instagram: LSLF_6"
