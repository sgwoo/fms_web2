<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//수정: 
	function update_post(idx){
		var fm = document.form1;
		if(confirm('수정하시겠습니까?')){
			fm.target = 'i_no';
			fm.submit();
		}		
	}
	

//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String mgr_st = request.getParameter("mgr_st")==null?"":request.getParameter("mgr_st");	
	
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
%>
<form name='form1' method='post' action='post_addr_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>

<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=610>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>거래처 > <span class=style5><%=firm_nm%> </span></span></td>
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=610>
			<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address +" ("+ data.buildingName+")";
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title width='150'>우편물주소</td>
				  <td width='460'>&nbsp;
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=base.getP_zip()%>">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br><br>
					&nbsp;
					<input type="text" name="t_addr" id="t_addr" size="62" value="<%=base.getP_addr()%>">
					<br><br>
					&nbsp;
					<input type="text" name="tax_agnt" id="tax_agnt" size="20" value="<%=base.getTax_agnt()%>">
				  </td>
				</tr>
                <tr>
                    <td class='title'>거래처  일괄적용 </td>
                    <td>&nbsp;<input type="checkbox" name="all_upchk" value="Y"> 
                    (위의 내용으로 일괄 수정하는 것) </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
	    <a href="javascript:update_post();"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp; 
        <a href='javascript:window.close()'><img src=../images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
