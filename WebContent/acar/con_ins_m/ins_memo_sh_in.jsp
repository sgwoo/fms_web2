<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.con_ins_m.*, acar.car_accident.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String tm_st = request.getParameter("tm_st")==null?"":request.getParameter("tm_st");	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
	
	Vector memos = new Vector();
	
	if(tm_st.equals("9")){
		memos = a_cad.getInsMemo(m_id, l_cd, c_id, tm_st, "", serv_id);
	}else{
		memos = a_cad.getInsMemo(m_id, l_cd, c_id, tm_st, accid_id, serv_id);
	}
	
	int memo_size = memos.size();
%>
<table border="1" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
        <%	if(memo_size > 0){
		for(int i = 0 ; i < memo_size ; i++){
			InsMemoBean memo = (InsMemoBean)memos.elementAt(i);%>
        <tr>
		  <td width=12% align='center'><%=c_db.getNameById(memo.getReg_id(), "USER")%></td>
		  <td width=13% align='center'><%=AddUtil.ChangeDate2(memo.getReg_dt())%></td>
		  <td width=12% align='center'>
		  <%if(tm_st.equals("9")){%>
			  <%=memo.getAccid_id()%>
		  <%}else{%>
			  <%=memo.getSpeaker()%>
		  <%}%>
		  </td>					
          <td width=63%><%=Util.htmlBR(memo.getContent())%></td>
		</tr>
<%		}
	}else{%>		
		<tr>
		  <td colspan='4' align='center'>등록된 데이타가 없습니다 </td>
		</tr>
<%	}%>
	  </table>
	</td>
  </tr>
</table>
</body>
</html>
