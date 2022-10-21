<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="acar.kakao.*" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="acar.util.AddUtil" %>
<%@ page import="acar.cont.AddContDatabase" %>
<%@ page import="acar.cont.ContBaseBean" %>
<%@ page import="acar.user_mng.UserMngDatabase" %>
<%@ page import="acar.user_mng.UsersBean" %>
<%@ page import="acar.client.AddClientDatabase" %>
<%@ page import="acar.client.ClientBean" %>
<%@ page import="acar.client.ClientSiteBean" %>
<%@ page import="acar.cont.CarMgrBean" %>
<%@ page import="acar.cont.ContFeeBean" %>
<%@ page import="acar.util.LoginBean" %>
<%@ page import="acar.common.CommonDataBase" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<%
    /*
        CMD
        send_msg : 알림톡 메시지 전송
        search_cont : 계약 리스트
        cont_info : 계약 정보
     */

    // TODO CHECK
  //  String ENC_STR = "EUC-KR";
    String ENC_STR = "UTF-8";       // 맥

    String cmd = request.getParameter("cmd");
    CommonDataBase cm_db = CommonDataBase.getInstance();
    AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
    AlimTalkLogDatabase atl_db = AlimTalkLogDatabase.getInstance();

    // 메시지 전송
    if (cmd.equals("send_msg")) {
        String data = request.getParameter("data");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject)parser.parse(data);

        int msgType    = Integer.parseInt((String)json.get("msg_type"));
        String tplCode = (String)json.get("template_code");
        String content = URLDecoder.decode((String)json.get("content"), ENC_STR);
        String recipientNum = (String)json.get("recipient_num");
        String callbackNum  = (String)json.get("callback_num");
        String rentLCd = (String)json.get("l_cd");
        String userId = (String)json.get("user_id");
        org.json.simple.JSONArray multiJsonArray = (org.json.simple.JSONArray)json.get("multi");
        
        // 일반 전송
        if (multiJsonArray == null) {
            at_db.sendMessage(msgType, tplCode, content, recipientNum, callbackNum, null, rentLCd, userId);
            //System.out.println("msgType:" + msgType + " tplCode:" + tplCode + ": alimtalk template" );
            
        // 멀티 전송
        } else {
            Iterator<JSONObject> it = multiJsonArray.iterator();
            while (it.hasNext()) {
                JSONObject jsonObject = it.next();
                String name = URLDecoder.decode((String)jsonObject.get("name"), ENC_STR);
                String num = (String)jsonObject.get("num");

                String lContent = content.replace("{customer_name}", name);
                at_db.sendMessage(msgType, tplCode, lContent, num, callbackNum, null, rentLCd, userId);
            }
        }

        JSONObject result = new JSONObject();
        result.put("result", "OK");

        out.print(result);
        out.flush();
    }

    // 계약 리스트 가져오기 - 항목에 추가시 contJson에 추가 (20171020)
    else if (cmd.equals("search_cont")) {
        String data = request.getParameter("data");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject) parser.parse(data);

        String s_kd = (String) json.get("s_kd");
        String t_wd = URLDecoder.decode((String)json.get("t_wd"), ENC_STR);
      
        
//          String t_wd = URLDecoder.decode(json.get("t_wd").toString(), "UTF-8");

 
         
        String andor = (String) json.get("andor");

        String gubun4 = (String) json.get("gubun4");
        String gubun5 = (String) json.get("gubun5");
        String st_dt = AddUtil.replace((String) json.get("st_dt"), "-", "");
        String end_dt = AddUtil.replace((String) json.get("end_dt"), "-", "");

   //     AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();		  //알림톡으로 변경 - 쿼리단순화 -2017-09-26
        Vector vt = at_db.getContList_20160614(s_kd, t_wd, andor, gubun4, gubun5, st_dt, end_dt);

        String ins_com_nm =  "";

        JSONArray result = new JSONArray();
        for (int i = 0; i < vt.size(); i++) {
            Hashtable cont = (Hashtable) vt.elementAt(i);

            JSONObject contJson = new JSONObject();

            ins_com_nm =  cm_db.getNameById(String.valueOf(cont.get("INS_COM_ID")),"INS_COM");
            ins_com_nm =  AddUtil.subData(ins_com_nm, 4);

            contJson.put("FIRM_NM", cont.get("FIRM_NM"));
            contJson.put("RENT_MNG_ID", cont.get("RENT_MNG_ID"));
            contJson.put("RENT_L_CD", cont.get("RENT_L_CD"));
            contJson.put("RENT_ST", cont.get("RENT_ST"));
            contJson.put("RENT_DT", cont.get("RENT_DT"));
            contJson.put("CAR_NO", cont.get("CAR_NO"));
            contJson.put("CAR_NM", cont.get("CAR_NM"));
            contJson.put("INS_NM",  ins_com_nm);
            contJson.put("BUS_NM",  cont.get("BUS_NM"));
            contJson.put("BUS_M_TEL",  cont.get("BUS_M_TEL"));
            contJson.put("BUS_NM2",  cont.get("BUS_NM2"));
            contJson.put("USE_YN", cont.get("USE_YN")); 
            contJson.put("RENT_START_DT", AddUtil.ChangeDate3(String.valueOf(cont.get("RENT_START_DT"))) );   
            contJson.put("RENT_END_DT", AddUtil.ChangeDate3(String.valueOf(cont.get("RENT_END_DT"))) );   
		  	contJson.put("ST_NM", cont.get("ST_NM"));
		  	contJson.put("HOT_TEL",  cont.get("HOT_TEL"));
            contJson.put("LOAN_ST",  cont.get("LOAN_ST"));
            result.put(contJson);
        }

        out.print(result);
        out.flush();
    }

    // 사용자 검색
    else if (cmd.equals("search_user")) {
        String data = request.getParameter("data");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject)parser.parse(data);
        String s_kd = (String) json.get("s_kd");

  //      AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
        Vector users = at_db.getUserList("", "", s_kd, "Y");

        JSONArray result = new JSONArray();
        for (int i = 0; i < users.size(); i++) {
            Hashtable cont = (Hashtable)users.elementAt(i);

            JSONObject userJson = new JSONObject();
            userJson.put("ID", cont.get("ID"));
            userJson.put("POS", cont.get("POS"));
            userJson.put("DEPT_ID", cont.get("DEPT_ID"));
            userJson.put("USER_ID", cont.get("USER_ID"));
            userJson.put("USER_NM", cont.get("USER_NM"));
            userJson.put("USER_POS", cont.get("USER_POS"));
            userJson.put("USER_M_TEL", cont.get("USER_M_TEL"));
            userJson.put("BR_NM", cont.get("BR_NM"));
            userJson.put("BR_TEL", cont.get("BR_TEL"));
            userJson.put("BR_ADDR", cont.get("BR_ADDR"));
            result.put(userJson);
        }

        out.print(result);
        out.flush();
    }



   // 영업사원 리스트 가져오기 -20170927 추가   
      
    else if (cmd.equals("search_commi")) {
        String data = request.getParameter("data");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject) parser.parse(data);

        String gubun = (String) json.get("gubun");
        String gubun1 = URLDecoder.decode((String)json.get("gubun1"), ENC_STR);
        String gubun2 = URLDecoder.decode((String) json.get("gubun2"), ENC_STR);
        String gubun3 = (String) json.get("gubun3");
        
        String gu_nm = URLDecoder.decode((String)json.get("gu_nm"), ENC_STR);
        
        String cng_rsn = (String) json.get("cng_rsn");
                   
        String st_dt = AddUtil.replace((String) json.get("st_dt"), "-", "");
        String end_dt = AddUtil.replace((String) json.get("end_dt"), "-", "");

 //       AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();		  //알림톡으로 변경 - 쿼리단순화 -2017-09-26

	    Vector vt = new Vector();
		 vt = at_db.getCarOffEmpAllList2(gubun1,gubun2,gubun3, gubun, gu_nm, "", "", cng_rsn, st_dt, end_dt);
 		
        JSONArray result = new JSONArray();
        for (int i = 0; i < vt.size(); i++) {
            Hashtable cont = (Hashtable) vt.elementAt(i);

            JSONObject contJson = new JSONObject();

            contJson.put("EMP_NM", cont.get("EMP_NM"));
            contJson.put("EMP_M_TEL", cont.get("EMP_M_TEL"));
            contJson.put("CAR_COMP_NM", cont.get("CAR_COMP_NM")); //추후 추가 ...           

            result.put(contJson);
        }

        out.print(result);
        out.flush();
    }
     
    // 영업사원 리스트 가져오기 끝  -20170927 추가   
     
    // 계약 정보 가져오기
    else if (cmd.equals("cont_info")) {
        String data = request.getParameter("data");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject) parser.parse(data);

        String m_id = (String)json.get("m_id");
        String l_cd = (String)json.get("l_cd");
        Boolean moreInfo = (Boolean)json.get("more_info");       // jjlim@20171116 추가 정보 플레그


        JSONObject result = new JSONObject();

        // 로그인 정보
        LoginBean login = LoginBean.getInstance();
        String reg_id = login.getCookieValue(request, "acar_id");

        // 계약기본정보
        AddContDatabase c_db = AddContDatabase.getInstance();
        ContBaseBean base = c_db.getCont(m_id, l_cd);

        // 담당자
        UserMngDatabase um_db = UserMngDatabase.getInstance();
        UsersBean user = um_db.getUsersBean(base.getBus_id2());
        UsersBean user2 = um_db.getUsersBean(base.getBus_id());
        //System.out.println(user2.getUser_nm());
        //System.out.println(user2.getUser_m_tel());
        //System.out.println(user2.getBus_nm());
        
        result.put("BUS_NM", user2.getUser_nm());
        result.put("BUS_M_TEL", user2.getUser_m_tel());
        result.put("HOT_TEL", user2.getHot_tel());
        result.put("LOAN_ST", user2.getLoan_st());

        JSONArray usersJson = new JSONArray();

        // 외근직이면 로그인 한 사람도 발신자에 포함
        if (user.getLoan_st().equals("") == false) {
            UsersBean loginUser = um_db.getUsersBean(reg_id);
            JSONObject userJson = new JSONObject();
            userJson.put("USER_ID", loginUser.getUser_id());
            userJson.put("USER_NM", loginUser.getUser_nm());
            userJson.put("USER_M_TEL", loginUser.getUser_m_tel());
            userJson.put("HOT_TEL", loginUser.getHot_tel());
            userJson.put("LOAN_ST", loginUser.getLoan_st());
            usersJson.put(userJson);
        }
        JSONObject userJson = new JSONObject();
        userJson.put("USER_ID", user.getUser_id());
        userJson.put("USER_NM", user.getUser_nm());
        userJson.put("USER_M_TEL", user.getUser_m_tel());
        userJson.put("HOT_TEL", user.getHot_tel());
        userJson.put("LOAN_ST", user.getLoan_st());
        usersJson.put(userJson);

        result.put("users", usersJson);

        // 고객
        AddClientDatabase cl_db = AddClientDatabase.getInstance();
        ClientBean client = cl_db.getNewClient(base.getClient_id());

        // 고객관련자
        Vector car_mgrs = c_db.getCarMgrListNew(m_id, l_cd, "Y");
        if (base.getUse_yn().equals("Y")) {
            car_mgrs = c_db.getCarMgrClientList(base.getClient_id(), "Y");
        }

        // 지점
        ClientSiteBean site = cl_db.getClientSite(base.getClient_id(), base.getR_site());


        JSONArray clntsJson = new JSONArray();

        if (client.getM_tel().equals("") == false) {
            JSONObject clntJson = new JSONObject();
            clntJson.put("USER_DESC", "[대표자]");
            //clntJson.put("USER_NM", client.getClient_nm());
            clntJson.put("USER_NM", client.getFirm_nm());
            clntJson.put("USER_M_TEL", client.getM_tel());
            clntsJson.put(clntJson);
        }
        if (client.getCon_agnt_m_tel().equals("") == false) {
            JSONObject clntJson = new JSONObject();
            clntJson.put("USER_DESC", "[세금계산서]");
            //clntJson.put("USER_NM", client.getCon_agnt_nm());
            clntJson.put("USER_NM", client.getFirm_nm());
            clntJson.put("USER_M_TEL", client.getCon_agnt_m_tel());
            clntsJson.put(clntJson);
        }
        if (site.getAgnt_m_tel().equals("") == false) {
            JSONObject clntJson = new JSONObject();
            clntJson.put("USER_DESC", "[지점세금계산서]");
            //clntJson.put("USER_NM", site.getAgnt_nm());
            clntJson.put("USER_NM", client.getFirm_nm());
            clntJson.put("USER_M_TEL", site.getAgnt_m_tel());
            clntsJson.put(clntJson);
        }

        for (int i = 0; i < car_mgrs.size(); i++) {
            CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
            if (mgr.getMgr_m_tel().equals("") == false) {
                JSONObject clntJson = new JSONObject();
                clntJson.put("USER_DESC", "[" + mgr.getMgr_st() + "]");
                //clntJson.put("USER_NM", mgr.getMgr_nm());
                clntJson.put("USER_NM", client.getFirm_nm());
                clntJson.put("USER_M_TEL", mgr.getMgr_m_tel());
                clntsJson.put(clntJson);
            }
        }

        JSONObject clntJson = new JSONObject();
        clntJson.put("USER_DESC", "[영업담당자]");
        clntJson.put("USER_NM", user.getUser_nm());
        clntJson.put("USER_M_TEL", user.getUser_m_tel());
        clntsJson.put(clntJson);

        result.put("clnts", clntsJson);
        
        // 보험
        Hashtable insur = c_db.getInsurOfCont(l_cd, m_id);
        JSONObject insurJson = new JSONObject();
        insurJson.put("INS_NM", insur.get("INS_COM_NM"));
        insurJson.put("INS_TEL", insur.get("INS_TEL"));
        insurJson.put("INS_MNG_NM", insur.get("USER_NM"));
        insurJson.put("INS_MNG_TEL", insur.get("USER_M_TEL"));
        result.put("insur", insurJson);

        // jjlim@20171116 추가정보
        if (moreInfo != null && moreInfo == true) {
            Hashtable contractMoreInfo = at_db.getContractMoreInfo(m_id, l_cd);
            result.put("CAR_MNG_ID", contractMoreInfo.get("CAR_MNG_ID"));
            result.put("CAR_NM", contractMoreInfo.get("CAR_NM"));
            result.put("CAR_NO", contractMoreInfo.get("CAR_NO"));
            result.put("CAR_NUM", contractMoreInfo.get("CAR_NUM"));
            result.put("RENT_DT", contractMoreInfo.get("RENT_DT"));
            result.put("RENT_START_DT", AddUtil.ChangeDate3(String.valueOf(contractMoreInfo.get("RENT_START_DT"))));
            result.put("RENT_END_DT", AddUtil.ChangeDate3(String.valueOf(contractMoreInfo.get("RENT_END_DT"))));
	        
            ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, "1");
	        //System.out.println(fees.getCon_mon());
	        
	        result.put("MONTH", fees.getCon_mon());
        }

        out.print(result);
        out.flush();
    }

    // 알림톡 로그  -- cat:10 인경우 친구톡에서 찾기 ...
    else if (cmd.equals("alimtalk_log")) {
        String data = request.getParameter("data");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject) parser.parse(data);

        // 템플릿 코드
        String code = (String) json.get("cat");
        if (code.equals("0")) code = "";

        // 기간 (1: 당일, 2: 전일, 3: 2일, 4: 당월, 5: 전월, 6: 월별, 7:6개월 log -> 계약을 선택한 경우 )
        String dateType = (String)json.get("s_dt");
        String startDate = "";
        String endDate = "";
        if (dateType.equals("6")) {
            //startDate = AddUtil.replace((String) json.get("t_st_dt"), "-", "");
            //endDate = AddUtil.replace((String) json.get("t_ed_dt"), "-", "");
            startDate = (String) json.get("t_st_dt");
            endDate = (String) json.get("t_ed_dt");
        }

        // 검색 (1: 계약번호, 2: 발신자, 3: 발신번호, 4: 수신번호, 5:내용, 6:상호)
        String searchType = (String)json.get("s_kd");
        String searchKeyword = URLDecoder.decode((String)json.get("t_wd"), ENC_STR);

        List<AlimTalkLogBean> logs = atl_db.selectByFilter(code, dateType, startDate, endDate, searchType, searchKeyword);

        JSONArray result = new JSONArray();
  
        
        for (int i = 0; i < logs.size(); i++) {
            AlimTalkLogBean log = logs.get(i);

            JSONObject logJson = new JSONObject();
            logJson.put("TEMPLATE_CODE", log.getTemplate_code());
            logJson.put("DATE_CLIENT_REQ", log.getDate_client_req_str2());
            logJson.put("CONTENT", log.getContent());
            logJson.put("CALLBACK", log.getCallback());
            logJson.put("RECIPIENT_NUM", log.getRecipient_num());
            logJson.put("REPORT_CODE", log.getReport_code());
            logJson.put("USER_NM", log.getUserNm());
            logJson.put("FIRM_NM", log.getFirmNm());
            result.put(logJson);
        }

        out.print(result);
        out.flush();
    }

    // 비즈톡문자 로그
    else if (cmd.equals("emtalk_log")) {
        String data = request.getParameter("data");

        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject) parser.parse(data);

        // 기간 (1: 당일, 2: 전일, 3: 2일, 4: 당월, 5: 전월, 6: 월별)
        String dateType = (String)json.get("s_dt");
        String startDate = "";
        String endDate = "";
        if (dateType.equals("6")) {
            //startDate = AddUtil.replace((String) json.get("t_st_dt"), "-", "");
            //endDate = AddUtil.replace((String) json.get("t_ed_dt"), "-", "");
            startDate = (String) json.get("t_st_dt");
            endDate = (String) json.get("t_ed_dt");
        }

        // 검색 (1: 계약번호, 2: 발신자, 3: 발신번호, 4: 수신번호, 5:내용)
        String searchType = (String)json.get("s_kd");
        String searchKeyword = URLDecoder.decode((String)json.get("t_wd"), ENC_STR);

        List<AlimTalkLogBean> logs = atl_db.selectByFilterEm("", dateType, startDate, endDate, searchType, searchKeyword);

        JSONArray result = new JSONArray();

        for (int i = 0; i < logs.size(); i++) {
            AlimTalkLogBean log = logs.get(i);

            JSONObject logJson = new JSONObject();
            //logJson.put("TEMPLATE_CODE", log.getTemplate_code());
            logJson.put("DATE_CLIENT_REQ", log.getDate_client_req_str2());
            logJson.put("CONTENT", log.getContent());
            logJson.put("CALLBACK", log.getCallback());
            logJson.put("RECIPIENT_NUM", log.getRecipient_num());
            logJson.put("REPORT_CODE", log.getReport_code());
            logJson.put("USER_NM", log.getUserNm());
            logJson.put("FIRM_NM", log.getFirmNm());
            result.put(logJson);
        }

        out.print(result);
        out.flush();
    }
%>




<%--String s_kd 	= request.getParameter("s_kd")==null?	"":request.getParameter("s_kd");--%>
<%--String t_wd 	= request.getParameter("t_wd")==null?	"":request.getParameter("t_wd");--%>
<%--String andor 	= request.getParameter("andor")==null?	"":request.getParameter("andor");--%>
<%--String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");--%>
<%--String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");--%>
<%--String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");--%>
<%--String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");--%>
<%--String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");--%>
<%--String st_dt 	= request.getParameter("st_dt")==null?	"":AddUtil.replace(request.getParameter("st_dt"),"-","");--%>
<%--String end_dt 	= request.getParameter("end_dt")==null?	"":AddUtil.replace(request.getParameter("end_dt"),"-","");--%>
