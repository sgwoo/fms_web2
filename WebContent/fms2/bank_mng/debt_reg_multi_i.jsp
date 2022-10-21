<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.bank_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<% 
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	int flag1 = 0;
	int count = 0;	

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");

	String[] chk_cd = request.getParameterValues("ch_l_cd");
	
	String vid_num="";
	
	String ch_i="";  
	String ch_l_id="";  
	String ch_cpt_cd="";
	String ch_cont_dt="";
	String ch_gubun="";	
		
%>

<html>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//등록
	function Save()
	{
		var fm = document.form1;	
		
		if(fm.cont_dt1.value == '')	{	alert('대출일을 입력하십시오.'); 	fm.cont_dt1.focus(); 		return; }

		if(confirm('등록하시겠습니까?')){					
			fm.action='debt_reg_multi_i_a.jsp';		
			fm.target='i_no';
			//fm.target='_blank';			
			fm.submit();
		}
	}


//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<%	
	//파싱
	for(int i=0; i<chk_cd.length;i++){
		vid_num=chk_cd[i];
		
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
				ch_i = token1.nextToken().trim();	
				ch_cpt_cd = token1.nextToken().trim();		
				ch_l_id = token1.nextToken().trim();	 
				ch_cont_dt = token1.nextToken().trim();	 
				ch_gubun = token1.nextToken().trim();	 
				
		}		
%>
  <input type="hidden" name="l_id" value="<%=ch_l_id%>">
  <input type="hidden" name="cpt_cd" value="<%=ch_cpt_cd%>">
  <input type="hidden" name="cont_dt" value="<%=ch_cont_dt%>">
  <input type="hidden" name="gubun" value="<%=ch_gubun%>">
      
<%	}%>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 구매자금관리 > <span class=style5>대출금전표등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>	<tr><td class=h></td></tr>
	
	<tr><td class=line2 colspan=2></td></tr>
    <tr> 
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>                               		
          		<tr> 
            		<td class='title'>대출일</td>
            		<td>&nbsp; <input name="cont_dt1" type="text" class="text" value="<%=ch_cont_dt%>" readonly size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>            		
          		</tr> 
        	</table>
        </td>
    </tr>   
    <tr>
    	<td class=h></td>
    </tr>
    <tr>
        <td>&nbsp; </td>
        <td align="right">
      		<a href="javascript:Save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
 	
      	</td>
    </tr> 
</table>  
<input type='hidden' name='user_id' value='<%=user_id%>'>   
        
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>  
</body>
</html>