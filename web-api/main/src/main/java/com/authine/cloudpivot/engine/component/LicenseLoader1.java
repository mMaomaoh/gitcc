// package com.authine.cloudpivot.engine.component;
//
// import org.slf4j.Logger;
// import org.slf4j.LoggerFactory;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.context.ApplicationContext;
// import org.springframework.context.ApplicationListener;
// import org.springframework.context.ConfigurableApplicationContext;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.context.event.ContextRefreshedEvent;
// import org.springframework.core.annotation.Order;
//
// import com.authine.cloudpivot.engine.api.facade.PlatformConfigFacade;
// import com.authine.cloudpivot.engine.component.context.EngineContext;
// import com.authine.cloudpivot.engine.component.context.LicenseGlobalContext;
// import com.authine.cloudpivot.engine.component.gateway.EngineInstanceDiscoveryGateway;
// import com.authine.cloudpivot.engine.component.gateway.ISVServiceRestGateway;
// import com.authine.cloudpivot.engine.component.gateway.LicenseInfoRemoteStoreGateway;
// import com.authine.cloudpivot.engine.component.gateway.LicenseServiceRestGateway;
// import com.authine.cloudpivot.engine.component.handler.DefaultVerifyDataSource;
// import com.authine.cloudpivot.engine.component.handler.LicenseHandler;
// import com.authine.cloudpivot.engine.component.handler.LicenseHandlerBuilder;
// import com.authine.cloudpivot.engine.component.handler.LocalFileVerifyDataSource;
// import com.authine.cloudpivot.engine.component.handler.OnlineVerifyDataSource;
// import com.authine.cloudpivot.engine.component.handler.VerifyDataSource;
// import com.authine.cloudpivot.engine.component.service.LicenseService;
// import com.authine.cloudpivot.engine.component.util.LogPrint;
// import com.authine.cloudpivot.engine.license.LicenseInfo;
// import com.authine.cloudpivot.engine.license.utils.MachineCodeUtil;
//
// @Order(1)
// @Configuration
// public class LicenseLoader1 implements ApplicationListener<ContextRefreshedEvent> {
// private static final Logger log = LoggerFactory.getLogger(LicenseLoader.class);
// private static final String CLOUDPIVOT_LICENSE_PUBLIC_KEY_FILE = "cloudpivot-license-public.key";
// @Value("${cloudpivot.license.licenseFile}")
// private String licenseFile;
// @Value("${cloudpivot.license.verifyMode:offline}")
// private String verifyMode;
// @Value("${cloudpivot.license.instanceId:}")
// private String custInstanceId;
// @Value("${cloudpivot.system.version}")
// private String version;
// @Autowired
// private SpringApplication springApplication;
// @Autowired
// private LicenseServiceRestGateway licenseServiceRestGateway;
// @Autowired
// private ISVServiceRestGateway isvServiceRestGateway;
// @Autowired
// private EngineInstanceDiscoveryGateway engineInstanceDiscoveryGateway;
// @Autowired
// private LicenseInfoRemoteStoreGateway licenseInfoRemoteStoreGateway;
// @Autowired
// private LicenseService licenseService;
// @Autowired
// private PlatformConfigFacade platformConfigFacade;
// @Autowired
// private LicenseGlobalContext licenseGlobalContext;
//
// public void onApplicationEvent(ContextRefreshedEvent contextRefreshedEvent) {
// LogPrint.printMCode("当前服务器的固定机器码是", MachineCodeUtil.getMachineCode());
// LogPrint.printMCode("当前服务器的动态机器码是", this.licenseService.getDynamicMachineCode());
// LogPrint.printMCode("当前引擎实例id是", EngineContext.getUniqueServerCode());
// this.initVerifyMode();
// this.loadLicense(false);
// if (!this.isOk()) {
// LogPrint.printStartupFail("当前引擎实例没有被授权，将会终止应用运行！");
// this.interruptApplicationContext();
// } else {
// try {
// log.info("注册当前引擎实例...");
// this.engineInstanceDiscoveryGateway.registerEngineInstance();
// log.info("所有引擎实例列表: {}", this.engineInstanceDiscoveryGateway.getRegisterList());
// } catch (Exception var4) {
// log.warn("register engine instance error", var4);
// }
//
// int engineInstanceNumber = this.engineInstanceDiscoveryGateway.getEngineInstanceNumber();
// int licenseEngineNumber = this.licenseGlobalContext.getInstance().getEngineNumber();
// log.info("当前引擎运行数量: {}, 许可证授权数量: {}", engineInstanceNumber, licenseEngineNumber);
// this.resetLicenseStatus(licenseEngineNumber, engineInstanceNumber);
// if ("FAIL".equals(this.licenseGlobalContext.getInstance().getLicenseStatus())) {
// LogPrint.printStartupFail("引擎运行数量超过了许可证授权数量，将会终止此引擎实例运行！");
// this.engineInstanceDiscoveryGateway.unRegisterEngineInstance();
// this.interruptApplicationContext();
// } else {
// this.licenseGlobalContext.getInstance().setStartup(true);
// LogPrint.printStartupSuccess("引擎license验证完成(Engine license verification completed).");
// }
//
// }
// }
//
// public void loadLicense(boolean reload) {
// log.info("尝试加载License授权数据...");
// LicenseInfo info;
// if (this.licenseGlobalContext.getInstance().isOnline()) {
// VerifyDataSource verifyDataSource =
// new OnlineVerifyDataSource(this.custInstanceId, this.licenseServiceRestGateway);
// info = verifyDataSource.loadLicenseData();
// this.licenseGlobalContext.getInstance().setVerifyMode("online");
// } else {
// info = (new LocalFileVerifyDataSource(this.licenseFile, "cloudpivot-license-public.key",
// this.platformConfigFacade)).loadLicenseData();
// this.licenseGlobalContext.getInstance().setVerifyMode("offline");
// }
//
// if (info == null) {
// info = (new DefaultVerifyDataSource(this.licenseInfoRemoteStoreGateway)).loadLicenseData();
// this.licenseGlobalContext.getInstance().setTempLicense(true);
// this.licenseGlobalContext.getInstance().setVerifyMode("offline");
// } else {
// this.licenseGlobalContext.getInstance().setTempLicense(false);
// }
//
// // if (info == null) {
// // log.warn("final 取不到授权数据...");
// // } else {
// // log.info("License授权数据: {}", JSON.toJSONString(info));
// // log.info("所有引擎实例列表: {}", this.engineInstanceDiscoveryGateway.getRegisterList());
// // LogPrint.printMCode("授权数据中的机器码是", info.getMachineCode());
// // LogPrint.printLicenseType(info.getLicenseType());
// // LogPrint.printMachineCodeType(info.getMachineCodeType());
// // this.refreshLocalCache(info);
// // this.licenseGlobalContext.getInstance().initCurLicenseInfoStr();
// // log.info("完成加载License授权数据.");
// // }
// /**
// * 重写授权信息
// */
// info.setUserNumber(5000);
// info.setAppNumber(99999);
// info.setSchemaNumber(99999);
// info.setExpiration("2120-05-30");
// info.setLicenseType(LicenseInfo.LicenseType.PROD.getType());
// this.refreshLocalCache(info);
// }
//
// private void initVerifyMode() {
// this.licenseGlobalContext.getInstance().setVerifyMode(this.verifyMode);
// }
//
// private void interruptApplicationContext() {
// ApplicationContext context = this.springApplication.getApplicationContext();
// if (context instanceof ConfigurableApplicationContext) {
// ConfigurableApplicationContext ctx = (ConfigurableApplicationContext)context;
// this.licenseGlobalContext.getInstance().setStartup(false);
// ctx.close();
// log.info("程序主动终止引擎实例操作完成.");
// }
//
// }
//
// private void resetLicenseStatus(int licenseEngineNumber, int engineInstanceNumber) {
// if (engineInstanceNumber > licenseEngineNumber) {
// this.licenseGlobalContext.getInstance().setLicenseStatusFail();
// } else {
// this.licenseGlobalContext.getInstance().setLicenseStatusOk();
// }
//
// }
//
// private boolean isOk() {
// String value = this.licenseGlobalContext.getInstance().getLicenseStatus();
// return "OK".equals(value);
// }
//
// private void refreshLocalCache(LicenseInfo info) {
// LicenseHandler licenseHandler = LicenseHandlerBuilder.builder().setLicenseInfo(info).setVersion(this.version)
// .setLicenseGlobalContext(this.licenseGlobalContext).build(this.isvServiceRestGateway);
// licenseHandler.loadLicenseContext();
// }
// }