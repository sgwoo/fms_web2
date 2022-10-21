<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.cooperation.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	String use_yn = request.getParameter("chk_yn")==null?"":request.getParameter("chk_yn");
	
	
	
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;

	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script src='/include/common.js'></script>
<script>
<!--
	function save()
	{
		var fm = document.form1;
		
		if(confirm('등록하시겠습니까?')){
			fm.action = "settle_acc_stop_req_a.jsp";	
			fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
</head>

<body>
<form action='' name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>




<table border=0 cellspacing=0 cellpadding=0 width=800>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 미수금정산관리 > <span class=style5>운행정지명령신청요청</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr><td class=line2></td></tr>
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=100%>
			    <tr>
			    	<td width="50" class='title'>연번</td>
			    	<td width="100" class='title'>계약번호</td>
			    	<td width="250" class='title'>상호</td>					
			    	<td width="120" class='title'>주소종류</td>
			    	<td width="280" class='title'>비고</td>					
			    </tr>		
				<%for(int i=0;i < vid_size;i++){
					vid_num = vid[i];
					rent_mng_id 	= vid_num.substring(0,6);
					rent_l_cd 		= vid_num.substring(6,19);
					//장기계약 상단정보
					LongRentBean base = ScdMngDb.getScdMngLongRentInfo(rent_mng_id, rent_l_cd);%>	
				<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
				<input type='hidden' name='firm_nm' value='<%=base.getFirm_nm()%>'>
			    <tr>
			    	<td align="center"><%=i+1%></td>				
			    	<td align="center"><%=rent_l_cd%></td>
			    	<td align="center"><%=base.getFirm_nm()%></td>
			    	<td align="center"><select name='post_st'>
								<option value='선택안함'>선택</option>
								<option value="사업장">사업장</option>		
								<option value="자택" selected>자택</option>
								<option value="우편물주소지">우편물주소지</option>
								<option value="기타">기타</option>								
               </select></td>
			   <td align="center"><input type="text" name="post_etc" size="40" class="text" value=""></td>
			    </tr>
				<%}%>
			</table>
		</td>
	</tr>	          
    <tr>
	    <td align='center'>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>			
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
			    