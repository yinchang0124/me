package test;

class Son extends Parent{
    static {System.out.println("son静态代码");};
    Son(){
        System.out.println("son构造方法");
    };

    public static void main(String[] args) {
        new Son();
        new Son();
    }
}

class Parent {
    static {
        System.out.println("parent静态代码");
    }
    public Parent(){
        System.out.println("parent构造方法");
    }
}
