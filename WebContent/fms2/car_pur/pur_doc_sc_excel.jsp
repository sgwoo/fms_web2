<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=pur_doc_sc_excel.xls");
%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
			
	Vector vt = d_db.getCarPurDocList(s_kd, t_wd, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
	int vt_size = vt.size();
	
	int count =0;
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
</script>
<body>
	<table width="1050" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > <span class=style5>차량대금지급요청</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>     
    <tr>
        <td class=line>     
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		                <td width='50' class='title'>연번</td>
		                <td width="300" class='title'>고객</td>
		                <td width='150' class='title'>계출번호</td>
			              <td width='100' class='title'>담당자</td>
			              <td width='150' class='title'>제조사</td>
			              <td width='200' class='title'>영업소</td>
			              <td width='100' class='title'>지급일자</td>				  
                </tr>
                <%
										for(int i = 0 ; i < vt_size ; i++)
										{
											Hashtable ht = (Hashtable)vt.elementAt(i);
			
											if(String.valueOf(ht.get("RENT_L_CD")).equals("K316KYPR00089")) continue;
			
											count++;
                %>
                <tr>
		                <td align='center'><%=count%></td>
		                <td align='center'><%=ht.get("FIRM_NM")%></td>
			              <td align='center'><%=ht.get("RPT_NO")%></td>				
			              <td align='center'><%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%></td>
			              <td align='center'><%=ht.get("CAR_COMP_NM")%></td>
			              <td align='center'><%=ht.get("CAR_OFF_NM")%></td>
			              <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%>			    
                </tr>
                <%	}%>
    		    </table>
	      </td>
    </tr>         	        
</table>
</body>
</html>
