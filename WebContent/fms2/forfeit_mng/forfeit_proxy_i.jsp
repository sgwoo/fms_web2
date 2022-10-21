<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<% 
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	int flag1 = 0;
	int count = 0;	

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun"); //1:통행료,주차요금 2:기타
	String[] chk_cd = request.getParameterValues("ch_l_cd");

	String vid_num="";
	
	String ch_m_id="";  
	String ch_l_cd="";
	String ch_c_id="";
	String ch_seq_no="";
	String ch_cust_nm="";
	String ch_dem_dt="";		
	String ch_e_dem_dt="";	
%>

<html>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//등록
	function Save()
	{
		var fm = document.form1;	
		
		if(fm.proxy_est_dt.value == '')	{	alert('납부예정일자를 입력하십시오.'); 	fm.proxy_est_dt.focus(); 		return; }

		if(confirm('등록하시겠습니까?')){					
			fm.action='forfeit_proxy_i_a.jsp';		
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
<input type='hidden' name='search_code' value=''>
<%	
	//파싱
	for(int i=0; i<chk_cd.length;i++){
		vid_num=chk_cd[i];
	//System.out.println("vid_num="+vid_num);
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
				ch_m_id = token1.nextToken().trim();	 
				ch_l_cd = token1.nextToken().trim();	 
				ch_c_id = token1.nextToken().trim();	 
				ch_seq_no = token1.nextToken().trim();
				ch_cust_nm = token1.nextToken().trim();		
				
				//선납과태료 메일보내는것하고 자릿수 맞추려고 추가함.2012-11-22
				//if  ( gubun.equals("1")) {
					ch_dem_dt = token1.nextToken().trim();
					ch_e_dem_dt = token1.nextToken().trim();
				//}	
		}		
%>
  <input type="hidden" name="m_id" value="<%=ch_m_id%>">
  <input type="hidden" name="l_cd" value="<%=ch_l_cd%>">
  <input type="hidden" name="c_id" value="<%=ch_c_id%>">
  <input type="hidden" name="seq_no" value="<%=ch_seq_no%>">    
  <input type="hidden" name="dem_dt" value="<%=ch_dem_dt%>">
  <input type="hidden" name="e_dem_dt" value="<%=ch_e_dem_dt%>">
    
<%	}%>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>고객지원 > 과태료관리 > <span class=style5>일일납입스케쥴등록</span></span></td>
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
            		<td class='title' width='100'>납부예정일자</td>
            		<td>&nbsp; <input name="proxy_est_dt" type="text" class="text" value="<%=AddUtil.getDate()%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            		
          		</tr>  
          		<tr> 
            		<td class='title'>구분</td>
            		<td>&nbsp; 
					  <input type='radio' name="reg_st" value='1' checked>
        				고객청구+출금등록
        			  <input type='radio' name="reg_st" value='2'>
       					출금등록만						
					</td>					
          		</tr>      		
          		<tr> 
            		<td class='title'>출금처리</td>
            		<td>&nbsp; 
					  <input type='radio' name="reg_type" value='1' checked>
        				개별
        			  <input type='radio' name="reg_type" value='2'>
       					묶음 (한국도로공사 엑셀등록분)
						
					</td>					
          		</tr>      
          		<tr> 
            		<td class='title'>송금통합여부</td>
            		<td>&nbsp; 
					  <input type='radio' name="act_union_yn" value='N' checked>
        				개별송금 (수신자통장에 차량번호표시)
						<br>&nbsp; 
        			  <input type='radio' name="act_union_yn" value='Y'>
       					통합송금 (동일 수신처는 묶어서 송금처리)
						
					</td>					
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
<input type='hidden' name='gubun' value='<%=gubun%>'>         
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>  
</body>
</html>