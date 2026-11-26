#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
typedef int (*Init_t)(void);
typedef int (*GetH_t)(void**, const char*, void*, void*);
int main(int argc, char** argv){
  const char* comp_name = argc>1? argv[1] : "OMX.qcom.image.jpeg.encoder";
  printf("before: RTLD_DEFAULT EVP_SealInit=%p\n", dlsym(RTLD_DEFAULT, "EVP_SealInit"));
  void* sh = dlopen("/system/lib/libjpcryptoseal.so", RTLD_GLOBAL | RTLD_NOW);
  printf("shim=%p (%s)\n", sh, sh ? "ok" : dlerror());
  printf("after:  RTLD_DEFAULT EVP_SealInit=%p\n", dlsym(RTLD_DEFAULT, "EVP_SealInit"));
  void* jd = dlopen("/system/vendor/lib/libmmqjpeg_codec.so", RTLD_NOW);
  printf("dlopen codec direct=%p dlerr=%s\n", jd, jd?"none":dlerror());
  void* h = dlopen("libqomx_core.so", RTLD_NOW);
  if(!h){ printf("dlopen core FAIL: %s\n", dlerror()); return 1; }
  Init_t ini = (Init_t)dlsym(h,"OMX_Init");
  if(ini) ini();
  GetH_t gh = (GetH_t)dlsym(h,"OMX_GetHandle");
  char cbs[512]; memset(cbs,0,sizeof cbs);
  void* comp=0; dlerror();
  int rc = gh(&comp, comp_name, NULL, cbs);
  printf("GetHandle rc=0x%x comp=%p dlerr=%s\n", rc, comp, dlerror());
  return 0;
}
