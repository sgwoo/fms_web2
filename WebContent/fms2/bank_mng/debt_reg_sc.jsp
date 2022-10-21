<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
			
	//스케쥴등록
	function DebtInReg(){
	
		var fm = i_no.document.form1;	
			
		var ccnt=	 toInt(parseDigit(fm.debt_size.value));
	
		var len=fm.elements.length;
			
		var index, str;
		var cnt=0;		
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];
			
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					idnum=ck.value;	
					index = idnum.indexOf("^");								
					str =  idnum.substring(0, index);														
					var idx = 	 toInt(parseDigit(str));
							
					if( ccnt == 1 ){
						if(fm.ven_code.value == '')					{ alert('금융사코드가 없습니다.'); 					return; }
						if(fm.acct_code.value == '')				{ alert('계정코드가 없습니다.'); 					return; }	
						if(fm.scd_cnt.value == '0')					{ alert('스케쥴이 없습니다.'); 					return; }		
						if(fm.debt_amt.value == '0')				{ alert('스케쥴 금액이 없습니다.'); 					return; }			
					}else{					
						if(fm.ven_code[idx].value == '')			{ alert((idx+1)+'번 금융사코드가 없습니다.'); 		return; }
						if(fm.acct_code[idx].value == '')			{ alert((idx+1)+'번 계정코드가 없습니다.'); 		return; }	
						if(fm.scd_cnt[idx].value == '0')			{ alert((idx+1)+'번 스케쥴이 없습니다.'); 		return; }	
						if(fm.debt_amt[idx].value == '0')			{ alert((idx+1)+'번 스케쥴 금액이 없습니다.'); 		return; }	
					}									
					cnt++;						
				}
			}		
		}
			
		if(cnt == 0){
		 	alert("데이타를 확인하세요!!!.");
			return;
		}	
								
		var newWin = window.open("", "pop", "left=700, top=200, width=400, height=200, resizable=yes, scrollbars=yes, status=yes");
				
		fm.target = "pop";
		fm.action = "debt_reg_multi_i.jsp";
		fm.submit();		
		
	} 
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
			
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

	
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	
	String hidden_value = "";
		
		//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "10");
			

	hidden_value = "?auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&bank_id="+bank_id+"&gubun1="+gubun1+"&st_dt="+st_dt+"&end_dt="+end_dt;

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
%>
<form name='form1' method='post'>
<input type='hidden' name='tax_no' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>

<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='bank_id' value='<%=bank_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <% 	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
  <tr> 
    <td align="right" >
	<a href="javascript:DebtInReg();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;

    </td>
   </tr>
<%	}%>  
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span></td>
	</tr> 
    <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./debt_reg_sc_in.jsp<%=hidden_value%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>
	
</table>
</form>
</body>
</html>
