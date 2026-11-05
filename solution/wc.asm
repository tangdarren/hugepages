
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	be 01 00 00 00       	mov    $0x1,%esi
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	83 ec 18             	sub    $0x18,%esp
  19:	8b 01                	mov    (%ecx),%eax
  1b:	8b 59 04             	mov    0x4(%ecx),%ebx
  1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  21:	83 c3 04             	add    $0x4,%ebx
  int fd, i;

  if(argc <= 1){
  24:	83 f8 01             	cmp    $0x1,%eax
  27:	7e 56                	jle    7f <main+0x7f>
  29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  30:	83 ec 08             	sub    $0x8,%esp
  33:	6a 00                	push   $0x0
  35:	ff 33                	push   (%ebx)
  37:	e8 e1 03 00 00       	call   41d <open>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	89 c7                	mov    %eax,%edi
  41:	85 c0                	test   %eax,%eax
  43:	78 26                	js     6b <main+0x6b>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
  45:	83 ec 08             	sub    $0x8,%esp
  48:	ff 33                	push   (%ebx)
  for(i = 1; i < argc; i++){
  4a:	83 c6 01             	add    $0x1,%esi
  4d:	83 c3 04             	add    $0x4,%ebx
    wc(fd, argv[i]);
  50:	50                   	push   %eax
  51:	e8 4a 00 00 00       	call   a0 <wc>
    close(fd);
  56:	89 3c 24             	mov    %edi,(%esp)
  59:	e8 a7 03 00 00       	call   405 <close>
  for(i = 1; i < argc; i++){
  5e:	83 c4 10             	add    $0x10,%esp
  61:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  64:	75 ca                	jne    30 <main+0x30>
  }
  exit();
  66:	e8 72 03 00 00       	call   3dd <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
  6b:	50                   	push   %eax
  6c:	ff 33                	push   (%ebx)
  6e:	68 c7 0a 00 00       	push   $0xac7
  73:	6a 01                	push   $0x1
  75:	e8 e6 04 00 00       	call   560 <printf>
      exit();
  7a:	e8 5e 03 00 00       	call   3dd <exit>
    wc(0, "");
  7f:	52                   	push   %edx
  80:	52                   	push   %edx
  81:	68 b9 0a 00 00       	push   $0xab9
  86:	6a 00                	push   $0x0
  88:	e8 13 00 00 00       	call   a0 <wc>
    exit();
  8d:	e8 4b 03 00 00       	call   3dd <exit>
  92:	66 90                	xchg   %ax,%ax
  94:	66 90                	xchg   %ax,%ax
  96:	66 90                	xchg   %ax,%ax
  98:	66 90                	xchg   %ax,%ax
  9a:	66 90                	xchg   %ax,%ax
  9c:	66 90                	xchg   %ax,%ax
  9e:	66 90                	xchg   %ax,%ax

000000a0 <wc>:
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
  l = w = c = 0;
  a6:	31 db                	xor    %ebx,%ebx
{
  a8:	83 ec 1c             	sub    $0x1c,%esp
  inword = 0;
  ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  b2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	68 00 02 00 00       	push   $0x200
  c8:	68 a0 0f 00 00       	push   $0xfa0
  cd:	ff 75 08             	push   0x8(%ebp)
  d0:	e8 20 03 00 00       	call   3f5 <read>
  d5:	83 c4 10             	add    $0x10,%esp
  d8:	89 c6                	mov    %eax,%esi
  da:	85 c0                	test   %eax,%eax
  dc:	7e 62                	jle    140 <wc+0xa0>
    for(i=0; i<n; i++){
  de:	31 ff                	xor    %edi,%edi
  e0:	eb 14                	jmp    f6 <wc+0x56>
  e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        inword = 0;
  e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  ef:	83 c7 01             	add    $0x1,%edi
  f2:	39 fe                	cmp    %edi,%esi
  f4:	74 42                	je     138 <wc+0x98>
      if(buf[i] == '\n')
  f6:	0f be 87 a0 0f 00 00 	movsbl 0xfa0(%edi),%eax
        l++;
  fd:	31 c9                	xor    %ecx,%ecx
  ff:	3c 0a                	cmp    $0xa,%al
 101:	0f 94 c1             	sete   %cl
      if(strchr(" \r\t\n\v", buf[i]))
 104:	83 ec 08             	sub    $0x8,%esp
 107:	50                   	push   %eax
        l++;
 108:	01 cb                	add    %ecx,%ebx
      if(strchr(" \r\t\n\v", buf[i]))
 10a:	68 a4 0a 00 00       	push   $0xaa4
 10f:	e8 4c 01 00 00       	call   260 <strchr>
 114:	83 c4 10             	add    $0x10,%esp
 117:	85 c0                	test   %eax,%eax
 119:	75 cd                	jne    e8 <wc+0x48>
      else if(!inword){
 11b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 11e:	85 d2                	test   %edx,%edx
 120:	75 cd                	jne    ef <wc+0x4f>
    for(i=0; i<n; i++){
 122:	83 c7 01             	add    $0x1,%edi
        w++;
 125:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        inword = 1;
 129:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
 130:	39 fe                	cmp    %edi,%esi
 132:	75 c2                	jne    f6 <wc+0x56>
 134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      c++;
 138:	01 75 dc             	add    %esi,-0x24(%ebp)
 13b:	eb 83                	jmp    c0 <wc+0x20>
 13d:	8d 76 00             	lea    0x0(%esi),%esi
  if(n < 0){
 140:	75 24                	jne    166 <wc+0xc6>
  printf(1, "%d %d %d %s\n", l, w, c, name);
 142:	83 ec 08             	sub    $0x8,%esp
 145:	ff 75 0c             	push   0xc(%ebp)
 148:	ff 75 dc             	push   -0x24(%ebp)
 14b:	ff 75 e0             	push   -0x20(%ebp)
 14e:	53                   	push   %ebx
 14f:	68 ba 0a 00 00       	push   $0xaba
 154:	6a 01                	push   $0x1
 156:	e8 05 04 00 00       	call   560 <printf>
}
 15b:	83 c4 20             	add    $0x20,%esp
 15e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 161:	5b                   	pop    %ebx
 162:	5e                   	pop    %esi
 163:	5f                   	pop    %edi
 164:	5d                   	pop    %ebp
 165:	c3                   	ret    
    printf(1, "wc: read error\n");
 166:	50                   	push   %eax
 167:	50                   	push   %eax
 168:	68 aa 0a 00 00       	push   $0xaaa
 16d:	6a 01                	push   $0x1
 16f:	e8 ec 03 00 00       	call   560 <printf>
    exit();
 174:	e8 64 02 00 00       	call   3dd <exit>
 179:	66 90                	xchg   %ax,%ax
 17b:	66 90                	xchg   %ax,%ax
 17d:	66 90                	xchg   %ax,%ax
 17f:	90                   	nop

00000180 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 180:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 181:	31 c0                	xor    %eax,%eax
{
 183:	89 e5                	mov    %esp,%ebp
 185:	53                   	push   %ebx
 186:	8b 4d 08             	mov    0x8(%ebp),%ecx
 189:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 190:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 194:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 197:	83 c0 01             	add    $0x1,%eax
 19a:	84 d2                	test   %dl,%dl
 19c:	75 f2                	jne    190 <strcpy+0x10>
    ;
  return os;
}
 19e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a1:	89 c8                	mov    %ecx,%eax
 1a3:	c9                   	leave  
 1a4:	c3                   	ret    
 1a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	53                   	push   %ebx
 1b4:	8b 55 08             	mov    0x8(%ebp),%edx
 1b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1ba:	0f b6 02             	movzbl (%edx),%eax
 1bd:	84 c0                	test   %al,%al
 1bf:	75 17                	jne    1d8 <strcmp+0x28>
 1c1:	eb 3a                	jmp    1fd <strcmp+0x4d>
 1c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1c7:	90                   	nop
 1c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1cc:	83 c2 01             	add    $0x1,%edx
 1cf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1d2:	84 c0                	test   %al,%al
 1d4:	74 1a                	je     1f0 <strcmp+0x40>
    p++, q++;
 1d6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 1d8:	0f b6 19             	movzbl (%ecx),%ebx
 1db:	38 c3                	cmp    %al,%bl
 1dd:	74 e9                	je     1c8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1df:	29 d8                	sub    %ebx,%eax
}
 1e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e4:	c9                   	leave  
 1e5:	c3                   	ret    
 1e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 1f0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 1f4:	31 c0                	xor    %eax,%eax
 1f6:	29 d8                	sub    %ebx,%eax
}
 1f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 1fd:	0f b6 19             	movzbl (%ecx),%ebx
 200:	31 c0                	xor    %eax,%eax
 202:	eb db                	jmp    1df <strcmp+0x2f>
 204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 20f:	90                   	nop

00000210 <strlen>:

uint
strlen(const char *s)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 216:	80 3a 00             	cmpb   $0x0,(%edx)
 219:	74 15                	je     230 <strlen+0x20>
 21b:	31 c0                	xor    %eax,%eax
 21d:	8d 76 00             	lea    0x0(%esi),%esi
 220:	83 c0 01             	add    $0x1,%eax
 223:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 227:	89 c1                	mov    %eax,%ecx
 229:	75 f5                	jne    220 <strlen+0x10>
    ;
  return n;
}
 22b:	89 c8                	mov    %ecx,%eax
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret    
 22f:	90                   	nop
  for(n = 0; s[n]; n++)
 230:	31 c9                	xor    %ecx,%ecx
}
 232:	5d                   	pop    %ebp
 233:	89 c8                	mov    %ecx,%eax
 235:	c3                   	ret    
 236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23d:	8d 76 00             	lea    0x0(%esi),%esi

00000240 <memset>:

void*
memset(void *dst, int c, uint n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 247:	8b 4d 10             	mov    0x10(%ebp),%ecx
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 d7                	mov    %edx,%edi
 24f:	fc                   	cld    
 250:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 252:	8b 7d fc             	mov    -0x4(%ebp),%edi
 255:	89 d0                	mov    %edx,%eax
 257:	c9                   	leave  
 258:	c3                   	ret    
 259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000260 <strchr>:

char*
strchr(const char *s, char c)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 26a:	0f b6 10             	movzbl (%eax),%edx
 26d:	84 d2                	test   %dl,%dl
 26f:	75 12                	jne    283 <strchr+0x23>
 271:	eb 1d                	jmp    290 <strchr+0x30>
 273:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 277:	90                   	nop
 278:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 27c:	83 c0 01             	add    $0x1,%eax
 27f:	84 d2                	test   %dl,%dl
 281:	74 0d                	je     290 <strchr+0x30>
    if(*s == c)
 283:	38 d1                	cmp    %dl,%cl
 285:	75 f1                	jne    278 <strchr+0x18>
      return (char*)s;
  return 0;
}
 287:	5d                   	pop    %ebp
 288:	c3                   	ret    
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 290:	31 c0                	xor    %eax,%eax
}
 292:	5d                   	pop    %ebp
 293:	c3                   	ret    
 294:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 29f:	90                   	nop

000002a0 <gets>:

char*
gets(char *buf, int max)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2a5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 2a8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2a9:	31 db                	xor    %ebx,%ebx
{
 2ab:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2ae:	eb 27                	jmp    2d7 <gets+0x37>
    cc = read(0, &c, 1);
 2b0:	83 ec 04             	sub    $0x4,%esp
 2b3:	6a 01                	push   $0x1
 2b5:	57                   	push   %edi
 2b6:	6a 00                	push   $0x0
 2b8:	e8 38 01 00 00       	call   3f5 <read>
    if(cc < 1)
 2bd:	83 c4 10             	add    $0x10,%esp
 2c0:	85 c0                	test   %eax,%eax
 2c2:	7e 1d                	jle    2e1 <gets+0x41>
      break;
    buf[i++] = c;
 2c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2c8:	8b 55 08             	mov    0x8(%ebp),%edx
 2cb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2cf:	3c 0a                	cmp    $0xa,%al
 2d1:	74 1d                	je     2f0 <gets+0x50>
 2d3:	3c 0d                	cmp    $0xd,%al
 2d5:	74 19                	je     2f0 <gets+0x50>
  for(i=0; i+1 < max; ){
 2d7:	89 de                	mov    %ebx,%esi
 2d9:	83 c3 01             	add    $0x1,%ebx
 2dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2df:	7c cf                	jl     2b0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2eb:	5b                   	pop    %ebx
 2ec:	5e                   	pop    %esi
 2ed:	5f                   	pop    %edi
 2ee:	5d                   	pop    %ebp
 2ef:	c3                   	ret    
  buf[i] = '\0';
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	89 de                	mov    %ebx,%esi
 2f5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 2f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2fc:	5b                   	pop    %ebx
 2fd:	5e                   	pop    %esi
 2fe:	5f                   	pop    %edi
 2ff:	5d                   	pop    %ebp
 300:	c3                   	ret    
 301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30f:	90                   	nop

00000310 <stat>:

int
stat(const char *n, struct stat *st)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	56                   	push   %esi
 314:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 315:	83 ec 08             	sub    $0x8,%esp
 318:	6a 00                	push   $0x0
 31a:	ff 75 08             	push   0x8(%ebp)
 31d:	e8 fb 00 00 00       	call   41d <open>
  if(fd < 0)
 322:	83 c4 10             	add    $0x10,%esp
 325:	85 c0                	test   %eax,%eax
 327:	78 27                	js     350 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 329:	83 ec 08             	sub    $0x8,%esp
 32c:	ff 75 0c             	push   0xc(%ebp)
 32f:	89 c3                	mov    %eax,%ebx
 331:	50                   	push   %eax
 332:	e8 fe 00 00 00       	call   435 <fstat>
  close(fd);
 337:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 33a:	89 c6                	mov    %eax,%esi
  close(fd);
 33c:	e8 c4 00 00 00       	call   405 <close>
  return r;
 341:	83 c4 10             	add    $0x10,%esp
}
 344:	8d 65 f8             	lea    -0x8(%ebp),%esp
 347:	89 f0                	mov    %esi,%eax
 349:	5b                   	pop    %ebx
 34a:	5e                   	pop    %esi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret    
 34d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 350:	be ff ff ff ff       	mov    $0xffffffff,%esi
 355:	eb ed                	jmp    344 <stat+0x34>
 357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35e:	66 90                	xchg   %ax,%ax

00000360 <atoi>:

int
atoi(const char *s)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 367:	0f be 02             	movsbl (%edx),%eax
 36a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 36d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 370:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 375:	77 1e                	ja     395 <atoi+0x35>
 377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 380:	83 c2 01             	add    $0x1,%edx
 383:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 386:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 38a:	0f be 02             	movsbl (%edx),%eax
 38d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 390:	80 fb 09             	cmp    $0x9,%bl
 393:	76 eb                	jbe    380 <atoi+0x20>
  return n;
}
 395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 398:	89 c8                	mov    %ecx,%eax
 39a:	c9                   	leave  
 39b:	c3                   	ret    
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	8b 45 10             	mov    0x10(%ebp),%eax
 3a7:	8b 55 08             	mov    0x8(%ebp),%edx
 3aa:	56                   	push   %esi
 3ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ae:	85 c0                	test   %eax,%eax
 3b0:	7e 13                	jle    3c5 <memmove+0x25>
 3b2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3b4:	89 d7                	mov    %edx,%edi
 3b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 3c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3c1:	39 f8                	cmp    %edi,%eax
 3c3:	75 fb                	jne    3c0 <memmove+0x20>
  return vdst;
}
 3c5:	5e                   	pop    %esi
 3c6:	89 d0                	mov    %edx,%eax
 3c8:	5f                   	pop    %edi
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    
 3cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3cf:	90                   	nop

000003d0 <sbrk_huge>:

char*
sbrk_huge(int n)
{
  return sbrkhuge(n); 
 3d0:	e9 c8 00 00 00       	jmp    49d <sbrkhuge>

000003d5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3d5:	b8 01 00 00 00       	mov    $0x1,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <exit>:
SYSCALL(exit)
 3dd:	b8 02 00 00 00       	mov    $0x2,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <wait>:
SYSCALL(wait)
 3e5:	b8 03 00 00 00       	mov    $0x3,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <pipe>:
SYSCALL(pipe)
 3ed:	b8 04 00 00 00       	mov    $0x4,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <read>:
SYSCALL(read)
 3f5:	b8 05 00 00 00       	mov    $0x5,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <write>:
SYSCALL(write)
 3fd:	b8 10 00 00 00       	mov    $0x10,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <close>:
SYSCALL(close)
 405:	b8 15 00 00 00       	mov    $0x15,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <kill>:
SYSCALL(kill)
 40d:	b8 06 00 00 00       	mov    $0x6,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <exec>:
SYSCALL(exec)
 415:	b8 07 00 00 00       	mov    $0x7,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <open>:
SYSCALL(open)
 41d:	b8 0f 00 00 00       	mov    $0xf,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <mknod>:
SYSCALL(mknod)
 425:	b8 11 00 00 00       	mov    $0x11,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <unlink>:
SYSCALL(unlink)
 42d:	b8 12 00 00 00       	mov    $0x12,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <fstat>:
SYSCALL(fstat)
 435:	b8 08 00 00 00       	mov    $0x8,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <link>:
SYSCALL(link)
 43d:	b8 13 00 00 00       	mov    $0x13,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <mkdir>:
SYSCALL(mkdir)
 445:	b8 14 00 00 00       	mov    $0x14,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <chdir>:
SYSCALL(chdir)
 44d:	b8 09 00 00 00       	mov    $0x9,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <dup>:
SYSCALL(dup)
 455:	b8 0a 00 00 00       	mov    $0xa,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <getpid>:
SYSCALL(getpid)
 45d:	b8 0b 00 00 00       	mov    $0xb,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <sbrk>:
SYSCALL(sbrk)
 465:	b8 0c 00 00 00       	mov    $0xc,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <sleep>:
SYSCALL(sleep)
 46d:	b8 0d 00 00 00       	mov    $0xd,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <uptime>:
SYSCALL(uptime)
 475:	b8 0e 00 00 00       	mov    $0xe,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <printhugepde>:
SYSCALL(printhugepde)
 47d:	b8 16 00 00 00       	mov    $0x16,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <procpgdirinfo>:
SYSCALL(procpgdirinfo)
 485:	b8 17 00 00 00       	mov    $0x17,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <vmalloc>:
SYSCALL(vmalloc)
 48d:	b8 18 00 00 00       	mov    $0x18,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <vfree>:
SYSCALL(vfree)
 495:	b8 19 00 00 00       	mov    $0x19,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <sbrkhuge>:
 49d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    
 4a5:	66 90                	xchg   %ax,%ax
 4a7:	66 90                	xchg   %ax,%ax
 4a9:	66 90                	xchg   %ax,%ax
 4ab:	66 90                	xchg   %ax,%ax
 4ad:	66 90                	xchg   %ax,%ax
 4af:	90                   	nop

000004b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	83 ec 3c             	sub    $0x3c,%esp
 4b9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4bc:	89 d1                	mov    %edx,%ecx
{
 4be:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 4c1:	85 d2                	test   %edx,%edx
 4c3:	0f 89 7f 00 00 00    	jns    548 <printint+0x98>
 4c9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4cd:	74 79                	je     548 <printint+0x98>
    neg = 1;
 4cf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 4d6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 4d8:	31 db                	xor    %ebx,%ebx
 4da:	8d 75 d7             	lea    -0x29(%ebp),%esi
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4e0:	89 c8                	mov    %ecx,%eax
 4e2:	31 d2                	xor    %edx,%edx
 4e4:	89 cf                	mov    %ecx,%edi
 4e6:	f7 75 c4             	divl   -0x3c(%ebp)
 4e9:	0f b6 92 3c 0b 00 00 	movzbl 0xb3c(%edx),%edx
 4f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4f3:	89 d8                	mov    %ebx,%eax
 4f5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 4f8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 4fb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 4fe:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 501:	76 dd                	jbe    4e0 <printint+0x30>
  if(neg)
 503:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 506:	85 c9                	test   %ecx,%ecx
 508:	74 0c                	je     516 <printint+0x66>
    buf[i++] = '-';
 50a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 50f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 511:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 516:	8b 7d b8             	mov    -0x48(%ebp),%edi
 519:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 51d:	eb 07                	jmp    526 <printint+0x76>
 51f:	90                   	nop
    putc(fd, buf[i]);
 520:	0f b6 13             	movzbl (%ebx),%edx
 523:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 526:	83 ec 04             	sub    $0x4,%esp
 529:	88 55 d7             	mov    %dl,-0x29(%ebp)
 52c:	6a 01                	push   $0x1
 52e:	56                   	push   %esi
 52f:	57                   	push   %edi
 530:	e8 c8 fe ff ff       	call   3fd <write>
  while(--i >= 0)
 535:	83 c4 10             	add    $0x10,%esp
 538:	39 de                	cmp    %ebx,%esi
 53a:	75 e4                	jne    520 <printint+0x70>
}
 53c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53f:	5b                   	pop    %ebx
 540:	5e                   	pop    %esi
 541:	5f                   	pop    %edi
 542:	5d                   	pop    %ebp
 543:	c3                   	ret    
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 548:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 54f:	eb 87                	jmp    4d8 <printint+0x28>
 551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55f:	90                   	nop

00000560 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	56                   	push   %esi
 565:	53                   	push   %ebx
 566:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 569:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 56c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 56f:	0f b6 13             	movzbl (%ebx),%edx
 572:	84 d2                	test   %dl,%dl
 574:	74 6a                	je     5e0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 576:	8d 45 10             	lea    0x10(%ebp),%eax
 579:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 57c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 57f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 581:	89 45 d0             	mov    %eax,-0x30(%ebp)
 584:	eb 36                	jmp    5bc <printf+0x5c>
 586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58d:	8d 76 00             	lea    0x0(%esi),%esi
 590:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 593:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 598:	83 f8 25             	cmp    $0x25,%eax
 59b:	74 15                	je     5b2 <printf+0x52>
  write(fd, &c, 1);
 59d:	83 ec 04             	sub    $0x4,%esp
 5a0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5a3:	6a 01                	push   $0x1
 5a5:	57                   	push   %edi
 5a6:	56                   	push   %esi
 5a7:	e8 51 fe ff ff       	call   3fd <write>
 5ac:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 5af:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5b2:	0f b6 13             	movzbl (%ebx),%edx
 5b5:	83 c3 01             	add    $0x1,%ebx
 5b8:	84 d2                	test   %dl,%dl
 5ba:	74 24                	je     5e0 <printf+0x80>
    c = fmt[i] & 0xff;
 5bc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 5bf:	85 c9                	test   %ecx,%ecx
 5c1:	74 cd                	je     590 <printf+0x30>
      }
    } else if(state == '%'){
 5c3:	83 f9 25             	cmp    $0x25,%ecx
 5c6:	75 ea                	jne    5b2 <printf+0x52>
      if(c == 'd'){
 5c8:	83 f8 25             	cmp    $0x25,%eax
 5cb:	0f 84 07 01 00 00    	je     6d8 <printf+0x178>
 5d1:	83 e8 63             	sub    $0x63,%eax
 5d4:	83 f8 15             	cmp    $0x15,%eax
 5d7:	77 17                	ja     5f0 <printf+0x90>
 5d9:	ff 24 85 e4 0a 00 00 	jmp    *0xae4(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e3:	5b                   	pop    %ebx
 5e4:	5e                   	pop    %esi
 5e5:	5f                   	pop    %edi
 5e6:	5d                   	pop    %ebp
 5e7:	c3                   	ret    
 5e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop
  write(fd, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 5f6:	6a 01                	push   $0x1
 5f8:	57                   	push   %edi
 5f9:	56                   	push   %esi
 5fa:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5fe:	e8 fa fd ff ff       	call   3fd <write>
        putc(fd, c);
 603:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 607:	83 c4 0c             	add    $0xc,%esp
 60a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 60d:	6a 01                	push   $0x1
 60f:	57                   	push   %edi
 610:	56                   	push   %esi
 611:	e8 e7 fd ff ff       	call   3fd <write>
        putc(fd, c);
 616:	83 c4 10             	add    $0x10,%esp
      state = 0;
 619:	31 c9                	xor    %ecx,%ecx
 61b:	eb 95                	jmp    5b2 <printf+0x52>
 61d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 620:	83 ec 0c             	sub    $0xc,%esp
 623:	b9 10 00 00 00       	mov    $0x10,%ecx
 628:	6a 00                	push   $0x0
 62a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 62d:	8b 10                	mov    (%eax),%edx
 62f:	89 f0                	mov    %esi,%eax
 631:	e8 7a fe ff ff       	call   4b0 <printint>
        ap++;
 636:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 63a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 63d:	31 c9                	xor    %ecx,%ecx
 63f:	e9 6e ff ff ff       	jmp    5b2 <printf+0x52>
 644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 648:	8b 45 d0             	mov    -0x30(%ebp),%eax
 64b:	8b 10                	mov    (%eax),%edx
        ap++;
 64d:	83 c0 04             	add    $0x4,%eax
 650:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 653:	85 d2                	test   %edx,%edx
 655:	0f 84 8d 00 00 00    	je     6e8 <printf+0x188>
        while(*s != 0){
 65b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 65e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 660:	84 c0                	test   %al,%al
 662:	0f 84 4a ff ff ff    	je     5b2 <printf+0x52>
 668:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 66b:	89 d3                	mov    %edx,%ebx
 66d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 670:	83 ec 04             	sub    $0x4,%esp
          s++;
 673:	83 c3 01             	add    $0x1,%ebx
 676:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 679:	6a 01                	push   $0x1
 67b:	57                   	push   %edi
 67c:	56                   	push   %esi
 67d:	e8 7b fd ff ff       	call   3fd <write>
        while(*s != 0){
 682:	0f b6 03             	movzbl (%ebx),%eax
 685:	83 c4 10             	add    $0x10,%esp
 688:	84 c0                	test   %al,%al
 68a:	75 e4                	jne    670 <printf+0x110>
      state = 0;
 68c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 68f:	31 c9                	xor    %ecx,%ecx
 691:	e9 1c ff ff ff       	jmp    5b2 <printf+0x52>
 696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 6a0:	83 ec 0c             	sub    $0xc,%esp
 6a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6a8:	6a 01                	push   $0x1
 6aa:	e9 7b ff ff ff       	jmp    62a <printf+0xca>
 6af:	90                   	nop
        putc(fd, *ap);
 6b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 6b3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6b6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 6b8:	6a 01                	push   $0x1
 6ba:	57                   	push   %edi
 6bb:	56                   	push   %esi
        putc(fd, *ap);
 6bc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6bf:	e8 39 fd ff ff       	call   3fd <write>
        ap++;
 6c4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6c8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6cb:	31 c9                	xor    %ecx,%ecx
 6cd:	e9 e0 fe ff ff       	jmp    5b2 <printf+0x52>
 6d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 6d8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 6db:	83 ec 04             	sub    $0x4,%esp
 6de:	e9 2a ff ff ff       	jmp    60d <printf+0xad>
 6e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6e7:	90                   	nop
          s = "(null)";
 6e8:	ba db 0a 00 00       	mov    $0xadb,%edx
        while(*s != 0){
 6ed:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 6f0:	b8 28 00 00 00       	mov    $0x28,%eax
 6f5:	89 d3                	mov    %edx,%ebx
 6f7:	e9 74 ff ff ff       	jmp    670 <printf+0x110>
 6fc:	66 90                	xchg   %ax,%ax
 6fe:	66 90                	xchg   %ax,%ax

00000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	a1 ac 11 00 00       	mov    0x11ac,%eax
{
 706:	89 e5                	mov    %esp,%ebp
 708:	57                   	push   %edi
 709:	56                   	push   %esi
 70a:	53                   	push   %ebx
 70b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 70e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 718:	89 c2                	mov    %eax,%edx
 71a:	8b 00                	mov    (%eax),%eax
 71c:	39 ca                	cmp    %ecx,%edx
 71e:	73 30                	jae    750 <free+0x50>
 720:	39 c1                	cmp    %eax,%ecx
 722:	72 04                	jb     728 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	39 c2                	cmp    %eax,%edx
 726:	72 f0                	jb     718 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 728:	8b 73 fc             	mov    -0x4(%ebx),%esi
 72b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 72e:	39 f8                	cmp    %edi,%eax
 730:	74 30                	je     762 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 732:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 735:	8b 42 04             	mov    0x4(%edx),%eax
 738:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 73b:	39 f1                	cmp    %esi,%ecx
 73d:	74 3a                	je     779 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 73f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 741:	5b                   	pop    %ebx
  freep = p;
 742:	89 15 ac 11 00 00    	mov    %edx,0x11ac
}
 748:	5e                   	pop    %esi
 749:	5f                   	pop    %edi
 74a:	5d                   	pop    %ebp
 74b:	c3                   	ret    
 74c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	39 c2                	cmp    %eax,%edx
 752:	72 c4                	jb     718 <free+0x18>
 754:	39 c1                	cmp    %eax,%ecx
 756:	73 c0                	jae    718 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 758:	8b 73 fc             	mov    -0x4(%ebx),%esi
 75b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 75e:	39 f8                	cmp    %edi,%eax
 760:	75 d0                	jne    732 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 762:	03 70 04             	add    0x4(%eax),%esi
 765:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 768:	8b 02                	mov    (%edx),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 76f:	8b 42 04             	mov    0x4(%edx),%eax
 772:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 775:	39 f1                	cmp    %esi,%ecx
 777:	75 c6                	jne    73f <free+0x3f>
    p->s.size += bp->s.size;
 779:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 77c:	89 15 ac 11 00 00    	mov    %edx,0x11ac
    p->s.size += bp->s.size;
 782:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 785:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 788:	89 0a                	mov    %ecx,(%edx)
}
 78a:	5b                   	pop    %ebx
 78b:	5e                   	pop    %esi
 78c:	5f                   	pop    %edi
 78d:	5d                   	pop    %ebp
 78e:	c3                   	ret    
 78f:	90                   	nop

00000790 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	57                   	push   %edi
 794:	56                   	push   %esi
 795:	53                   	push   %ebx
 796:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 799:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 79c:	8b 3d ac 11 00 00    	mov    0x11ac,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a2:	8d 70 07             	lea    0x7(%eax),%esi
 7a5:	c1 ee 03             	shr    $0x3,%esi
 7a8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 7ab:	85 ff                	test   %edi,%edi
 7ad:	0f 84 9d 00 00 00    	je     850 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 7b5:	8b 4a 04             	mov    0x4(%edx),%ecx
 7b8:	39 f1                	cmp    %esi,%ecx
 7ba:	73 6a                	jae    826 <malloc+0x96>
 7bc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7c1:	39 de                	cmp    %ebx,%esi
 7c3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7c6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 7d0:	eb 17                	jmp    7e9 <malloc+0x59>
 7d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7da:	8b 48 04             	mov    0x4(%eax),%ecx
 7dd:	39 f1                	cmp    %esi,%ecx
 7df:	73 4f                	jae    830 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e1:	8b 3d ac 11 00 00    	mov    0x11ac,%edi
 7e7:	89 c2                	mov    %eax,%edx
 7e9:	39 d7                	cmp    %edx,%edi
 7eb:	75 eb                	jne    7d8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 7ed:	83 ec 0c             	sub    $0xc,%esp
 7f0:	ff 75 e4             	push   -0x1c(%ebp)
 7f3:	e8 6d fc ff ff       	call   465 <sbrk>
  if(p == (char*)-1)
 7f8:	83 c4 10             	add    $0x10,%esp
 7fb:	83 f8 ff             	cmp    $0xffffffff,%eax
 7fe:	74 1c                	je     81c <malloc+0x8c>
  hp->s.size = nu;
 800:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 803:	83 ec 0c             	sub    $0xc,%esp
 806:	83 c0 08             	add    $0x8,%eax
 809:	50                   	push   %eax
 80a:	e8 f1 fe ff ff       	call   700 <free>
  return freep;
 80f:	8b 15 ac 11 00 00    	mov    0x11ac,%edx
      if((p = morecore(nunits)) == 0)
 815:	83 c4 10             	add    $0x10,%esp
 818:	85 d2                	test   %edx,%edx
 81a:	75 bc                	jne    7d8 <malloc+0x48>
        return 0;
  }
}
 81c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 81f:	31 c0                	xor    %eax,%eax
}
 821:	5b                   	pop    %ebx
 822:	5e                   	pop    %esi
 823:	5f                   	pop    %edi
 824:	5d                   	pop    %ebp
 825:	c3                   	ret    
    if(p->s.size >= nunits){
 826:	89 d0                	mov    %edx,%eax
 828:	89 fa                	mov    %edi,%edx
 82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 830:	39 ce                	cmp    %ecx,%esi
 832:	74 4c                	je     880 <malloc+0xf0>
        p->s.size -= nunits;
 834:	29 f1                	sub    %esi,%ecx
 836:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 839:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 83c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 83f:	89 15 ac 11 00 00    	mov    %edx,0x11ac
}
 845:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 848:	83 c0 08             	add    $0x8,%eax
}
 84b:	5b                   	pop    %ebx
 84c:	5e                   	pop    %esi
 84d:	5f                   	pop    %edi
 84e:	5d                   	pop    %ebp
 84f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 850:	c7 05 ac 11 00 00 b0 	movl   $0x11b0,0x11ac
 857:	11 00 00 
    base.s.size = 0;
 85a:	bf b0 11 00 00       	mov    $0x11b0,%edi
    base.s.ptr = freep = prevp = &base;
 85f:	c7 05 b0 11 00 00 b0 	movl   $0x11b0,0x11b0
 866:	11 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 869:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 86b:	c7 05 b4 11 00 00 00 	movl   $0x0,0x11b4
 872:	00 00 00 
    if(p->s.size >= nunits){
 875:	e9 42 ff ff ff       	jmp    7bc <malloc+0x2c>
 87a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 880:	8b 08                	mov    (%eax),%ecx
 882:	89 0a                	mov    %ecx,(%edx)
 884:	eb b9                	jmp    83f <malloc+0xaf>
 886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 88d:	8d 76 00             	lea    0x0(%esi),%esi

00000890 <free_huge>:
static Header base_huge;
static Header *freep_huge;

void 
free_huge(void *ap)
{
 890:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep_huge; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 891:	a1 a0 11 00 00       	mov    0x11a0,%eax
{
 896:	89 e5                	mov    %esp,%ebp
 898:	57                   	push   %edi
 899:	56                   	push   %esi
 89a:	53                   	push   %ebx
 89b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 89e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep_huge; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8a8:	89 c2                	mov    %eax,%edx
 8aa:	8b 00                	mov    (%eax),%eax
 8ac:	39 ca                	cmp    %ecx,%edx
 8ae:	73 30                	jae    8e0 <free_huge+0x50>
 8b0:	39 c1                	cmp    %eax,%ecx
 8b2:	72 04                	jb     8b8 <free_huge+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b4:	39 c2                	cmp    %eax,%edx
 8b6:	72 f0                	jb     8a8 <free_huge+0x18>
      break;
  
  if(bp + bp->s.size == p->s.ptr){
 8b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8be:	39 f8                	cmp    %edi,%eax
 8c0:	74 30                	je     8f2 <free_huge+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8c2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  
  if(p + p->s.size == bp){
 8c5:	8b 42 04             	mov    0x4(%edx),%eax
 8c8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 8cb:	39 f1                	cmp    %esi,%ecx
 8cd:	74 3a                	je     909 <free_huge+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8cf:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  
  freep_huge = p;
}
 8d1:	5b                   	pop    %ebx
  freep_huge = p;
 8d2:	89 15 a0 11 00 00    	mov    %edx,0x11a0
}
 8d8:	5e                   	pop    %esi
 8d9:	5f                   	pop    %edi
 8da:	5d                   	pop    %ebp
 8db:	c3                   	ret    
 8dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	39 c2                	cmp    %eax,%edx
 8e2:	72 c4                	jb     8a8 <free_huge+0x18>
 8e4:	39 c1                	cmp    %eax,%ecx
 8e6:	73 c0                	jae    8a8 <free_huge+0x18>
  if(bp + bp->s.size == p->s.ptr){
 8e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ee:	39 f8                	cmp    %edi,%eax
 8f0:	75 d0                	jne    8c2 <free_huge+0x32>
    bp->s.size += p->s.ptr->s.size;
 8f2:	03 70 04             	add    0x4(%eax),%esi
 8f5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f8:	8b 02                	mov    (%edx),%eax
 8fa:	8b 00                	mov    (%eax),%eax
 8fc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 8ff:	8b 42 04             	mov    0x4(%edx),%eax
 902:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 905:	39 f1                	cmp    %esi,%ecx
 907:	75 c6                	jne    8cf <free_huge+0x3f>
    p->s.size += bp->s.size;
 909:	03 43 fc             	add    -0x4(%ebx),%eax
  freep_huge = p;
 90c:	89 15 a0 11 00 00    	mov    %edx,0x11a0
    p->s.size += bp->s.size;
 912:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 915:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 918:	89 0a                	mov    %ecx,(%edx)
}
 91a:	5b                   	pop    %ebx
 91b:	5e                   	pop    %esi
 91c:	5f                   	pop    %edi
 91d:	5d                   	pop    %ebp
 91e:	c3                   	ret    
 91f:	90                   	nop

00000920 <malloc_huge>:
  return freep_huge;
}

void* 
malloc_huge(uint nbytes)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	57                   	push   %edi
 924:	56                   	push   %esi
 925:	53                   	push   %ebx
 926:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 929:	8b 45 08             	mov    0x8(%ebp),%eax
  
  if((prevp = freep_huge) == 0){
 92c:	8b 3d a0 11 00 00    	mov    0x11a0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 932:	8d 70 07             	lea    0x7(%eax),%esi
 935:	c1 ee 03             	shr    $0x3,%esi
 938:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep_huge) == 0){
 93b:	85 ff                	test   %edi,%edi
 93d:	0f 84 9d 00 00 00    	je     9e0 <malloc_huge+0xc0>
    base_huge.s.ptr = freep_huge = prevp = &base_huge;
    base_huge.s.size = 0;
  }
  
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 943:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 945:	8b 4a 04             	mov    0x4(%edx),%ecx
 948:	39 f1                	cmp    %esi,%ecx
 94a:	73 6a                	jae    9b6 <malloc_huge+0x96>
 94c:	bb 00 00 08 00       	mov    $0x80000,%ebx
 951:	39 de                	cmp    %ebx,%esi
 953:	0f 43 de             	cmovae %esi,%ebx
  p = sbrkhuge(nu * sizeof(Header));
 956:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 95d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 960:	eb 17                	jmp    979 <malloc_huge+0x59>
 962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 96a:	8b 48 04             	mov    0x4(%eax),%ecx
 96d:	39 f1                	cmp    %esi,%ecx
 96f:	73 4f                	jae    9c0 <malloc_huge+0xa0>
        p->s.size = nunits;
      }
      freep_huge = prevp;
      return (void*)(p + 1);
    }
    if(p == freep_huge)
 971:	8b 3d a0 11 00 00    	mov    0x11a0,%edi
 977:	89 c2                	mov    %eax,%edx
 979:	39 d7                	cmp    %edx,%edi
 97b:	75 eb                	jne    968 <malloc_huge+0x48>
  p = sbrkhuge(nu * sizeof(Header));
 97d:	83 ec 0c             	sub    $0xc,%esp
 980:	ff 75 e4             	push   -0x1c(%ebp)
 983:	e8 15 fb ff ff       	call   49d <sbrkhuge>
  if(p == (char*)-1)
 988:	83 c4 10             	add    $0x10,%esp
 98b:	83 f8 ff             	cmp    $0xffffffff,%eax
 98e:	74 1c                	je     9ac <malloc_huge+0x8c>
  hp->s.size = nu;
 990:	89 58 04             	mov    %ebx,0x4(%eax)
  free_huge((void*)(hp + 1));
 993:	83 ec 0c             	sub    $0xc,%esp
 996:	83 c0 08             	add    $0x8,%eax
 999:	50                   	push   %eax
 99a:	e8 f1 fe ff ff       	call   890 <free_huge>
  return freep_huge;
 99f:	8b 15 a0 11 00 00    	mov    0x11a0,%edx
      if((p = morecore_huge(nunits)) == 0)
 9a5:	83 c4 10             	add    $0x10,%esp
 9a8:	85 d2                	test   %edx,%edx
 9aa:	75 bc                	jne    968 <malloc_huge+0x48>
        return 0;
  }
}
 9ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9af:	31 c0                	xor    %eax,%eax
}
 9b1:	5b                   	pop    %ebx
 9b2:	5e                   	pop    %esi
 9b3:	5f                   	pop    %edi
 9b4:	5d                   	pop    %ebp
 9b5:	c3                   	ret    
    if(p->s.size >= nunits){
 9b6:	89 d0                	mov    %edx,%eax
 9b8:	89 fa                	mov    %edi,%edx
 9ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 9c0:	39 ce                	cmp    %ecx,%esi
 9c2:	74 4c                	je     a10 <malloc_huge+0xf0>
        p->s.size -= nunits;
 9c4:	29 f1                	sub    %esi,%ecx
 9c6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9c9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9cc:	89 70 04             	mov    %esi,0x4(%eax)
      freep_huge = prevp;
 9cf:	89 15 a0 11 00 00    	mov    %edx,0x11a0
}
 9d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9d8:	83 c0 08             	add    $0x8,%eax
}
 9db:	5b                   	pop    %ebx
 9dc:	5e                   	pop    %esi
 9dd:	5f                   	pop    %edi
 9de:	5d                   	pop    %ebp
 9df:	c3                   	ret    
    base_huge.s.ptr = freep_huge = prevp = &base_huge;
 9e0:	c7 05 a0 11 00 00 a4 	movl   $0x11a4,0x11a0
 9e7:	11 00 00 
    base_huge.s.size = 0;
 9ea:	bf a4 11 00 00       	mov    $0x11a4,%edi
    base_huge.s.ptr = freep_huge = prevp = &base_huge;
 9ef:	c7 05 a4 11 00 00 a4 	movl   $0x11a4,0x11a4
 9f6:	11 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f9:	89 fa                	mov    %edi,%edx
    base_huge.s.size = 0;
 9fb:	c7 05 a8 11 00 00 00 	movl   $0x0,0x11a8
 a02:	00 00 00 
    if(p->s.size >= nunits){
 a05:	e9 42 ff ff ff       	jmp    94c <malloc_huge+0x2c>
 a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a10:	8b 08                	mov    (%eax),%ecx
 a12:	89 0a                	mov    %ecx,(%edx)
 a14:	eb b9                	jmp    9cf <malloc_huge+0xaf>
 a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a1d:	8d 76 00             	lea    0x0(%esi),%esi

00000a20 <userspace_vmalloc>:

void *userspace_vmalloc(uint nbytes, int flag) {
 a20:	55                   	push   %ebp
 a21:	89 e5                	mov    %esp,%ebp
 a23:	83 ec 08             	sub    $0x8,%esp
 a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (flag == VMALLOC_SIZE_BASE)
 a29:	85 c0                	test   %eax,%eax
 a2b:	74 13                	je     a40 <userspace_vmalloc+0x20>
    return malloc(nbytes);
  else if (flag == VMALLOC_SIZE_HUGE)
 a2d:	83 f8 01             	cmp    $0x1,%eax
 a30:	75 14                	jne    a46 <userspace_vmalloc+0x26>
  else {
    printf(2, "Please pass VMALLOC_SIZE_BASE or VMALLOC_SIZE_HUGE as flag.\n");
    exit();
    return 0;
  }
}
 a32:	c9                   	leave  
    return malloc_huge(nbytes);
 a33:	e9 e8 fe ff ff       	jmp    920 <malloc_huge>
 a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a3f:	90                   	nop
}
 a40:	c9                   	leave  
    return malloc(nbytes);
 a41:	e9 4a fd ff ff       	jmp    790 <malloc>
    printf(2, "Please pass VMALLOC_SIZE_BASE or VMALLOC_SIZE_HUGE as flag.\n");
 a46:	50                   	push   %eax
 a47:	50                   	push   %eax
 a48:	68 50 0b 00 00       	push   $0xb50
 a4d:	6a 02                	push   $0x2
 a4f:	e8 0c fb ff ff       	call   560 <printf>
    exit();
 a54:	e8 84 f9 ff ff       	call   3dd <exit>
 a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000a60 <userspace_vfree>:

void userspace_vfree(void *ap) {
 a60:	55                   	push   %ebp
 a61:	89 e5                	mov    %esp,%ebp
 a63:	83 ec 08             	sub    $0x8,%esp
 a66:	8b 45 08             	mov    0x8(%ebp),%eax
  if((uint)ap >= KERNBASE) {
 a69:	85 c0                	test   %eax,%eax
 a6b:	78 21                	js     a8e <userspace_vfree+0x2e>
    printf(2, "Error - trying to free a kernel pointer in userspace\n");
    exit();
  }
  
  if(((uint)ap % HUGE_PAGE_SIZE == 0) && ((uint)ap >= HUGE_VA_OFFSET) && ((uint)ap < KERNBASE))
 a6d:	a9 ff ff 3f 00       	test   $0x3fffff,%eax
 a72:	75 07                	jne    a7b <userspace_vfree+0x1b>
 a74:	3d ff ff ff 3f       	cmp    $0x3fffffff,%eax
 a79:	77 0d                	ja     a88 <userspace_vfree+0x28>
    free_huge(ap);
  else
    free(ap);
 a7b:	89 45 08             	mov    %eax,0x8(%ebp)
 a7e:	c9                   	leave  
    free(ap);
 a7f:	e9 7c fc ff ff       	jmp    700 <free>
 a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a88:	c9                   	leave  
    free_huge(ap);
 a89:	e9 02 fe ff ff       	jmp    890 <free_huge>
    printf(2, "Error - trying to free a kernel pointer in userspace\n");
 a8e:	50                   	push   %eax
 a8f:	50                   	push   %eax
 a90:	68 90 0b 00 00       	push   $0xb90
 a95:	6a 02                	push   $0x2
 a97:	e8 c4 fa ff ff       	call   560 <printf>
    exit();
 a9c:	e8 3c f9 ff ff       	call   3dd <exit>
