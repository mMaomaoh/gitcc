package app.ext.util;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public class ExtClassUtils {

    public static List<String> getFiledsName(Class<?> clzz) {
        Field[] fields = clzz.getDeclaredFields();
        List<String> list = new ArrayList<>();
        for (Field f : fields) {
            list.add(f.getName().toString());
        }
        return list;
    }

    public static List<String> getFiledsValue(Class<?> clzz) throws Exception {
        Field[] fields = clzz.getDeclaredFields();
        List<String> list = new ArrayList<>();
        for (Field f : fields) {
            list.add(f.get(f.getName()).toString());
        }
        return list;
    }

}
