/* Android N BoringSSL dropped the OpenSSL EVP Seal/Open envelope API that the
 * KK libmmqjpeg_codec.so blob relocates against. Provide no-op replacements;
 * JPEG metadata encryption is unused on this device. */
typedef struct EVP_CIPHER_CTX EVP_CIPHER_CTX;
typedef struct EVP_CIPHER EVP_CIPHER;
typedef struct EVP_PKEY EVP_PKEY;

int EVP_SealInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
                 unsigned char **ek, int *ekl, unsigned char *iv,
                 EVP_PKEY **pubk, int npubk)
{ (void)ctx;(void)type;(void)ek;(void)ekl;(void)iv;(void)pubk;(void)npubk; return 0; }

int EVP_SealFinal(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl)
{ (void)ctx;(void)out; if (outl) *outl = 0; return 0; }

int EVP_OpenInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
                 const unsigned char *ek, int ekl, const unsigned char *iv,
                 EVP_PKEY *priv)
{ (void)ctx;(void)type;(void)ek;(void)ekl;(void)iv;(void)priv; return 0; }

int EVP_OpenFinal(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl)
{ (void)ctx;(void)out; if (outl) *outl = 0; return 0; }
