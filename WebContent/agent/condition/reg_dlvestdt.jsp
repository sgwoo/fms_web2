<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.user_mng.*, acar.car_sche.*,acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	//납품관리 페이지
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
  CommonDataBase c_db = CommonDataBase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//출고정보
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	
	String gubun = c_db.getNameByIdCode("0032", "", car.getCar_ext());
	
	Hashtable est = a_db.getRentEst(m_id, l_cd);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function update(){		
		var fm = document.form1;
		fm.action='reg_dlvestdt_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}
	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="mode" value="<%=mode%>">
<input type='hidden' name="firm_nm" value="<%=est.get("FIRM_NM")%>">
<table border="0" cellspacing="0" cellpadding="0" width=570>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>출고예정일 등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>계약번호</td>
                    <td width='29%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>상호</td>
                    <td width='41%'>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>등록지역</td>
                    <td>&nbsp;<%=gubun%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>
                <tr> 
                    <td class='title'>계출번호</td>
                    <td colspan='3'>&nbsp;<%=pur.getRpt_no()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>출고요청일</td>
                    <td>&nbsp;<%=pur.getPur_req_dt()%></td>
                </tr>
                <tr> 
                    <td class='title'>출고예정일</td>
                    <td>&nbsp;<input type='text' size='12' name='dlv_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
        			  <input type='text' size='2' name='dlv_est_h' class='default' value='<%=String.valueOf(est.get("DLV_EST_H"))%>'>시
    			    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">		
		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
