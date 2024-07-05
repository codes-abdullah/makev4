#include "WIN/Window.h"
#include "utils/logger/log.h"
#include <GLFW/glfw3.h>
int main(){
	
	log("i'm logger");
	goWindow();
	glfwInit();
	return 0;
}
