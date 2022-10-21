<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="acar.kakao.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLDecoder" %>

<jsp:useBean id="at_db" scope="page" class="acar.kakao.AlimTemplateDatabase"/>

<%
	/*
	CMD
	list : 알림톡 템플릿 리스트
	create : 알림톡 템플릿 생성
	update : 알림톡 템플릿 변경
	delete : 알림톡 템플릿 삭제
	*/

    // TODO CHECK
	// String ENC_STR = "EUC-KR";
    String ENC_STR = "UTF-8";	// 맥

    String cmd = request.getParameter("cmd");
	String cmd_use = request.getParameter("use");	// 템플릿 선택 조건에 사용 여부, 관리 여부 추가 2017.12.21
	String cmd_manage = request.getParameter("manage");
	  	
    // 리스트
    if (cmd.equals("list") || cmd.equals("list_only") || cmd.equals("new_list_only") || cmd.equals("log_list_only")) {
             
        String data = request.getParameter("data");
     	// System.out.println("data " + data);

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject)parser.parse(data);
        // System.out.println("(String)json " + json);
        
        String category_1 = (String)json.get("cat_1");
     	// System.out.println("ajax category_1" + category_1);
        
        String category = (String)json.get("cat");
     	// System.out.println("ajax category" + category);
     	
        String m_nm = (String)json.get("m_nm")==null?"":(String)json.get("m_nm");
        m_nm = URLDecoder.decode(m_nm, ENC_STR);
       
        List<AlimTemplateBean> templateList;
        if (cmd.equals("list")) {
            templateList = at_db.selectTemplateList2(category_1, category, cmd_use, cmd_manage);
        } else if (cmd.equals("list_only")) {
   			// System.out.println("list_only");
            templateList = at_db.selectTemplateList(category_1, category, true);
        } else if (cmd.equals("new_list_only")) {
   			// System.out.println("list_only");
            templateList = at_db.selectNewTemplateList(m_nm, true);
        } else {
  			// System.out.println("log_list_only");
            templateList = at_db.selectTemplateLogList(category_1, category, true);    
        }

        JSONArray result = new JSONArray();

        for (int i = 0; i < templateList.size(); i++) {
            AlimTemplateBean template = templateList.get(i);

            JSONObject templateJson = new JSONObject();
            templateJson.put("NO", template.getNo());
            templateJson.put("CAT", template.getCategory());
            templateJson.put("CAT_1", template.getCategory_1());
            templateJson.put("SHOW", template.getShowList());
            templateJson.put("CODE", template.getCode());
            templateJson.put("NAME", template.getName());
            templateJson.put("CONTENT", template.getContent());
            templateJson.put("DESC", template.getDesc());
            templateJson.put("USE_YN", template.getUse_yn());
            templateJson.put("M_NM", template.getM_nm());

            result.put(templateJson);
        }

        out.print(result);
        out.flush();
  
    // 시퀀스
    } else if (cmd.equals("sequence")) {
       
        int result = at_db.sequence();

        JSONObject respJson = new JSONObject();
        respJson.put("sequence", result);
        out.print(respJson);
        out.flush();
        
    // 생성
    } else if (cmd.equals("create")) {
        String data = request.getParameter("data");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject)parser.parse(data);

        int no = Integer.parseInt((String)json.get("no"));
        String code = (String)json.get("code");
        String cat_1 = (String)json.get("cat_1");
        String cat = (String)json.get("cat");
        String show = (String)json.get("show");
        String name = (String)json.get("name");
        String content = (String)json.get("content");
        String desc = (String)json.get("desc");
        String use_yn = (String)json.get("use_yn");
        String m_nm = (String)json.get("m_nm");

        AlimTemplateBean template = new AlimTemplateBean();
        template.setNo(no);
        template.setCode(code);
        template.setCategory_1(cat_1);
        template.setCategory(cat);
        template.setShowList(show);
        template.setName(URLDecoder.decode(name, ENC_STR));
        template.setContent(URLDecoder.decode(content, ENC_STR));
        template.setDesc(URLDecoder.decode(desc, ENC_STR));
        template.setUse_yn(use_yn);
        template.setM_nm(URLDecoder.decode(m_nm, ENC_STR));
      
        int result = at_db.insertTemplate(template);

        JSONObject respJson = new JSONObject();

        if (result == 1) {
            respJson.put("result", "OK");
        } else {
            respJson.put("result", "NOK");
        }

        out.print(respJson);
        out.flush();
        
    // 변경
    } else if (cmd.equals("update")) {
        String data = request.getParameter("data");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject)parser.parse(data);

        int no = Integer.parseInt((String)json.get("no"));
        String code = (String)json.get("code");
        String cat_1 = (String)json.get("cat_1");
        String cat = (String)json.get("cat");
        String show = (String)json.get("show");
        String name = (String)json.get("name");
        String content = (String)json.get("content");
        String desc = (String)json.get("desc");
        String use_yn = (String)json.get("use_yn");
        String m_nm = (String)json.get("m_nm");

        AlimTemplateBean template = new AlimTemplateBean();
        template.setNo(no);
        template.setCode(code);
        template.setCategory_1(cat_1);
        template.setCategory(cat);
        template.setShowList(show);
        template.setName(URLDecoder.decode(name, ENC_STR));
        template.setContent(URLDecoder.decode(content, ENC_STR));
        template.setDesc(URLDecoder.decode(desc, ENC_STR));
        template.setUse_yn(use_yn);
        template.setM_nm(URLDecoder.decode(m_nm, ENC_STR));
       
        int result = at_db.updateTemplate(template);

        JSONObject respJson = new JSONObject();

        if (result == 1) {
            respJson.put("result", "OK");
        } else {
            respJson.put("result", "NOK");
        }

        out.print(respJson);
        out.flush();
        
    // 삭제
    } else if (cmd.equals("delete")) {
        String data = request.getParameter("data");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject)parser.parse(data);

        int no = Integer.parseInt((String)json.get("no"));
        String code = (String)json.get("code");

        int result = at_db.deleteTemplate(no, code);

        JSONObject respJson = new JSONObject();

        if (result == 1) {
            respJson.put("result", "OK");
        } else {
            respJson.put("result", "NOK");
        }

        out.print(respJson);
        out.flush();
    }

%>



