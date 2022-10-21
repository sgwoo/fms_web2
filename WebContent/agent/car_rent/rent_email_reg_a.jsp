<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.im_email.*, tax.*"%>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	//메일관리 메일 발송 처리 페이지
	
	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"scd":request.getParameter("f_list");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String cls_st 	= request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String reg_yn 	= request.getParameter("reg_yn")==null?"":request.getParameter("reg_yn");
	String gubun	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	String con_agnt_nm 		= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_dept 	= request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept");
	String con_agnt_title 	= request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title");
	String con_agnt_email 	= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel 	= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");
	String content 			= request.getParameter("content")==null?"":request.getParameter("content");
	String firm_nm 			= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String firm_nm2			= request.getParameter("firm_nm2")==null?"":request.getParameter("firm_nm2");
	String car_no 			= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String msg 				= request.getParameter("msg")==null?"":request.getParameter("msg");
	String sendname 		= "(주)아마존카";
	String sendphone 		= "02-392-4243";
	int flag = 0;
	
	//[5단계] 인포메일러 발송 : d-mail 생성

	if(!con_agnt_email.equals("")){
	
		//	1. d-mail 등록-------------------------------
		
		DmailBean d_bean = new DmailBean();
		
		if     (content.equals("http://fms1.amazoncar.co.kr/mailing/rent/scd_fee.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st))			d_bean.setSubject(firm_nm+"님, (주)아마존카 장기대여 이용 안내문입니다.");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st))			d_bean.setSubject(firm_nm+"님, (주)아마존카 서비스 통합 안내문입니다.");		
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/fms/fms_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st))			d_bean.setSubject(firm_nm+"님, (주)아마존카 고객FMS 이용 안내문입니다.");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/car_adm/car_mng_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st))		d_bean.setSubject(firm_nm+"님, (주)아마존카 차량관리안내문입니다.");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/ins/sos.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st))				d_bean.setSubject(firm_nm+"님, (주)아마존카 마스타자동차 긴급출동 안내문입니다.");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/cms/cms_m.html"))					                                d_bean.setSubject(firm_nm+"님, (주)아마존카 CMS관련 변경사항 안내문입니다.");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/cms/cms_fine.html"))					                        d_bean.setSubject(firm_nm+"님, (주)아마존카 유료고속도로&주차장 미납통행료납부 안내문입니다.");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/etc/notice_rep.html"))					                        d_bean.setSubject(firm_nm+"님, (주)아마존카 스피드메이트 정비협력업체 안내문입니다.");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/cms/bank.html"))					                     	        d_bean.setSubject(firm_nm+"님, (주)아마존카 통장사본입니다.");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/cls/cls_con_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&cls_st="+cls_st))			d_bean.setSubject(firm_nm+"님, (주)아마존카 해지정산 내역 안내문입니다.");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/rent/scd_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="))				d_bean.setSubject(firm_nm+"님, (주)아마존카 장기대여 스케줄 안내문입니다.");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/etc/2012_play.html"))								d_bean.setSubject(firm_nm+"님, (주)아마존카 고객초청 연극공연");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/etc/fine_receipt.html"))								d_bean.setSubject(firm_nm+"님, (주)아마존카 과태료·통행료·주차요금 영수증발급기관 안내문입니다.");

		d_bean.setSql				("SSV:"+con_agnt_email.trim());
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom			("\"아마존카\"<tax@amazoncar.co.kr>");
		d_bean.setMailto			("\""+firm_nm+"\"<"+con_agnt_email.trim()+">");
		d_bean.setReplyto			("\"아마존카\"<tax@amazoncar.co.kr>");
		d_bean.setErrosto			("\"아마존카\"<tax@amazoncar.co.kr>");
		d_bean.setHtml				(1);
		d_bean.setEncoding			(0);
		d_bean.setCharset			("euc-kr");
		d_bean.setDuration_set		(1);
		d_bean.setClick_set			(0);
		d_bean.setSite_set			(0);
		d_bean.setAtc_set			(0);
		if     (content.equals("http://fms1.amazoncar.co.kr/mailing/rent/scd_fee.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st))			d_bean.setGubun	(l_cd+"scd_fee");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st))			d_bean.setGubun	(l_cd+"total_mail");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/fms/fms_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st))			d_bean.setGubun	(l_cd+"fms_info");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/car_adm/car_mng_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st))		d_bean.setGubun	(l_cd+"car_info");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/ins/sos.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st))				d_bean.setGubun	(l_cd+"car_sos");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/cms/cms_m.html"))                                                           	d_bean.setGubun	(l_cd+"cms_m");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/cms/cms_fine.html"))                                                        	d_bean.setGubun	(l_cd+"cms_fine");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/etc/notice_rep.html"))                                                       	d_bean.setGubun (l_cd+"speedmate");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/cms/bank.html"))                                                      	    	d_bean.setGubun	(l_cd+"bank");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/cls/cls_con_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&cls_st="+cls_st))			d_bean.setGubun	(l_cd+"cls_info");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/rent/scd_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="))				d_bean.setGubun	(l_cd+"scd_info");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/etc/2012_play.html"))								d_bean.setGubun	(l_cd+"201204 event");
		else if(content.equals("http://fms1.amazoncar.co.kr/mailing/etc/fine_receipt.html"))								d_bean.setGubun	(l_cd+"receipt");
		
		d_bean.setRname				("mail");
		d_bean.setMtype       			(0);
		d_bean.setU_idx       			(1);//admin계정
		d_bean.setG_idx				(1);//admin계정
		d_bean.setMsgflag     			(0);
		d_bean.setContent			(content);
		
		if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
	}
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){	  
		//parent.window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='reg_yn' value='<%=reg_yn%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>  
<a href="javascript:go_step()"></a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("이메일 발송 에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("이메일를 발송하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
