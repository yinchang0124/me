package main.java.study.dao.implement;

import java.util.Collection;

public abstract class test<E> implements Collection<E> {
    public abstract int size();
    public boolean isEmpty(){
        return size()==0;
    }

}
