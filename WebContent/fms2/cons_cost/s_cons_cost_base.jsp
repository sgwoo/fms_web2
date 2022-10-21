<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	String car_comp_id	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd 		= request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String off_id 		= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String off_nm 		= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	String dlv_ext 		= request.getParameter("dlv_ext")==null?"":request.getParameter("dlv_ext");
	String udt_st 		= request.getParameter("udt_st")==null?"":request.getParameter("udt_st");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	Vector vt = a_db.getCarPurBaseConsCost(car_comp_id, car_cd, dlv_ext, udt_st, rent_l_cd);	
	int vt_size = vt.size();
	
	if(vt_size > 20) vt_size = 20;
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--


//-->
</script>
</head>

<body>
<form name='form1' method='post'>
 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>기본탁송료</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td>* 기본출고지 : <%=dlv_ext%> / 인수지 : <%=c_db.getNameByIdCode("0035", "", udt_st)%> </td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>	   				
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="50%">출고일자</td>
                    <td class=title width="50%">탁송료1</td>
                </tr>
            <%for (int i = 0 ; i < vt_size ; i++){
  				Hashtable ht = (Hashtable)vt.elementAt(i);
    	    %>
                <tr align="center">
                    <td><%=ht.get("DLV_DT")%></td>
                    <td><%=AddUtil.parseDecimal(ht.get("CONS_AMT1"))%>원</td>		  
                </tr>
            <%		}%>
            </table>
	    </td>
    </tr>	
    <tr> 
        <td align="center">
	    <a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		
	    </td>
    </tr>
</table>
</form>
</body>
</html>