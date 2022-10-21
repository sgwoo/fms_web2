<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.ars_card.*, acar.res_search.*, tax.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String ars_code 	= request.getParameter("ars_code")==null?"":request.getParameter("ars_code");
	
	
	ArsCardBean ars = ar_db.getArsCard(ars_code);
	

	String resend_st 	= request.getParameter("resend_st")	==null?"":request.getParameter("resend_st");
	String am_ax_code  	= request.getParameter("am_ax_code")	==null?"":request.getParameter("am_ax_code");
	String am_good_amt 	= request.getParameter("am_good_amt")	==null?"":request.getParameter("am_good_amt");
	String email 		= request.getParameter("email")		==null?"":request.getParameter("email");
	String m_tel 		= request.getParameter("m_tel")		==null?"":request.getParameter("m_tel");
	
	
	int count = 0;
	int flag = 0;
	
	
	//�������� �������� �ִ��� Ȯ���Ѵ�.
	Hashtable ht_ax = rs_db.getAxHubCase(am_ax_code);
	
	
			//��߱��޴�����ȣ�� �����Ѵ�.			
			count = rs_db.updateAxHub(am_ax_code, ck_acar_id, m_tel);
				
		
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
						
			IssueDb.insertsendMail_V5_H(sendphone, sendname, m_tel, ars.getBuyr_name(), "", "", msg_type, title, msg, "", "", ck_acar_id, "ax_hub");						
		
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&ars_code="+ars_code;

%>
<script language='javascript'>
<%	if(flag == 0){%>
		alert('���������� ó���Ǿ����ϴ�');
		parent.self.close();
		parent.opener.location	='ars_card_frame.jsp<%=valus%>';		
		
<%	}else{ //����%>
		alert('ó������ �ʾҽ��ϴ�\n\n�����߻�!');
<%	}%>
</script>
</body>
</html>
