<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.coolmsg.*, acar.user_mng.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	//출고예정일 수정 처리 페이지
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String dlv_est_dt 	= request.getParameter("dlv_est_dt")==null?"":request.getParameter("dlv_est_dt");
	String dlv_est_h	= request.getParameter("dlv_est_h")==null?"00":request.getParameter("dlv_est_h");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String query = "";
	int flag = 0;
	boolean flag5 = true;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	


	//출고정보
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	
	ContBaseBean base = a_db.getCont(m_id, l_cd);


	query = " UPDATE car_pur SET dlv_est_dt =replace('"+dlv_est_dt+""+dlv_est_h+"','-','')   WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
	flag = a_db.updateEstDt(query);
	
	


	//담당자에게 통보	
	if(pur.getDlv_est_dt().equals("")){
		
		
		
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			

			String sub2 		= "장기계약 출고예정일 확정";
			String cont2 		= "[ "+l_cd+" "+request.getParameter("firm_nm")+"  ] 장기계약의 출고예정일("+dlv_est_dt+")이 확정되었습니다.";
			String target_id2 	= base.getBus_id();	
			
									
			//사용자 정보 조회
			UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub2+"</SUB>"+
		  				"    <CONT>"+cont2+"</CONT>"+
 						"    <URL></URL>";
			xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";

			xml_data2 += "    <SENDER></SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
			
			flag5 = cm_db.insertCoolMsg(msg2);
			System.out.println("쿨메신저("+l_cd+" "+request.getParameter("firm_nm")+" [미출고현황] 출고예정일 확정)-----------------------"+target_bean2.getUser_nm());
			//System.out.println(xml_data);			
	}
	
	
%>
<script language='javascript'>
<%	if(flag == 0){%>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>		
		alert("처리되었습니다");
		<%if(mode.equals("board")){%>	
			parent.window.close();
			parent.opener.location.reload();
		<%}%>
<%	}			%>
</script>