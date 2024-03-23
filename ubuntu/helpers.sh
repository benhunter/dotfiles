# MCSO AOS Pintos Project 2 - User Programs
make_check() {
  cd ~/projects/aos_pintos_project_2/aos_pintos/src/
  make clean
  cd userprog/
  make && make check
}

pintos_gdb_test() {
  cd ~/projects/aos_pintos_project_2/aos_pintos/src/userprog/
  echo "Testing $TEST in gdb..."
  make && pintos -v -k -T 60 --qemu --filesys-size=2 -p build/tests/userprog/$TEST -a $TEST --gdb -- -q -f run $TEST < /dev/null 
}

pintos_test() {
  cd ~/projects/aos_pintos_project_2/aos_pintos/src/userprog/
  echo "Testing $TEST..."
  make && pintos -v -k -T 60 --qemu --filesys-size=2 -p build/tests/userprog/$TEST -a $TEST -- -q -f run $TEST < /dev/null 
}

test_result() {
  cd ~/projects/aos_pintos_project_2/aos_pintos/src/userprog/
  echo "Testing $TEST..."
  rm build/tests/userprog/$TEST.result; make build/tests/userprog/$TEST.result
}
