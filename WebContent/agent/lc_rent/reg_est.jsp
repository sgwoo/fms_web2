<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.tint.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	//납품관리 페이지
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
%>
<%	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//차량기본정보
	ContCarBean car = a_db.getContCarNew(m_id, l_cd);
	
	//예정일정보
	Hashtable est = a_db.getRentEst(m_id, l_cd);
	
	//출고정보
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	
	//납품관리
	TintBean tint 	= t_db.getTint(m_id, l_cd);
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
		if(fm.dlv_est_dt.value  != '' && fm.dlv_est_h.value  == '') 	fm.dlv_est_h.value  = '00';		
		if(fm.reg_est_dt.value  != '' && fm.reg_est_h.value  == '') 	fm.reg_est_h.value  = '00';		
		if(fm.rent_est_dt.value != '' && fm.rent_est_h.value == '') 	fm.rent_est_h.value = '00';						
		fm.action='reg_est_a.jsp';		
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
<table border="0" cellspacing="0" cellpadding="0" width=570>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>일정관리</span></span></td>
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
                    <td class='title' width='14%'>계약번호</td>
                    <td width='31%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='14%'>상호</td>
                    <td width='41%'>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=est.get("CAR_NO")%></td>
                    <td class='title'>차명</td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td><%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp; </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='14%'>구분</td>
                    <td class='title' width='35%'>예정일시</td>
                    <td class='title' width='34%'>실시일</td>
                    <td class='title' width='17%'>비고</td>
                </tr>
                <tr> 
                    <td align="center">출고</td>
                    <td align="center"> <input type='text' size='11' name='dlv_est_dt' class='text' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>' <%if(!base.getDlv_dt().equals("")||!car.getCar_amt_dt().equals("")||!car.getCar_tax_dt().equals("")){%>readonly<%}%> onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    &nbsp; <input type='text' size='2' name='dlv_est_h' class='text' value='<%=String.valueOf(est.get("DLV_EST_H"))%>' <%if(!base.getDlv_dt().equals("")||!car.getCar_amt_dt().equals("")||!car.getCar_tax_dt().equals("")){%>readonly<%}%>>
                    시 
                    <input type='hidden' name="o_dlv_est_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>">
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_DT")))%></td>
                    <td align="center">출고일자</td>
                </tr>
                <tr> 
                    <td align="center">인수</td>
                    <td align="center"> <input type='text' size='11' name='udt_est_dt' class='text' value='<%=AddUtil.ChangeDate2(pur.getUdt_est_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <input type='hidden' name="o_udt_est_dt" value="<%=AddUtil.ChangeDate2(pur.getUdt_est_dt())%>">
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(pur.getUdt_dt())%></td>
                    <td align="center">인수일자</td>
                </tr>                
                <tr> 
                    <td align="center">등록</td>
                    <td align="center"> <input type='text' size='11' name='reg_est_dt' class='text' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("REG_EST_DT")))%>' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    &nbsp; <input type='text' size='2' name='reg_est_h' class='text' value='<%=String.valueOf(est.get("REG_EST_H"))%>'>
                    시 
                    <input type='hidden' name="o_reg_est_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(est.get("REG_EST_DT")))%>">
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(est.get("INIT_REG_DT")))%></td>
                    <td align="center">최초등록일</td>
                </tr>
                <tr> 
                    <td align="center">납품</td>
                    <td align="center"> <input type='text' size='11' name='rent_est_dt' class='text' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_EST_DT")))%>' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    &nbsp; <input type='text' size='2' name='rent_est_h' class='text' value='<%=String.valueOf(est.get("RENT_EST_H"))%>'>
                    시 
                    <input type='hidden' name="o_rent_est_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_EST_DT")))%>">
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_START_DT")))%></td>
                    <td align="center">대여개시일</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
		<%if(String.valueOf(est.get("INIT_REG_DT")).equals("")){%>
		<a href='javascript:update()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
		<%}%>
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
