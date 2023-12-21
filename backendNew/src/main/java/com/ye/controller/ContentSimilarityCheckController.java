package com.ye.controller;

import cn.textcheck.CheckManager;
import cn.textcheck.engine.checker.CheckTask;
import cn.textcheck.engine.pojo.LocalPaperLibrary;
import cn.textcheck.engine.pojo.Paper;
import cn.textcheck.engine.report.Reporter;
import cn.textcheck.engine.type.ReportType;
import cn.textcheck.starter.EasyStarter;
import com.ye.pojo.ClassPojo;
import com.ye.pojo.FilePojo;
import com.ye.pojo.UserPojo;
import com.ye.utils.FileConversionUtil;
import com.ye.utils.RandomProduct;
import com.ye.utils.Result;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@RestController
public class ContentSimilarityCheckController {
    // 定义一个对象用于作为锁
    private static final Object lock = new Object();
    private static String password = "";
    @RequestMapping(value = "/ContentCheck", method = RequestMethod.POST)
    public String ContentCheck(@RequestParam("fileA") MultipartFile fileA,
                               @RequestParam("fileB") MultipartFile fileB) throws IOException, InterruptedException {
        synchronized (lock) {        // 只允许pdf word excel txt rtf文件
            System.out.println(fileA.getContentType());
            if (fileA.getContentType() == null || !(fileA.getContentType().contains("pdf") || fileA.getContentType().contains("word") || fileA.getContentType().contains("excel") || fileA.getContentType().contains("txt") || fileA.getContentType().contains("rtf") || fileA.getContentType().contains("text"))) {
                return Result.defeat("文件A格式不正确, 只允许pdf word excel txt rtf文件");
            }
            if (fileB.getContentType() == null || !(fileB.getContentType().contains("pdf") || fileB.getContentType().contains("word") || fileB.getContentType().contains("excel") || fileB.getContentType().contains("txt") || fileB.getContentType().contains("rtf") || fileB.getContentType().contains("text"))) {
                return Result.defeat("文件B格式不正确, 只允许pdf word excel txt rtf文件");
            }
            String localPathA = "C:\\Users\\Yellowish\\Desktop\\new\\testA";
            String localPathB = "C:\\Users\\Yellowish\\Desktop\\new\\testB";
            String localResult = "C:\\Users\\Yellowish\\Desktop\\new\\result";
            String localZipResult = "C:\\Users\\Yellowish\\Desktop\\new\\result.zip";
            String fileAPath = localPathA + "\\" + fileA.getOriginalFilename();
            String fileBPath = localPathB + "\\" + fileB.getOriginalFilename();
            FileConversionUtil.deleteFolderContents(new File(localResult));
            FileConversionUtil.deleteFolderContents(new File(localPathA));
            FileConversionUtil.deleteFolderContents(new File(localPathB));
            FileConversionUtil.saveMultipartFileToLocal(fileA, fileAPath);
            FileConversionUtil.saveMultipartFileToLocal(fileB, fileBPath);


            FileConversionUtil.deleteFolderContents(new File(localResult));
            CheckManager.INSTANCE.setRegCode("zX+he13egYtjqKDHuS6Ld9iYUD/4JY+ug+XPPVmzl+1OCfbCk13sBxt9pPdtlkWB8b/49yfGSonPu4ZS6Qx11qZRFm8huk6R/dL9nUMxWn7pOlOCzmloejO4r2GGkWOI9xvG1ilZQOg3hUD8uYeHPaP98GkMqO09TrD2vsYmXpvi70YpOkht7/M1XJ6PzDcxZBlfK7ZyIkTuLxkcJwe/UNUUXUkU6+xDF7PqVCuvilvaMShPdgzeW+md7CKXcypLt9WYDX2Wflb05V7mz4CAMM6Spuaikvt/CQ9LkriW3/Sq2H5cinFzPJBc4yctXvycaLGAs5UXLRh6JtADgmSQ2QwFflfpT3DF6tP4oWK5KHEb6FNcVjIwyhlBf2p2hHGhpLb50701RmsRtd4xylX6qxrLYl2D61DPT1F7LcMp2V548tmBWX9bf3En0J6XKeuI+92Wgh5JigvBa7WaM04hz2Ah/q1Vr2P/ytJxAg2xzX0=");
            EasyStarter.check(new File(localPathA), new File(localPathB), localResult);
            FileConversionUtil.zipFolder(localResult, localZipResult);

            password = RandomProduct.getCheckCode();
            Map<String, Object> map = new HashMap<>();
            map.put("token", password);
            return Result.success("成功查重", map);
        }

    }

    @RequestMapping(value = "/getContentCheck", method = RequestMethod.GET)
    public String getContentCheck(HttpServletResponse response,
                                  @RequestParam("checkToken") String checkToken) throws IOException, InterruptedException {
        if (!checkToken.equals(password)) {
            return Result.defeat("checkToken不正确");
        }
        byte[] bytes = Files.readAllBytes(Paths.get("C:\\Users\\Yellowish\\Desktop\\new\\result.zip"));
        return Result.success("查重报告.zip", bytes, response);
    }


}
