# certs

To create a custom self-signed certificate for an internal domain:

First, create an OpenSSL folder by running ``mkdir openssl``, then navigate into it using ``cd openssl``.

Create two folders within the OpenSSL directory: ``mkdir {ca,domain.internal}``.

Generate a custom Certificate Authority (CA) by executing the following commands:

```bash
openssl genrsa -out ca/ca.key 2048
openssl req -new -key ca/ca.key -out ca/ca.csr
openssl x509 -req -in ca/ca.csr -signkey ca/ca.key -out ca/ca.crt -days 365
```

Then create your custom self signed certificate : 

```bash
openssl ecparam -name secp384r1 -genkey -out domain.internal/domain.internal.key
openssl req -new -key domain.internal/domain.internal.key -out domain.internal/domain.internal.csr -subj "/CN=domain.internal"
openssl x509 -req -in domain.internal/domain.internal.csr -CA ca/ca.crt -CAkey ca/ca.key -CAcreateserial -out domain.internal/domain.internal.crt -days 365
```

Now in NGINX you can put your new custom self signed certificate like this : 

```bash
ssl_certificate /path/to/openssl/folder/domain.internal.crt;
ssl_certificate_key /path/to/openssl/folder/domain.internal.key;
```
