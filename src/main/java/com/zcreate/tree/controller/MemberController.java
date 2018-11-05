package com.zcreate.tree.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.LongSerializationPolicy;
import com.zcreate.tree.dao.MemberMapper;
import com.zcreate.tree.pojo.Member;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.*;

@Controller

@RequestMapping("/")
public class MemberController {
    private static Logger log = LoggerFactory.getLogger(MemberController.class);
    /*@Value("#{prop.title}")
    private String title;
    @Value("#{prop.short_title}")
    private String short_title;*/
    @Resource
    private Properties configs;

    @Autowired
    private MemberMapper memberMapper;
    private Gson gson = new GsonBuilder().setLongSerializationPolicy(LongSerializationPolicy.STRING).
            serializeNulls().setDateFormat("yyyy-MM-dd HH:mm").create();

    @ResponseBody
    @RequestMapping(value = "/listMember", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listMember(@RequestParam(value = "memberId", required = false) Long memberId,
                             @RequestParam(value = "userName", required = false) String userName,
                             @RequestParam(value = "memberNo", required = false) String memberNo,
                             @RequestParam(value = "phone", required = false) String phone,
                             @RequestParam(value = "idCard", required = false) String idCard,
                             @RequestParam(value = "parentNo", required = false) String parentNo,
                             @RequestParam(value = "parentName", required = false) String parentName,
                             @RequestParam(value = "realName", required = false) String realName,
                             @RequestParam(value = "threeThirty", required = false) Boolean threeThirty,
                             @RequestParam(value = "draw", required = false) Integer draw,
                             @RequestParam(value = "start", required = false) Integer start,
                             @RequestParam(value = "length", required = false, defaultValue = "100") Integer length
    ) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberId", memberId);
        param.put("userName", userName);
        param.put("memberNo", memberNo);
        param.put("phone", phone);
        param.put("idCard", idCard);
        param.put("realName", realName);
        param.put("threeThirty", threeThirty);
        param.put("parentNo", parentNo);
        param.put("parentName", parentName);
        param.put("start", start);
        if (parentNo == null)
            param.put("length", length);
        List<Member> members = memberMapper.selectMember(param);
        int recordCount = memberMapper.getMemberCount(param);

        Map<String, Object> result = new HashMap<>();
        result.put("data", members);
        result.put("draw", draw);//draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/memberTree", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberTree(@RequestParam(value = "memberNo", required = false) String memberNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("parentNo", memberNo);
        List<Member> members = memberMapper.selectMember(param);

        Map<String, Object> result = new HashMap<>();
        Map<String, Object> obj = new HashMap<>();
        //List<Map<String, Object>> oj = new List<HashMap<>>();
        for (Member member : members) {
            Map<String, Object> item = new HashMap<>();
            String baseText = "层级:" + member.getCurLevel() + "，：" + ("".equals(member.getRealName()) ? "用户名：" + member.getUserName() : "姓名：" + member.getRealName()) + "，手机：" + member.getPhone();
            if (member.getDirectCount() > 0) {
                baseText += "，下级深度：" + member.getChildDepth() + "，下级总数：" + member.getChildTotal();
                item.put("type", "folder");
            } else {
                baseText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i class='ace-icon fa fa-user'></i>&nbsp;" + baseText;
                item.put("type", "item");
            }

            item.put("text", baseText);

            Map<String, Object> addParam = new HashMap<>();
            addParam.put("children", member.getDirectCount() > 0 ? true : null);
            addParam.put("id", member.getMemberNo());
            //addParam.put("info", member.getMemberInfo());

            item.put("additionalParameters", addParam);

            obj.put("node_" + member.getMemberNo(), item);
        }

        result.put("data", obj);
        result.put("status", "OK");
        return gson.toJson(result);
    }

    @RequestMapping(value = "/member", method = RequestMethod.GET)
    public String member(@RequestParam(value = "searchKey", required = false) String searchKey, ModelMap model) {
        log.debug("title = " + configs.getProperty("title"));

        model.addAttribute("title",  configs.getProperty("title"));
        model.addAttribute("short_title", configs.getProperty("short_title"));
        return "/member";
    }


    @RequestMapping(value = "/memberInfo", method = RequestMethod.GET)
    public String memberInfo(@RequestParam(value = "memberNo", required = false) String memberNo,
                             @RequestParam(value = "memberId", required = false) Long memberId,
                             @RequestParam(value = "realName", required = false) String realName,
                             @RequestParam(value = "userName", required = false) String userName,
                             ModelMap model) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("memberId", memberId);
        param.put("realName", realName);
        param.put("userName", userName);
        List<Member> members = memberMapper.selectMember(param);
        if (members.size() >= 1)
            model.addAttribute("member", members.get(0));
        model.addAttribute("title",  configs.getProperty("title"));
        model.addAttribute("short_title", configs.getProperty("short_title"));

        return "/memberInfo";
    }

    @ResponseBody
    @RequestMapping(value = "/getParent", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getParent(@RequestParam(value = "memberNo") String memberNo,
                            @RequestParam(value = "maxlevel", required = false, defaultValue = "30") Integer maxlevel) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("maxlevel", maxlevel);
        List<Map<String, Object>> recordCounts = memberMapper.selectParent(param);

        Map<String, Object> result = new HashMap<>();
        result.put("data", recordCounts);
        result.put("recordsTotal", recordCounts.size());
        result.put("recordsFiltered", recordCounts.size());
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/memberDeposit", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberDeposit(@RequestParam(value = "memberId", required = false) Long memberId,
                                @RequestParam(value = "draw", required = false) Integer draw,
                                @RequestParam(value = "start", required = false) Integer start,
                                @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("user_id", memberId);
        param.put("start", start);
        param.put("length", length);

        int recordCount = memberMapper.getDepositCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", memberMapper.selectDeposit(param));
        result.put("draw", draw);/*draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。*/
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/memberWithdraw", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberWithdraw(@RequestParam(value = "memberId", required = false) Long memberId,
                                 @RequestParam(value = "draw", required = false) Integer draw,
                                 @RequestParam(value = "start", required = false) Integer start,
                                 @RequestParam(value = "length", required = false, defaultValue = "10000") Integer length) {
        Map<String, Object> param = new HashMap<>();
        param.put("user_id", memberId);
        param.put("start", start);
        param.put("length", length);

        int recordCount = memberMapper.getWithdrawCount(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", memberMapper.selectWithdraw(param));
        result.put("draw", draw);/*draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。*/
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

}
