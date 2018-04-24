#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

//待Lua调用的C注册函数。
static int add2(lua_State* L)
{
    //检查栈中的参数是否合法，1表示Lua调用时的第一个参数(从左到右)，依此类推。
    //如果Lua代码在调用时传递的参数不为number，该函数将报错并终止程序的执行。
    double op1 = luaL_checknumber(L,1);
    double op2 = luaL_checknumber(L,2);
    //将函数的结果压入栈中。如果有多个返回值，可以在这里多次压入栈中。
    lua_pushnumber(L,op1 + op2);
    //返回值用于提示该C函数的返回值数量，即压入栈中的返回值数量。
    return 1;
}

//另一个待Lua调用的C注册函数。
static int sub2(lua_State* L)
{
    double op1 = luaL_checknumber(L,1);
    double op2 = luaL_checknumber(L,2);
    lua_pushnumber(L,op1 - op2);
    return 1;
}
static const struct luaL_Reg mylib [] = {
	        {"add2", add2},
	        {"sub2", sub2},

			        {NULL, NULL}
};

int luaopen_demo(lua_State *L)
{
       luaL_register(L, "demo", mylib);
       
	   return 1;
}


