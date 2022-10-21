<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_mst.CarOptBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");		
	
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_id 		= request.getParameter("car_id")	==null?"":request.getParameter("car_id");
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String t_wd2 		= request.getParameter("t_wd2")		==null?"":request.getParameter("t_wd2");
	String t_wd3 		= request.getParameter("t_wd3")		==null?"":request.getParameter("t_wd3");
	String t_wd4 		= request.getParameter("t_wd4")		==null?"":request.getParameter("t_wd4");
	String t_wd5 		= request.getParameter("t_wd5")		==null?"":request.getParameter("t_wd5");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	
	 
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();
	
	CarMstBean [] cm_r = null;
	
	if(view_dt.equals("")){
		cm_r = a_cmd.getCarNmAll4(car_comp_id, code, t_wd, t_wd2, t_wd3, t_wd4, t_wd5, gubun1, sort_gubun, asc);		
	}else{
		cm_r = a_cmd.getCarNmAll4(car_comp_id, code, car_id, view_dt, t_wd, t_wd2, t_wd3, t_wd4, t_wd5, gubun1, sort_gubun, asc);		
	}
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line>            
            <table border=0 cellspacing=1 width=100%>
        <%	for(int i=0; i<cm_r.length; i++){
			    cm_bean = cm_r[i];
				CarOptBean [] co_r = a_cmd.getCarOptList(cm_bean.getCar_comp_id(), cm_bean.getCode(), cm_bean.getCar_id(), cm_bean.getCar_seq(), "");
				//기본사양 포함 차명
				String car_b_inc_name = a_cmd.getCar_b_inc_name(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
				String bgcolor = "";
				if(i%2==0) bgcolor = "style='background-color:#f1f0ef;'";//ECECEC
		%>
                <tr> 
                    <td <%=bgcolor%> width='3%'  rowspan="3" align=center><%=i+1%></td>
                    <td <%=bgcolor%> width='20%' align=center><%=cm_bean.getCar_nm()%></td>
                    <td <%=bgcolor%> width='39%'>&nbsp;<a href="javascript:parent.Update('<%=cm_bean.getCar_id()%>','<%=cm_bean.getCar_seq()%>');"><%=cm_bean.getCar_name()%></a></td>
                   
                    <td <%=bgcolor%> width='4%' align=center><%=cm_bean.getCar_y_form()%></td>
                    <td <%=bgcolor%> width='6%' align=center><%=cm_bean.getJg_code()%></td>
                    <td <%=bgcolor%> width='4%' align=center><%=cm_bean.getDpm()%>cc</td>
                    <td <%=bgcolor%> width='6%' align=center><% if(cm_bean.getCar_yn().equals("N")){ %>
                    미사용
                    <% } else{%>
        			사용
                    <% } %>			</td>										
                    <td <%=bgcolor%> width='9%' align=right><%=AddUtil.parseDecimal(cm_bean.getCar_b_p())%>원&nbsp;&nbsp;&nbsp;</td>
                    <td <%=bgcolor%> width="9%" align="center"><%=AddUtil.ChangeDate2(cm_bean.getCar_b_dt())%></td>
                </tr>
                <tr> 
                    <td colspan="8">
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td <%=bgcolor%>> 
                    <% if(!car_b_inc_name.equals("")){ %>
                    <%= car_b_inc_name %> 기본사양 외 
                    <% } %>
                    <%=cm_bean.getCar_b()%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td colspan="8" align="right" >
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td <%=bgcolor%>  align="right" >
            			        <% for(int j=0; j<co_r.length; j++){
            			 	    co_bean = co_r[j];
            			 	    if(co_bean.getUse_yn().equals("N")) continue;
            				    out.println(co_bean.getCar_s()+" ["+AddUtil.parseDecimal(co_bean.getCar_s_p())+"원]<br>");
            			        } %>
        				        </td>
        				    </tr>
        				</table>
        		    </td>
                </tr>
                <%	}	%>
                <% if(cm_r.length == 0){ %>
                <tr> 
                    <td align=center height=25 colspan="8">등록된 데이타가 없습니다.</td>
                </tr>
                <%	}	%>
            </table>
        </td>
    </tr>
</table>
<form action="./car_office_c.jsp" name="CarOffUpdateForm" method="post">
<input type="hidden" name="car_off_id" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
</form>
</body>
</html>