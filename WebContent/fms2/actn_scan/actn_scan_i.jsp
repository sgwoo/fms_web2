<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.free_time.*" %>
<%@ page import="acar.schedule.*, acar.attend.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");	

	
	String title = "";	
	String title1 = "";	
	String sch_file = "";	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");	
	
%>

<HTML>
<HEAD>
<TITLE></TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function actn_scan_reg(){
		fm = document.form1;		
		if(!confirm("내용을 등록하시겠습니까?"))	return;
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/actn_scan_all_a.jsp";
		
		//fm.target = "_blank";
		fm.submit();
	}

function actn_scan_close()
{
	self.close();
	window.close();
}


//-->
</script>


</HEAD>
<BODY>
<form action="" name='form1' method='post' enctype="multipart/form-data">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  	
<table border="0" cellspacing="0" cellpadding="0" width=600>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 경매관리 > <span class=style5>낙찰스캔관리 등록</span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=600>
                <tr> 
                    <td width='20%' class='title'>경매장</td>
                    <td width="" align='left' >&nbsp; 
						<select name='actn_nm'>
                        	<option value='분당-현대글로비스(주)'>분당-현대글로비스(주)</option>
							<option value='시화-현대글로비스(주)'>시화-현대글로비스(주)</option>
							<option value='(주)서울자동차경매'>(주)서울자동차경매</option>
							<option value='동화엠파크 주식회사'>동화엠파크 주식회사</option>
						</select>
					</td>
                </tr>
				<tr> 
                    <td class='title' width="20%">경매횟차</td>
                    <td colspan="">&nbsp; 
        			  <input type="text" name="actn_su" value='' size="15" class=text>&nbsp;회
                    </td>
                </tr>
				<tr> 
                    <td class='title' width="20%">경매일자</td>
                    <td colspan="">&nbsp; 
        			  <input type="text" name="actn_dt" value='' size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>

            </table>
			
			
		</td>
	</tr>
	<tr>
		<td align='right'>
			 
	 		<a href="javascript:actn_scan_reg()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
			<a href="javascript:actn_scan_close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
	<tr>
		<td align='left'>
		 <font color="#999999">※ (주)서울자동차경매장은 경매횟차가 없으므로 0으로 입력한다.<br>
		 ※ 내용을 등록하고 스캔파일은 별도로 등록합니다.
		 </font>
		 
		</td>
	</tr>
</table>
</form>
</BODY>
</HTML>
