<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String cng_dt 	= request.getParameter("cng_dt")==null?"":request.getParameter("cng_dt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//대여변경이력
	FeeScdCngBean fee_scd = af_db.getFeeScdCngCase(m_id, l_cd, cng_dt);
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//대여스케줄 변경
	function cng_schedule()
	{
		var fm = document.form1;
	
		if(confirm('변경사유를 수정 하시겠습니까?'))
		{			
			fm.cmd.value = 'u';										
			fm.action = './fee_scd_u_cng_a.jsp';
//			fm.target = 'i_no';
			fm.submit();
		}
	}		
	
	//대여스케줄 삭제
	function del_schedule()
	{
		var fm = document.form1;
	
		
		if(confirm('변경이력을 삭제 하시겠습니까?'))
		{									
			if(confirm('변경이력을 정말로 삭제 하시겠습니까?'))
			{		
				fm.cmd.value = 'd';							
				fm.action = './fee_scd_u_cng_a.jsp';
//				fm.target = 'i_no';
				fm.submit();
			}
		}				
	}	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="post">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='cng_dt' value='<%=cng_dt%>'>
<input type='hidden' name='cmd' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > 대여료스케줄관리 > <span class=style5>대여료스케줄 변경 내용수정</span></span></td>
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
	    <td align='right' class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="15%" class='title'>항목</td>
                    <td width="25%" class='title'>변경전</td>
                    <td width="25%" class='title'>변경후</td>
                    <td width="20%" class='title'>변경일자</td>
                    <td width="15%" class='title'>변경자</td>
                </tr>
                <tr align="center">
                    <td>
						<%=fee_scd.getGubun()%>						
					</td>
                    <td><%=fee_scd.getB_value()%></td>
                    <td><%=fee_scd.getA_value()%></td>
                    <td><%=AddUtil.ChangeDate2(fee_scd.getCng_dt())%></td>
                    <td><%=c_db.getNameById(fee_scd.getCng_id(),"USER")%></td>
                </tr>
                <tr>
                    <td class='title'>변경사유</td>
					<td colspan='4'>&nbsp;<textarea name="cng_cau" cols="65" rows="5" class=default><%=fee_scd.getCng_cau()%></textarea></td>
                </tr>				
            </table>
        </td>
    </tr>	
	<tr>
	    <td align='right'>&nbsp;</td>
    </tr>	
	<tr>
	    <td align="center">
			<a href="javascript:cng_schedule();"><img src=/acar/images/center/button_ch.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;
			<a href="javascript:del_schedule();" title='삭제'><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;
      		<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif  align=absmiddle border="0"></a>
	    </td>
	</tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
