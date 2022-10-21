<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.im_email.*, tax.*, acar.admin.*, acar.credit.*, acar.car_register.*, acar.common.*"%>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>	
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//메일관리 메일 발송 처리 페이지
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();

	String rent_mng_id = request.getParameter("rent_mng_id") == null? "" : request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd") == null? "" : request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st") == null? "" : request.getParameter("rent_st");
	
	String send_type = request.getParameter("send_type") == null? "" : request.getParameter("send_type");
	
	String firm_nm = request.getParameter("firm_nm") == null? "" : request.getParameter("firm_nm");
	String con_agnt_nm = request.getParameter("con_agnt_nm") == null? "" : request.getParameter("con_agnt_nm");
	String con_agnt_email = request.getParameter("con_agnt_email") == null? "" : request.getParameter("con_agnt_email");
	
	String stamp_yn = request.getParameter("stamp_yn") == null? "N" : request.getParameter("stamp_yn");
	
	String check_value[] = request.getParameterValues("check_value");
	int check_value_size = 0;
	
	if (!send_type. equals("single")) {
		check_value_size = check_value.length;
	}
	
	int flag = 0;
	
	//[5단계] 인포메일러 발송 : d-mail 생성
	if (!con_agnt_email.equals("")) {
		
		//	1. d-mail 등록-----------------------------
		DmailBean d_bean = new DmailBean();
		
		String content = "";
		
		if (check_value_size > 0) {
			
			for (int i = 0; i < check_value_size; i++) {
				String temp_val = check_value[i];
				String split_temp_val_1 = temp_val.split("_")[0];
				String split_temp_val_2 = temp_val.split("_")[1];
				String split_temp_val_3 = temp_val.split("_")[2];
				
				rent_mng_id = split_temp_val_1;
				rent_l_cd = split_temp_val_2;
				rent_st = split_temp_val_3;
				
				//cont_view
				Hashtable base = a_db.getContViewCase(rent_mng_id, rent_l_cd);
				
				content = "http://fms1.amazoncar.co.kr/mailing/rent/scd_info.jsp?m_id=" + rent_mng_id + "&l_cd=" + rent_l_cd + "&rent_st=&stamp_yn=" + stamp_yn;
				
				d_bean.setSubject			(firm_nm + "님, "+base.get("CAR_NO")+" (주)아마존카 장기대여 스케줄 안내문입니다.");
				d_bean.setSql				("SSV:"+con_agnt_email.trim());
				d_bean.setReject_slist_idx	(0);
				d_bean.setBlock_group_idx	(0);
				d_bean.setMailfrom			("\"아마존카\"<tax200@amazoncar.co.kr>");
				d_bean.setMailto			("\""+firm_nm+"\"<"+con_agnt_email.trim()+">");
				d_bean.setReplyto			("\"아마존카\"<tax200@amazoncar.co.kr>");
				d_bean.setErrosto			("\"아마존카\"<tax200@amazoncar.co.kr>");
				d_bean.setHtml				(1);
				d_bean.setEncoding			(0);
				d_bean.setCharset			("euc-kr");
				d_bean.setDuration_set		(1);
				d_bean.setClick_set			(0);
				d_bean.setSite_set			(0);
				d_bean.setAtc_set			(0);		
				d_bean.setGubun				(rent_l_cd + "scd_info");
				d_bean.setRname				("mail");
				d_bean.setMtype				(0);
				d_bean.setU_idx				(1); //admin계정
				d_bean.setG_idx				(1); //admin계정
				d_bean.setMsgflag			(0);
				d_bean.setContent			(content);
				
				if (!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) {
					//flag += 1;
					flag ++;
				}
			}
			
		} else {
			
			//cont_view
			Hashtable base2 = a_db.getContViewCase(rent_mng_id, rent_l_cd);
			
			content = "http://fms1.amazoncar.co.kr/mailing/rent/scd_info.jsp?m_id=" + rent_mng_id + "&l_cd=" + rent_l_cd + "&rent_st=&stamp_yn=" + stamp_yn;
			
			d_bean.setSubject			(firm_nm + "님, "+base2.get("CAR_NO")+" (주)아마존카 장기대여 스케줄 안내문입니다.");	
			d_bean.setSql				("SSV:"+con_agnt_email.trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"아마존카\"<tax200@amazoncar.co.kr>");
			d_bean.setMailto			("\""+firm_nm+"\"<"+con_agnt_email.trim()+">");
			d_bean.setReplyto			("\"아마존카\"<tax200@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<tax200@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);	
			d_bean.setGubun				(rent_l_cd + "scd_info");
			d_bean.setRname				("mail");
			d_bean.setMtype				(0);
			d_bean.setU_idx				(1); //admin계정
			d_bean.setG_idx				(1); //admin계정
			d_bean.setMsgflag			(0);
			d_bean.setContent			(content);
	
			if (!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) {
				//flag += 1;
				flag ++;
			}
		}
	}
%>

<html>
<head>
<title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){	  
		//parent.window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name="form1" action="" method="post">
<script language='javascript'>
<!--
<%if (flag > 0) {//에러발생%>
		alert("이메일 발송 에러가 발생하였습니다.");
<%} else {//정상%>	
		alert("이메일를 발송하였습니다.");	
<%}%>
//-->
</script>
</form>
</body>
</html>
