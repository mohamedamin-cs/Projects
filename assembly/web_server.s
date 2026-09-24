.intel_syntax noprefix
.global _start
_start:
push rbx
push rbp
push r12
push r13
push r14
push r15
mov rdi, 2
mov rsi, 1
mov rdx, 0
mov rax, 41
syscall
mov rbx, rax

sub rsp, 16
mov qword ptr [rsp + 8], 0
mov dword ptr [rsp + 4], 0
mov word ptr [rsp + 2], 0x5000
mov word ptr [rsp], 2

mov rdi, rbx
mov rsi, rsp
mov rdx, 16
mov rax, 49
syscall

mov rdi, rbx
mov rsi, 0
mov rax, 50
syscall

loop:
mov rdi, rbx
mov rsi, 0
mov rdx, 0
mov rax, 43
syscall
mov rbp, rax
mov rax, 57
syscall

cmp rax, 0
jne parent

child:
mov rdi, rbx
mov rax, 3
syscall
sub rsp, 512
mov rdi, rbp
mov rsi, rsp
mov rdx, 512
mov rax, 0
syscall
mov r15, rax

cmp byte ptr [rsp], 'P'
je parse_post
lea rdi, [rsp + 4]
jmp find_space

parse_post:
lea rdi, [rsp + 5]
find_space:
mov rdx, 0
find_space_loop:
movzx rax, byte ptr [rdi + rdx]
cmp rax, 32
je space_found
inc rdx
jmp find_space_loop
space_found:
mov byte ptr [rdi + rdx], 0
cmp byte ptr [rsp], 'P'
je do_post

do_get:
mov rsi, 0
mov rax, 2
syscall
mov r13, rax
sub rsp, 256
mov rdi, r13
mov rsi, rsp
mov rdx, 256
mov rax, 0
syscall
mov r14, rax

mov rdi, r13
mov rax, 3
syscall

mov rdi, rbp
lea rsi, [rip + path]
mov rdx, 19
mov rax, 1
syscall

mov rdi, rbp
mov rsi, rsp
mov rdx, r14
mov rax, 1
syscall

jmp child_cleanup

do_post:
mov rsi, 0x41
mov rdx, 0777
mov rax, 2
syscall
mov r13, rax
mov r12, rsp

find_header_end:
cmp dword ptr [r12], 0x0a0d0a0d
je header_end_found
inc r12
jmp find_header_end
header_end_found:
add r12, 4
lea rax, [rsp + r15]
sub rax, r12
mov r14, rax

mov rdi, r13
mov rsi, r12
mov rdx, r14
mov rax, 1
syscall

mov rdi, r13
mov rax, 3
syscall

mov rdi, rbp
lea rsi, [rip + path]
mov rdx, 19
mov rax, 1
syscall

child_cleanup:
mov rdi, rbp
mov rax, 3
syscall
mov rdi, 0
mov rax, 60
syscall

parent:
mov rdi, rbp
mov rax, 3
syscall
jmp loop
path:
.asciz "HTTP/1.0 200 OK\r\n\r\n"

i built this web server, sqhould i post it on linkedin???
