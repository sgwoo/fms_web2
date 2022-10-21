<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_yb.*"%>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	Offls_ybBean detail = olyD.getYb_detail(car_mng_id);
	
	
	

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//상품평가 수정 등록 구분하기 위해
	String apprsl_car_mng_id = olyD.getApprsl_Car_mng_id(car_mng_id);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
function detailUpd(ioru)
{
	var fm = document.form1;	
	fm.gubun.value = ioru;
	fm.action="./off_lease_sc_in_b_apprsl_iu.jsp";
	fm.submit();
}
-->
</script>
</head>
<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>상품평가</span></td>
        <td align="right"> 
        <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
        <%if(apprsl_car_mng_id.equals("")){%>
        <a href='javascript:detailUpd("i");' onMouseOver="window.status=''; return true"> 
        <img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
        <%}else{%>
        <a href='javascript:detailUpd("u");' onMouseOver="window.status=''; return true"> 
        <img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
        <%}%>
        <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                    <td class='title' width=16%> 자체평가</td>
                    <td width=22% align=center><%if(detail.getLev().equals("1")){%>
        		  	상
        		  <%}else if(detail.getLev().equals("2")){%>
        		  	중
                  <%}else if(detail.getLev().equals("3")){%>
        		  	하
        			<% } %></td>
                    <td class='title' width=14%>평가일자</td>
                    <td align="center" width=18%><%=AddUtil.ChangeDate2(detail.getApprsl_dt())%></td>
                    <td class='title' width=13%>&nbsp;</td>
                    <td width=17%>&nbsp; </td>
                </tr>
                <tr> 
                    <td class='title'>평가요인</td>
                    <td colspan="5">&nbsp;&nbsp;<%=detail.getReason()%></td>
                </tr>
                <tr> 
                    <td class='title'>차량상태</td>
                    <td colspan="5">&nbsp;&nbsp;<%=detail.getCar_st()%></td>
                </tr>
                <tr> 
                    <td class='title'>사고유무</td>
                    <td width="180" align="center">
                      <%if(detail.getAccident_yn().equals("1")){%>
                      있음 
                      <%}else{%>
                      없음 
                      <%}%>
                    </td>
                    <td class='title'>담당자</td>
                    <td><%if(login.getAcarName(detail.getDamdang_id()).equals("error")){%>
                    &nbsp; 
                    <%}else{%>
                    <%=login.getAcarName(detail.getDamdang_id())%> 
                    <%}%></td>
                    <td class='title'>최종수정자</td>
                    <td align="center">&nbsp; 
                      <%if(login.getAcarName(detail.getModify_id()).equals("error")){%>
                      &nbsp; 
                      <%}else{%>
                      <%=login.getAcarName(detail.getModify_id())%> 
                      <%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td></td>
	</tr>
    <tr> 
        <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>반납전 차량운행자</span></td>
        <td align="right">&nbsp; </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2" align='left' class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=16%>운행자</td>
                    <td width=84%>&nbsp;&nbsp;
        			<%if(detail.getDriver().equals("1")){%>
        			임원
        			<%}else if(detail.getDriver().equals("2")){%>
        			직원
        			<%}%> 
        			</td>
                </tr>
            </table>
        </td>
    </tr>
	
</table>
</form>
</body>
</html>
