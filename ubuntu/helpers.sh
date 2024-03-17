# MCSO AOS Pintos Project 2 - User Programs
make_check() {
    cd ~/projects/aos_pintos_project_2/aos_pintos/src/
    make clean
    cd userprog/
    make && make check
}
