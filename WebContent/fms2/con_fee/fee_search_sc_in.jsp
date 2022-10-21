<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
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
	String idx 		= request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	
	Vector vt = af_db.getFeeSearchListAll(s_kd, t_wd);
	int vt_size = vt.size();
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method="post">
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr>
	    <td class='line' >			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
    			    <td width='40' class='title'>연번</td>
    			    <td width='100' class='title'>계약번호</td>
    			    <td width='200' class='title'>상호</td>
        			<td width='100' class='title'>차량번호</td>
        			<td width='200' class='title'>차명</td>
        			<td width='100' class='title'>대여개시일</td>
        			<td width='60' class='title'>대여개월</td>					        			
    		    </tr>
<%	if(vt_size > 0){%>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
		        <tr>
			        <td align='center' ><%=i+1%></td>
			        <td align='center' ><a href="javascript:parent.view_scd_fee('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>								
			        <td align='center' ><%if(ht.get("USE_YN").equals("N")){%>[해지] <%}%><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
        			<td align='center' ><span title='최초등록일:<%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%>'><%=ht.get("CAR_NO")%></span></td>					
        			<td align='center' ><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 5)%></span></td>		  
        			<td align='center' ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
        			<td align='center' ><%=ht.get("CON_MON")%>개월</td>					
		        </tr>
<%		}%>
<%	}else{ %>	
		        <tr>
			        <td colspan="7" align='center'></td>
		        </tr>						
<%	}%>								
		    </table>
 	    </td>
	</tr>		
</table>
</form>
</body>
</html>