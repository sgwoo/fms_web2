<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.alink.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<% 
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	String link_table 	= request.getParameter("link_table")==null?"":request.getParameter("link_table");
	String link_type 	= request.getParameter("link_type")==null?"":request.getParameter("link_type");
	String link_rent_st 	= request.getParameter("link_rent_st")==null?"":request.getParameter("link_rent_st");
	String link_im_seq 	= request.getParameter("link_im_seq")==null?"":request.getParameter("link_im_seq");

	String link_com 	= request.getParameter("link_com")==null?"":request.getParameter("link_com");
	
	String mgr_nm 		= request.getParameter("mgr_nm")==null?"":request.getParameter("mgr_nm");
	String mgr_email 	= request.getParameter("mgr_email")==null?"":request.getParameter("mgr_email");
	String mgr_m_tel 	= request.getParameter("mgr_m_tel")==null?"":request.getParameter("mgr_m_tel");
	String mgr_cng 		= request.getParameter("mgr_cng")==null?"":request.getParameter("mgr_cng");
	
	String suc_mgr_nm 	= request.getParameter("suc_mgr_nm")==null?"":request.getParameter("suc_mgr_nm");
	String suc_mgr_email 	= request.getParameter("suc_mgr_email")==null?"":request.getParameter("suc_mgr_email");
	String suc_mgr_m_tel 	= request.getParameter("suc_mgr_m_tel")==null?"":request.getParameter("suc_mgr_m_tel");
	
	String send_alert 	= request.getParameter("send_alert")==null?"":request.getParameter("send_alert");
	String cms_type 	= request.getParameter("cms_type")==null?"":request.getParameter("cms_type");

	if(link_table.equals("rm_rent_link") && link_com.equals("2")){
		link_table = "rm_rent_link_m";
	}
	
	boolean flag1 = true;
	boolean flag2 = true;	
	
	Hashtable ht = new Hashtable();
	
	
	String doc_code  = Long.toString(System.currentTimeMillis());
	String doc_code2  = "";
	
	int alink_y_count = ln_db.getALinkCntY(link_table, rent_l_cd, link_rent_st);
	
	if(alink_y_count == 0){
	
		//전자문서 전송데이터 처리		
		flag1 = ln_db.insertALink(doc_code, link_table, link_type, rent_l_cd, link_rent_st, link_im_seq, mgr_nm, mgr_email, mgr_m_tel, user_id, suc_mgr_nm, suc_mgr_email, suc_mgr_m_tel, link_com, cms_type);
	
		//계약담당자 업데이트
		if(flag1 && mgr_cng.equals("Y") && link_table.equals("lc_rent_link")){
			//계약담당자
			CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "계약담당자");
			mgr.setMgr_nm			(mgr_nm);
			mgr.setMgr_email	(mgr_email.trim());
			mgr.setMgr_m_tel	(mgr_m_tel);
			//=====[CAR_MGR] update=====
			flag2 = a_db.updateCarMgrNew(mgr);
		}
	
		//전자문서 전송 함수 타기 : 데이터코리아
		if(flag1){
			ht = ln_db.getALink(link_table, doc_code);
			
			if((link_type.equals("1") || link_type.equals("3")) && (String.valueOf(ht.get("CAR_ST")).equals("리스plus 기본식") || String.valueOf(ht.get("CAR_ST")).equals("리스plus 일반식"))){
				ht.put("DOC_TYPE","7");
			}
			if(link_type.equals("2") && (String.valueOf(ht.get("CAR_ST")).equals("리스plus 기본식") || String.valueOf(ht.get("CAR_ST")).equals("리스plus 일반식"))){
				ht.put("DOC_TYPE","8");
			}	
			
			if(String.valueOf(ht.get("COMPANY_NAME")).equals("")){
				flag1 = false;
			}
		}
		
		
	}else{
		flag1 = false;
	}
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%-- jjlim add papyless --%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>

<Script language="JavaScript">

	function webMethodCall(webServiceUrl,methodName,arg,returnFunction) {
	
		
		<%if(send_alert.equals("Y")){%>
		alert(arg);
		<%}%>
	
		var request = createRequestObject();

		var args = arg.split("&");
		var sendXML = "";
		
		
		sendXML += "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
		sendXML += "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">";
		sendXML += "<soap:Body>";
		sendXML += "<"+methodName+" xmlns=\"http://tempuri.org/\">";

		for (var i = 0; i < args.length; i++) {
			var keyAndValue = args[i].split("=");

			if (keyAndValue.length == 2) {
				var key = keyAndValue[0];
				var value = keyAndValue[1];

				value= value.replace(/>/g,"==");
				value= value.replace(/</g,"||");

				sendXML += "<" + key + ">" + value + "</" + key + ">";
			}
		}

		sendXML += "</"+methodName+">";
		sendXML += "</soap:Body>";
		sendXML += "</soap:Envelope>";




        // jjlim add papyless
        var param = {
            url: "/AmazonCar.asmx",
            method: methodName,
            body: sendXML
        };
        $.ajax({
            contentType: 'application/json',
            dataType: 'json',
            data: JSON.stringify(param),
            url: 'reg_edoc_link_proxy.jsp',
            type: 'POST',
            success: function(data) {
                returnFunction(data['result']);
            },
            error: function(xhr, status, error) {
                alert(error);
            }
        });


        
//		request.open("POST", webServiceUrl, false);
//		request.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
//		request.setRequestHeader("SOAPAction", "http://tempuri.org/" + methodName);
//		request.setRequestHeader("Content-Length", sendXML.length);
//
//		request.onreadystatechange = function RequestCallBack() {
//			var state = { "UNINITIALIZED": 0, "LOADING": 1, "LOADED": 2, "INTERAVTIVE": 3, "COMPLETED": 4 };
//			switch (request.readyState) {
//				case state.UNINITIALIZED:
//				break;
//			case state.LOADING:
//				break;
//			case state.LOADED:
//				break;
//			case state.INTERAVTIVE:
//				break;
//			case state.COMPLETED:
//				returnFunction(request.responseText);
//				break;
//			}
//		};
//		request.send(sendXML);


    }

	function createRequestObject() {
		if (window.XMLHttpRequest) {
			return xmlhttprequest = new XMLHttpRequest();
		}
		else if (window.ActiveXObject) {
			return xmlhttprequest = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}

	//월렌트 계약서
	function CallInsertTypeA()
	{
		var sendXML ="";
		
//		sendXML += "<?xml version='1.0' encoding='utf-8'?>";
		sendXML += "<root> ";
		sendXML += "<COMPANY_NAME><%=ht.get("COMPANY_NAME")%></COMPANY_NAME> ";
		sendXML += "<OWNER_NAME><%=ht.get("OWNER_NAME")%></OWNER_NAME> ";
		sendXML += "<RESNO><%=ht.get("RESNO")%></RESNO> ";
		sendXML += "<REGNO><%=ht.get("REGNO")%></REGNO> ";
		sendXML += "<CORPNUM><%=ht.get("CORPNUM")%></CORPNUM> ";
		sendXML += "<ZIPCODE><%=ht.get("ZIPCODE")%></ZIPCODE> ";
		sendXML += "<ADDR1><%=ht.get("ADDR1")%></ADDR1> ";
		sendXML += "<ADDR2><%=ht.get("ADDR2")%></ADDR2> ";
		sendXML += "<TELNO><%=ht.get("TELNO")%></TELNO> ";
		sendXML += "<MOBILE><%=ht.get("MOBILE")%></MOBILE> ";
		sendXML += "<FAXNO><%=ht.get("FAXNO")%></FAXNO> ";
		sendXML += "<EMAIL><%=ht.get("EMAIL")%></EMAIL> ";
		sendXML += "<UPJONG><%=ht.get("UPJONG")%></UPJONG> ";
		sendXML += "<UPTAE><%=ht.get("UPTAE")%></UPTAE> ";
		sendXML += "<GENDER><%=ht.get("GENDER")%></GENDER> ";
		sendXML += "<USERID><%=ht.get("USERID")%></USERID> ";
		sendXML += "<PASSWORD><%=ht.get("PASSWORD")%></PASSWORD> ";
		sendXML += "<doc_type><%=ht.get("DOC_TYPE")%></doc_type> ";
		sendXML += "<reg_id><%=ht.get("ACAR_USER_ID")%></reg_id> ";
		sendXML += "<reg_dt><%=ht.get("REG_DT")%></reg_dt> ";
		sendXML += "<acar_user_nm><%=ht.get("ACAR_USER_NM")%></acar_user_nm> ";
		sendXML += "<acar_user_email><%=ht.get("ACAR_USER_EMAIL")%></acar_user_email> ";
		sendXML += "<acar_user_tel><%=ht.get("ACAR_USER_TEL")%></acar_user_tel> ";
		sendXML += "<client_user_nm><%=ht.get("CLIENT_USER_NM")%></client_user_nm> ";
		sendXML += "<client_user_email><%=ht.get("CLIENT_USER_EMAIL")%></client_user_email> ";
		sendXML += "<client_user_tel><%=ht.get("CLIENT_USER_TEL")%></client_user_tel> ";
		sendXML += "<rent_l_cd><%=ht.get("RENT_L_CD")%></rent_l_cd> ";
		sendXML += "<rent_st><%=ht.get("RENT_ST")%></rent_st> ";
		sendXML += "<im_seq><%=ht.get("IM_SEQ")%></im_seq> ";
		sendXML += "<car_no><%=ht.get("CAR_NO")%></car_no> ";
		sendXML += "<br_nm><%=ht.get("BR_NM")%></br_nm> ";
		sendXML += "<client_st><%=ht.get("CLIENT_ST")%></client_st> ";
		sendXML += "<car_st><%=ht.get("CAR_ST")%></car_st> ";
		sendXML += "<bus_user_nm><%=ht.get("BUS_USER_NM")%></bus_user_nm> ";
		sendXML += "<bus_user_pos><%=ht.get("BUS_USER_POS")%></bus_user_pos> ";
		sendXML += "<bus_user_m_tel><%=ht.get("BUS_USER_M_TEL")%></bus_user_m_tel> ";
		sendXML += "<bus2_user_nm><%=ht.get("BUS2_USER_NM")%></bus2_user_nm> ";
		sendXML += "<bus2_user_pos><%=ht.get("BUS2_USER_POS")%></bus2_user_pos> ";
		sendXML += "<bus2_user_m_tel><%=ht.get("BUS2_USER_M_TEL")%></bus2_user_m_tel> ";
		sendXML += "<mng_user_nm><%=ht.get("MNG_USER_NM")%></mng_user_nm> ";
		sendXML += "<mng_user_pos><%=ht.get("MNG_USER_POS")%></mng_user_pos> ";
		sendXML += "<mng_user_m_tel><%=ht.get("MNG_USER_M_TEL")%></mng_user_m_tel> ";
		sendXML += "<client_nm><%=ht.get("CLIENT_NM")%></client_nm> ";
		sendXML += "<ssn><%=ht.get("SSN")%></ssn> ";
		sendXML += "<firm_nm><%=ht.get("FIRM_NM")%></firm_nm> ";
		sendXML += "<enp_no><%=ht.get("ENP_NO")%></enp_no> ";
		sendXML += "<o_addr><%=ht.get("O_ADDR")%></o_addr> ";
		sendXML += "<mgr_lic_no1><%=ht.get("MGR_LIC_NO1")%></mgr_lic_no1> ";
		sendXML += "<mgr_lic_st1><%=ht.get("MGR_LIC_ST1")%></mgr_lic_st1> ";
		sendXML += "<o_tel><%=ht.get("O_TEL")%></o_tel> ";
		sendXML += "<m_tel><%=ht.get("M_TEL")%></m_tel> ";
		sendXML += "<mgr_nm2><%=ht.get("MGR_NM2")%></mgr_nm2> ";
		sendXML += "<mgr_ssn2><%=ht.get("MGR_SSN2")%></mgr_ssn2> ";
		sendXML += "<mgr_addr2><%=ht.get("MGR_ADDR2")%></mgr_addr2> ";
		sendXML += "<mgr_m_tel2><%=ht.get("MGR_M_TEL2")%></mgr_m_tel2> ";
		sendXML += "<mgr_lic_no2><%=ht.get("MGR_LIC_NO2")%></mgr_lic_no2> ";
		sendXML += "<mgr_etc2><%=ht.get("MGR_ETC2")%></mgr_etc2> ";
		sendXML += "<car_nm><%=ht.get("CAR_NM")%></car_nm> ";
		sendXML += "<fuel_kd><%=ht.get("FUEL_KD")%></fuel_kd> ";
		sendXML += "<sh_km><%=ht.get("SH_KM")%></sh_km> ";
		sendXML += "<navi_yn><%=ht.get("NAVI_YN")%></navi_yn> ";
		sendXML += "<con_mon><%=ht.get("CON_MON")%></con_mon> ";
		sendXML += "<con_day><%=ht.get("CON_DAY")%></con_day> ";
		sendXML += "<rent_start_dt><%=ht.get("RENT_START_DT")%></rent_start_dt> ";
		sendXML += "<rent_end_dt><%=ht.get("RENT_END_DT")%></rent_end_dt> ";
		sendXML += "<car_use><%=ht.get("CAR_USE")%></car_use> ";
		sendXML += "<deli_plan_dt><%=ht.get("DELI_PLAN_DT")%></deli_plan_dt> ";
		sendXML += "<ret_plan_dt><%=ht.get("RET_PLAN_DT")%></ret_plan_dt> ";
		sendXML += "<deli_loc><%=ht.get("DELI_LOC")%></deli_loc> ";
		sendXML += "<ret_loc><%=ht.get("RET_LOC")%></ret_loc> ";
		sendXML += "<ret_loc_tel><%=ht.get("RET_LOC_TEL")%></ret_loc_tel> ";
		sendXML += "<ret_loc_addr><%=ht.get("RET_LOC_ADDR")%></ret_loc_addr> ";
		sendXML += "<inv_s_amt><%=ht.get("INV_S_AMT")%></inv_s_amt> ";
		sendXML += "<inv_v_amt><%=ht.get("INV_V_AMT")%></inv_v_amt> ";
		sendXML += "<inv_amt><%=ht.get("INV_AMT")%></inv_amt> ";
		sendXML += "<navi_s_amt><%=ht.get("NAVI_S_AMT")%></navi_s_amt> ";
		sendXML += "<navi_v_amt><%=ht.get("NAVI_V_AMT")%></navi_v_amt> ";
		sendXML += "<navi_amt><%=ht.get("NAVI_AMT")%></navi_amt> ";
		sendXML += "<etc_s_amt><%=ht.get("ETC_S_AMT")%></etc_s_amt> ";
		sendXML += "<etc_v_amt><%=ht.get("ETC_V_AMT")%></etc_v_amt> ";
		sendXML += "<etc_amt><%=ht.get("ETC_AMT")%></etc_amt> ";
		sendXML += "<fee_s_amt><%=ht.get("FEE_S_AMT")%></fee_s_amt> ";
		sendXML += "<fee_v_amt><%=ht.get("FEE_V_AMT")%></fee_v_amt> ";
		sendXML += "<fee_amt><%=ht.get("FEE_AMT")%></fee_amt> ";
		sendXML += "<cons_s_amt><%=ht.get("CONS_S_AMT")%></cons_s_amt> ";
		sendXML += "<cons_v_amt><%=ht.get("CONS_V_AMT")%></cons_v_amt> ";
		sendXML += "<cons_amt><%=ht.get("CONS_AMT")%></cons_amt> ";
		sendXML += "<t_fee_s_amt><%=ht.get("T_FEE_S_AMT")%></t_fee_s_amt> ";
		sendXML += "<t_fee_v_amt><%=ht.get("T_FEE_V_AMT")%></t_fee_v_amt> ";
		sendXML += "<t_fee_amt><%=ht.get("T_FEE_AMT")%></t_fee_amt> ";
		sendXML += "<f_paid_way><%=ht.get("F_PAID_WAY")%></f_paid_way> ";
		sendXML += "<f_rent_tot_amt><%=ht.get("F_RENT_TOT_AMT")%></f_rent_tot_amt> ";
		sendXML += "<f_paid_way2><%=ht.get("F_PAID_WAY2")%></f_paid_way2> ";
		sendXML += "<fee_cdt><%=ht.get("FEE_CDT")%></fee_cdt> ";
		sendXML += "<ins_com_nm><%=ht.get("INS_COM_NM")%></ins_com_nm> ";
		sendXML += "<ins_com_tel><%=ht.get("INS_COM_TEL")%></ins_com_tel> ";
		sendXML += "<car_ja><%=ht.get("CAR_JA")%></car_ja> ";
		sendXML += "<my_accid_yn><%=ht.get("MY_ACCID_YN")%></my_accid_yn> ";
		sendXML += "<cars><%=ht.get("CARS")%></cars> ";
		sendXML += "<amt_01d><%=ht.get("AMT_01D")%></amt_01d> ";
		sendXML += "<amt_03d><%=ht.get("AMT_03D")%></amt_03d> ";
		sendXML += "<amt_05d><%=ht.get("AMT_05D")%></amt_05d> ";
		sendXML += "<amt_07d><%=ht.get("AMT_07D")%></amt_07d> ";
		sendXML += "<agree_dist><%=ht.get("AGREE_DIST")%></agree_dist> ";
		sendXML += "<over_run_amt><%=ht.get("OVER_RUN_AMT")%></over_run_amt> ";
		sendXML += "<end_dt7><%=ht.get("END_DT7")%></end_dt7> ";
		sendXML += "<bus3_user_nm><%=ht.get("BUS3_USER_NM")%></bus3_user_nm> ";
		sendXML += "<bus3_user_pos><%=ht.get("BUS3_USER_POS")%></bus3_user_pos> ";
		sendXML += "<bus3_user_m_tel><%=ht.get("BUS3_USER_M_TEL")%></bus3_user_m_tel> ";
		sendXML += "<con_etc><%=ht.get("CON_ETC")%></con_etc> ";
		sendXML += "<day_cnt><%=ht.get("DAY_CNT")%></day_cnt> ";
		sendXML += "<day_per1><%=ht.get("DAY_PER1")%></day_per1> ";
		sendXML += "<day_per2><%=ht.get("DAY_PER2")%></day_per2> ";
		sendXML += "<day_per3><%=ht.get("DAY_PER3")%></day_per3> ";
		sendXML += "<day_per4><%=ht.get("DAY_PER4")%></day_per4> ";
		sendXML += "<day_per5><%=ht.get("DAY_PER5")%></day_per5> ";
		sendXML += "<day_per6><%=ht.get("DAY_PER6")%></day_per6> ";
		sendXML += "<day_per7><%=ht.get("DAY_PER7")%></day_per7> ";
		sendXML += "<day_per8><%=ht.get("DAY_PER8")%></day_per8> ";
		sendXML += "<day_per9><%=ht.get("DAY_PER9")%></day_per9> ";
		sendXML += "<day_per10><%=ht.get("DAY_PER10")%></day_per10> ";
		sendXML += "<day_per11><%=ht.get("DAY_PER11")%></day_per11> ";
		sendXML += "<day_per12><%=ht.get("DAY_PER12")%></day_per12> ";
		sendXML += "<day_per13><%=ht.get("DAY_PER13")%></day_per13> ";
		sendXML += "<day_per14><%=ht.get("DAY_PER14")%></day_per14> ";
		sendXML += "<day_per15><%=ht.get("DAY_PER15")%></day_per15> ";
		sendXML += "<day_per16><%=ht.get("DAY_PER16")%></day_per16> ";
		sendXML += "<day_per17><%=ht.get("DAY_PER17")%></day_per17> ";
		sendXML += "<day_per18><%=ht.get("DAY_PER18")%></day_per18> ";
		sendXML += "<day_per19><%=ht.get("DAY_PER19")%></day_per19> ";
		sendXML += "<day_per20><%=ht.get("DAY_PER20")%></day_per20> ";
		sendXML += "<day_per21><%=ht.get("DAY_PER21")%></day_per21> ";
		sendXML += "<day_per22><%=ht.get("DAY_PER22")%></day_per22> ";
		sendXML += "<day_per23><%=ht.get("DAY_PER23")%></day_per23> ";
		sendXML += "<day_per24><%=ht.get("DAY_PER24")%></day_per24> ";
		sendXML += "<day_per25><%=ht.get("DAY_PER25")%></day_per25> ";
		sendXML += "<day_per26><%=ht.get("DAY_PER26")%></day_per26> ";
		sendXML += "<day_per27><%=ht.get("DAY_PER27")%></day_per27> ";
		sendXML += "<day_per28><%=ht.get("DAY_PER28")%></day_per28> ";
		sendXML += "<day_per29><%=ht.get("DAY_PER29")%></day_per29> ";
		sendXML += "<day_per30><%=ht.get("DAY_PER30")%></day_per30> ";
		sendXML += "<rent_dt><%=ht.get("RENT_DT")%></rent_dt> ";
		sendXML += "<mgr_title3><%=ht.get("MGR_TITLE3")%></mgr_title3> ";
		sendXML += "<mgr_ssn3><%=ht.get("MGR_SSN3")%></mgr_ssn3> ";
		sendXML += "<mgr_nm3><%=ht.get("MGR_NM3")%></mgr_nm3> ";
		sendXML += "<repre_nm><%=ht.get("REPRE_NM")%></repre_nm> ";
		sendXML += "<cms_dep_nm><%=ht.get("CMS_DEP_NM")%></cms_dep_nm> ";
		sendXML += "<cms_dep_ssn><%=ht.get("CMS_DEP_SSN")%></cms_dep_ssn> ";
		sendXML += "<cms_bank><%=ht.get("CMS_BANK")%></cms_bank> ";
		sendXML += "<cms_acc_no><%=ht.get("CMS_ACC_NO")%></cms_acc_no> ";
		sendXML += "<cms_tel><%=ht.get("CMS_TEL")%></cms_tel> ";
		sendXML += "<cms_m_tel><%=ht.get("CMS_M_TEL")%></cms_m_tel> ";
		sendXML += "<cms_etc><%=ht.get("ETC")%></cms_etc> ";
		sendXML += "</root>";

		webMethodCall("http://www.papyless.co.kr/AmazonCar.asmx", "InsertTypeA", "XmlString=" + sendXML , RtnService);
	}
	
	//장기계약서
	function CallInsertTypeB()
	{
		var sendXML ="";
		
//		sendXML += "<?xml version='1.0' encoding='utf-8'?>";
		sendXML += "<root>";
		sendXML += "<COMPANY_NAME><%=ht.get("COMPANY_NAME")%></COMPANY_NAME> ";
		sendXML += "<OWNER_NAME><%=ht.get("OWNER_NAME")%></OWNER_NAME> ";
		sendXML += "<RESNO><%=ht.get("RESNO")%></RESNO> ";
		sendXML += "<REGNO><%=ht.get("REGNO")%></REGNO> ";
		sendXML += "<CORPNUM><%=ht.get("CORPNUM")%></CORPNUM> ";
		sendXML += "<ZIPCODE><%=ht.get("ZIPCODE")%></ZIPCODE> ";
		sendXML += "<ADDR1><%=ht.get("ADDR1")%></ADDR1> ";
		sendXML += "<ADDR2><%=ht.get("ADDR2")%></ADDR2> ";
		sendXML += "<TELNO><%=ht.get("TELNO")%></TELNO> ";
		sendXML += "<MOBILE><%=ht.get("MOBILE")%></MOBILE> ";
		sendXML += "<FAXNO><%=ht.get("FAXNO")%></FAXNO> ";
		sendXML += "<EMAIL><%=ht.get("EMAIL")%></EMAIL> ";
		sendXML += "<UPJONG><%=ht.get("UPJONG")%></UPJONG> ";
		sendXML += "<UPTAE><%=ht.get("UPTAE")%></UPTAE> ";
		sendXML += "<GENDER><%=ht.get("GENDER")%></GENDER> ";
		sendXML += "<USERID><%=ht.get("USERID")%></USERID> ";
		sendXML += "<PASSWORD><%=ht.get("PASSWORD")%></PASSWORD> ";
		sendXML += "<doc_type><%=ht.get("DOC_TYPE")%></doc_type> ";
		sendXML += "<reg_id><%=ht.get("ACAR_USER_ID")%></reg_id> ";
		sendXML += "<reg_dt><%=ht.get("REG_DT")%></reg_dt> ";
		sendXML += "<acar_user_nm><%=ht.get("ACAR_USER_NM")%></acar_user_nm> ";
		sendXML += "<acar_user_email><%=ht.get("ACAR_USER_EMAIL")%></acar_user_email> ";
		sendXML += "<acar_user_tel><%=ht.get("ACAR_USER_TEL")%></acar_user_tel> ";
		sendXML += "<client_user_nm><%=ht.get("CLIENT_USER_NM")%></client_user_nm> ";
		sendXML += "<client_user_email><%=ht.get("CLIENT_USER_EMAIL")%></client_user_email> ";
		sendXML += "<client_user_tel><%=ht.get("CLIENT_USER_TEL")%></client_user_tel> ";
		sendXML += "<rent_l_cd><%=ht.get("RENT_L_CD")%></rent_l_cd> ";
		sendXML += "<rent_st><%=ht.get("RENT_ST")%></rent_st> ";
		sendXML += "<im_seq><%=ht.get("IM_SEQ")%></im_seq> ";
		sendXML += "<car_no><%=ht.get("CAR_NO")%></car_no> ";
		sendXML += "<br_nm><%=ht.get("BR_NM")%></br_nm> ";
		sendXML += "<bus_user_nm><%=ht.get("BUS_USER_NM")%></bus_user_nm> ";
		sendXML += "<bus_user_m_tel><%=ht.get("BUS_USER_M_TEL")%></bus_user_m_tel> ";
		sendXML += "<car_st><%=ht.get("CAR_ST")%></car_st> ";
		sendXML += "<car_gu><%=ht.get("CAR_GU")%></car_gu> ";
		sendXML += "<client_st><%=ht.get("CLIENT_ST")%></client_st> ";
		sendXML += "<firm_nm><%=ht.get("FIRM_NM")%></firm_nm> ";
		sendXML += "<client_nm><%=ht.get("CLIENT_NM")%></client_nm> ";
		sendXML += "<enp_no><%=ht.get("ENP_NO")%></enp_no> ";
		sendXML += "<ssn><%=ht.get("SSN")%></ssn> ";
		sendXML += "<o_addr><%=ht.get("O_ADDR")%></o_addr> ";
		sendXML += "<p_addr><%=ht.get("P_ADDR")%></p_addr> ";
		sendXML += "<r_site><%=ht.get("R_SITE")%></r_site> ";
		sendXML += "<lic_no><%=ht.get("LIC_NO")%></lic_no> ";
		sendXML += "<o_tel><%=ht.get("O_TEL")%></o_tel> ";
		sendXML += "<fax><%=ht.get("FAX")%></fax> ";
		sendXML += "<m_tel><%=ht.get("M_TEL")%></m_tel> ";
		sendXML += "<h_tel><%=ht.get("H_TEL")%></h_tel> ";
		sendXML += "<mgr_dept1><%=ht.get("MGR_DEPT1")%></mgr_dept1> ";
		sendXML += "<mgr_nm1><%=ht.get("MGR_NM1")%></mgr_nm1> ";
		sendXML += "<mgr_title1><%=ht.get("MGR_TITLE1")%></mgr_title1> ";
		sendXML += "<mgr_tel1><%=ht.get("MGR_TEL1")%></mgr_tel1> ";
		sendXML += "<mgr_m_tel1><%=ht.get("MGR_M_TEL1")%></mgr_m_tel1> ";
		sendXML += "<mgr_email1><%=ht.get("MGR_EMAIL1")%></mgr_email1> ";
		sendXML += "<mgr_dept2><%=ht.get("MGR_DEPT2")%></mgr_dept2> ";
		sendXML += "<mgr_nm2><%=ht.get("MGR_NM2")%></mgr_nm2> ";
		sendXML += "<mgr_title2><%=ht.get("MGR_TITLE2")%></mgr_title2> ";
		sendXML += "<mgr_tel2><%=ht.get("MGR_TEL2")%></mgr_tel2> ";
		sendXML += "<mgr_m_tel2><%=ht.get("MGR_M_TEL2")%></mgr_m_tel2> ";
		sendXML += "<mgr_email2><%=ht.get("MGR_EMAIL2")%></mgr_email2> ";
		sendXML += "<mgr_dept3><%=ht.get("MGR_DEPT3")%></mgr_dept3> ";
		sendXML += "<mgr_nm3><%=ht.get("MGR_NM3")%></mgr_nm3> ";
		sendXML += "<mgr_title3><%=ht.get("MGR_TITLE3")%></mgr_title3> ";
		sendXML += "<mgr_tel3><%=ht.get("MGR_TEL3")%></mgr_tel3> ";
		sendXML += "<mgr_m_tel3><%=ht.get("MGR_M_TEL3")%></mgr_m_tel3> ";
		sendXML += "<mgr_email3><%=ht.get("MGR_EMAIL3")%></mgr_email3> ";
		sendXML += "<car_nm><%=ht.get("CAR_NM")%></car_nm> ";
		sendXML += "<opt><%=ht.get("OPT")%></opt> ";
		sendXML += "<colo><%=ht.get("COLO")%></colo> ";
		sendXML += "<in_col><%=ht.get("IN_COL")%></in_col> ";
		sendXML += "<car_amt><%=ht.get("CAR_AMT")%></car_amt> ";
		sendXML += "<sh_amt><%=ht.get("SH_AMT")%></sh_amt> ";
		sendXML += "<con_mon><%=ht.get("CON_MON")%></con_mon> ";
		sendXML += "<rent_start_dt><%=ht.get("RENT_START_DT")%></rent_start_dt> ";
		sendXML += "<rent_end_dt><%=ht.get("RENT_END_DT")%></rent_end_dt> ";
		sendXML += "<driving_age><%=ht.get("DRIVING_AGE")%></driving_age> ";
		sendXML += "<gcp_kd><%=ht.get("GCP_KD")%></gcp_kd> ";
		sendXML += "<bacdt_kd><%=ht.get("BACDT_KD")%></bacdt_kd> ";
		sendXML += "<canoisr_yn><%=ht.get("CANOISR_YN")%></canoisr_yn> ";
		sendXML += "<car_ja><%=ht.get("CAR_JA")%></car_ja> ";
		sendXML += "<pro_yn><%=ht.get("PRO_YN")%></pro_yn> ";
		sendXML += "<ac_dae_yn><%=ht.get("AC_DAE_YN")%></ac_dae_yn> ";
		sendXML += "<rent_way_1><%=ht.get("RENT_WAY_1")%></rent_way_1> ";
		sendXML += "<rent_way_2><%=ht.get("RENT_WAY_2")%></rent_way_2> ";
		sendXML += "<grt_amt_s><%=ht.get("GRT_AMT_S")%></grt_amt_s> ";
		sendXML += "<grt_amt><%=ht.get("GRT_AMT")%></grt_amt> ";
		sendXML += "<pp_s_amt><%=ht.get("PP_S_AMT")%></pp_s_amt> ";
		sendXML += "<pp_v_amt><%=ht.get("PP_V_AMT")%></pp_v_amt> ";
		sendXML += "<pp_amt><%=ht.get("PP_AMT")%></pp_amt> ";
		sendXML += "<ifee_s_amt><%=ht.get("IFEE_S_AMT")%></ifee_s_amt> ";
		sendXML += "<ifee_v_amt><%=ht.get("IFEE_V_AMT")%></ifee_v_amt> ";
		sendXML += "<ifee_amt><%=ht.get("IFEE_AMT")%></ifee_amt> ";
		sendXML += "<fee_s_amt><%=ht.get("FEE_S_AMT")%></fee_s_amt> ";
		sendXML += "<fee_v_amt><%=ht.get("FEE_V_AMT")%></fee_v_amt> ";
		sendXML += "<fee_amt><%=ht.get("FEE_AMT")%></fee_amt> ";
		sendXML += "<fee_pay_tm><%=ht.get("FEE_PAY_TM")%></fee_pay_tm> ";
		sendXML += "<fee_est_day><%=ht.get("FEE_EST_DAY")%></fee_est_day> ";
		sendXML += "<t_pp_amt><%=ht.get("T_PP_AMT")%></t_pp_amt> ";
		sendXML += "<fee_pay_start_dt><%=ht.get("FEE_PAY_START_DT")%></fee_pay_start_dt> ";
		sendXML += "<fee_pay_end_dt><%=ht.get("FEE_PAY_END_DT")%></fee_pay_end_dt> ";
		sendXML += "<pere_r_mth><%=ht.get("PERE_R_MTH")%></pere_r_mth> ";
		sendXML += "<gi_st><%=ht.get("GI_ST")	%></gi_st> ";
		sendXML += "<gi_fee><%=ht.get("GI_FEE")%></gi_fee> ";
		sendXML += "<agree_dist><%=ht.get("AGREE_DIST")%></agree_dist> ";
		sendXML += "<over_run_amt><%=ht.get("OVER_RUN_AMT")%></over_run_amt> ";
		sendXML += "<agree_dist_yn><%=ht.get("AGREE_DIST_YN")%></agree_dist_yn> ";
		sendXML += "<over_bas_km><%=ht.get("OVER_BAS_KM")%></over_bas_km> ";
		sendXML += "<cls_r_per><%=ht.get("CLS_R_PER")%></cls_r_per> ";
		sendXML += "<opt_amt><%=ht.get("OPT_AMT")%></opt_amt> ";
		sendXML += "<con_etc><%=ht.get("CON_ETC")%></con_etc> ";
		sendXML += "<rent_dt><%=ht.get("RENT_DT")%></rent_dt> ";
		sendXML += "<repre_addr><%=ht.get("REPRE_ADDR")%></repre_addr> ";
		sendXML += "<repre_ssn><%=ht.get("REPRE_SSN")%></repre_ssn> ";
		sendXML += "<repre_nm><%=ht.get("REPRE_NM")%></repre_nm> ";
		sendXML += "<cms_dep_nm><%=ht.get("CMS_DEP_NM")%></cms_dep_nm> ";
		sendXML += "<cms_dep_ssn><%=ht.get("CMS_DEP_SSN")%></cms_dep_ssn> ";
		sendXML += "<cms_bank><%=ht.get("CMS_BANK")%></cms_bank> ";
		sendXML += "<cms_acc_no><%=ht.get("CMS_ACC_NO")%></cms_acc_no> ";
		sendXML += "<cms_tel><%=ht.get("CMS_TEL")%></cms_tel> ";
		sendXML += "<cms_m_tel><%=ht.get("CMS_M_TEL")%></cms_m_tel> ";
		sendXML += "<cms_etc><%=ht.get("ETC")%></cms_etc> ";						
		sendXML += "<com_emp_yn><%=ht.get("COM_EMP_YN")%></com_emp_yn> ";				
		sendXML += "<gi_amt><%=ht.get("GI_AMT")%></gi_amt> ";
		sendXML += "<gi_con><%=ht.get("GI_MON")%></gi_con> ";
		sendXML += "<pp_chk><%=ht.get("PP_CHK")%></pp_chk> ";	//선납금계산서발행구분	
		sendXML += "</root>";


		<%if(String.valueOf(ht.get("CAR_ST")).equals("장기렌트 기본식") || String.valueOf(ht.get("CAR_ST")).equals("장기렌트 일반식")){%>
		webMethodCall("http://www.papyless.co.kr/AmazonCar.asmx", "InsertTypeB", "XmlString=" + sendXML , RtnService);
		<%}else{%>
		webMethodCall("http://www.papyless.co.kr/AmazonCar.asmx", "InsertTypeE", "XmlString=" + sendXML , RtnService);
		<%}%>
	}
	
	//승계계약서
	function CallInsertTypeC()
	{
		var sendXML ="";
		
//		sendXML += "<?xml version='1.0' encoding='utf-8'?>";
		sendXML += "<root>";
		sendXML += "<COMPANY_NAME><%=ht.get("COMPANY_NAME")%></COMPANY_NAME> ";
		sendXML += "<OWNER_NAME><%=ht.get("OWNER_NAME")%></OWNER_NAME> ";
		sendXML += "<RESNO><%=ht.get("RESNO")%></RESNO> ";
		sendXML += "<REGNO><%=ht.get("REGNO")%></REGNO> ";
		sendXML += "<CORPNUM><%=ht.get("CORPNUM")%></CORPNUM> ";
		sendXML += "<ZIPCODE><%=ht.get("ZIPCODE")%></ZIPCODE> ";
		sendXML += "<ADDR1><%=ht.get("ADDR1")%></ADDR1> ";
		sendXML += "<ADDR2><%=ht.get("ADDR2")%></ADDR2> ";
		sendXML += "<TELNO><%=ht.get("TELNO")%></TELNO> ";
		sendXML += "<MOBILE><%=ht.get("MOBILE")%></MOBILE> ";
		sendXML += "<FAXNO><%=ht.get("FAXNO")%></FAXNO> ";
		sendXML += "<EMAIL><%=ht.get("EMAIL")%></EMAIL> ";
		sendXML += "<UPJONG><%=ht.get("UPJONG")%></UPJONG> ";
		sendXML += "<UPTAE><%=ht.get("UPTAE")%></UPTAE> ";
		sendXML += "<GENDER><%=ht.get("GENDER")%></GENDER> ";
		sendXML += "<USERID><%=ht.get("USERID")%></USERID> ";
		sendXML += "<PASSWORD><%=ht.get("PASSWORD")%></PASSWORD> ";
		sendXML += "<doc_type><%=ht.get("DOC_TYPE")%></doc_type> ";
		sendXML += "<reg_id><%=ht.get("ACAR_USER_ID")%></reg_id> ";
		sendXML += "<reg_dt><%=ht.get("REG_DT")%></reg_dt> ";
		sendXML += "<acar_user_nm><%=ht.get("ACAR_USER_NM")%></acar_user_nm> ";
		sendXML += "<acar_user_email><%=ht.get("ACAR_USER_EMAIL")%></acar_user_email> ";
		sendXML += "<acar_user_tel><%=ht.get("ACAR_USER_TEL")%></acar_user_tel> ";
		sendXML += "<client_user_nm><%=ht.get("CLIENT_USER_NM")%></client_user_nm> ";
		sendXML += "<client_user_email><%=ht.get("CLIENT_USER_EMAIL")%></client_user_email> ";
		sendXML += "<client_user_tel><%=ht.get("CLIENT_USER_TEL")%></client_user_tel> ";
		sendXML += "<rent_l_cd><%=ht.get("RENT_L_CD")%></rent_l_cd> ";
		sendXML += "<rent_st><%=ht.get("RENT_ST")%></rent_st> ";
		sendXML += "<im_seq><%=ht.get("IM_SEQ")%></im_seq> ";
		sendXML += "<car_no><%=ht.get("CAR_NO")%></car_no> ";
		sendXML += "<br_nm><%=ht.get("BR_NM")%></br_nm> ";
		sendXML += "<bus_user_nm><%=ht.get("BUS_USER_NM")%></bus_user_nm> ";
		sendXML += "<bus_user_m_tel><%=ht.get("BUS_USER_M_TEL")%></bus_user_m_tel> ";
		sendXML += "<car_st><%=ht.get("CAR_ST")%></car_st> ";
		sendXML += "<car_gu><%=ht.get("CAR_GU")%></car_gu> ";
		sendXML += "<client_st><%=ht.get("CLIENT_ST")%></client_st> ";
		sendXML += "<firm_nm><%=ht.get("FIRM_NM")%></firm_nm> ";
		sendXML += "<client_nm><%=ht.get("CLIENT_NM")%></client_nm> ";
		sendXML += "<enp_no><%=ht.get("ENP_NO")%></enp_no> ";
		sendXML += "<ssn><%=ht.get("SSN")%></ssn> ";
		sendXML += "<o_addr><%=ht.get("O_ADDR")%></o_addr> ";
		sendXML += "<p_addr><%=ht.get("P_ADDR")%></p_addr> ";
		sendXML += "<r_site><%=ht.get("R_SITE")%></r_site> ";
		sendXML += "<lic_no><%=ht.get("LIC_NO")%></lic_no> ";
		sendXML += "<o_tel><%=ht.get("O_TEL")%></o_tel> ";
		sendXML += "<fax><%=ht.get("FAX")%></fax> ";
		sendXML += "<m_tel><%=ht.get("M_TEL")%></m_tel> ";
		sendXML += "<h_tel><%=ht.get("H_TEL")%></h_tel> ";
		sendXML += "<mgr_dept1><%=ht.get("MGR_DEPT1")%></mgr_dept1> ";
		sendXML += "<mgr_nm1><%=ht.get("MGR_NM1")%></mgr_nm1> ";
		sendXML += "<mgr_title1><%=ht.get("MGR_TITLE1")%></mgr_title1> ";
		sendXML += "<mgr_tel1><%=ht.get("MGR_TEL1")%></mgr_tel1> ";
		sendXML += "<mgr_m_tel1><%=ht.get("MGR_M_TEL1")%></mgr_m_tel1> ";
		sendXML += "<mgr_email1><%=ht.get("MGR_EMAIL1")%></mgr_email1> ";
		sendXML += "<mgr_dept2><%=ht.get("MGR_DEPT2")%></mgr_dept2> ";
		sendXML += "<mgr_nm2><%=ht.get("MGR_NM2")%></mgr_nm2> ";
		sendXML += "<mgr_title2><%=ht.get("MGR_TITLE2")%></mgr_title2> ";
		sendXML += "<mgr_tel2><%=ht.get("MGR_TEL2")%></mgr_tel2> ";
		sendXML += "<mgr_m_tel2><%=ht.get("MGR_M_TEL2")%></mgr_m_tel2> ";
		sendXML += "<mgr_email2><%=ht.get("MGR_EMAIL2")%></mgr_email2> ";
		sendXML += "<mgr_dept3><%=ht.get("MGR_DEPT3")%></mgr_dept3> ";
		sendXML += "<mgr_nm3><%=ht.get("MGR_NM3")%></mgr_nm3> ";
		sendXML += "<mgr_title3><%=ht.get("MGR_TITLE3")%></mgr_title3> ";
		sendXML += "<mgr_tel3><%=ht.get("MGR_TEL3")%></mgr_tel3> ";
		sendXML += "<mgr_m_tel3><%=ht.get("MGR_M_TEL3")%></mgr_m_tel3> ";
		sendXML += "<mgr_email3><%=ht.get("MGR_EMAIL3")%></mgr_email3> ";
		sendXML += "<car_nm><%=ht.get("CAR_NM")%></car_nm> ";
		sendXML += "<opt><%=ht.get("OPT")%></opt> ";
		sendXML += "<colo><%=ht.get("COLO")%></colo> ";
		sendXML += "<in_col><%=ht.get("IN_COL")%></in_col> ";
		sendXML += "<car_amt><%=ht.get("CAR_AMT")%></car_amt> ";
		sendXML += "<sh_amt><%=ht.get("SH_AMT")%></sh_amt> ";
		sendXML += "<con_mon><%=ht.get("CON_MON")%></con_mon> ";
		sendXML += "<rent_start_dt><%=ht.get("RENT_START_DT")%></rent_start_dt> ";
		sendXML += "<rent_end_dt><%=ht.get("RENT_END_DT")%></rent_end_dt> ";
		sendXML += "<driving_age><%=ht.get("DRIVING_AGE")%></driving_age> ";
		sendXML += "<gcp_kd><%=ht.get("GCP_KD")%></gcp_kd> ";
		sendXML += "<bacdt_kd><%=ht.get("BACDT_KD")%></bacdt_kd> ";
		sendXML += "<canoisr_yn><%=ht.get("CANOISR_YN")%></canoisr_yn> ";
		sendXML += "<car_ja><%=ht.get("CAR_JA")%></car_ja> ";
		sendXML += "<pro_yn><%=ht.get("PRO_YN")%></pro_yn> ";
		sendXML += "<ac_dae_yn><%=ht.get("AC_DAE_YN")%></ac_dae_yn> ";
		sendXML += "<rent_way_1><%=ht.get("RENT_WAY_1")%></rent_way_1> ";
		sendXML += "<rent_way_2><%=ht.get("RENT_WAY_2")%></rent_way_2> ";
		sendXML += "<grt_amt_s><%=ht.get("GRT_AMT_S")%></grt_amt_s> ";
		sendXML += "<grt_amt><%=ht.get("GRT_AMT")%></grt_amt> ";
		sendXML += "<pp_s_amt><%=ht.get("PP_S_AMT")%></pp_s_amt> ";
		sendXML += "<pp_v_amt><%=ht.get("PP_V_AMT")%></pp_v_amt> ";
		sendXML += "<pp_amt><%=ht.get("PP_AMT")%></pp_amt> ";
		sendXML += "<ifee_s_amt><%=ht.get("IFEE_S_AMT")%></ifee_s_amt> ";
		sendXML += "<ifee_v_amt><%=ht.get("IFEE_V_AMT")%></ifee_v_amt> ";
		sendXML += "<ifee_amt><%=ht.get("IFEE_AMT")%></ifee_amt> ";
		sendXML += "<fee_s_amt><%=ht.get("FEE_S_AMT")%></fee_s_amt> ";
		sendXML += "<fee_v_amt><%=ht.get("FEE_V_AMT")%></fee_v_amt> ";
		sendXML += "<fee_amt><%=ht.get("FEE_AMT")%></fee_amt> ";
		sendXML += "<fee_pay_tm><%=ht.get("FEE_PAY_TM")%></fee_pay_tm> ";
		sendXML += "<fee_est_day><%=ht.get("FEE_EST_DAY")%></fee_est_day> ";
		sendXML += "<t_pp_amt><%=ht.get("T_PP_AMT")%></t_pp_amt> ";
		sendXML += "<fee_pay_start_dt><%=ht.get("FEE_PAY_START_DT")%></fee_pay_start_dt> ";
		sendXML += "<fee_pay_end_dt><%=ht.get("FEE_PAY_END_DT")%></fee_pay_end_dt> ";
		sendXML += "<pere_r_mth><%=ht.get("PERE_R_MTH")%></pere_r_mth> ";
		sendXML += "<gi_st><%=ht.get("GI_ST")%></gi_st> ";
		sendXML += "<gi_fee><%=ht.get("GI_FEE")%></gi_fee> ";
		sendXML += "<agree_dist><%=ht.get("AGREE_DIST")%></agree_dist> ";
		sendXML += "<over_run_amt><%=ht.get("OVER_RUN_AMT")%></over_run_amt> ";
		sendXML += "<agree_dist_yn><%=ht.get("AGREE_DIST_YN")%></agree_dist_yn> ";
		sendXML += "<over_bas_km><%=ht.get("OVER_BAS_KM")%></over_bas_km> ";
		sendXML += "<cls_r_per><%=ht.get("CLS_R_PER")%></cls_r_per> ";
		sendXML += "<opt_amt><%=ht.get("OPT_AMT")%></opt_amt> ";
		sendXML += "<con_etc><%=ht.get("CON_ETC")%></con_etc> ";
		sendXML += "<rent_dt><%=ht.get("RENT_DT")%></rent_dt> ";
		sendXML += "<repre_addr><%=ht.get("REPRE_ADDR")%></repre_addr> ";
		sendXML += "<repre_ssn><%=ht.get("REPRE_SSN")%></repre_ssn> ";
		sendXML += "<repre_nm><%=ht.get("REPRE_NM")%></repre_nm> ";
		sendXML += "<cms_dep_nm><%=ht.get("CMS_DEP_NM")%></cms_dep_nm> ";
		sendXML += "<cms_dep_ssn><%=ht.get("CMS_DEP_SSN")%></cms_dep_ssn> ";
		sendXML += "<cms_bank><%=ht.get("CMS_BANK")%></cms_bank> ";
		sendXML += "<cms_acc_no><%=ht.get("CMS_ACC_NO")%></cms_acc_no> ";
		sendXML += "<cms_tel><%=ht.get("CMS_TEL")%></cms_tel> ";
		sendXML += "<cms_m_tel><%=ht.get("CMS_M_TEL")%></cms_m_tel> ";
		sendXML += "<cms_etc><%=ht.get("ETC")%></cms_etc> ";	

		sendXML += "<S_COMPANY_NAME><%=ht.get("S_COMPANY_NAME")%></S_COMPANY_NAME> ";
		sendXML += "<S_OWNER_NAME><%=ht.get("S_OWNER_NAME")%></S_OWNER_NAME> ";
		sendXML += "<S_RESNO><%=ht.get("S_RESNO")%></S_RESNO> ";
		sendXML += "<S_REGNO><%=ht.get("S_REGNO")%></S_REGNO> ";
		sendXML += "<S_CORPNUM><%=ht.get("S_CORPNUM")%></S_CORPNUM> ";
		sendXML += "<S_ZIPCODE><%=ht.get("S_ZIPCODE")%></S_ZIPCODE> ";
		sendXML += "<S_ADDR1><%=ht.get("S_ADDR1")%></S_ADDR1> ";
		sendXML += "<S_ADDR2><%=ht.get("S_ADDR2")%></S_ADDR2> ";
		sendXML += "<S_TELNO><%=ht.get("S_TELNO")%></S_TELNO> ";
		sendXML += "<S_MOBILE><%=ht.get("S_MOBILE")%></S_MOBILE> ";
		sendXML += "<S_FAXNO><%=ht.get("S_FAXNO")%></S_FAXNO> ";
		sendXML += "<S_EMAIL><%=ht.get("S_EMAIL")%></S_EMAIL> ";
		sendXML += "<S_UPJONG><%=ht.get("S_UPJONG")%></S_UPJONG> ";
		sendXML += "<S_UPTAE><%=ht.get("S_UPTAE")%></S_UPTAE> ";
		sendXML += "<S_GENDER><%=ht.get("S_GENDER")%></S_GENDER> ";
		sendXML += "<S_USERID><%=ht.get("S_USERID")%></S_USERID> ";
		sendXML += "<S_PASSWORD><%=ht.get("S_PASSWORD")%></S_PASSWORD> ";
		sendXML += "<rent_suc_firm_nm><%=ht.get("RENT_SUC_FIRM_NM")%></rent_suc_firm_nm> ";
		sendXML += "<rent_suc_rent_dt><%=ht.get("RENT_SUC_RENT_DT")%></rent_suc_rent_dt> ";
		sendXML += "<rent_suc_rent_l_cd><%=ht.get("RENT_SUC_RENT_L_CD")%></rent_suc_rent_l_cd> ";
		sendXML += "<rent_suc_commi><%=ht.get("RENT_SUC_COMMI")%></rent_suc_commi> ";
		sendXML += "<rent_suc_dt><%=ht.get("RENT_SUC_DT")%></rent_suc_dt> ";
		sendXML += "<rent_suc_client_st><%=ht.get("RENT_SUC_CLIENT_ST")%></rent_suc_client_st> ";
		sendXML += "<rent_suc_enp_no><%=ht.get("RENT_SUC_ENP_NO")%></rent_suc_enp_no> ";
		sendXML += "<rent_suc_client_user_nm><%=ht.get("RENT_SUC_CLIENT_USER_NM")%></rent_suc_client_user_nm> ";
		sendXML += "<rent_suc_client_user_email><%=ht.get("RENT_SUC_CLIENT_USER_EMAIL")%></rent_suc_client_user_email> ";
		sendXML += "<rent_suc_client_user_tel><%=ht.get("RENT_SUC_CLIENT_USER_TEL")%></rent_suc_client_user_tel> ";
		sendXML += "<rent_suc_dist><%=ht.get("RENT_SUC_DIST")%></rent_suc_dist> ";
		sendXML += "<com_emp_yn><%=ht.get("COM_EMP_YN")%></com_emp_yn> ";				
		sendXML += "<gi_amt><%=ht.get("GI_AMT")%></gi_amt> ";
		sendXML += "<gi_con><%=ht.get("GI_MON")%></gi_con> ";
		sendXML += "<pp_chk><%=ht.get("PP_CHK")%></pp_chk> ";	//선납금계산서발행구분	
		
		sendXML += "</root>";

		<%if(String.valueOf(ht.get("CAR_ST")).equals("장기렌트 기본식") || String.valueOf(ht.get("CAR_ST")).equals("장기렌트 일반식")){%>
		webMethodCall("http://www.papyless.co.kr/AmazonCar.asmx", "InsertTypeC", "XmlString=" + sendXML , RtnService);
		<%}else{%>
		webMethodCall("http://www.papyless.co.kr/AmazonCar.asmx", "InsertTypeF", "XmlString=" + sendXML , RtnService);
		<%}%>
	}		

	//CMS출금이체신청서
	function CallInsertTypeD()
	{
		var sendXML ="";
		
//		sendXML += "<?xml version='1.0' encoding='utf-8'?>";
		sendXML += "<root> ";
		sendXML += "<COMPANY_NAME><%=ht.get("COMPANY_NAME")%></COMPANY_NAME> ";
		sendXML += "<OWNER_NAME><%=ht.get("OWNER_NAME")%></OWNER_NAME> ";
		sendXML += "<RESNO><%=ht.get("RESNO")%></RESNO> ";
		sendXML += "<REGNO><%=ht.get("REGNO")%></REGNO> ";
		sendXML += "<CORPNUM><%=ht.get("CORPNUM")%></CORPNUM> ";
		sendXML += "<ZIPCODE><%=ht.get("ZIPCODE")%></ZIPCODE> ";
		sendXML += "<ADDR1><%=ht.get("ADDR1")%></ADDR1> ";
		sendXML += "<ADDR2><%=ht.get("ADDR2")%></ADDR2> ";
		sendXML += "<TELNO><%=ht.get("TELNO")%></TELNO> ";
		sendXML += "<MOBILE><%=ht.get("MOBILE")%></MOBILE> ";
		sendXML += "<FAXNO><%=ht.get("FAXNO")%></FAXNO> ";
		sendXML += "<EMAIL><%=ht.get("EMAIL")%></EMAIL> ";
		sendXML += "<UPJONG><%=ht.get("UPJONG")%></UPJONG> ";
		sendXML += "<UPTAE><%=ht.get("UPTAE")%></UPTAE> ";
		sendXML += "<GENDER><%=ht.get("GENDER")%></GENDER> ";
		sendXML += "<USERID><%=ht.get("USERID")%></USERID> ";
		sendXML += "<PASSWORD><%=ht.get("PASSWORD")%></PASSWORD> ";
		sendXML += "<doc_type><%=ht.get("DOC_TYPE")%></doc_type> ";
		sendXML += "<reg_id><%=ht.get("ACAR_USER_ID")%></reg_id> ";
		sendXML += "<reg_dt><%=ht.get("REG_DT")%></reg_dt> ";
		sendXML += "<acar_user_nm><%=ht.get("ACAR_USER_NM")%></acar_user_nm> ";
		sendXML += "<acar_user_email><%=ht.get("ACAR_USER_EMAIL")%></acar_user_email> ";
		sendXML += "<acar_user_tel><%=ht.get("ACAR_USER_TEL")%></acar_user_tel> ";
		sendXML += "<client_user_nm><%=ht.get("CLIENT_USER_NM")%></client_user_nm> ";
		sendXML += "<client_user_email><%=ht.get("CLIENT_USER_EMAIL")%></client_user_email> ";
		sendXML += "<client_user_tel><%=ht.get("CLIENT_USER_TEL")%></client_user_tel> ";
		sendXML += "<rent_l_cd><%=ht.get("RENT_L_CD")%></rent_l_cd> ";
		sendXML += "<rent_st><%=ht.get("RENT_ST")%></rent_st> ";
		sendXML += "<im_seq><%=ht.get("IM_SEQ")%></im_seq> ";
		sendXML += "<car_no><%=ht.get("CAR_NO")%></car_no> ";
		sendXML += "<cms_dep_nm><%=ht.get("CMS_DEP_NM")%></cms_dep_nm> ";
		sendXML += "<cms_dep_ssn><%=ht.get("CMS_DEP_SSN")%></cms_dep_ssn> ";
		sendXML += "<cms_bank><%=ht.get("CMS_BANK")%></cms_bank> ";
		sendXML += "<cms_acc_no><%=ht.get("CMS_ACC_NO")%></cms_acc_no> ";
		sendXML += "<cms_tel><%=ht.get("CMS_TEL")%></cms_tel> ";
		sendXML += "<cms_m_tel><%=ht.get("CMS_M_TEL")%></cms_m_tel> ";
		sendXML += "<firm_nm><%=ht.get("FIRM_NM")%></firm_nm> ";
		sendXML += "<etc><%=ht.get("ETC")%></etc> ";
		sendXML += "<o_tel><%=ht.get("O_TEL")%></o_tel> ";
		sendXML += "<m_tel><%=ht.get("M_TEL")%></m_tel> ";
		sendXML += "</root>";

		webMethodCall("http://www.papyless.co.kr/AmazonCar.asmx", "InsertTypeD", "XmlString=" + sendXML , RtnService);
	}
	
	

	function RtnService(returnvalue)
	{
		alert(returnvalue);
	}

</script>
</head>
<body>
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 		value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>      
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="now_stat" 		value="<%=now_stat%>">   
  <input type='hidden' name="link_table" 	value="<%=link_table%>">  
  <input type='hidden' name="link_type" 	value="<%=link_type%>">  
  <input type='hidden' name="link_rent_st" 	value="<%=link_rent_st%>">  
  <input type='hidden' name="link_im_seq" 	value="<%=link_im_seq%>">  
</form>
<script language="JavaScript">
<!--

<%if(flag1){%>

	<%if(link_type.equals("1")){%>		CallInsertTypeB();	
	<%}else if(link_type.equals("2")){%>	CallInsertTypeC();
	<%}else if(link_type.equals("3")){%>	CallInsertTypeB();
	<%}else if(link_type.equals("4")){%>
		<%if(link_table.equals("rm_rent_link_m") && link_com.equals("2")){%>
			//모바일 -> 프로시저에서 모두 처리
		<%}else{%>
			//파피리스	
			CallInsertTypeA();
		<%}%>
	<%}else if(link_type.equals("5")){%>	CallInsertTypeD();
	<%}%>
	
	alert("정상적으로 발송 되었습니다.");
	var fm = document.form1;		
	fm.action='reg_edoc_link.jsp';		
	fm.target='EDOC_LINK';
	fm.submit();
	
<%}else{%>

	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	<%if(alink_y_count > 0){%>
		alert("이미 전송된 전자문서가 있습니다.");
	<%}%>

<%}%>

//-->
</script>
</body>
</html>




