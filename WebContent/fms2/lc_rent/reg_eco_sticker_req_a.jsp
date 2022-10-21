<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cooperation.*, acar.coolmsg.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>	
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>	
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String post_st 	= request.getParameter("post_st")==null?"":request.getParameter("post_st");
	String post_etc 	= request.getParameter("post_etc")==null?"":request.getParameter("post_etc");
	
	int count = 0;
	boolean flag6 = true;

	//����� �������
	LongRentBean base = ScdMngDb.getScdMngLongRentInfo(rent_mng_id, rent_l_cd);

	String title 	= "[�����ؽ�ƼĿ��߱޿�û]"+rent_l_cd+" "+base.getFirm_nm();
	String content 	= "�����ؽ�ƼĿ ��߱޿�û�մϴ�.\n\n\n��ȣ : "+base.getFirm_nm()+"\n����ȣ : "+rent_l_cd+"\n������ȣ : "+base.getCar_no()+"\n�ּ����� : "+post_st+"\n����ó : "+base.getM_tel()+"\n��� : "+post_etc;
			
	cp_bean.setIn_id		(ck_acar_id);
	cp_bean.setTitle		(title);
	cp_bean.setContent	(content);
	cp_bean.setOut_id		("");
	cp_bean.setSub_id		(nm_db.getWorkAuthUser("�����ؽ�ƼĿ���"));
	cp_bean.setCom_id		(ck_acar_id);
	
	count = cp_db.insertCooperation(cp_bean);


	UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
	UsersBean target_bean 	= umd.getUsersBean(cp_bean.getSub_id());
	
	String sub 		= "�����ؽ�ƼĿ �������� ���";
	String cont 	= "["+sender_bean.getUser_nm()+"]���� �����ؽ�ƼĿ ��߱޸� ��û�ϼ̽��ϴ�. &lt;br&gt; &lt;br&gt; Ȯ�ιٶ��ϴ�.";
	
	String url 		= "/fms2/cooperation/cooperation_n2_frame.jsp";
	
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
	  					"<ALERTMSG>"+
  						"<BACKIMG>4</BACKIMG>"+
  						"<MSGTYPE>104</MSGTYPE>"+
  						"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
  						"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
						
						//�޴»�� // �޴»�� ���̵� �˻��ؼ� �ݺ����ִ� �κ�
						xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
						//�������
						xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
  					"    <FLDTYPE>1</FLDTYPE>"+
  					"  	 </ALERTMSG>"+
	  				"</COOLMSG>";
			
	CdAlertBean msg = new CdAlertBean();
	msg.setFlddata(xml_data);
	msg.setFldtype("1");
	flag6 = cm_db.insertCoolMsg(msg);

	
%>

<form name='form1' method='post'>
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
</form>  
<script language='javascript'>
<%	if(count == 0){%>
		alert("ó������ �ʾҽ��ϴ�");		
<%	}else{%>		
		alert("ó���Ǿ����ϴ�");
		parent.window.close();		
<%	}%>
</script>