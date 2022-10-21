<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.im_email.*, tax.*"%>
<%@ page import="acar.accid.*"%>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	
	Hashtable cont = as_db.getRentCase(m_id, l_cd);

	
	String con_agnt_email 	= String.valueOf(cont.get("CON_AGNT_EMAIL"));//

	String firm_nm 	= String.valueOf(cont.get("FIRM_NM"));
	

	boolean flag1 = true;

	int result = 0;
	
	String subject 		= firm_nm+"님, 자동차 정기검사 안내문입니다.";
	String msg 			= firm_nm+"님, 자동차 정기검사 안내문입니다.";
	String sendname 	= "(주)아마존카";
	String sendphone 	= "02-392-4243";
	int seqidx			= 0;
	


	if(!con_agnt_email.equals("")){
			//	1. d-mail 등록-------------------------------
			DmailBean d_bean = new DmailBean();
			d_bean.setSubject			(subject);
			d_bean.setSql				("SSV:"+con_agnt_email.trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"아마존카\"<cs@amazoncar.co.kr>");
			d_bean.setMailto			("\""+firm_nm+"\"<"+con_agnt_email.trim()+">");
			d_bean.setReplyto			("\"아마존카\"<cs@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<cs@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				("car_maint");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin계정
			d_bean.setG_idx				(1);//admin계정
			d_bean.setMsgflag     		(0);
		
		  	d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/ser/insp.jsp?m_id="+m_id+"&l_cd="+l_cd);

		   seqidx = ImEmailDb.insertDEmail2(d_bean, "4", "", "+7");
			
		}

%>

<script>
<%	if(seqidx > 0){%>
			alert("정상적으로 발송 되었습니다.");
				
<%		}else{%>
			alert("에러발생!");
<%		}%>

</script>

</body>
</html>