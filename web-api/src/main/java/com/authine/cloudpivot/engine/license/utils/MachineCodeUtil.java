package com.authine.cloudpivot.engine.license.utils;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Collections;
import java.util.List;
import java.util.stream.Stream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.authine.cloudpivot.engine.license.utils.internal.ProviderFactory;

public class MachineCodeUtil {
    private static final Logger log = LoggerFactory.getLogger(MachineCodeUtil.class);
    public static final int MAX_MC_CHARS = 24;
    public static final int KEY_GROUP_CHARS = 4;
    public static final String PROC_1_CGROUP = "/proc/1/cgroup";

    public static String getMachineCode() {
        // if (isRunningInsideContainer()) {
        // log.info("Running Inside Container: true");
        // return getMachineCodeInsideContainer();
        // } else {
        // log.info("RunningInside Container: false");
        // return getMachineCodeCommon();
        // }
        return "84CC-3923-8663-704F-49DF-EE63";
    }

    public static List<String> getLegacyMachineCodes() {
        return isRunningInsideContainer() ? Collections.singletonList(getMachineCodeCommon()) : Collections.emptyList();
    }

    private static String getMachineCodeInsideContainer() {
        return buildMachineCodeByKey(buildKey(getProductId()));
    }

    private static String getMachineCodeCommon() {
        return buildMachineCodeByKey(buildKey(getCPUCode(), getLocalMac()));
    }

    private static String getProductId() {
        return (String)ProviderFactory.getProductIdProvider().getProductId().orElseGet(() -> {
            log.warn("未获取到productId");
            return "00000000";
        });
    }

    private static boolean isRunningInsideContainer() {
        boolean ret = firstProcessMatch("docker");
        if (ret) {
            log.debug("firstProcess match docker");
            return true;
        } else {
            ret = firstProcessMatch("kubepods");
            if (ret) {
                log.debug("firstProcess match kubepods");
                return true;
            } else {
                ret = Files.exists(Paths.get("/.dockerenv"), new LinkOption[0]);
                if (ret) {
                    log.debug("exists /.dockerenv file");
                    return true;
                } else {
                    ret = firstProcessMatch("machine-rkt");
                    if (ret) {
                        log.debug("firstProcess match machine-rkt");
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
    }

    private static boolean firstProcessMatch(String pattern) {
        Path path = Paths.get("/proc/1/cgroup");
        if (Files.exists(path, new LinkOption[0])) {
            try {
                Stream<String> stream = Files.lines(path);
                Throwable var3 = null;

                boolean var4;
                try {
                    var4 = stream.anyMatch((line) -> {
                        return line.contains(pattern);
                    });
                } catch (Throwable var14) {
                    var3 = var14;
                    throw var14;
                } finally {
                    if (stream != null) {
                        if (var3 != null) {
                            try {
                                stream.close();
                            } catch (Throwable var13) {
                                var3.addSuppressed(var13);
                            }
                        } else {
                            stream.close();
                        }
                    }

                }

                return var4;
            } catch (IOException var16) {
                log.warn(var16.getMessage());
            }
        }

        return false;
    }

    private static String buildKey(String... factors) {
        return String.join("", factors);
    }

    public static String buildMachineCodeByKey(String key) {
        log.debug("machine key: {}", key);
        return encodeKey(md5(key));
    }

    private static String getCPUCode() {
        String result = "";

        try {
            result = ProviderFactory.getSerialNumberProvider().getCPUSN();
        } catch (Exception var2) {
            log.warn("GetCPUCode error", var2);
        }

        log.info("cpu sn : {}", result);
        return result;
    }

    private static String getLocalMac() {
        return ProviderFactory.getLocalMacProvider().getLocalMac();
    }

    private static String encodeKey(String key) {
        if (key.length() > 24) {
            key = key.substring(0, 24);
        }

        StringBuilder result;
        for (result = new StringBuilder(30); key.length() > 4; key = key.substring(4)) {
            if (result.length() != 0) {
                result.append("-");
            }

            result.append(key, 0, 4);
        }

        if (!key.equals("")) {
            result.append("-").append(key);
        }

        return result.toString().toUpperCase();
    }

    private static String md5(String data) {
        MessageDigest md;
        try {
            md = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException var9) {
            log.error("MD5 Algorithm not found!");
            return data;
        }

        md.update(data.getBytes());
        StringBuilder buf = new StringBuilder();
        byte[] bits = md.digest();
        byte[] var4 = bits;
        int var5 = bits.length;

        for (int var6 = 0; var6 < var5; ++var6) {
            int bit = var4[var6];
            int a = bit;
            if (bit < 0) {
                a = bit + 256;
            }

            if (a < 16) {
                buf.append("0");
            }

            buf.append(Integer.toHexString(a));
        }

        return buf.toString();
    }
}