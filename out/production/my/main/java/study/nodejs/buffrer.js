buf = Buffer.alloc(26);
for(var i=0; i<26; i++){
    buf[i] = i+97;
}

len = buf.length;
console.log(len);
console.log(buf.toString('ascii'));
console.log(buf.toString('utf-8'));
console.log(buf.toString());
