<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, tax.*, ax_hub.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ax_db" scope="page" class="ax_hub.AxHubDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");	
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");		
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");

	String s_cd 		= request.getParameter("s_cd")		==null?"":request.getParameter("s_cd");
	String c_id 		= request.getParameter("c_id")		==null?"":request.getParameter("c_id");
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");		
	String f_page 		= request.getParameter("f_page")	==null?"":request.getParameter("f_page");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
		
	String scd_rent_st 	= request.getParameter("scd_rent_st")	==null?"":request.getParameter("scd_rent_st");
	String scd_tm 		= request.getParameter("scd_tm")	==null?"":request.getParameter("scd_tm");
	
	String car_no 		= request.getParameter("car_no")	==null?"":request.getParameter("car_no");
	String c_firm_nm 	= request.getParameter("c_firm_nm")	==null?"":request.getParameter("c_firm_nm");
	String c_client_nm 	= request.getParameter("c_client_nm")	==null?"":request.getParameter("c_client_nm");
	

	
	
	
	String email 		= request.getParameter("email")		==null?"":request.getParameter("email");
	String m_tel 		= request.getParameter("m_tel")		==null?"":request.getParameter("m_tel");
	String am_good_s_amt 	= request.getParameter("am_good_s_amt")	==null?"":request.getParameter("am_good_s_amt");
	String am_good_v_amt 	= request.getParameter("am_good_v_amt")	==null?"":request.getParameter("am_good_v_amt");
	String am_good_m_amt 	= request.getParameter("am_good_m_amt")	==null?"":request.getParameter("am_good_m_amt");
	String am_good_amt 	= request.getParameter("am_good_amt")	==null?"":request.getParameter("am_good_amt");
	
	
	int count = 0;
	int flag = 0;
	
	
	//String am_ax_code  	= Long.toString(System.currentTimeMillis());
	
	String am_ax_code  	= "";
	
	
	
	
	//20130830 6�ڸ� �����ڵ�
	for(int i=0;i < 100;i++){
		
		String am_ax_code2  	= AddUtil.parseFloatTruncZero(String.valueOf(Math.random()*1000000));
								
		//�ߺ�����			
		AxHubBean ax_bean 	= ax_db.getAxHubCase(am_ax_code2);
						
		if(ax_bean.getAm_ax_code().equals("")){
			am_ax_code = am_ax_code2;
				
			//out.println(am_ax_code2+"<br>");
			//out.println(i+"<br>");
				
			break;	
		}																		
	}
	
	
	
	
	
	if(!am_ax_code.equals("")){
	
		//ax_hub ���	
		count = rs_db.insertAxHub(am_ax_code, "����Ʈ", s_cd, c_id, Util.parseDigit(am_good_amt), Util.parseDigit(am_good_s_amt), Util.parseDigit(am_good_v_amt), Util.parseDigit(am_good_m_amt), user_id, email, m_tel);
	
	
	
		if(count == 1){
		
		//���Ϲ߼�
		/*
		DmailBean d_bean = new DmailBean();
		d_bean.setSubject		(c_firm_nm+"��, (��)�Ƹ���ī �������������Դϴ�.");
		d_bean.setSql			("SSV:"+email);
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom		("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
		d_bean.setMailto		("\""+c_firm_nm+"\"<"+email+">");
		d_bean.setReplyto		("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
		d_bean.setErrosto		("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
		d_bean.setHtml			(1);
		d_bean.setEncoding		(0);
		d_bean.setCharset		("euc-kr");
		d_bean.setDuration_set		(1);
		d_bean.setClick_set		(0);
		d_bean.setSite_set		(0);
		d_bean.setAtc_set		(0);
		d_bean.setGubun			(am_ax_code);
		d_bean.setRname			("mail");
		d_bean.setMtype       		(0);
		d_bean.setU_idx       		(1);//admin����
		d_bean.setG_idx			(1);//admin����
		d_bean.setMsgflag     		(0);
		d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/ax_hub/index.jsp?am_good_st=����Ʈ&am_good_id1="+s_cd+"&am_good_id2="+c_id+"&am_good_amt="+am_good_amt+"&am_user_id="+user_id);
		if(!IssueDb.insertDEmail(d_bean, "", "+6.05")) flag += 1;
	
	
		//���ڹ߼�	
		if(flag == 0){			
		
		*/
		
			String sendname 	= "(��)�Ƹ���ī";
			String sendphone 	= "02-392-4243";
			String msg 		= "";
			String title 		= "";
			
			msg = "�Ƹ���ī ������ȣ�� ["+am_ax_code+"]�Դϴ�. ����ƮȨ���������� �����Ͻñ� �ٶ��ϴ�. -�Ƹ���ī-";
			
			int i_msglen = AddUtil.lengthb(msg);
		
			String msg_type = "0";
		
			//80�̻��̸� �幮��
			if(i_msglen>80){
				msg_type = "5";
				title = "�Ƹ���ī ����������ȣ";
			}
				
		
			IssueDb.insertsendMail_V5_H(sendphone, sendname, m_tel, c_firm_nm, "", "", msg_type, title, msg, "", "", ck_acar_id, "ax_hub");

		//}	
		}
	}
	
	

%>
<script language='javascript'>
<%	if(!am_ax_code.equals("") && count == 1){%>
		alert('���������� ó���Ǿ����ϴ�');
		parent.self.close();
		<%if(from_page.equals("/acar/res_stat/res_rent_u.jsp")){%>
		parent.opener.location	='/acar/res_stat/res_rent_u.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&s_cd=<%=s_cd%>&c_id=<%=c_id%>&list_from_page=<%=list_from_page%>';
		<%}else{%>
		parent.opener.location	='/acar/rent_mng/res_rent_u.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>&s_cd=<%=s_cd%>&c_id=<%=c_id%>&list_from_page=<%=list_from_page%>';
		<%}%>
		
<%	}else{ //����%>
		alert('ó������ �ʾҽ��ϴ�\n\n�����߻�!');
<%	}%>
</script>
</body>
</html>
